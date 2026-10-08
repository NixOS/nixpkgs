{
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m9bh8c78nc44xgq3sdcxabpg16hz7gx83cbffcxw31hq7im7g3a";
      type = "gem";
    };
    version = "1.1124.0";
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
      sha256 = "1iy9qkwmv9bwfx7ywbp6v0hj2xc8fcmzvsn1b4yqlvpsrisbb1gg";
      type = "gem";
    };
    version = "3.226.2";
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
      sha256 = "01v0a2213fqrgajvafrpmi3n8pmbj1a2xkxfyv5fsvblakqy6dqp";
      type = "gem";
    };
    version = "1.106.0";
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
      sha256 = "1lyz0i052hskibapsynvvf6pf3r7shy01li1kny5r4p2mvdl3db2";
      type = "gem";
    };
    version = "1.191.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "1b3ix36yfnfwyxb4w9ss8a7nc6w15m1wbj3q8rarsqjrs3xj6wjs";
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
      sha256 = "0cyk4pimz1g5lqf4vw2p9kf8ji3v53zfi8jix8sgz4ndy81ylah5";
      type = "gem";
    };
    version = "0.8.10";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  kwalify = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ngxg3ysq5vip9dn3d32ajc7ly61kdin86hfycm1hkrcvkkn1vjf";
      type = "gem";
    };
    version = "0.7.2";
  };
  lightly = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sgj2r6j7qxb9vqzkx5isjbphi38rplk4h8838am0cjcpq5h3jb3";
      type = "gem";
    };
    version = "0.3.3";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
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
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  netaddr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d7iccg9cjcsfl0fd0iiqfc5s7yh2602dgscbji5lrn2q879ghz7";
      type = "gem";
    };
    version = "2.0.6";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h6gazp5837xbz1aqvq9x0a5ffpw32nhvknn931a4074k6i04wvd";
      type = "gem";
    };
    version = "0.6.2";
  };
  psych = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "186i2hc6sfvg4skhqf82kxaf4mb60g65fsif8w8vg1hc9mbyiaph";
      type = "gem";
    };
    version = "3.3.4";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jmbf6lf7pcyacpb939xjjpn1f84c3nw83dy3p1lwjx0l2ljfif7";
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
      sha256 = "023lbh48fcn72gwyh1x52ycs1wx1bnhdajmv0qvkidmdsmxnxzjd";
      type = "gem";
    };
    version = "0.3.0";
  };
}
