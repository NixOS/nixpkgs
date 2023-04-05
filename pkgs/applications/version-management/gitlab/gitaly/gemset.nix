{
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2y6sqpan68lrx78pvhbxb2917m75s808r6cg1kyygwvg31niza";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10g5gk8h4mfhvgqylzbf591fqf5p78ca35cb97p9bclpv9jfy0za";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14pjq2k761qaywaznpqq8ziivjk2ks1ma2cjwdflkxqgndxjmsr2";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nc8x27hlzlrr5c2gn7mar4vdr0apw5xg22wp6m8dx3wqr04a0y";
      type = "gem";
    };
    version = "2.4.2";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "078n2dkpgsivcf0pr50981w95nfc2bsrp3wpf9wnxz1qsp8jbb9s";
      type = "gem";
    };
    version = "1.0.0";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qnsflsbjj38im8xq35g0vihlz96h09wjn2dad5g543l3vvrkrx5";
      type = "gem";
    };
    version = "1.2.0";
  };
  crass = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  debug_inspector = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01l678ng12rby6660pmwagmyg8nccvjfgs3487xna7ay378a59ga";
      type = "gem";
    };
    version = "1.1.0";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  dotenv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
  };
  erubi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08s75vs9cxlc4r1q2bjg4br8g9wc5lc5x5vl0vv4zq5ivxsdpgi7";
      type = "gem";
    };
    version = "1.12.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pfk942d6qwhw151hxaz7n4knk6whyxqvvywdx2cdw9yhykyaqzq";
      type = "gem";
    };
    version = "6.2.1";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wwks9652xwgjm7yszcq5xr960pjypc07ivwzbjzpvy9zh2fw6iq";
      type = "gem";
    };
    version = "1.0.1";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  gitaly = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hpgljz05rhik15z081ghxw9pw83vz78p12wjdgxj3qz1a4x8pfq";
      type = "gem";
    };
    version = "15.5.0";
  };
  gitlab-labkit = {
    dependencies = ["actionpack" "activesupport" "grpc" "jaeger-client" "opentracing" "pg_query" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yxz433p9gg8avl94wnb68fm89zaq02r179dkirx5db614vkjfiy";
      type = "gem";
    };
    version = "0.31.1";
  };
  gitlab-license_finder = {
    dependencies = ["rubyzip" "thor" "tomlrb" "with_env" "xml-simple"];
    groups = ["development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzrv96kbzyqnsdj762x7n0y006rsgsi8k23nad4xsa43d065i71";
      type = "gem";
    };
    version = "6.14.2.1";
  };
  gitlab-markup = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvh8vv9kgd06hc8c1pl2hq56w56vr0n7dr5mz19fx4p2v89y7xb";
      type = "gem";
    };
    version = "1.8.1";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zqyy07ps6zh0gi9nppmnsngzv5nx1qjv726mzhv83sh90rc25nm";
      type = "gem";
    };
    version = "3.22.2";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04sy3c91nlw2sv53xf2h2yf0cc09bdcvj2qbjsxwzxpbqgfrf255";
      type = "gem";
    };
    version = "1.4.0";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jjq2ing7px4zvdrg9xcq5a9qsciq6g3v14n95a3d9n6cyg69lmk";
      type = "gem";
    };
    version = "1.42.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
  };
  jaeger-client = {
    dependencies = ["opentracing" "thrift"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a2qlkc1hkr5hkj2574l1a63sm04bdx98gfhh9m8vvp6psdrnpnb";
      type = "gem";
    };
    version = "1.1.0";
  };
  json = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nalhin1gda4v8ybk6lq8f407cgfrj6qzn234yra4ipkmlbfmal6";
      type = "gem";
    };
    version = "2.6.3";
  };
  licensee = {
    dependencies = ["dotenv" "octokit" "reverse_markdown" "rugged" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v9x94h19b20wc551vs9a0yvk44w2y3g9ng07fflk26s8jsmjsab";
      type = "gem";
    };
    version = "9.15.2";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08qhzck271anrx9y6qa6mh8hwwdzsgwld8q0000rcd7yvvpnjr3c";
      type = "gem";
    };
    version = "2.19.1";
  };
  method_source = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1af4yarhbbx62f7qsmgg5fynrik0s36wjy3difkawy536xg343mp";
      type = "gem";
    };
    version = "2.8.1";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjy67qajw4rnkbjs5jyk7kc3lyhz5613fwj1i8f6ppdk4zampy0";
      type = "gem";
    };
    version = "5.17.0";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lva6bkvb4mfa0m3bqn4lm4s4gi81c40jvdcsrxr6vng49q9daih";
      type = "gem";
    };
    version = "1.3.3";
  };
  multipart-post = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qr6psd9qgv83pklpw7cpmshkcasnv8d777ksmvwsacwfvvkmnxj";
      type = "gem";
    };
    version = "1.14.1";
  };
  octokit = {
    dependencies = ["faraday" "sawyer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fl517ld5vj0llyshp3f9kb7xyl9iqy28cbz3k999fkbwcxzhlyq";
      type = "gem";
    };
    version = "4.20.0";
  };
  opentracing = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11lj1d8vq0hkb5hjz8q4lm82cddrggpbb33dhqfn7rxhwsmxgdfy";
      type = "gem";
    };
    version = "0.5.0";
  };
  optimist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vnk6bb54k4yc06xnwck7php50l09vvlw1ga8wdz0pia461zpzb";
      type = "gem";
    };
    version = "1.22.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zk8mdyr0322r11d63rcp5jhz4lakxilhvyvdv0ql5dw4lb83623";
      type = "gem";
    };
    version = "3.2.0.0";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slcbzzqdv6104l5h8ql6kj43zmnm16g2dav8bc8dasfpwmrg1k0";
      type = "gem";
    };
    version = "2.2.1";
  };
  proc_to_ast = {
    dependencies = ["coderay" "parser" "unparser"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14c65w48bbzp5lh1cngqd1y25kqvfnq1iy49hlzshl12dsk3z9wj";
      type = "gem";
    };
    version = "0.1.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f3knlwfwm05sfbaihrxm4g772b79032q14c16q4b38z8bi63qcb";
      type = "gem";
    };
    version = "4.0.7";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jgz6r0f7v84a7jz9an85q8vvmp743dqcsdm3z9c8rqcqv6pljq";
      type = "gem";
    };
    version = "1.6.2";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17wg99w29hpiq9p4cmm8c6kdg4lcw0ll2c36qw7y50gy1cs4h5j2";
      type = "gem";
    };
    version = "2.2.6.3";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rjl709krgf499dhjdapg580l2qaj9d91pwzk8ck8fpnazlx1bdd";
      type = "gem";
    };
    version = "2.0.2";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ygav4xyq943qqyhjmi3mzirn180j565mc9h5j4css59x1sn0cmz";
      type = "gem";
    };
    version = "1.5.0";
  };
  rainbow = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8prj0klfgpmpfcpdzbf149qrrsdxgnb6w6kkqc9gyars4vyaqn";
      type = "gem";
    };
    version = "0.4.14";
  };
  redis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i4a8hxxcxci3n8hhlm9a8wa7a9m58r6sjvh4749v7362i8cy010";
      type = "gem";
    };
    version = "4.8.0";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zjg29w5zvar7by1kqck3zilbdzm5iz3jp5d1zn3970krskfazh2";
      type = "gem";
    };
    version = "2.6.2";
  };
  reverse_markdown = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w786j869fjhjf72waj0hc9i4ghi45b78a2am27kij4sa2hmsc53";
      type = "gem";
    };
    version = "1.4.0";
  };
  rexml = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171rc90vcgjl8p1bdrqa92ymrj8a87qf6w20x05xq29mljcigi6c";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ibb81slc35q5yp276sixp3yrvj9q92wlmi1glbnwlk6g49z8rn4";
      type = "gem";
    };
    version = "3.12.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03ba3lfdsj9zl00v1yvwgcx87lbadf87livlfa5kgqssn9qdnll6";
      type = "gem";
    };
    version = "3.12.2";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sq2cc9pm5gq411y7iwfvzbmgv3g91lyf7y7cqn1lr3yf1v122nc";
      type = "gem";
    };
    version = "3.12.3";
  };
  rspec-parameterized = {
    dependencies = ["rspec-parameterized-core" "rspec-parameterized-table_syntax"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11mk52x34j957rqccxfqlsqjzg26dz04ipd1v4yx5yraqx1v01ww";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-parameterized-core = {
    dependencies = ["parser" "proc_to_ast" "rspec" "unparser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfc2q7g8f5s6kdh1chwlalvz3fvj57vlfpn18b23677hm4ljyr8";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-parameterized-table_syntax = {
    dependencies = ["binding_of_caller" "rspec-parameterized-core"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "134q0hki279np9dv7mgr85wspdrvhpj9lpvxr9kx6pcwzwg9bpyp";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12y52zwwb3xr7h91dy9k3ndmyyhr3mjcayk0nnarnrzz8yr48kfx";
      type = "gem";
    };
    version = "3.12.0";
  };
  rubocop = {
    dependencies = ["json" "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a2j57r6pvngqlzkmww031gs5isax3nsr9n7cbfpqnh34ljh2lk1";
      type = "gem";
    };
    version = "1.44.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pdzabz95hv3z5sfbkfqa8bdybsfl13gv7rjb32v3ss8klq99lbd";
      type = "gem";
    };
    version = "1.24.1";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02nmaw7yx9kl7rbaan5pl8x5nn0y4j5954mzrkzi9i3dhsrps4nc";
      type = "gem";
    };
    version = "1.11.0";
  };
  rubyzip = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wnfgxx59nq2wpvi8ll7bqw9x99x5hps6i38xdjrwbb5a3896d58";
      type = "gem";
    };
    version = "1.5.1";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yrdchs3psh583rjapkv33mljdivggqn99wkydkjdckcjn43j3cz";
      type = "gem";
    };
    version = "0.8.2";
  };
  sentry-raven = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jin9x4f43lplglhr9smv2wxsjgmph2ygqlci4s0v0aq5493ng8h";
      type = "gem";
    };
    version = "3.1.2";
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18yhlvmfya23cs3pvhr1qy38y41b6mhr5q9vwv5lrgk16wmf3jna";
      type = "gem";
    };
    version = "1.1.0";
  };
  thrift = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r3k8x3vfaa6wnz8mhpn10938bzmfj489zc18q73xpsb469v0nv9";
      type = "gem";
    };
    version = "0.18.1";
  };
  tomlrb = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a83cb5xpyzlr651d46rk5xgq37s46hs9nfqy9baawzs31hm9k2g";
      type = "gem";
    };
    version = "2.0.1";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rx114mpqnw2k4h98vc0rs0x0bmf0img84yh8mkkjkal07cjydf5";
      type = "gem";
    };
    version = "2.0.5";
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gi82k102q7bkmfi7ggn9ciypn897ylln1jk9q67kjhr39fj043a";
      type = "gem";
    };
    version = "2.4.2";
  };
  unparser = {
    dependencies = ["diff-lcs" "parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j6ym6cn43ry4lvcal7cv0n9g9awny7kcrn1crp7cwx2vwzffhmf";
      type = "gem";
    };
    version = "0.6.7";
  };
  with_env = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r5ns064mbb99hf1dyxsk9183hznc5i7mn3bi86zka6dlvqf9csh";
      type = "gem";
    };
    version = "1.1.0";
  };
  xml-simple = {
    dependencies = ["rexml"];
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb9plyl71mdbjr4kllfy53qx6g68ryxblmnq9dilvy837jk24fj";
      type = "gem";
    };
    version = "1.1.9";
  };
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09pqhdi6q4sqv0p1gnjpbcy4az0yv8hrpykjngdgh9qiqd87nfdv";
      type = "gem";
    };
    version = "2.6.6";
  };
}
