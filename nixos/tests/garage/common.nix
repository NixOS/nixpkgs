{ ... }:
{
  _module.args.testScriptSetup = # python
    ''
      from typing import List
      from dataclasses import dataclass
      import re

      start_all()

      cur_version_regex = re.compile(r'Current cluster layout version: (?P<ver>\d*)')

      @dataclass
      class S3Key:
         key_name: str
         key_id: str
         secret_key: str

      @dataclass
      class GarageNode:
         node_id: str
         host: str

      def get_node_fqn(machine: BaseMachine) -> GarageNode:
        node_id, host = machine.succeed("garage node id").split('@')
        return GarageNode(node_id=node_id, host=host)

      def get_node_id(machine: BaseMachine) -> str:
        return get_node_fqn(machine).node_id

      def get_layout_version(machine: BaseMachine) -> int:
        version_data = machine.succeed("garage layout show")
        m = cur_version_regex.search(version_data)
        if m and m.group('ver') is not None:
          return int(m.group('ver')) + 1
        else:
          raise ValueError('Cannot find current layout version')

      def apply_garage_layout(machine: BaseMachine, layouts: List[str]):
         for layout in layouts:
            machine.succeed(f"garage layout assign {layout}")
         version = get_layout_version(machine)
         machine.succeed(f"garage layout apply --version {version}")

      def create_api_key(machine: BaseMachine, key_name: str) -> S3Key:
         output = machine.succeed(f"garage key create {key_name}")
         return parse_api_key_data(output)

      def get_api_key(machine: BaseMachine, key_pattern: str) -> S3Key:
         output = machine.succeed(f"garage key info --show-secret {key_pattern}")
         return parse_api_key_data(output)

      def parse_api_key_data(text) -> S3Key:
        key_creation_regex = re.compile(r'Key name: \s*(?P<key_name>.*)|' r'Key ID: \s*(?P<key_id>.*)|' r'Secret key: \s*(?P<secret_key>.*)', re.IGNORECASE)
        fields = {}
        for match in key_creation_regex.finditer(text):
          for key, value in match.groupdict().items():
            if value:
              fields[key] = value.strip()
        try:
          return S3Key(**fields)
        except TypeError as e:
          raise ValueError(f"Cannot parse API key data. Missing required field(s): {e}")

      def get_aws_env(s3_key: S3Key) -> str:
        return (
          f"AWS_ACCESS_KEY_ID={s3_key.key_id} "
          f"AWS_SECRET_ACCESS_KEY={s3_key.secret_key} "
          f"AWS_DEFAULT_REGION=garage"
        )

      def test_bucket_writes(node):
        node.succeed("garage bucket create test-bucket")
        s3_key = create_api_key(node, "test-api-key")
        node.succeed("garage bucket allow --read --write test-bucket --key test-api-key")
        other_s3_key = get_api_key(node, 'test-api-key')
        assert other_s3_key.secret_key == other_s3_key.secret_key

        env = get_aws_env(s3_key)
        endpoint = "--endpoint-url http://[::1]:3900"

        node.succeed(f"echo test > /tmp/test.txt && {env} aws {endpoint} s3 cp /tmp/test.txt s3://test-bucket/test.txt")

        node.succeed(f"{env} aws {endpoint} s3 cp s3://test-bucket/test.txt /tmp/downloaded.txt")
        assert node.succeed("cat /tmp/downloaded.txt").strip() == "test"

      def test_bucket_over_http(node, bucket='test-bucket', url=None):
        if url is None:
           url = f"{bucket}.web.garage"

        s3_key = get_api_key(node, 'test-api-key')
        env = get_aws_env(s3_key)
        endpoint = "--endpoint-url http://[::1]:3900"

        node.succeed(f'garage bucket website --allow {bucket}')

        node.succeed(f'echo -n "hello world" > /tmp/index.html && {env} aws {endpoint} s3 cp /tmp/index.html s3://{bucket}/index.html')

        assert (node.succeed(f"curl -H 'Host: {url}' http://localhost:3902")).strip() == 'hello world'
    '';
}
