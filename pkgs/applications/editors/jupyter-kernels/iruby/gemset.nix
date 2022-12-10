{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcm2hchn897xjhqj9zzsxf3n9xhddymj4lsclz508f4vw3av46l";
      type = "gem";
    };
    version = "2.6.0";
  };
  amq-protocol = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpn9vgh7y037aqhhp04smihzr73vp5i5g6xlqlha10wy3q0wp7x";
      type = "gem";
    };
    version = "2.0.1";
  };
  amqp = {
    dependencies = ["amq-protocol" "eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbrqnpjgj9v0722p3n5rw589l4g26ry8mcghwc5yr20ggkpdaz9";
      type = "gem";
    };
    version = "1.6.0";
  };
  bond = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r19ifc4skyl2gxnifrxa5jvbbay9fb2in79ppgv02b6n4bhsw90";
      type = "gem";
    };
    version = "0.5.1";
  };
  childprocess = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lv7axi1fhascm9njxh3lx1rbrnsm8wgvib0g7j26v4h1fcphqg0";
      type = "gem";
    };
    version = "0.5.8";
  };
  cookiejar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q0kmbks9l3hl0wdq744hzy97ssq9dvlzywyqv9k9y1p3qc9va2a";
      type = "gem";
    };
    version = "0.3.3";
  };
  czmq-ffi-gen = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ngsd1yxiayd50v402vwhmq7ma9ang6pcba5kqiwq7smpdvfmbmp";
      type = "gem";
    };
    version = "0.15.0";
  };
  cztop = {
    dependencies = ["czmq-ffi-gen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12xcz7g42dbp2ryhcwdm2ykj7bmwfhjhla296hy18g7a09zlfnz7";
      type = "gem";
    };
    version = "0.13.1";
  };
  data_uri = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzkxgdxrlbfl4537y3n9mjxbm28kir639gcw3x47ffchwsgdcky";
      type = "gem";
    };
    version = "0.1.0";
  };
  em-http-request = {
    dependencies = ["addressable" "cookiejar" "em-socksify" "eventmachine" "http_parser.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rxmbi0fv91n4sg300v3i9iiwd0jxv0i6xd0sp81dx3jlx7kasx";
      type = "gem";
    };
    version = "1.1.5";
  };
  em-http-server = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8l4gymy9dzjjchjav90ck6has2i2zdjihlhcyrg3jgq6kjzyq5";
      type = "gem";
    };
    version = "0.1.8";
  };
  em-socksify = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rk43ywaanfrd8180d98287xv2pxyl7llj291cwy87g1s735d5nk";
      type = "gem";
    };
    version = "0.3.2";
  };
  em-worker = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z4jx9z2q5hxvdvik4yp0ahwfk69qsmdnyp72ln22p3qlkq2z5wk";
      type = "gem";
    };
    version = "0.0.2";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2dl10pi6a30kcvx2s6p2v1wb4kbm48iv38kmz2ff600nirhpb8";
      type = "gem";
    };
    version = "1.9.21";
  };
  ffi-rzmq = {
    dependencies = ["ffi-rzmq-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14a5kxfnf8l3ngyk8hgmk30z07aj1324ll8i48z67ps6pz2kpsrg";
      type = "gem";
    };
    version = "2.0.7";
  };
  ffi-rzmq-core = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0amkbvljpjfnv0jpdmz71p1i3mqbhyrnhamjn566w0c01xd64hb5";
      type = "gem";
    };
    version = "1.0.7";
  };
  "http_parser.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  iruby = {
    dependencies = ["bond" "data_uri" "mimemagic" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wdf2c0x8y6cya0n3y0p3p7b1sxkb2fdavdn2k58rf4rs37s7rzn";
      type = "gem";
    };
    version = "0.3";
  };
  mimemagic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04cp5sfbh1qx82yqxn0q75c7hlcx8y1dr5g3kyzwm4mx6wi2gifw";
      type = "gem";
    };
    version = "0.3.3";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "147whmq8h2n04chskl3v4a132xhz5i6kk6vhnz83jwng4vihin5f";
      type = "gem";
    };
    version = "2.18.1";
  };
  parse-cron = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02fj9i21brm88nb91ikxwxbwv9y7mb7jsz6yydh82rifwq7357hg";
      type = "gem";
    };
    version = "0.1.4";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
  };
  rbczmq = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bqr44m2nb61smza6y5cahp09hk16lsn0z3wpq9g5zpr9nhp50fx";
      type = "gem";
    };
    version = "1.7.9";
  };
  sensu = {
    dependencies = ["em-http-request" "em-http-server" "eventmachine" "parse-cron" "sensu-extension" "sensu-extensions" "sensu-json" "sensu-logger" "sensu-redis" "sensu-settings" "sensu-spawn" "sensu-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rxv6yj63nkxlzmmqk6qpfpcvrbar9s4sd4kgfb5zsv9bw7236cr";
      type = "gem";
    };
    version = "1.6.2";
  };
  sensu-extension = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpizp4n01rv72cryjjlrbfxxj3csish3mkxjzdy4inpi5j5h1dw";
      type = "gem";
    };
    version = "1.5.2";
  };
  sensu-extensions = {
    dependencies = ["sensu-extension" "sensu-extensions-check-dependencies" "sensu-extensions-debug" "sensu-extensions-json" "sensu-extensions-occurrences" "sensu-extensions-only-check-output" "sensu-extensions-ruby-hash" "sensu-json" "sensu-logger" "sensu-settings"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04v221qjv8qy3jci40i66p63ig5vrrh0dpgmf1l8229x5m7bxrsg";
      type = "gem";
    };
    version = "1.10.0";
  };
  sensu-extensions-check-dependencies = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hc4kz7k983f6fk27ikg5drvxm4a85qf1k07hqssfyk3k75jyj1r";
      type = "gem";
    };
    version = "1.1.0";
  };
  sensu-extensions-debug = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11abdgn2kkkbvxq4692yg6a27qnxz4349gfiq7d35biy7vrw34lp";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-json = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wnbn9sycdqdh9m0fhszaqkv0jijs3fkdbvcv8kdspx6irbv3m6g";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-occurrences = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lx5wsbblfs0rvkxfg09bsz0g2mwmckrhga7idnarsnm8m565v1v";
      type = "gem";
    };
    version = "1.2.0";
  };
  sensu-extensions-only-check-output = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ds2i8wd4ji9ifig2zzr4jpxinvk5dm7j10pvaqy4snykxa3rqh3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-extensions-ruby-hash = {
    dependencies = ["sensu-extension"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xyrj3gbmslbivcd5qcmyclgapn7qf7f5jwfvfpw53bxzib0h7s3";
      type = "gem";
    };
    version = "1.0.0";
  };
  sensu-json = {
    dependencies = ["oj"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08zlxg5j3bhs72cc7wcllp026jbif0xiw6ib1cgawndlpsfl9fgx";
      type = "gem";
    };
    version = "2.1.1";
  };
  sensu-logger = {
    dependencies = ["eventmachine" "sensu-json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpw4kz36ilaknrzb3rbkhpbgv93w2d668z2cv395dq30d4d3iwm";
      type = "gem";
    };
    version = "1.2.2";
  };
  sensu-redis = {
    dependencies = ["eventmachine"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0widfmmj1h9ca2kk14wy1sqmlkq40linp89a73s3ghngnzri0xyk";
      type = "gem";
    };
    version = "2.4.0";
  };
  sensu-settings = {
    dependencies = ["parse-cron" "sensu-json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "152n4hazv2l4vbzrgd316rpj135jmz042fyh6k2yv2kw0x29pi0f";
      type = "gem";
    };
    version = "10.14.0";
  };
  sensu-spawn = {
    dependencies = ["childprocess" "em-worker" "eventmachine" "ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17yc8ivjpjbvig9r7yl6991d6ma0kcq75fbpz6i856ljvcr3lmd5";
      type = "gem";
    };
    version = "2.5.0";
  };
  sensu-transport = {
    dependencies = ["amq-protocol" "amqp" "eventmachine" "sensu-redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x6vyfmg1jm1srf7xa5aka73by7qwcmry2rx8kq8phwa4g0v4mzr";
      type = "gem";
    };
    version = "8.2.0";
  };
}
