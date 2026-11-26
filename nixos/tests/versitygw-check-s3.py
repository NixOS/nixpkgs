import json
import sys

import boto3
from botocore.config import Config
from botocore.exceptions import ClientError


def client(access, secret):
    return boto3.client(
        "s3", endpoint_url="http://127.0.0.1:7070",
        region_name="us-east-1", aws_access_key_id=access,
        aws_secret_access_key=secret,
        config=Config(s3={"addressing_style": "path"}),
    )


root = client("fixture-root", "fixture-root-secret")
reader = client("fixture-reader", "fixture-reader-secret")
bucket = "test-bucket"
if sys.argv[1] == "external-storage":
    root.create_bucket(Bucket=bucket)
    root.put_bucket_versioning(
        Bucket=bucket, VersioningConfiguration={"Status": "Enabled"},
    )
    first = root.put_object(
        Bucket=bucket, Key="versioned", Body=b"first",
        Metadata={"revision": "first"},
    )["VersionId"]
    second = root.put_object(
        Bucket=bucket, Key="versioned", Body=b"second",
        Metadata={"revision": "second"},
    )["VersionId"]
    assert first != second
    for version, body in [(first, b"first"), (second, b"second")]:
        response = root.get_object(
            Bucket=bucket, Key="versioned", VersionId=version,
        )
        assert response["Body"].read() == body
        assert response["Metadata"] == {"revision": body.decode()}
    sys.exit(0)
if sys.argv[1] == "create":
    root.create_bucket(Bucket=bucket)
    root.put_object(Bucket=bucket, Key="hello", Body=b"hello, S3")
    root.put_bucket_policy(Bucket=bucket, Policy=json.dumps({
        "Version": "2012-10-17",
        "Statement": [{
            "Effect": "Allow",
            "Principal": {"AWS": ["fixture-reader"]},
            "Action": ["s3:GetObject"],
            "Resource": ["arn:aws:s3:::test-bucket/*"],
        }],
    }))
assert bucket in [item["Name"] for item in root.list_buckets()["Buckets"]]
response = reader.get_object(Bucket=bucket, Key="hello")
assert response["Body"].read() == b"hello, S3"
try:
    reader.put_object(Bucket=bucket, Key="forbidden", Body=b"no")
except ClientError as error:
    assert error.response["Error"]["Code"] == "AccessDenied"
else:
    raise AssertionError("read-only account could write an object")
