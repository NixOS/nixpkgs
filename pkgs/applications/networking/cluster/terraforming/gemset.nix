{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A0pyxAjHf8jQgTKJe+UCXc1BTNiR7NdYsRRlN2OJ00k=";
      type = "gem";
    };
    version = "1.1.1";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkRlpsmR+zzW4KOfCnIBnlIq+8gAKTlYe8aK5xRLwL4=";
      type = "gem";
    };
    version = "1.436.0";
  };
  aws-sdk-autoscaling = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eZP+XdtalaqP0ehWfInQgJgLQLd1VrUjijmXKKKDJi8=";
      type = "gem";
    };
    version = "1.59.0";
  };
  aws-sdk-cloudwatch = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DORumjTClEePoFTftHADYEalyDjui0v+c7mIZBsA6nU=";
      type = "gem";
    };
    version = "1.50.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P0n06O7Gxi5JNqfgplTc2StEUgBuX1vgxgcMh53v5Jw=";
      type = "gem";
    };
    version = "3.113.0";
  };
  aws-sdk-dynamodb = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IwaJBvxZRbMOwG6o2ae/ErdVO7/pmcL+9PGztP+s2rU=";
      type = "gem";
    };
    version = "1.60.0";
  };
  aws-sdk-ec2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4++tYz8fObEB2YurEDqNm4zFapKS90HMWI0kJzzF+LA=";
      type = "gem";
    };
    version = "1.230.0";
  };
  aws-sdk-efs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zV6k6QG9xUK5nKFvij5MwjsBUjHNAuTYt6bOrg36t04=";
      type = "gem";
    };
    version = "1.39.0";
  };
  aws-sdk-elasticache = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6jPJtUHqg/WES0jeMP2TWmU6RSw9MD5tctrmM8gUdhY=";
      type = "gem";
    };
    version = "1.54.0";
  };
  aws-sdk-elasticloadbalancing = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Yw+KR9TeDOKA8LRCpnpb1AkVFJ9uggB8tbp7YRvqd0g=";
      type = "gem";
    };
    version = "1.31.0";
  };
  aws-sdk-elasticloadbalancingv2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tQYmgtO7IsKFgbHVOIIRB/R02GozQdYIqDHosvGyE5o=";
      type = "gem";
    };
    version = "1.61.0";
  };
  aws-sdk-iam = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yZR/N78fxwPkqpAZvEZWS1F3TBNOxJtWvBR5TRcyR3Q=";
      type = "gem";
    };
    version = "1.51.0";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UG9RMQYt8fFOWCrB5L3I2ReZLgmA4E/oL0bprIkD7QY=";
      type = "gem";
    };
    version = "1.43.0";
  };
  aws-sdk-rds = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yvQ2BIR8ygn5v5wJSLR6a72OtgNaf3WLbb8uoyZ7nUM=";
      type = "gem";
    };
    version = "1.117.0";
  };
  aws-sdk-redshift = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bRkp4MrPFejXXDudnL6dOCN4kbA6GxXhCUVSALZB4eo=";
      type = "gem";
    };
    version = "1.58.0";
  };
  aws-sdk-route53 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xV4C5MbMyouz+HjQLTxk3N8h5xxcbd6YVdiwxJkGL10=";
      type = "gem";
    };
    version = "1.48.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JElMPWzoo7sDCStKwhm/wr/kLPpMqFf5c4bdQX5ywkc=";
      type = "gem";
    };
    version = "1.93.0";
  };
  aws-sdk-sns = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BKeYZ8rGr8y8M8XbWaHJDU2oCvB6J+SXodOKHA6KvV4=";
      type = "gem";
    };
    version = "1.39.0";
  };
  aws-sdk-sqs = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LkISfBCQjcblnEnXPIkXvVYYQ1yFg0O37NERTDyiogY=";
      type = "gem";
    };
    version = "1.38.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XNVKS/LMwHfYkOWgBOcpYfIWctKH+/PunN/dOmKFP7U=";
      type = "gem";
    };
    version = "1.2.3";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7lkw7YM9NHL84xq/L0o5hScY6QsJncKmcTI01gBTnLQ=";
      type = "gem";
    };
    version = "1.4.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XcwLVplp89FljGi11Zf83B/Do01K6StGFcdA2VqqUeU=";
      type = "gem";
    };
    version = "1.12.2";
  };
  terraforming = {
    dependencies = [
      "aws-sdk-autoscaling"
      "aws-sdk-cloudwatch"
      "aws-sdk-dynamodb"
      "aws-sdk-ec2"
      "aws-sdk-efs"
      "aws-sdk-elasticache"
      "aws-sdk-elasticloadbalancing"
      "aws-sdk-elasticloadbalancingv2"
      "aws-sdk-iam"
      "aws-sdk-kms"
      "aws-sdk-rds"
      "aws-sdk-redshift"
      "aws-sdk-route53"
      "aws-sdk-s3"
      "aws-sdk-sns"
      "aws-sdk-sqs"
      "multi_json"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kFdHCqHuALkPrlGCnPLAB+bzHyLns3WNsOv2ZTqG3g0=";
      type = "gem";
    };
    version = "0.18.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ysrhKjdhvkzL5jvhkmE1KxCPhschw32HZkMo7+qm0KM=";
      type = "gem";
    };
    version = "1.1.0";
  };
}
