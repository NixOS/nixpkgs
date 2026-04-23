import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "listmonk";
    meta.maintainers = with lib.maintainers; [ raitobezarius ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.mailhog.enable = true;
        services.listmonk = {
          enable = true;
          database = {
            createLocally = true;
            # https://github.com/knadh/listmonk/blob/174a48f252a146d7e69dab42724e3329dbe25ebe/internal/messenger/email/email.go#L18-L27
            settings.smtp = [
              {
                enabled = true;
                host = "localhost";
                port = 1025;
                tls_type = "none";
              }
            ];
          };
        };
      };

    testScript = ''
      import json

      start_all()

      def generate_listmonk_request(type, url, data=None):
         if data is None: data = {}
         json_data = json.dumps(data)
         return f'curl -j -b cookies.txt -X {type} "http://localhost:9000/api/{url}" -H "Content-Type: application/json; charset=utf-8" --data-raw \'{json_data}\'''

      machine.wait_for_unit("mailhog.service")
      machine.wait_for_unit("postgresql.target")
      machine.wait_for_unit("listmonk.service")
      machine.wait_for_open_port(1025)
      machine.wait_for_open_port(8025)
      machine.wait_for_open_port(9000)
      machine.succeed("[[ -f /var/lib/listmonk/.db_settings_initialized ]]")
      machine.succeed('curl -c cookies.txt -X POST "http://localhost:9000/admin/login" --data email=listmonk@test.local --data username=listmonk --data password=hunter22 --data password2=hunter22')

      assert json.loads(machine.succeed(generate_listmonk_request("GET", 'health')))['data'], 'Health endpoint returned unexpected value'

      # A sample subscriber is guaranteed to exist at install-time
      # A sample transactional template is guaranteed to exist at install-time
      subscribers = json.loads(machine.succeed(generate_listmonk_request('GET', "subscribers")))['data']['results']
      templates = json.loads(machine.succeed(generate_listmonk_request('GET', "templates")))['data']
      tx_template = templates[2]

      # Test transactional endpoint
      print(machine.succeed(
        generate_listmonk_request('POST', 'tx', data={'subscriber_id': subscribers[0]['id'], 'template_id': tx_template['id']})
      ))

      assert 'Welcome Anon Doe' in machine.succeed(
          "curl --fail http://localhost:8025/api/v2/messages"
      ), "Failed to find Welcome John Doe inside the messages API endpoint"

      # Test campaign endpoint
      # Based on https://github.com/knadh/listmonk/blob/174a48f252a146d7e69dab42724e3329dbe25ebe/cmd/campaigns.go#L549 as docs do not exist.
      campaign_data = json.loads(machine.succeed(
        generate_listmonk_request('POST', 'campaigns/1/test', data={'template_id': templates[0]['id'], 'subscribers': ['john@example.com'], 'name': 'Test', 'subject': 'NixOS is great', 'lists': [1], 'messenger': 'email'})
      ))

      assert campaign_data['data']  # This is a boolean asserting if the test was successful or not: https://github.com/knadh/listmonk/blob/174a48f252a146d7e69dab42724e3329dbe25ebe/cmd/campaigns.go#L626

      messages = json.loads(machine.succeed(
          "curl --fail http://localhost:8025/api/v2/messages"
      ))

      assert messages['total'] == 2
    '';
  }
)
