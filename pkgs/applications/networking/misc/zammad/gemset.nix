{
  aasm = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05j0rdhdzc628v5nyzrazp4704hh96j5sjbn48zxyk4v3a61f4m2";
      type = "gem";
    };
    version = "5.2.0";
  };
  actioncable = {
    dependencies = [ "actionpack" "nio4r" "websocket-driver" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vv8dq95apmwsnam1l2c62ayjr2jwi5m24bcd2l4p324cqmds3ir";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  actionmailbox = {
    dependencies = [ "actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q8bhmdi1jgybs18vaa3hpmydhw8mjx8hcpjlravkwc78ckl19vy";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  actionmailer = {
    dependencies = [ "actionpack" "actionview" "activejob" "mail" "rails-dom-testing" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nximq0hwcy5vhywsryn6y67zaqwhk5gk44d0rgyisbwl6s34zim";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  actionpack = {
    dependencies = [ "actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vsfvrbw1dx1xpvpca5szk1z9qqv5g00c2gyrvskvxbgn3298bg";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  actiontext = {
    dependencies = [ "actionpack" "activerecord" "activestorage" "activesupport" "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00yz34p7syz3wr7sbgn81b5qf97hv5lm2vbbf5xiny9cj1y8hrll";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  actionview = {
    dependencies = [ "activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03dqdl0qkwmkxf6xar9lrxp547hj72ysqg6i13kw8jg8mprk1xk1";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  activejob = {
    dependencies = [ "activesupport" "globalid" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r4dk44x1kn16bsi4h9q13sq65waa940nrnf4i0wd2cssk34sx3i";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" "nulldb" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1m254z419v5n6flqvvf923p5hxwqv43x6nr8gzaw378vl68sp8ff";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  activerecord = {
    dependencies = [ "activemodel" "activesupport" ];
    groups = [ "default" "nulldb" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q48dsxkvlrr34w6hap2dyr1ym68azkmnhllng60pxaizml89azl";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  activerecord-import = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17ydad9gcsh0c9ny68fyvxmh6rbld4pyvyabnc7882678dnvfy8i";
      type = "gem";
    };
    version = "1.2.0";
  };
  activerecord-nulldb-adapter = {
    dependencies = [ "activerecord" ];
    groups = [ "nulldb" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iybn9vafw9vcdi966yidj4zk5vy6b0gg0zk39v1r0kgj9n9qm1v";
      type = "gem";
    };
    version = "0.7.0";
  };
  activerecord-session_store = {
    dependencies = [ "actionpack" "activerecord" "multi_json" "rack" "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06ddhz1b2yg72iv09n48gcd3ix5da7hxlzi7vvj13nrps2qwlffg";
      type = "gem";
    };
    version = "2.0.0";
  };
  activestorage = {
    dependencies = [ "actionpack" "activejob" "activerecord" "marcel" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g6h5k478d9v14w09wnhflsk8xj06clkd6xbfw4sxbbww5n8vl55";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  activesupport = {
    dependencies = [ "concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk" ];
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ldrpgy4gfqykzavgdp0svsm41hkzfi2aaq8as9lqd0sq19mgpqx";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  acts_as_list = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12p22h59c45dnccb51pqk275ziyi502azf9w3qcnkcsq827ma5jm";
      type = "gem";
    };
    version = "1.0.4";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
  };
  argon2 = {
    dependencies = [ "ffi" "ffi-compiler" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0285wr6ai2c1qswr67pybpbj28dv5nv1i4597hg3vg9w1fb7gmzl";
      type = "gem";
    };
    version = "2.0.3";
  };
  ast = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
  };
  async = {
    dependencies = [ "console" "nio4r" "timers" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lh36bsb41vllyrkiffs8qba2ilcjl7nrywizrb8ffrix50rfjn9";
      type = "gem";
    };
    version = "1.29.1";
  };
  async-http = {
    dependencies = [ "async" "async-io" "async-pool" "protocol-http" "protocol-http1" "protocol-http2" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a1si0iz1m6b1lzd5f8cvf1cbniy8kqc06n10bn74l1ppx8a6lc2";
      type = "gem";
    };
    version = "0.56.3";
  };
  async-http-faraday = {
    dependencies = [ "async-http" "faraday" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ndynkfknabv6m9wzcmdnj4r4bhlxqkg9c6rzsjc1pk8q057kslv";
      type = "gem";
    };
    version = "0.11.0";
  };
  async-io = {
    dependencies = [ "async" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z58cgnw79idasx63knyjqihxp5v4wrp7r4jf251a8kyykwdd83a";
      type = "gem";
    };
    version = "1.32.1";
  };
  async-pool = {
    dependencies = [ "async" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rq62gnhiy4a275wid465xqv6f6xsmp1zd9002xw4b37y83y5rqg";
      type = "gem";
    };
    version = "0.3.7";
  };
  autodiscover = {
    dependencies = [ "httpclient" "logging" "nokogiri" "nori" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "ee9b53dfa797ce6d4f970b82beea7fbdd2df56bb";
      sha256 = "1qffylir5i06vd3khwd182pslnqsa0kfc3dihvvjfdyl7p1lxv16";
      type = "git";
      url = "https://github.com/zammad-deps/autodiscover";
    };
    version = "1.0.2";
  };
  autoprefixer-rails = {
    dependencies = [ "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bj8ajlq6ygyqxz7ykykaxfr4jn0ivc95sl64wrycwz7hxz29vda";
      type = "gem";
    };
    version = "10.3.3.0";
  };
  binding_of_caller = {
    dependencies = [ "debug_inspector" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "078n2dkpgsivcf0pr50981w95nfc2bsrp3wpf9wnxz1qsp8jbb9s";
      type = "gem";
    };
    version = "1.0.0";
  };
  biz = {
    dependencies = [ "clavius" "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n2d7cs9jlnpi75nbssv77qlw0jsqnixaikpxsrbxz154q43gvlc";
      type = "gem";
    };
    version = "1.8.2";
  };
  bootsnap = {
    dependencies = [ "msgpack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ndjra3h86dq28njm2swmaw6n3vsywrycrf7i5iy9l8hrhfhv4x2";
      type = "gem";
    };
    version = "1.9.1";
  };
  brakeman = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y71fqqd0azy5rn78fwiz9px0mql23zrl0ij0dzdkx22l4cscpb0";
      type = "gem";
    };
    version = "5.1.1";
  };
  browser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g4bcpax07kqqr9cp7cjc7i0pcij4nqpn1rdsg2wdwhzf00m6x32";
      type = "gem";
    };
    version = "5.3.1";
  };
  buftok = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rzsy1vy50v55x9z0nivf23y0r9jkmq6i130xa75pq9i8qrn1mxs";
      type = "gem";
    };
    version = "0.2.0";
  };
  builder = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  byebug = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  capybara = {
    dependencies = [ "addressable" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1viqcpsngy9fqjd68932m43ad6xj656d1x33nx9565q57chgi29k";
      type = "gem";
    };
    version = "3.35.3";
  };
  childprocess = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ic028k8xgm2dds9mqnvwwx3ibaz32j8455zxr9f4bcnviyahya5";
      type = "gem";
    };
    version = "3.0.0";
  };
  chunky_png = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  clavius = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y58v8k860vafm1psm69f2ndcqmcifyvswsjdy8bxbxy30zrgad1";
      type = "gem";
    };
    version = "1.0.4";
  };
  clearbit = {
    dependencies = [ "nestful" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ccgvxzgpll1wr5i9wjm1h0m2z600j6c4yf6pww423qhg8a25lbl";
      type = "gem";
    };
    version = "0.3.3";
  };
  coderay = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coffee-rails = {
    dependencies = [ "coffee-script" "railties" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "170sp4y82bf6nsczkkkzypzv368sgjg6lfrkib4hfjgxa6xa3ajx";
      type = "gem";
    };
    version = "5.0.0";
  };
  coffee-script = {
    dependencies = [ "coffee-script-source" "execjs" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1907v9q1zcqmmyqzhzych5l7qifgls2rlbnbhy5vzyr7i7yicaz1";
      type = "gem";
    };
    version = "1.12.2";
  };
  coffeelint = {
    dependencies = [ "coffee-script" "execjs" "json" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k6nqia44m6jzzkav6wz1aafjipbygla3g6nl6i7sks854bwgdg1";
      type = "gem";
    };
    version = "1.16.1";
  };
  composite_primary_keys = {
    dependencies = [ "activerecord" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08w8rns5dgjmvavqf1apfbd59dyqyv4igni940rklnqps297w2bn";
      type = "gem";
    };
    version = "12.0.10";
  };
  concurrent-ruby = {
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    version = "1.1.9";
  };
  console = {
    dependencies = [ "fiber-local" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04vhg3vnj2ky00fld4v6qywx32z4pjsa7l8i7sl1bl213s8334l9";
      type = "gem";
    };
    version = "1.13.1";
  };
  coveralls = {
    dependencies = [ "multi_json" "rest-client" "simplecov" "term-ansicolor" "thor" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b97bp3kndl1glfx8rlm19b1vxphirvkrjqn5hn9y1p975iwhl3w";
      type = "gem";
    };
    version = "0.7.1";
  };
  crack = {
    dependencies = [ "rexml" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cr1kfpw3vkhysvkk3wg7c54m75kd68mbm9rs5azdjdq57xid13r";
      type = "gem";
    };
    version = "0.4.5";
  };
  crass = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "079al4y5rjgx12s7rg08rnf9w1n51a7ghycvmr7vhw6r6i81ry8s";
      type = "gem";
    };
    version = "3.2.0";
  };
  daemons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  dalli = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0br39scmr187w3ifl5gsddl2fhq6ahijgw6358plqjdzrizlg764";
      type = "gem";
    };
    version = "2.7.11";
  };
  debug_inspector = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01l678ng12rby6660pmwagmyg8nccvjfgs3487xna7ay378a59ga";
      type = "gem";
    };
    version = "1.1.0";
  };
  delayed_job = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19ym3jw2jj1pxm6p22x2mpf69sdxiw07ddr69v92ccgg6d7q87rh";
      type = "gem";
    };
    version = "4.1.9";
  };
  delayed_job_active_record = {
    dependencies = [ "activerecord" "delayed_job" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0n6wjvk0yfkp1z19kvma7piasw1xgjh5ls51sf24c8g1jlmkmvdh";
      type = "gem";
    };
    version = "4.1.6";
  };
  deprecation_toolkit = {
    dependencies = [ "activesupport" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fh4d98irhph3ri7c2rrvvmmjd4z14702r8baq9flh5f34dap8d8";
      type = "gem";
    };
    version = "1.5.1";
  };
  diff-lcs = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
  };
  diffy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nrg7kpgz6cn1gv2saj2fa5sfiykamvd7vn9lw2v625k7pjwf31l";
      type = "gem";
    };
    version = "3.4.0";
  };
  docile = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lxqxgq71rqwj1lpl9q1mbhhhhhhdkkj7my341f2889pwayk85sz";
      type = "gem";
    };
    version = "1.4.0";
  };
  domain_name = {
    dependencies = [ "unf" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  doorkeeper = {
    dependencies = [ "railties" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hnwd7by65yyiz90ycs3pj4f78s7bnl09nzs1g1vs62509j4nz19";
      type = "gem";
    };
    version = "5.5.2";
  };
  dotenv = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  eco = {
    dependencies = [ "coffee-script" "eco-source" "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09jiwb7pkg0sxk730maxahra4whqw5l47zd7yg7fvd71pikdwdr0";
      type = "gem";
    };
    version = "1.0.0";
  };
  eco-source = {
    groups = [ "assets" "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ccxrvaac6mw5kdj1i490b5xb1wdka3a5q4jhvn8dvg41594yba1";
      type = "gem";
    };
    version = "1.1.0.rc.1";
  };
  em-websocket = {
    dependencies = [ "eventmachine" "http_parser.rb" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mg1mx735a0k1l8y14ps2mxdwhi5r01ikydf34b0sp60v66nvbkb";
      type = "gem";
    };
    version = "0.5.2";
  };
  equalizer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09l8lz3j00m898li0yfsnb6ihc63rdvhw3k5xczna5zrjk104f2l";
      type = "gem";
    };
    version = "1.10.0";
  };
  eventmachine = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
    groups = [ "assets" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  factory_bot = {
    dependencies = [ "activesupport" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04vxmjr200akcil9fqxc9ghbb9q0lyrh2q03xxncycd5vln910fi";
      type = "gem";
    };
    version = "6.2.0";
  };
  factory_bot_rails = {
    dependencies = [ "factory_bot" "railties" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fhcihkc074gk62iwqgbdgc3ymim4fm0b4p3ipffy5hcsb9d2r7";
      type = "gem";
    };
    version = "6.2.0";
  };
  faker = {
    dependencies = [ "i18n" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hb9wfxyb4ss2vl2mrj1zgdk7dh4yaxghq22gbx62yxj5yb9w4zw";
      type = "gem";
    };
    version = "2.19.0";
  };
  faraday = {
    dependencies = [ "faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "multipart-post" "ruby2_keywords" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0afhlqgby2cizcwgh7h2sq5f77q01axjbdl25bsvfwsry9n7gyyi";
      type = "gem";
    };
    version = "1.8.0";
  };
  faraday-em_http = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-http-cache = {
    dependencies = [ "faraday" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lhfwlk4mhmw9pdlgdsl2bq4x45w7s51jkxjryf18wym8iiw36g7";
      type = "gem";
    };
    version = "2.2.0";
  };
  faraday-httpclient = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jik2kgfinwnfi6fpp512vlvs0mlggign3gkbpkg5fw1jr9his0r";
      type = "gem";
    };
    version = "1.0.0";
  };
  ffi = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wgvaclp4h9y8zkrgz8p2hqkrgr4j7kz0366mik0970w532cbmcq";
      type = "gem";
    };
    version = "1.15.3";
  };
  ffi-compiler = {
    dependencies = [ "ffi" "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  fiber-local = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vrxxb09fc7aicb9zb0pmn5akggjy21dmxkdl3w949y4q05rldr9";
      type = "gem";
    };
    version = "1.0.0";
  };
  formatador = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mprf1dwznz5ld0q1jpbyl59fwnwk6azspnd0am7zz7kfg3pxhv5";
      type = "gem";
    };
    version = "0.3.0";
  };
  github_changelog_generator = {
    dependencies = [ "activesupport" "async" "async-http-faraday" "faraday-http-cache" "multi_json" "octokit" "rainbow" "rake" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04d6z2ysq3gzvpw91lq8mxmdlqcxkmvp8rw9zrzkmksh3pjdzli1";
      type = "gem";
    };
    version = "1.16.4";
  };
  gli = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sxpixpkbwi0g1lp9nv08hb4hw9g563zwxqfxd3nqp9c1ymcv5h3";
      type = "gem";
    };
    version = "2.20.1";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k6ww3shk3mv119xvr9m99l6ql0czq91xhd66hm8hqssb18r2lvm";
      type = "gem";
    };
    version = "0.5.2";
  };
  gmail_xoauth = {
    dependencies = [ "oauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dslnb1kffcygcbs8sqw58w6ba0maq4w7k1i7kjrqpq0kxx6wklq";
      type = "gem";
    };
    version = "0.4.2";
  };
  guard = {
    dependencies = [ "formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zqy994fr0pf3pda0x3mmkhgnfg4hd12qp5bh1s1xm68l00viwhj";
      type = "gem";
    };
    version = "2.18.0";
  };
  guard-compat = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-livereload = {
    dependencies = [ "em-websocket" "guard" "guard-compat" "multi_json" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yd74gdbbv2yz2caqwpsavzw8d5fd5y446wp8rdjw8wan0yd6k8j";
      type = "gem";
    };
    version = "2.5.2";
  };
  guard-symlink = {
    dependencies = [ "guard" "guard-compat" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0s5lwl8v55lq0bbvj9k3fv0l4nkl0ydd7gr1k26ycs2a80cgd5mq";
      type = "gem";
    };
    version = "0.1.1";
  };
  hashdiff = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
  };
  hashie = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02bsx12ihl78x0vdm37byp78jjw2ff6035y7rrmbd90qxjwxr43q";
      type = "gem";
    };
    version = "4.1.0";
  };
  hiredis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04jj8k7lxqxw24sp0jiravigdkgsyrpprxpxm71ba93x1wr2w1bz";
      type = "gem";
    };
    version = "0.6.3";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = [ "addressable" "http-cookie" "http-form_data" "http-parser" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z8vmvnkrllkpzsxi94284di9r63g9v561a16an35izwak8g245y";
      type = "gem";
    };
    version = "4.4.1";
  };
  http-accept = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19370bc97gsy2j4hanij246hv1ddc85hw0xjb6sj7n1ykqdlx9l9";
      type = "gem";
    };
    version = "1.0.4";
  };
  http-form_data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
  };
  http-parser = {
    dependencies = [ "ffi-compiler" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18qqvckvqjffh88hfib6c8pl9qwk9gp89w89hl3f2s1x8hgyqka1";
      type = "gem";
    };
    version = "1.2.3";
  };
  "http_parser.rb" = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g2fnag935zn2ggm5cn6k4s4xvv53v2givj1j90szmvavlpya96a";
      type = "gem";
    };
    version = "1.8.10";
  };
  icalendar = {
    dependencies = [ "ice_cube" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wv5wq6pzq6434bnxfanvijswj2rnfvjmgisj1qg399mc42g46ls";
      type = "gem";
    };
    version = "2.7.1";
  };
  icalendar-recurrence = {
    dependencies = [ "icalendar" "ice_cube" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06li3cdbwkd9y2sadjlbwj54blqdaa056yx338s4ddfxywrngigh";
      type = "gem";
    };
    version = "1.1.3";
  };
  ice_cube = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rzfydzgy6jppqvzzr76skfk07nmlszpcjzzn4wlzpsgmagmf0wq";
      type = "gem";
    };
    version = "0.16.3";
  };
  inflection = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mfkk0j0dway3p4gwzk8fnpi4hwaywl2v0iywf1azf98zhk9pfnf";
      type = "gem";
    };
    version = "1.0.0";
  };
  iniparse = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      type = "gem";
    };
    version = "1.5.0";
  };
  interception = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01vrkn28psdx1ysh5js3hn17nfp1nvvv46wc1pwqsakm6vb1hf55";
      type = "gem";
    };
    version = "0.5";
  };
  json = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  jwt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "036i5fc09275ms49mw43mh4i9pwaap778ra2pmx06ipzyyjl6bfs";
      type = "gem";
    };
    version = "2.2.3";
  };
  kgio = {
    groups = [ "default" "unicorn" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ipzvw7n0kz1w8rkqybyxvf3hb601a770khm0xdqm68mc4aa59xx";
      type = "gem";
    };
    version = "2.11.4";
  };
  koala = {
    dependencies = [ "addressable" "faraday" "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k7nlif8nwgb6bfkclry41xklaf4rqf18ycgq63sgkgj6zdpda4w";
      type = "gem";
    };
    version = "3.0.0";
  };
  libv8 = {
    groups = [ "mini_racer" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0317sr3nrl51sp844bps71smkrwim3fjn47wdfpbycixnbxspivm";
      type = "gem";
    };
    version = "8.4.255.0";
  };
  listen = {
    dependencies = [ "rb-fsevent" "rb-inotify" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h2v34xhi30w0d9gfzds2w6v89grq2gkpgvmdj9m8x1ld1845xnj";
      type = "gem";
    };
    version = "3.5.1";
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
  logging = {
    dependencies = [ "little-plugger" "multi_json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pkmhcxi8lp74bq5gz9lxrvaiv5w0745kk7s4bw2b1x07qqri0n9";
      type = "gem";
    };
    version = "2.3.0";
  };
  loofah = {
    dependencies = [ "crass" "nokogiri" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nqcya57x2n58y1dify60i0dpla40n4yir928khp4nj5jrn9mgmw";
      type = "gem";
    };
    version = "2.12.0";
  };
  lumberjack = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06pybb23hypc9gvs2p839ildhn26q68drb6431ng3s39i3fkkba8";
      type = "gem";
    };
    version = "1.2.8";
  };
  mail = {
    dependencies = [ "mini_mime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      fetchSubmodules = false;
      rev = "9265cf75bbe376f595944bd10d2dd953f863e765";
      sha256 = "04jxql35kwijapl37h9an6127hzz0y4pnj82a9iw39kz9vva890s";
      type = "git";
      url = "https://github.com/zammad-deps/mail";
    };
    version = "2.7.2.edge";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bp001p687nsa4a8sp3q1iv8pfhs24w7s3avychjp64sdkg6jxq3";
      type = "gem";
    };
    version = "1.0.1";
  };
  memoizable = {
    dependencies = [ "thread_safe" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v42bvghsvfpzybfazl14qhkrjvx0xlmxz0wwqc960ga1wld5x5c";
      type = "gem";
    };
    version = "0.4.2";
  };
  messagebird-rest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nj994h4ziwb72g54ma3ivb3rbfkv3yk81wwcmgykl2ik3g7q2bm";
      type = "gem";
    };
    version = "3.0.0";
  };
  method_source = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zj12l9qk62anvk9bjvandpa6vy4xslil15wl6wlivyf51z773vh";
      type = "gem";
    };
    version = "3.3.1";
  };
  mime-types-data = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1phcq7z0zpipwd7y4fbqmlaqghv07fjjgrx99mwq3z3n0yvy7fmi";
      type = "gem";
    };
    version = "3.2021.0225";
  };
  mini_mime = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "173dp4vqvx1sl6aq83daxwn5xvb5rn3jgynjmb91swl7gmgp17yl";
      type = "gem";
    };
    version = "1.1.1";
  };
  mini_portile2 = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lvxm91hi0pabnkkg47wh1siv56s6slm2mdq1idfm86dyfidfprq";
      type = "gem";
    };
    version = "2.6.1";
  };
  mini_racer = {
    dependencies = [ "libv8" ];
    groups = [ "mini_racer" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zi36qcg5qj4g1c11vwmc7lknjihirrmc6yxi6q8j6v4lfnyjbyg";
      type = "gem";
    };
    version = "0.2.9";
  };
  minitest = {
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19z7wkhg59y8abginfrm2wzplz7py3va8fyngiigngqvsws6cwgl";
      type = "gem";
    };
    version = "5.14.4";
  };
  msgpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06iajjyhx0rvpn4yr3h1hc4w4w3k59bdmfhxnjzzh76wsrdxxrc6";
      type = "gem";
    };
    version = "1.4.2";
  };
  multi_json = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  multi_xml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  mysql2 = {
    groups = [ "mysql" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d14pcy5m4hjig0zdxnl9in5f4izszc7v9zcczf2gyi5kiyxk8jw";
      type = "gem";
    };
    version = "0.5.3";
  };
  naught = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wwjx35zgbc0nplp8a866iafk4zsrbhwwz4pav5gydr2wm26nksg";
      type = "gem";
    };
    version = "1.1.0";
  };
  nenv = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
  };
  nestful = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sn7lrdhp1dwn9xkqwkarby5bxx1g30givy3fi1dwp1xvqbrqikw";
      type = "gem";
    };
    version = "1.1.4";
  };
  net-ldap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j19yxrz7h3hj7kiiln13c7bz7hvpdqr31bwi88dj64zifr7896n";
      type = "gem";
    };
    version = "0.17.0";
  };
  netrc = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nio4r = {
    groups = [ "default" "development" "puma" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    version = "2.5.8";
  };
  nokogiri = {
    dependencies = [ "mini_portile2" "racc" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v02g7k7cxiwdcahvlxrmizn3avj2q6nsjccgilq1idc89cr081b";
      type = "gem";
    };
    version = "1.12.5";
  };
  nori = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
      type = "gem";
    };
    version = "2.6.0";
  };
  notiffany = {
    dependencies = [ "nenv" "shellany" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  oauth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zwd6v39yqfdrpg1p3d9jvzs9ljg55ana2p06m0l7qn5w0lgx1a0";
      type = "gem";
    };
    version = "0.5.6";
  };
  oauth2 = {
    dependencies = [ "faraday" "jwt" "multi_json" "multi_xml" "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q6q2kgpxmygk8kmxqn54zkw8cs57a34zzz5cxpsh1bj3ag06rk3";
      type = "gem";
    };
    version = "1.4.7";
  };
  octokit = {
    dependencies = [ "faraday" "sawyer" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ak64rb48d8z98nw6q70r6i0i3ivv61iqla40ss5l79491qfnn27";
      type = "gem";
    };
    version = "4.21.0";
  };
  omniauth = {
    dependencies = [ "hashie" "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "002vi9gwamkmhf0dsj2im1d47xw2n1jfhnzl18shxf3ampkqfmyz";
      type = "gem";
    };
    version = "1.9.1";
  };
  omniauth-facebook = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z0f5sr2ddnvfva0jrfd4926nlv4528rfj7z595288n39304r092";
      type = "gem";
    };
    version = "8.0.0";
  };
  omniauth-github = {
    dependencies = [ "omniauth" "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xbk0dbxqfpyfb33ghz6vrlz3m6442rp18ryf13gwzlnifcawhlb";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-gitlab = {
    dependencies = [ "omniauth" "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nbrg93p0nqxs1i2ddyij2rr7jn4vr3la4la39q4fknpin535k3z";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth-google-oauth2 = {
    dependencies = [ "jwt" "oauth2" "omniauth" "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10pnxvb6wpnf58dja3yz4ja527443x3q13hzhcbays4amnnp8i4a";
      type = "gem";
    };
    version = "0.8.2";
  };
  omniauth-linkedin-oauth2 = {
    dependencies = [ "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ydkj9f2hd3fskpc2gazz9dim70z2k6z6pb8j3glnlhkd67iyzci";
      type = "gem";
    };
    version = "1.0.0";
  };
  omniauth-microsoft-office365 = {
    dependencies = [ "omniauth" "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vw6418gykxqd9z32ddq0mr6wa737la1zwppb1ilw9sgii24rg1v";
      type = "gem";
    };
    version = "0.0.8";
  };
  omniauth-oauth = {
    dependencies = [ "oauth" "omniauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yw2vzx633p9wpdkd4jxsih6mw604mj7f6myyfikmj4d95c8d9z7";
      type = "gem";
    };
    version = "1.2.0";
  };
  omniauth-oauth2 = {
    dependencies = [ "oauth2" "omniauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10fr2b58sp7l6nfdvxpbi67374hkrvsf507cvda89jjs0jacy319";
      type = "gem";
    };
    version = "1.7.1";
  };
  omniauth-rails_csrf_protection = {
    dependencies = [ "actionpack" "omniauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xgkxwg17w39q3yjqcj0fm6hdkw37qm1l82dvm9zxn6q2pbzm2zv";
      type = "gem";
    };
    version = "0.1.2";
  };
  omniauth-saml = {
    dependencies = [ "omniauth" "ruby-saml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gxl14lbksnjkl8dfn23lsjkk63md77icm5racrh6fsp5n4ni9d4";
      type = "gem";
    };
    version = "1.10.3";
  };
  omniauth-twitter = {
    dependencies = [ "omniauth-oauth" "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r5j65hkpgzhvvbs90id3nfsjgsad6ymzggbm7zlaxvnrmvnrk65";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-weibo-oauth2 = {
    dependencies = [ "omniauth" "omniauth-oauth2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02cz73lj38cjqkbrdnfr7iymzqdcxgqcjy992r5hmawgpqqgxvwb";
      type = "gem";
    };
    version = "0.5.2";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03wbynzkhay7l1x76srjkg91q48mxl575vrxb3blfxlpqwsvvp0w";
      type = "gem";
    };
    version = "2.2.0";
  };
  overcommit = {
    dependencies = [ "childprocess" "iniparse" "rexml" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wbczp2pxwiggx5n925mdr2q17c6m9hq7h0q7ml2spmla29609sr";
      type = "gem";
    };
    version = "0.58.0";
  };
  parallel = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hkfpm78c2vs1qblnva3k1grijvxh87iixcnyd83s3lxrxsjvag4";
      type = "gem";
    };
    version = "1.21.0";
  };
  parser = {
    dependencies = [ "ast" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06ma6w87ph8lnc9z4hi40ynmcdnjv0p8x53x0s3fjkz4q2p6sxh5";
      type = "gem";
    };
    version = "3.0.2.0";
  };
  pg = {
    groups = [ "postgres" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vhasqwc4f98qb4wxqn2h07fjwzhp5lwyi41j2gndi2g02wrdqh";
      type = "gem";
    };
    version = "0.21.0";
  };
  power_assert = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01z44m715rb6nzfrc90c5rkkdiy42dv3q94jw1q8baf9dg33nwi5";
      type = "gem";
    };
    version = "2.0.1";
  };
  protocol-hpack = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sd85am1hj2w7z5hv19wy1nbisxfr1vqx3wlxjfz9xy7x7s6aczw";
      type = "gem";
    };
    version = "1.4.2";
  };
  protocol-http = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q7js6npc8flgipjpdykmbdmhf2ml8li5gy7763y6awkpli6s6p6";
      type = "gem";
    };
    version = "0.22.4";
  };
  protocol-http1 = {
    dependencies = [ "protocol-http" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wp9pi1qjh1darrqv0r46i4bvax3n64aa0mn7kza4251qmk0dwz5";
      type = "gem";
    };
    version = "0.14.1";
  };
  protocol-http2 = {
    dependencies = [ "protocol-hpack" "protocol-http" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a9klpfmi7w465zq5xz8y8h1qvj42hkm0qd0nlws9d2idd767q5j";
      type = "gem";
    };
    version = "0.14.2";
  };
  pry = {
    dependencies = [ "coderay" "method_source" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0m445x8fwcjdyv2bc0glzss2nbm1ll51bq45knixapc7cl3dzdlr";
      type = "gem";
    };
    version = "0.14.1";
  };
  pry-rails = {
    dependencies = [ "pry" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cf4ii53w2hdh7fn8vhqpzkymmchjbwij4l3m7s6fsxvb9bn51j6";
      type = "gem";
    };
    version = "0.3.9";
  };
  pry-remote = {
    dependencies = [ "pry" "slop" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10g1wrkcy5v5qyg9fpw1cag6g5rlcl1i66kn00r7kwqkzrdhd7nm";
      type = "gem";
    };
    version = "0.1.8";
  };
  pry-rescue = {
    dependencies = [ "interception" "pry" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wn72y8y3d3g0ng350ld92nyjln012432q2z2iy9lhwzjc4dwi65";
      type = "gem";
    };
    version = "1.5.2";
  };
  pry-stack_explorer = {
    dependencies = [ "binding_of_caller" "pry" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h7kp99r8vpvpbvia079i58932qjz2ci9qhwbk7h1bf48ydymnx2";
      type = "gem";
    };
    version = "0.6.1";
  };
  public_suffix = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "puma" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r22aq2shhmvi461pfs1c7pf66l4kbwndpi1jgxqydp0a1lfjbbk";
      type = "gem";
    };
    version = "4.3.10";
  };
  pundit = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1i3rccbzyw46xrx1ic95r11v15ia2kj8naiyi68gdvxfrisk1fxm";
      type = "gem";
    };
    version = "2.1.1";
  };
  pundit-matchers = {
    dependencies = [ "rspec-rails" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10kvf0pj5339fh3dgf9lvsv94d74x7x1wxdb0hp8a1ac7w5l6vmm";
      type = "gem";
    };
    version = "1.7.0";
  };
  racc = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rack = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-livereload = {
    dependencies = [ "rack" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1slzlmvlapgp2pc7389i0zndq3nka0s6sh445vf21cxpz7vz3p5i";
      type = "gem";
    };
    version = "0.3.17";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rails = {
    dependencies = [ "actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q0y3nc0phg85zjxh9j78rs2hlc34zbhwn2zaw2w7bz2fc2vbxk2";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  rails-controller-testing = {
    dependencies = [ "actionpack" "actionview" "activesupport" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = [ "activesupport" "nokogiri" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
  };
  rails-html-sanitizer = {
    dependencies = [ "loofah" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0whc4d4jqm8kd4x3jzbax54sscm1k4pfkr5d1gpapjbzqkfj77yy";
      type = "gem";
    };
    version = "1.4.1";
  };
  railties = {
    dependencies = [ "actionpack" "activesupport" "method_source" "rake" "thor" ];
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v454xnsfh2sival85cah5wbagzzzzd7frqx9kwn4nc9m8m3yx74";
      type = "gem";
    };
    version = "6.0.4.1";
  };
  rainbow = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  raindrops = {
    groups = [ "default" "unicorn" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07nikrdnsf6g55225njnzs1lm9s0lnbv2krvqd2gldwl49l7vl9x";
      type = "gem";
    };
    version = "0.19.2";
  };
  rake = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  rb-fsevent = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qsx9c4jr11vr3a9s5j83avczx9qn9rjaf32gxpc2v451hvbc0is";
      type = "gem";
    };
    version = "0.11.0";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  rchardet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  redis = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ig832dp0xmpp6a934nifzaj7wm9lzjxzasw911fagycs8p6m720";
      type = "gem";
    };
    version = "4.4.0";
  };
  regexp_parser = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vg7imjnfcqjx7kw94ccj5r78j4g190cqzi1i59sh4a0l940b9cr";
      type = "gem";
    };
    version = "2.1.1";
  };
  rest-client = {
    dependencies = [ "http-accept" "http-cookie" "mime-types" "netrc" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  rexml = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wwnfhxxvrlxlk1a3yxlb82k2f9lm0yn0598x7lk8fksaz4vv6mc";
      type = "gem";
    };
    version = "3.10.1";
  };
  rspec-expectations = {
    dependencies = [ "diff-lcs" "rspec-support" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sz9bj4ri28adsklnh257pnbq4r5ayziw02qf67wry0kvzazbb17";
      type = "gem";
    };
    version = "3.10.1";
  };
  rspec-mocks = {
    dependencies = [ "diff-lcs" "rspec-support" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d13g6kipqqc9lmwz5b244pdwc97z15vcbnbq6n9rlf32bipdz4k";
      type = "gem";
    };
    version = "3.10.2";
  };
  rspec-rails = {
    dependencies = [ "actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "152yz205p8zi5nxxhs8z581rjdvvqsfjndklkvn11f2vi50nv7n9";
      type = "gem";
    };
    version = "5.0.2";
  };
  rspec-support = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15j52parvb8cgvl6s0pbxi2ywxrv6x0764g222kz5flz0s4mycbl";
      type = "gem";
    };
    version = "3.10.2";
  };
  rszr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ns5qxdkgbqw1d52nz29lwx6xgs5bqwx1js1227n6l4q36g3snpp";
      type = "gem";
    };
    version = "0.5.2";
  };
  rubocop = {
    dependencies = [ "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gqsacpqzcflc8j08qx1asvcr89jjg9gqhijhir6wivjbmz700cm";
      type = "gem";
    };
    version = "1.21.0";
  };
  rubocop-ast = {
    dependencies = [ "parser" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06fkn66wrsfprvd7bh0bkjvdcr17b9jy3j0cs7lbd3f2yscvwr63";
      type = "gem";
    };
    version = "1.11.0";
  };
  rubocop-faker = {
    dependencies = [ "faker" "rubocop" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05d2mpi8xq50xh1s53h75hgvdhcz76lv9cnfn4jg35nbg67j1pdz";
      type = "gem";
    };
    version = "1.1.0";
  };
  rubocop-performance = {
    dependencies = [ "rubocop" "rubocop-ast" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0whjb16w70z1x0x797cfbcmqq6ngf0vkhn5qn2f2zmcin0929kgm";
      type = "gem";
    };
    version = "1.11.5";
  };
  rubocop-rails = {
    dependencies = [ "activesupport" "rack" "rubocop" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sc2hbz434j6h3y1s6pzqrmdbbj6y0csfqdyjm23scwfdg7g3n07";
      type = "gem";
    };
    version = "2.12.2";
  };
  rubocop-rspec = {
    dependencies = [ "rubocop" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "037v3zb1ia12sgqb2f2dd2cgrfj4scfvy29nfp5688av0wghb7fd";
      type = "gem";
    };
    version = "2.5.0";
  };
  ruby-progressbar = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
  };
  ruby-saml = {
    dependencies = [ "nokogiri" "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v21hgbhaqvz99w3jdm3s1pxwc2idjgqyw4fghzj54g9sgm0dxii";
      type = "gem";
    };
    version = "1.12.2";
  };
  ruby2_keywords = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyntlm = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b8hczk8hysv53ncsqzx4q6kma5gy5lqc7s5yx8h64x3vdb18cjv";
      type = "gem";
    };
    version = "0.6.3";
  };
  rubyzip = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0590m2pr9i209pp5z4mx0nb1961ishdiqb28995hw1nln1d1b5ji";
      type = "gem";
    };
    version = "2.3.0";
  };
  sassc = {
    dependencies = [ "ffi" ];
    groups = [ "assets" "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  sassc-rails = {
    dependencies = [ "railties" "sassc" "sprockets" "sprockets-rails" "tilt" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d9djmwn36a5m8a83bpycs48g8kh1n2xkyvghn7dr6zwh4wdyksz";
      type = "gem";
    };
    version = "2.1.2";
  };
  sawyer = {
    dependencies = [ "addressable" "faraday" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yrdchs3psh583rjapkv33mljdivggqn99wkydkjdckcjn43j3cz";
      type = "gem";
    };
    version = "0.8.2";
  };
  selenium-webdriver = {
    dependencies = [ "childprocess" "rubyzip" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0adcvp86dinaqq3nhf8p3m0rl2g6q0a4h52k0i7kdnsg1qz9k86y";
      type = "gem";
    };
    version = "3.142.7";
  };
  shellany = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
  };
  shoulda-matchers = {
    dependencies = [ "activesupport" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z6v2acldnvqrnvfk70f9xq39ppw5j03kbz2hpz7s17lgnn21vx8";
      type = "gem";
    };
    version = "5.0.0";
  };
  simple_oauth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dw9ii6m7wckml100xhjc6vxpjcry174lbi9jz5v7ibjr3i94y8l";
      type = "gem";
    };
    version = "0.3.1";
  };
  simplecov = {
    dependencies = [ "docile" "simplecov-html" "simplecov_json_formatter" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hrv046jll6ad1s964gsmcq4hvkr3zzr6jc7z1mns22mvfpbc3cr";
      type = "gem";
    };
    version = "0.21.2";
  };
  simplecov-html = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx01bxa8pbf9ip4hagqkp5m0mqfnwnw2xk8kjraiywz4lrss6jb";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov-rcov = {
    dependencies = [ "simplecov" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "056fav5r7m73fkzpsrvbg0kgv905lkpmnj1l80q9msj3gfq23xn7";
      type = "gem";
    };
    version = "0.2.3";
  };
  simplecov_json_formatter = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19r15hyvh52jx7fmsrcflb58xh8l7l0zx4sxkh3hqzhq68y81pjl";
      type = "gem";
    };
    version = "0.1.3";
  };
  slack-notifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "001bipchr45sny33nlavqgxca9y1qqxa7xpi7pvjfqiybwzvm6nd";
      type = "gem";
    };
    version = "2.4.0";
  };
  slack-ruby-client = {
    dependencies = [ "faraday" "faraday_middleware" "gli" "hashie" "websocket-driver" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q9v6ch9jpc82z1nghwibbbbxbi23q41fcw8i57dpjmq06ma9z2";
      type = "gem";
    };
    version = "0.17.0";
  };
  slop = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  spring = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12kyz3jdnaarhf2jbykmd9mqg085gxsx00c16la5q7czxvpb2x2r";
      type = "gem";
    };
    version = "3.0.0";
  };
  spring-commands-rspec = {
    dependencies = [ "spring" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    version = "1.0.4";
  };
  spring-commands-testunit = {
    dependencies = [ "spring" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qqb0iyjgl9nr7w69p07nq8ghidjcp5n81xrsn8rvafana5lis5c";
      type = "gem";
    };
    version = "1.0.1";
  };
  sprockets = {
    dependencies = [ "concurrent-ruby" "rack" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = [ "actionpack" "activesupport" "sprockets" ];
    groups = [ "assets" "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mwmz36265646xqfyczgr1mhkm1hfxgxxvgdgr4xfcbf2g72p1k2";
      type = "gem";
    };
    version = "3.2.2";
  };
  sync = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1z9qlq4icyiv3hz1znvsq1wz2ccqjb1zwd6gkvnwg6n50z65d0v6";
      type = "gem";
    };
    version = "0.5.0";
  };
  tcr = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14678jlva69bxx24sz5i882x25h357xmbmqsichvq8vdiw2xf6aa";
      type = "gem";
    };
    version = "0.2.2";
  };
  telegramAPI = {
    dependencies = [ "rest-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "043blxqk5qps62jgjyr7hbf2y2fg5ldcmii8mxk09b3c6ps9ji6g";
      type = "gem";
    };
    version = "1.4.2";
  };
  telephone_number = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0231010c9rq0sp2iss6m9lrycpwrapl2hdg1fjg9d0jg5m1ly66v";
      type = "gem";
    };
    version = "1.4.12";
  };
  term-ansicolor = {
    dependencies = [ "tins" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xq5kci9215skdh27npyd3y55p812v4qb4x2hv3xsjvwqzz9ycwj";
      type = "gem";
    };
    version = "1.7.1";
  };
  test-unit = {
    dependencies = [ "power_assert" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03pn837vgza8v550ggzhcxbvb80d6qivqnhv3n39lrfnsc8xgi7m";
      type = "gem";
    };
    version = "3.4.7";
  };
  thor = {
    groups = [ "assets" "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  thread_safe = {
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    groups = [ "assets" "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  timers = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00xdi97gm01alfqhjgvv5sff9n1n2l6aym69s9jh8l9clg63b0jc";
      type = "gem";
    };
    version = "4.3.3";
  };
  tins = {
    dependencies = [ "sync" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nzp88y19rqlcizp1nw8m44fvfxs9g3bhjpscz44dwfawfrmr0cb";
      type = "gem";
    };
    version = "1.29.1";
  };
  twilio-ruby = {
    dependencies = [ "faraday" "jwt" "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07g0jrd5qxzgrv10pgyxajahvmfnqx26i8kp0sxmn2in2xj6fb6c";
      type = "gem";
    };
    version = "5.58.3";
  };
  twitter = {
    dependencies = [ "addressable" "buftok" "equalizer" "http" "http-form_data" "http_parser.rb" "memoizable" "multipart-post" "naught" "simple_oauth" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13dmkjgsnym1avym9f7y2i2h3mlk8crqvc87drrzr4f0sf9l8g2y";
      type = "gem";
    };
    version = "7.0.0";
  };
  tzinfo = {
    dependencies = [ "thread_safe" ];
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    version = "1.2.9";
  };
  uglifier = {
    dependencies = [ "execjs" ];
    groups = [ "assets" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
  };
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wc47r23h063l8ysws8sy24gzh74mks81cak3lkzlrw4qkqb3sg4";
      type = "gem";
    };
    version = "0.0.7.7";
  };
  unicode-display_width = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0csjm9shhfik0ci9mgimb7hf3xgh7nx45rkd9rzgdz6vkwr8rzxn";
      type = "gem";
    };
    version = "2.1.0";
  };
  unicorn = {
    dependencies = [ "kgio" "raindrops" ];
    groups = [ "unicorn" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jcm85d7j7njfgims712svlgml32zjim6qwabm99645aj5laayln";
      type = "gem";
    };
    version = "6.0.0";
  };
  valid_email2 = {
    dependencies = [ "activemodel" "mail" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l4xkwvx7aj5z18h6vzp0wsfjbcrl76ixp0x95wwlrhn03qab6hs";
      type = "gem";
    };
    version = "4.0.0";
  };
  vcr = {
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j9j257wjkjbh8slx6gjgcwch8x4f7pk53iaq2w71z35rm1a0a3a";
      type = "gem";
    };
    version = "6.0.0";
  };
  viewpoint = {
    dependencies = [ "httpclient" "logging" "nokogiri" "rubyntlm" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14bvihfs0gzmam680xqqs07isxjk677yi3ph2pdvyyhhkbfys0l0";
      type = "gem";
    };
    version = "1.1.1";
  };
  webmock = {
    dependencies = [ "addressable" "crack" "hashdiff" ];
    groups = [ "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1l8vh8p0g92cqcvv0ra3mblsa4nczh0rz8nbwbkc3g3yzbva85xk";
      type = "gem";
    };
    version = "3.14.0";
  };
  websocket-driver = {
    dependencies = [ "websocket-extensions" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0a3bwxd9v3ghrxzjc4vxmf4xa18c6m4xqy5wb0yk5c6b9psc7052";
      type = "gem";
    };
    version = "0.7.5";
  };
  websocket-extensions = {
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  writeexcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0waaf1drp17m5qdchxqlqzj51sfa9hxqccw7d71qdg73gzay1x34";
      type = "gem";
    };
    version = "1.0.5";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" "development" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  zeitwerk = {
    groups = [ "assets" "default" "development" "nulldb" "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1746czsjarixq0x05f7p3hpzi38ldg6wxnxxw74kbjzh1sdjgmpl";
      type = "gem";
    };
    version = "2.4.2";
  };
  zendesk_api = {
    dependencies = [ "faraday" "hashie" "inflection" "mini_mime" "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j50s7cw52hrjnd9v3lbfk76d44vx3sq4af7alz9hiy90gnxnd9z";
      type = "gem";
    };
    version = "1.33.0";
  };
}
