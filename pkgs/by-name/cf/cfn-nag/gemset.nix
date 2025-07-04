{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fiw6Vcpw14YdXTyY5H2qRj7VOcNJyroitIMFuJGVctc=";
      type = "gem";
    };
    version = "1.3.2";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dAjEXQp/cxDQFsFqCEBbxNAVg+dd3Z4wR1rDog+IW4s=";
      type = "gem";
    };
    version = "1.1106.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xheq4/Q7or/p+BnBoxx8nb2j4dGjPHRsI8TcFWOIF6w=";
      type = "gem";
    };
    version = "3.224.0";
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
      hash = "sha256-RNi1tpznOUzALzD5o1vqBOoSyUe1/+FHFTXupRGTaNc=";
      type = "gem";
    };
    version = "1.101.0";
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
      hash = "sha256-W3A7iq/CbKTz+Sc2hBLaX0uPdJCbsORlHriv6KoQWAM=";
      type = "gem";
    };
    version = "1.186.1";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UKh5aZGoYjJEQgNq16OVkgVyuEu2zSm5ReXhgA6Nods=";
      type = "gem";
    };
    version = "1.11.0";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  cfn-model = {
    dependencies = [
      "kwalify"
      "psych"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WnIj+9BZYp1VRnjIxUMtgRtmj0JaJ05W99xZ583ocaw=";
      type = "gem";
    };
    version = "0.6.6";
  };
  cfn-nag = {
    dependencies = [
      "aws-sdk-s3"
      "cfn-model"
      "lightly"
      "logging"
      "netaddr"
      "optimist"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BSrqA/LNkv806lGi6P4oe0SJ3ExX8E0cpuWFX+Ml0zM=";
      type = "gem";
    };
    version = "0.8.10";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  kwalify = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tu5g59wsTxgq8w4aZGObwXh6mFRitGFbunEXrP14/dk=";
      type = "gem";
    };
    version = "0.7.2";
  };
  lightly = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y8kBC75MMlAVGghBMunNaER4l9Sx9PnxTqvjI00W8mk=";
      type = "gem";
    };
    version = "0.3.3";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1fNHwA2dZIBA73wX1usJ09Bxmt8ZyjDRo7b7JtCmMbs=";
      type = "gem";
    };
    version = "1.1.4";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ljNZ29q3JaMyDqsXkBfSDVuXMdcUjh76hDLBhKSKRho=";
      type = "gem";
    };
    version = "2.2.2";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  netaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-58OXDsLCZlqiXEy/JoAR0B9dmMMxguYAdZpJlh5j8bQ=";
      type = "gem";
    };
    version = "2.0.6";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-M2t1NnbWEXytkwH6x+kdq0Io90fU5xeYka06Fjxk4u0=";
      type = "gem";
    };
    version = "3.0.1";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  psych = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8KroV00MhrcRRy5qV8wDZlXiVJ8COQynJm87bRgU0aA=";
      type = "gem";
    };
    version = "3.3.4";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  syslog = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tf5ue9Wttjg3BrtK1aBdofOgmRelB+j5E8cyhwhcdAg=";
      type = "gem";
    };
    version = "0.3.0";
  };
}
