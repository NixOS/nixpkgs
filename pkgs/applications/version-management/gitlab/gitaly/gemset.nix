{
  abstract_type = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09330cmhrc2wmfhdj9zzg82sv6cdhm3qgdkva5ni5xfjril2pf14";
      type = "gem";
    };
    version = "0.0.7";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5x42s72mik9xkrgbway4ra139k71p2dfxcvg5gwdmac8maiq7k";
      type = "gem";
    };
    version = "6.1.6.1";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0syh8jwih5qvv87zfyzl37rz6sc1prhy6gia95bn76zyqk9cfzx8";
      type = "gem";
    };
    version = "6.1.6.1";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vb0xi7yvgfqky9h4clyncb886mr1wvz9amk7d9ffmgpwrpzvjaz";
      type = "gem";
    };
    version = "6.1.6.1";
  };
  adamantium = {
    dependencies = ["ice_nine" "memoizable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0165r2ikgfwv2rm8dzyijkp74fvg0ni72hpdx8ay2v7cj08dqyak";
      type = "gem";
    };
    version = "0.2.0";
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
  binding_ninja = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17fa3sv6p2fw9g8fxpwx1kjhhs28aw41akkba0hlgvk60055b1aa";
      type = "gem";
    };
    version = "0.2.3";
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
  concord = {
    dependencies = ["adamantium" "equalizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b6cdn0fg4n9gzbdr7zyf4jq40y6h0c0g9cra7wk9hhmsylk91bg";
      type = "gem";
    };
    version = "0.1.5";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s4fpn3mqiizpmpy2a24k4v365pv75y50292r8ajrv4i1p5b2k14";
      type = "gem";
    };
    version = "1.1.10";
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
  equalizer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11bz1v1cxabm8672gabrw542zyg51dizlcvdck6vvwzagxbjv9zx";
      type = "gem";
    };
    version = "1.11.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02ijqa3g6lb8l8mvi40z1zgh9bb3gr08p2r2ym159ghhfbcrmbwk";
      type = "gem";
    };
    version = "5.0.2";
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
      sha256 = "09xlv72nbys9a5iqvhxfzdr7vy3s3m2a6ixqb9vq71k925faq6gb";
      type = "gem";
    };
    version = "0.29.0";
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
      sha256 = "0xnlra517pfj3hx07kasbqlcw51ix4xajr6bsd3mwg8bc92dlwy7";
      type = "gem";
    };
    version = "1.7.1";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dcgkhjiaxha3yznyxxzm8a4n4jf61rk7kgbxy4sdkb865zbn2ab";
      type = "gem";
    };
    version = "3.21.12";
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
  ice_nine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
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
      sha256 = "1fpyk1965py77al7iadkn5dibwgvybknkr7r8bii2dj73wvr29rh";
      type = "gem";
    };
    version = "2.19.0";
  };
  memoizable = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v42bvghsvfpzybfazl14qhkrjvx0xlmxz0wwqc960ga1wld5x5c";
      type = "gem";
    };
    version = "0.4.2";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
  };
  minitest = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0516ypqlx0mlcfn5xh7qppxqc3xndn1fnadxawa8wld5dkcimy30";
      type = "gem";
    };
    version = "5.16.3";
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
      sha256 = "0g7axlq2y6gzmixzzzhw3fn6nhrhg469jj8gfr7gs8igiclpkhkr";
      type = "gem";
    };
    version = "1.13.8";
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
      sha256 = "17b127xxmm2yqdz146qwbs57046kn0js1h8synv01dwqz2z1kp2l";
      type = "gem";
    };
    version = "1.19.2";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sszdl9mpzqzn9kxrp28sqmg47mjxcwypr4d60vbajqba4v885di";
      type = "gem";
    };
    version = "3.0.3.2";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l79y41nwwacabj61jkbh4r7haajaf8y4bn5pihh0m1g8547b8w4";
      type = "gem";
    };
    version = "2.2.0";
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
  procto = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13imvg1x50rz3r0yyfbhxwv72lbf7q28qx9l9nfbb91h2n9ch58c";
      type = "gem";
    };
    version = "0.0.3";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00rm71x0r1jdycwbs83lf9l6p494m99asakbvqxh8rz7zwnlzg69";
      type = "gem";
    };
    version = "0.12.2";
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
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0axc6w0rs4yj0pksfll1hjgw1k6a5q0xi2lckh91knfb72v348pa";
      type = "gem";
    };
    version = "2.2.4";
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
      sha256 = "1mj0b7ay10a2fgwj70kjw7mlyrp7a5la8lx8zmwhy40bkansdfrf";
      type = "gem";
    };
    version = "1.4.3";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "0n9d14ppshnx71i3mi1pnm3hwhcbb6m6vsc0b0dqgsab8r2rs96n";
      type = "gem";
    };
    version = "1.8.1";
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
      sha256 = "15ppasvb9qrscwlyjz67ppw1lnxiqnkzx5vkx1bd8x5n3dhikxc3";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1s5bnbqp3sxk67y0fh0x884jjym527r0vgmhbm81w7aq6b7l4p";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c4gs5ybf7km0qshdm92p38zvg32n1j2kr5fgs2icacz7xf2y6fy";
      type = "gem";
    };
    version = "3.8.3";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06y508cjqycb4yfhxmb3nxn0v9xqf17qbd46l1dh4xhncinr4fyp";
      type = "gem";
    };
    version = "3.8.0";
  };
  rspec-parameterized = {
    dependencies = ["binding_ninja" "parser" "proc_to_ast" "rspec" "unparser"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c0892jbaznnldk1wi24qxm70g4zhw2idqx516rhgdzgd7yh5j31";
      type = "gem";
    };
    version = "0.4.2";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p3m7drixrlhvj2zpc38b11x145bvm311x6f33jjcxmvcm0wq609";
      type = "gem";
    };
    version = "3.8.0";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jl3ghxw1bpj272s5s3gl07l2rbd1vwr9z9jmlxxaa2faldn9gms";
      type = "gem";
    };
    version = "0.86.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w5rjkwxaxkr2jr1sl5wz0nffal27ik6b1qfzx5skl43vfk2jz97";
      type = "gem";
    };
    version = "0.2.0";
  };
  ruby-progressbar = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k77i0d4wsn23ggdd2msrcwfy0i376cglfqypkk2q77r2l3408zf";
      type = "gem";
    };
    version = "1.10.1";
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
      sha256 = "1v846qs2pa3wnzgz95jzbcdrgl9vyjl65qiscw4q4dvm5sb7j68i";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "17j4br2lpnd8066d50mkg9kwk9v70hn3zfiqkvysd8p9nffmqnm0";
      type = "gem";
    };
    version = "3.0.4";
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
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  thrift = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12p856z7inf47azpvh9qswsfx8035r5hbzlg2x5n8z2sjqzjkk80";
      type = "gem";
    };
    version = "0.17.0";
  };
  timecop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d7mm786180v4kzvn1f77rhfppsg5n0sq2bdx63x9nv114zm8jrp";
      type = "gem";
    };
    version = "0.9.1";
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
      sha256 = "06i3id27s60141x6fdnjn5rar1cywdwy64ilc59cz937303q3mna";
      type = "gem";
    };
    version = "1.7.0";
  };
  unparser = {
    dependencies = ["abstract_type" "adamantium" "concord" "diff-lcs" "equalizer" "parser" "procto"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qg1apxlnf4kxfj9jpm6hhv73jsncbs4zpsgyan32p5r331q1gmx";
      type = "gem";
    };
    version = "0.4.7";
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
      sha256 = "0xjdr2szxvn3zb1sb5l8nfd6k9jr3b4qqbbg1mj9grf68m3fxckc";
      type = "gem";
    };
    version = "2.6.0";
  };
}
