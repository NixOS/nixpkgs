{
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k6qzammv9r6b2cw3siasaik18i6wjc5m0gw5nfdc6jj64h79z1g";
      type = "gem";
    };
    version = "3.1.9";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  cucumber = {
    dependencies = [
      "builder"
      "cucumber-ci-environment"
      "cucumber-core"
      "cucumber-cucumber-expressions"
      "cucumber-gherkin"
      "cucumber-html-formatter"
      "cucumber-messages"
      "diff-lcs"
      "mini_mime"
      "multi_test"
      "sys-uname"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cbi1g6qwdh38z2jxm8a1mc63iz887108747c99s3g452hwn2hgs";
      type = "gem";
    };
    version = "9.2.1";
  };
  cucumber-ci-environment = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cc6w7dqlmnp59ymi7pyspm3w4m7fn37x6b18pziv62wr373yvmv";
      type = "gem";
    };
    version = "10.0.1";
  };
  cucumber-core = {
    dependencies = [
      "cucumber-gherkin"
      "cucumber-messages"
      "cucumber-tag-expressions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i2k5j3l8yy1367hzmg7x3xy984bnmihnzjh0ic8s2nwb3b2h770";
      type = "gem";
    };
    version = "13.0.3";
  };
  cucumber-cucumber-expressions = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14fkk7bfzm9cyacgcyzgkjc3nblflz4rcnlyz0pzd1ypwpqrvgm1";
      type = "gem";
    };
    version = "17.1.0";
  };
  cucumber-gherkin = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "063p0slf6fvigdn3jynp5pjf9b05byyyi0jhsyapy46hq4984sif";
      type = "gem";
    };
    version = "27.0.0";
  };
  cucumber-html-formatter = {
    dependencies = [ "cucumber-messages" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18bfg6gpijjbka0pp7604src1ajjkmsr79nyvr6zjgw4j0nvdsfn";
      type = "gem";
    };
    version = "21.9.0";
  };
  cucumber-messages = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06d7dnixz68ivngf6qflmi6xrjshjyi85gmyjrl07pbmhqi6r2nh";
      type = "gem";
    };
    version = "22.0.0";
  };
  cucumber-tag-expressions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vcifp1fiha6yqi36m26n1vr8sz3dpnn5966hcz4a3dq43lf947p";
      type = "gem";
    };
    version = "6.1.2";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19kdyjg3kv7x0ad4xsd4swy5izsbb1vl1rpb6qqcqisr5s23awi9";
      type = "gem";
    };
    version = "1.17.2";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_test = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "042d6a1416h3di57z107ygmjdgacrpyswi73ryz75yv3v36m1rg9";
      type = "gem";
    };
    version = "1.1.0";
  };
  sys-uname = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "177l8rrqnb4rxf657mw28sgvgc8a2m7nlqcbdbra5m4xga0ypcxp";
      type = "gem";
    };
    version = "1.3.1";
  };
}
