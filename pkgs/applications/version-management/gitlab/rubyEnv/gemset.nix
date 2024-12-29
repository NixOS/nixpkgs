src:
{
  acme-client = {
    dependencies = ["faraday" "faraday-retry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgj5r8b7q242f3p9rr17v0q10dd9nx53gmscpmidz3gj90v7siz";
      type = "gem";
    };
    version = "2.0.18";
  };
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c46q4ykf8cqcpzad7zhkrxjhvf92sil0185zvxwzhj95p1zp5vr";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail" "net-imap" "net-pop" "net-smtp"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x100vq4rf2c5ndz8ai00hb5gsb9ax2xqc89dsfzzhxbpa9gs9ik";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "net-imap" "net-pop" "net-smtp" "rails-dom-testing"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hds7b6n7vsa64fmma7wl7x9mxscr89myfb13vxni5fcns1agwzr";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18k05a55i0xgyv60lx0m1psnyncn935j76ivbp9hssqpij00jj1f";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "globalid" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g54g1kjyrwv9g592gxfz7z6ksmj916l1cgkxk54zhywxf6gpn0y";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03rfynhj40270dqhkm4cyaphzb37b4fdiaqh9grvcfq760vx7ha5";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b54didwsg5p8wn30qjwspzh97w7g07hrsdzr7wdrdly4zii7sr1";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mi5cppdmkzgr2z135ibs0bq71qndbnip0vfflz1n4j4hqnhjkpg";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkv0jvvjc3grr0rvxni9b3j3hb22jaj0h70g476h9w54p0aljcb";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  activerecord-explain-analyze = {
    dependencies = ["activerecord" "pg"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvz452ww0vn3n6197gx6zklwa591gc7f1m8accvjd9zw8gv3ssx";
      type = "gem";
    };
    version = "0.1.0";
  };
  activerecord-gitlab = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/activerecord-gitlab";
      type = "path";
    };
    version = "0.2.0";
  };
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel" "mini_mime"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qdqx20dqkg7iwzb8q5148x5sl9mr2063hxzy4i7i94af2d2vz6b";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15z11983ws5svibg6rky9k2mgd4d4chnvddyxfpgn81b81q70139";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["danger" "default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  aes_key_wrap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bn0y70qm6mfj4y1m0j3s8ggh6dvxwrwrj5vfamhdrpddsz8ddr";
      type = "gem";
    };
    version = "1.1.0";
  };
  akismet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c5jhqfgvpz84d8jai51hin018ldpfd0civbk7mfwmrj7n71p6bl";
      type = "gem";
    };
    version = "3.0.0";
  };
  aliyun-sdk = {
    dependencies = ["nokogiri" "rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17avsza5r4f6d0f2ajgy6clmasrxs7jd16hz7ljq502jkczmv4b5";
      type = "gem";
    };
    version = "0.8.0";
  };
  amatch = {
    dependencies = ["mize" "tins"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xs5j64cbbjc94lx72fgjq6f3r99p2fmg51fh1r7qqifd8i1bzyk";
      type = "gem";
    };
    version = "0.4.1";
  };
  android_key_attestation = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02spc1sh7zsljl02v9d5rdb717b628vw2k7jkkplifyjk4db0zj6";
      type = "gem";
    };
    version = "0.3.0";
  };
  apollo_upload_server = {
    dependencies = ["actionpack" "graphql"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnddcnrb0gwhi0w2hrmh53fkpdxxy2v80rfp2q1hrcf4mr41v6w";
      type = "gem";
    };
    version = "2.1.6";
  };
  app_store_connect = {
    dependencies = ["activesupport" "jwt" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjwnb5fj0kzwgrn1n98gnb0s855ck1dm3j06sd01vcqj8829xih";
      type = "gem";
    };
    version = "0.38.0";
  };
  arr-pm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fddw0vwdrr7v3a0lfqbmnd664j48a9psrjd3wh3k4i3flplizzx";
      type = "gem";
    };
    version = "0.0.12";
  };
  asciidoctor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyxgwmnz9bw377r3lba26b090hbsq9qnbw8575a1prpy83qh82j";
      type = "gem";
    };
    version = "2.0.23";
  };
  asciidoctor-include-ext = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y3qixbssfrzp04ng7g4lh3dq16pgrw3p8cwc0v5bhmz5yfxnsj0";
      type = "gem";
    };
    version = "0.4.0";
  };
  asciidoctor-kroki = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qih280cjsh3nmywa5ja6kbrd576qmkxnp9zbmxjw3hjizc2ahlf";
      type = "gem";
    };
    version = "0.10.0";
  };
  asciidoctor-plantuml = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14qppm3qzfra2g2lf8jl3mbnrhi4alp8232zqz6dbpl6276lfzj0";
      type = "gem";
    };
    version = "0.0.16";
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
  async = {
    dependencies = ["console" "fiber-annotation" "io-event"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "199yvq9m9kx3svaxdrqg8ainfh2p7gfmkrlspc5d8nnhysnb6vql";
      type = "gem";
    };
    version = "2.12.1";
  };
  atlassian-jwt = {
    dependencies = ["jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08vqx5s0ax71lwis9l1bzy570sch0hpb53031ha2wgvp31sdilig";
      type = "gem";
    };
    version = "0.2.1";
  };
  attr_encrypted = {
    dependencies = ["encryptor"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/attr_encrypted";
      type = "path";
    };
    version = "3.2.4";
  };
  attr_required = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16fbwr6nmsn97n0a6k1nwbpyz08zpinhd6g7196lz1syndbgrszh";
      type = "gem";
    };
    version = "1.0.2";
  };
  awesome_print = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vkq6c8y2jvaw03ynds5vjzl1v9wg608cimkd3bidzxc0jvk56z9";
      type = "gem";
    };
    version = "1.9.2";
  };
  awrence = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gj8f8c54r9cabkm41s59sa1ca5wpbipw7gq3sfl87x9296227fx";
      type = "gem";
    };
    version = "1.2.1";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gvdg4yx4p9av2glmp7vsxhs0n8fj1ga9kq2xdb8f95j7b04qhzi";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01w3b84d129q9b6bg2cm8p4cn8pl74l343sxsc47ax9sglqz6y99";
      type = "gem";
    };
    version = "1.1001.0";
  };
  aws-sdk-cloudformation = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09kb3k5vpymg846gajc5d3wznww63yiv3ygdf4v42d4pf4wpbr1i";
      type = "gem";
    };
    version = "1.41.0";
  };
  aws-sdk-core = {
    dependencies = ["aws-eventstream" "aws-partitions" "aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16mvscjhxdyhlvk2rpbxdzqmyikcf64xavb35grk4dkh0pg390rk";
      type = "gem";
    };
    version = "3.211.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jfgw9a9c8xyjhkmgpd9rpi95h9i0rhbqszn8iqkbfm9rc9m1xz7";
      type = "gem";
    };
    version = "1.76.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jnf9k9d91ki3yvy12q4kph5wvd8l3ziwwh0qsmar5xhyb7zbwrz";
      type = "gem";
    };
    version = "1.169.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yf396fxashbqn0drbnvd9srxfg7w06v70q8kqpzi04zqchf6lvp";
      type = "gem";
    };
    version = "1.9.1";
  };
  axe-core-api = {
    dependencies = ["dumb_delegator" "virtus"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n7yv7s9mdxa3zz00gj93fsczk58ia3i1lj5adab677fpwbar9wy";
      type = "gem";
    };
    version = "4.9.1";
  };
  axe-core-rspec = {
    dependencies = ["axe-core-api" "dumb_delegator" "virtus"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zbf7rd353i6y1rr9ysk18kj3ivazfi3ma2ny6ryzminxrxhdvri";
      type = "gem";
    };
    version = "4.9.1";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  babosa = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mqrnyizr1ipdp26vhrg0hwb851bwyvrs6xc29dk3ywljw8s8d6";
      type = "gem";
    };
    version = "2.0.0";
  };
  backport = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xbzzjrgah0f8ifgd449kak2vyf30micpz6x2g82aipfv7ypsb4i";
      type = "gem";
    };
    version = "1.2.0";
  };
  base32 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b7y8sy6j9v1lvfzd4va88k5vg9yh0xcjzzn3llcw7yxqlcrnbjk";
      type = "gem";
    };
    version = "0.3.2";
  };
  base64 = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  batch-loader = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04zjpzb2m1qjxk0lzdi5m812wyq5kkwcdbxs1asbm67lp0wgcjwn";
      type = "gem";
    };
    version = "2.0.5";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "048z3fvcknqx7ikkhrcrykxlqmf9bzc7l0y5h1cnvrc9n2qf0k8m";
      type = "gem";
    };
    version = "3.1.18";
  };
  benchmark = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xwcnbwnbqq8jp92mvawn6y69cb53wsz84wwmk9vsfk1jjvqfw2z";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark-ips = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v3db77blqz3g4z8nskd3jhdviz5d6q2xxvzxvq5m2bk2228kahy";
      type = "gem";
    };
    version = "2.11.0";
  };
  benchmark-malloc = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0svyac8alxbmip6b9rp34wq5lcimdaapjkaqdw1385i66l28ziip";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark-memory = {
    dependencies = ["memory_profiler"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p5bwqc828yai7h71b7ny77hgd7dll00dy34izp3b5dh6dj467na";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark-perf = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08cngwnwk2h6cdxx3dyckxcg7d0yi3pm83c26kfzkq1xkyah2azy";
      type = "gem";
    };
    version = "0.6.0";
  };
  benchmark-trend = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10axhj80jan0b7c77hm0aj2yxv0dh9clfy4pppxvxfj3yjlh4nny";
      type = "gem";
    };
    version = "0.4.0";
  };
  better_errors = {
    dependencies = ["erubi" "rack" "rouge"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wqazisnn6hn1wsza412xribpw5wzx6b5z5p4mcpfgizr6xg367p";
      type = "gem";
    };
    version = "2.10.1";
  };
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cq1c29zbkcxgdihqisirhcw76xc768z2zpd5vbccpq0l1lv76g7";
      type = "gem";
    };
    version = "3.1.7";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0shg48ilaxn8ps8arvyb8pr6pqigdmccirks185c306dzychr3n3";
      type = "gem";
    };
    version = "2.4.11";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "078n2dkpgsivcf0pr50981w95nfc2bsrp3wpf9wnxz1qsp8jbb9s";
      type = "gem";
    };
    version = "1.0.0";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mdgj9yw1hmx3xh2qxyjc31y8igmxzd9h0c245ay2zkz76pl4k5c";
      type = "gem";
    };
    version = "1.18.4";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g4bcpax07kqqr9cp7cjc7i0pcij4nqpn1rdsg2wdwhzf00m6x32";
      type = "gem";
    };
    version = "5.3.1";
  };
  builder = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fxkrdiarjgcyw2ihh79kvjhpf6a4azj15wvx45clx6bfk0jb5s2";
      type = "gem";
    };
    version = "7.1.2";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gdx0019vj04n1512shhdx7hwphzqmdpw4vva2k551nd47y1dixx";
      type = "gem";
    };
    version = "0.9.1";
  };
  bundler-checksum = {
    dependencies = [];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/bundler-checksum";
      type = "path";
    };
    version = "0.1.0";
  };
  byebug = {
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
  capybara = {
    dependencies = ["addressable" "matrix" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxfah83j6zpw3v5hic0j70h519nvmix2hbszmjwm8cfawhagns2";
      type = "gem";
    };
    version = "3.40.0";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xqc7hdiw1ql42mklpfvqd2pyfsxmy55cpx0h9y0jlkpl1q96sw1";
      type = "gem";
    };
    version = "1.0.26";
  };
  carrierwave = {
    dependencies = ["activemodel" "activesupport" "mime-types" "ssrf_filter"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "089s8rbwddzcyw1ky34h90flz5wzqzi2lvajykbxn3l3s6mjsxw1";
      type = "gem";
    };
    version = "1.3.4";
  };
  cbor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dsf9gjc2cj79vrnz2vgq573biqjw7ad4b0idm05xg6rb3y9gq4y";
      type = "gem";
    };
    version = "0.5.9.8";
  };
  CFPropertyList = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "193l8r1ycd3dcxa7lsb4pqcghbk56dzc5244m6y8xmv88z6m31d7";
      type = "gem";
    };
    version = "3.0.5";
  };
  character_set = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l9z2pihzc11f0jpq2sx789zwpmwf5nyhsjps45zzvfs5931fwrb";
      type = "gem";
    };
    version = "1.8.0";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1dws56r7p8y363dhyikg7205z59a3bn4amnv2y488rrq8qm7ml";
      type = "gem";
    };
    version = "0.7.9";
  };
  chef-config = {
    dependencies = ["addressable" "chef-utils" "fuzzyurl" "mixlib-config" "mixlib-shellout" "tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pvjf3qbb3apg9vdy4zykamm7801qz4m6256wjqn73fs87zs50y1";
      type = "gem";
    };
    version = "18.3.0";
  };
  chef-utils = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087jwhqslfm3ygj507dmmdp3k0589j5jl54mkwgbabbwan7lzw2";
      type = "gem";
    };
    version = "18.3.0";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  circuitbox = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056snhim934xysz630ysfbfdxa64vin5y24h2ha1wvj9fqg9qvj9";
      type = "gem";
    };
    version = "2.0.0";
  };
  citrus = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l7nhk3gkm1hdchkzzhg2f70m47pc0afxfpl6mkiibc9qcpl3hjf";
      type = "gem";
    };
    version = "3.0.2";
  };
  claide = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bpqhc0kqjp1bh9b7ffc395l9gfls0337rrhmab4v46ykl45qg3d";
      type = "gem";
    };
    version = "1.1.0";
  };
  claide-plugins = {
    dependencies = ["cork" "nap" "open4"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bhw5j985qs48v217gnzva31rw5qvkf7qj8mhp73pcks0sy7isn7";
      type = "gem";
    };
    version = "0.9.2";
  };
  click_house-client = {
    dependencies = ["activesupport" "addressable" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/click_house-client";
      type = "path";
    };
    version = "0.1.0";
  };
  cloud_profiler_agent = {
    dependencies = ["google-cloud-profiler-v2" "google-protobuf" "googleauth" "stackprof"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/cloud_profiler_agent";
      type = "path";
    };
    version = "0.0.1.pre";
  };
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  colored2 = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commonmarker = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lb5slzbqrca49h0gaifg82xky5r7i9xgm4560pin1xl5fp15lzx";
      type = "gem";
    };
    version = "0.23.10";
  };
  concurrent-ruby = {
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qh1b14jwbbj242klkyz5fc7npd4j0mvndz62gajhvl1l3wd7zc2";
      type = "gem";
    };
    version = "1.2.3";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x32mcpm2cl5492kd6lbjbaf17qsssmpx9kdyr7z1wcif2cwyh0g";
      type = "gem";
    };
    version = "2.4.1";
  };
  console = {
    dependencies = ["fiber-annotation" "fiber-local" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hz9j70qyqsszckmvbdywrrgpsf3j5pvfj2l4wn7nlhf3f6by3s6";
      type = "gem";
    };
    version = "1.25.2";
  };
  cork = {
    dependencies = ["colored2"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g6l780z1nj4s3jr11ipwcj8pjbibvli82my396m3y32w98ar850";
      type = "gem";
    };
    version = "0.3.0";
  };
  cose = {
    dependencies = ["cbor" "openssl-signature_algorithm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00c6x4ha7qiaaf88qdbyf240mk146zz78rbm4qwyaxmwlmk7q933";
      type = "gem";
    };
    version = "1.3.0";
  };
  countries = {
    dependencies = ["i18n_data" "sixarm_ruby_unaccent"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic1zbzqbrvb3myhgzpq4vigr3qnyl2r0vga84d9z5121cy8lbnk";
      type = "gem";
    };
    version = "4.0.1";
  };
  coverband = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j0p1qsnnx0xhx43y7xskxwpcsv3yw5wj79qf7naf3nhdn73kkv5";
      type = "gem";
    };
    version = "6.1.4";
  };
  crack = {
    dependencies = ["safe_yaml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  crass = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  creole = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00rcscz16idp6dx0dk5yi5i0fz593i3r6anbn5bg2q07v3i025wm";
      type = "gem";
    };
    version = "0.5.0";
  };
  crystalball = {
    dependencies = ["git"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1why2py76hv2m7i3a1im3zi5zcjcvz2l1nvshzndlwah58vrywkf";
      type = "gem";
    };
    version = "0.7.0";
  };
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04q1vin8slr3k8mp76qz0wqgap6f9kdsbryvgfq9fljhrm463kpj";
      type = "gem";
    };
    version = "1.14.0";
  };
  cssbundling-rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qbwdksjq9lw2h4xs2lb7lvp94pwgv38hp0mm46qj8bvc8yjf8ab";
      type = "gem";
    };
    version = "1.4.1";
  };
  csv_builder = {
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/csv_builder";
      type = "path";
    };
    version = "0.1.0";
  };
  cvss-suite = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yfkibv7c7aazh8p3v9mksa2rdkqacq1x3621pyl4ah3jjg9xjmm";
      type = "gem";
    };
    version = "3.0.1";
  };
  danger = {
    dependencies = ["claide" "claide-plugins" "colored2" "cork" "faraday" "faraday-http-cache" "git" "kramdown" "kramdown-parser-gfm" "no_proxy_fix" "octokit" "terminal-table"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "104x4p9rmk8frf4l858p171vjaif7mqgxspx61d26c0hfg355ra3";
      type = "gem";
    };
    version = "9.4.2";
  };
  danger-gitlab = {
    dependencies = ["danger" "gitlab"];
    groups = ["danger" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a530kx5s5rbx5yx3jqay56lkksqh0yj468hcpg16faiyv8dfza9";
      type = "gem";
    };
    version = "8.0.0";
  };
  database_cleaner-active_record = {
    dependencies = ["activerecord" "database_cleaner-core"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iz1hv2b1z7509dxvxdwzay1hhs24glxls5ldbyh688zxkcdca1j";
      type = "gem";
    };
    version = "2.2.0";
  };
  database_cleaner-core = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v44bn386ipjjh4m2kl53dal8g4d41xajn2jggnmjbhn6965fil6";
      type = "gem";
    };
    version = "2.0.1";
  };
  date = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03skfikihpx37rc27vr3hwrb057gxnmdzxhmzd4bf4jpkl0r55w1";
      type = "gem";
    };
    version = "3.3.3";
  };
  dead_end = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrg9cwy21iwzl1djp1hamy24q3pfhvvrjqi9q0bwj81gizxy48h";
      type = "gem";
    };
    version = "3.1.1";
  };
  deb_version = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04z75v3wdghqbahgipvz8y75krkqq17jbbna349ddl9ggwfr27y2";
      type = "gem";
    };
    version = "1.0.2";
  };
  debug_inspector = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01l678ng12rby6660pmwagmyg8nccvjfgs3487xna7ay378a59ga";
      type = "gem";
    };
    version = "1.1.0";
  };
  deckar01-task_list = {
    dependencies = ["html-pipeline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rqn9jh45gsw045c6fm05875bpj2xbhnff5m5drmk9wy01zdrav6";
      type = "gem";
    };
    version = "2.3.4";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  declarative_policy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jri6fqpyrlnhl99mhqlqwpi6z8idb7g421rysxz40yyk8lwzx4s";
      type = "gem";
    };
    version = "1.1.0";
  };
  deprecation_toolkit = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fh4d98irhph3ri7c2rrvvmmjd4z14702r8baq9flh5f34dap8d8";
      type = "gem";
    };
    version = "1.5.1";
  };
  derailed_benchmarks = {
    dependencies = ["benchmark-ips" "dead_end" "get_process_mem" "heapy" "memory_profiler" "mini_histogram" "rack" "rack-test" "rake" "ruby-statistics" "thor"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kx1i7qsb5gvc24kxwq4bpcvsknm4c04mq7mz27m7dgfdhhcdbga";
      type = "gem";
    };
    version = "2.1.2";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  devfile = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18fbys0bf562681c96a4qcbdwxhlc9w3jz8rzkkfqns421hn024q";
      type = "gem";
    };
    version = "0.1.0";
  };
  device_detector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zbsjj1bgwmsiqiw6x5fzbzp25xc10c02s37ggl2635ha0qzn05q";
      type = "gem";
    };
    version = "1.0.0";
  };
  devise = {
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "warden"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121ljaaapil79dcsl5mkh5k613hv58z4z3g2lrnzb5qvqpb3h1j8";
      type = "gem";
    };
    version = "4.9.3";
  };
  devise-pbkdf2-encryptable = {
    dependencies = ["devise" "devise-two-factor"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/devise-pbkdf2-encryptable";
      type = "path";
    };
    version = "0.0.0";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15cbgb0hyq78myc6aaszzdrd9qll9n3qdhykmrx22qiyac3mnpy9";
      type = "gem";
    };
    version = "4.1.1";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwvjahnp7cpmracd8x732rjgnilqv2sx7d1gfrysslc3h039fa9";
      type = "gem";
    };
    version = "1.5.0";
  };
  diff_match_patch = {
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/diff_match_patch";
      type = "path";
    };
    version = "0.1.0";
  };
  diffy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qcsv29ljfhy76gq4xi8zpn6dc6nv15c41r131bdr38kwpxjzd1n";
      type = "gem";
    };
    version = "3.4.2";
  };
  digest-crc = {
    dependencies = ["rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09114ndpnnyamc2q07bmpzw7kp3rbbfv7plmxcbzzi9d6prmd92w";
      type = "gem";
    };
    version = "0.6.5";
  };
  discordrb-webhooks = {
    dependencies = ["rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c933kq48sqja1a2fc4ki9w8x5ajl6lp67hslka5k05hwfyaiysj";
      type = "gem";
    };
    version = "3.5.0";
  };
  docile = {
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lxqxgq71rqwj1lpl9q1mbhhhhhhdkkj7my341f2889pwayk85sz";
      type = "gem";
    };
    version = "1.4.0";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a6nbc12nfz355am2vwm1ql2p8zck7mr941glghmnl32djaga24b";
      type = "gem";
    };
    version = "5.7.1";
  };
  doorkeeper-device_authorization_grant = {
    dependencies = ["doorkeeper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y96jc05c26ld35q121yj1g7lfcb55jfsn6d1s2l42fml09arhwl";
      type = "gem";
    };
    version = "1.0.3";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpw7flhhkfffbfpxrpc46hw1jrvmyafn8npqzhlds8ks68sj2ap";
      type = "gem";
    };
    version = "1.8.9";
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
  dry-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w39jms4bsggxvl23cxanhccv1ngb6nqxsqhi784v5bjz1lx3si8";
      type = "gem";
    };
    version = "1.0.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03a5qn74c4lk2rpy6wlhv66synjlyzc4wn086xzphkpmw12l4bzk";
      type = "gem";
    };
    version = "1.0.1";
  };
  dry-inflector = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09hnvna3lg2x36li63988kv664d0zvy7y0z33803yvrdr9hj7lka";
      type = "gem";
    };
    version = "1.0.0";
  };
  dry-logic = {
    dependencies = ["concurrent-ruby" "dry-core" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05nldkc154r0qzlhss7n5klfiyyz05x2fkq08y13s34py6023vcr";
      type = "gem";
    };
    version = "1.5.0";
  };
  dry-types = {
    dependencies = ["concurrent-ruby" "dry-core" "dry-inflector" "dry-logic" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f6dz0hm67rhybh6xq2s3vvr700cp43kf50z2lids62s2i0mh5hj";
      type = "gem";
    };
    version = "1.7.1";
  };
  dumb_delegator = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151fdn7y0gqs7f6y3y7rn3frv0z359qrw9hb4s7avn6j2qc42ppz";
      type = "gem";
    };
    version = "1.0.0";
  };
  duo_api = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk1437b5vrjg8prk2khsva5rkx3apsj7c46n3yk5b8g34787jc7";
      type = "gem";
    };
    version = "1.3.0";
  };
  e2mmap = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n8gxjb63dck3vrmsdcqqll7xs7f3wk78mw8w0gdk9wp5nx6pvj5";
      type = "gem";
    };
    version = "0.1.0";
  };
  ed25519 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zb2dr2ihb1qiknn5iaj1ha1w9p7lj9yq5waasndlfadz225ajji";
      type = "gem";
    };
    version = "1.3.0";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11pw5x7kg6f6m8rqy2kpbzdlnvijjpmbqkj2gz8237wkbl40y27d";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01wi43a3zylrq2vca08vir5va142g5m3jcsak3rprjck8jvggn7y";
      type = "gem";
    };
    version = "7.17.11";
  };
  elasticsearch-model = {
    dependencies = ["activesupport" "elasticsearch" "hashie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02x2wvd22wwi2v6pps7y4advzkyfbhxn0fgsai49zcjbcrblnp4b";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-rails = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r2nh6csdlbfk5hqq5qbvvw1kvv6qa382alil2ixjn33jl7dql07";
      type = "gem";
    };
    version = "7.2.1";
  };
  elasticsearch-transport = {
    dependencies = ["base64" "faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00qgyyvjyyv7z22qjd408pby1h7902gdwkh8h3z3jk2y57amg06i";
      type = "gem";
    };
    version = "7.17.11";
  };
  email_reply_trimmer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vijywhy1acsq4187ss6w8a7ksswaf1d5np3wbj962b6rqif5vcz";
      type = "gem";
    };
    version = "0.1.6";
  };
  email_spec = {
    dependencies = ["htmlentities" "launchy" "mail"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yadaif80cf2ry0nvhir1s70xmm22xzncq6vfvvffdd8h02ridv0";
      type = "gem";
    };
    version = "2.2.0";
  };
  email_validator = {
    dependencies = ["activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0106y8xakq6frv2xc68zz76q2l2cqvhfjc7ji69yyypcbc4kicjs";
      type = "gem";
    };
    version = "2.2.4";
  };
  encryptor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8rvfl0vn8w7k1sgkc234060jh468s3zd45xa64p1jdmfa3zwmb";
      type = "gem";
    };
    version = "3.0.0";
  };
  error_tracking_open_api = {
    dependencies = ["typhoeus"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/error_tracking_open_api";
      type = "path";
    };
    version = "1.0.0";
  };
  erubi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08s75vs9cxlc4r1q2bjg4br8g9wc5lc5x5vl0vv4zq5ivxsdpgi7";
      type = "gem";
    };
    version = "1.12.0";
  };
  escape_utils = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "029c7kynhkxw8fgq9q171xi68ajfqrb22r7drvkar018j8871yyz";
      type = "gem";
    };
    version = "1.3.0";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r6zylqjfv0xhdxvldr0kgmnglm57nm506pcm6085f0xqa68cvnj";
      type = "gem";
    };
    version = "1.2.11";
  };
  ethon = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17ix0mijpsy3y0c6ywrk5ibarmvqzjsirjyprpsy3hwax8fdm85v";
      type = "gem";
    };
    version = "0.16.0";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j826kfvzn7nc5pv950n270r0sx1702k988ad11cdlav3dcxxw09";
      type = "gem";
    };
    version = "0.99.0";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  expgen = {
    dependencies = ["parslet"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fd2sdh3lc3x0qds30czli8k5qr45bkb7ssx0kb038hhn9jhysjf";
      type = "gem";
    };
    version = "0.1.1";
  };
  expression_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1938z3wmmdabqxlh5d5c56xfg1jc6z15p7zjyhvk7364zwydnmib";
      type = "gem";
    };
    version = "0.9.0";
  };
  extended-markdown-filter = {
    dependencies = ["html-pipeline"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7isjr3vpvmyc3arqcgn1fc69axxd73xk87nk31ibpv15sfzvn8";
      type = "gem";
    };
    version = "0.7.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q927lvgjqj0xaplxhicj5xv8xadx3957mank3p7g01vb6iv6x33";
      type = "gem";
    };
    version = "6.5.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "122wkrc3d2q1dlca27794hh3arw0kvrf3rgmvn7hj3y5lb51g7hk";
      type = "gem";
    };
    version = "6.4.4";
  };
  faraday = {
    dependencies = ["faraday-net_http" "json" "logger"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vxaw0mg8avqivdj0lzj19nxf652ri208grsdf0361flyn5i5wi3";
      type = "gem";
    };
    version = "2.12.1";
  };
  faraday-follow_redirects = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y87p3yk15bjbk0z9mf01r50lzxvp7agr56lbm9gxiz26mb9fbfr";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday-http-cache = {
    dependencies = ["faraday"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qvl49xpl2mwxgcj6aj11qrjk94xrqhbnpl5vp1y2275crnkddv4";
      type = "gem";
    };
    version = "2.5.0";
  };
  faraday-multipart = {
    dependencies = ["multipart-post"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09871c4hd7s5ws1wl4gs7js1k2wlby6v947m2bbzg43pnld044lh";
      type = "gem";
    };
    version = "1.0.4";
  };
  faraday-net_http = {
    dependencies = ["net-http"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17w51yk4rrm9rpnbc3x509s619kba0jga3qrj4b17l30950vw9qn";
      type = "gem";
    };
    version = "3.1.0";
  };
  faraday-net_http_persistent = {
    dependencies = ["faraday" "net-http-persistent"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02yydasm9qlq59dnj3dldaqd0xidxyx59pnr2iqygnjn7yqj05xl";
      type = "gem";
    };
    version = "2.1.0";
  };
  faraday-retry = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "023ncwlagnf2irx2ckyj1pg1f1x436jgr4a5y45mih298p8zwij1";
      type = "gem";
    };
    version = "2.2.1";
  };
  faraday-typhoeus = {
    dependencies = ["faraday" "typhoeus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rwhd2f78vqj0wkkdah395apx6igp5xf82n5xgixs61q45y19ii4";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday_middleware-aws-sigv4 = {
    dependencies = ["aws-sigv4" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13xym8pfjh1j2pf63r45ybdy6p4hjrqn4algml5wd8bwd17yl0d0";
      type = "gem";
    };
    version = "1.0.1";
  };
  fast_blank = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1shpmamyzyhyxmv95r96ja5rylzaw60r19647d0fdm7y2h2c77r6";
      type = "gem";
    };
    version = "1.0.1";
  };
  fast_gettext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "112gsrqah2w03kgi9mjsn6hl74mrwckphf223h36iayc4djf4lq2";
      type = "gem";
    };
    version = "2.3.0";
  };
  ffaker = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1644hpjg7k08dsjhljwg4grs49riaw6bxp5xf62jrac4q9fgnbcx";
      type = "gem";
    };
    version = "2.23.0";
  };
  ffi = {
    groups = ["default" "development" "kerberos" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07139870npj59jnl8vmk39ja3gdk3fb5z9vc0lf32y2h891hwqsi";
      type = "gem";
    };
    version = "1.17.0";
  };
  ffi-compiler = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  ffi-yajl = {
    dependencies = ["libyajl2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dj3y95260rvlclkkcxak6c1dsrzbyr4wik7jv3y949r4w9adfk9";
      type = "gem";
    };
    version = "2.6.0";
  };
  fiber-annotation = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = ["fiber-storage"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b5fr7i4p2gfqv6k2d93124zcv2kbdzvamalbcb1hn1yzm12gxq2";
      type = "gem";
    };
    version = "0.1.2";
  };
  find_a_port = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sswgpvn38yav4i21adrr7yy8c8299d7rj065gd3iwg6nn26lpb0";
      type = "gem";
    };
    version = "1.0.1";
  };
  flipper = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "127ryr9107719rfk9k638fxk2p38cnbz23h9ghxxbckiv4474mvd";
      type = "gem";
    };
    version = "0.26.2";
  };
  flipper-active_record = {
    dependencies = ["activerecord" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g10lck7p3776r2dshz185rd1hjzv47z95bhgpk7bxz2ikpsxpk1";
      type = "gem";
    };
    version = "0.26.2";
  };
  flipper-active_support_cache_store = {
    dependencies = ["activesupport" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6j2frspzafqmha5wlkpv05n5vfzrglbprpgj1dxiz5s4x8ily2";
      type = "gem";
    };
    version = "0.26.2";
  };
  fog-aliyun = {
    dependencies = ["addressable" "aliyun-sdk" "fog-core" "fog-json" "ipaddress" "xml-simple"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f6cwnq4vq628lgv1wn7fzmwgcpv840zbmcwpfpiwy7b9dh388wg";
      type = "gem";
    };
    version = "0.4.0";
  };
  fog-aws = {
    dependencies = ["base64" "fog-core" "fog-json" "fog-xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f67gjmvpcdql5mh4z9z0i03snwx80q7y37nyp1bgryb61gic4vm";
      type = "gem";
    };
    version = "3.27.0";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador" "mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1agd6xgzk0rxrsjdpn94v4hy89s0nm2cs4zg2p880w2dan9xgrak";
      type = "gem";
    };
    version = "2.1.0";
  };
  fog-google = {
    dependencies = ["addressable" "fog-core" "fog-json" "fog-xml" "google-apis-compute_v1" "google-apis-dns_v1" "google-apis-iamcredentials_v1" "google-apis-monitoring_v3" "google-apis-pubsub_v1" "google-apis-sqladmin_v1beta4" "google-apis-storage_v1" "google-cloud-env"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q2qhdkz7axp1f853d3jxx852gj5idrqhypxk8k3zm9fs72lxmnw";
      type = "gem";
    };
    version = "1.24.1";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj8llzc119zafbmfa4ai3z5s7c4vp9akfs0f9l2piyvcarmlkyx";
      type = "gem";
    };
    version = "1.2.0";
  };
  fog-local = {
    dependencies = ["fog-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yggsxd7c58p5i8zgvfw9rkqlg75l6hkbwnpgawd2sacwl4jsfr6";
      type = "gem";
    };
    version = "0.8.0";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "043lwdw2wsi6d55ifk0w3izi5l1d1h0alwyr3fixic7b94kc812n";
      type = "gem";
    };
    version = "0.1.3";
  };
  formatador = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  forwardable = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b5g1i3xdvmxxpq4qp0z4v78ivqnazz26w110fh4cvzsdayz8zgi";
      type = "gem";
    };
    version = "1.3.3";
  };
  fugit = {
    dependencies = ["et-orbi" "raabro"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cm2lrvhrpqq19hbdsxf4lq2nkb2qdldbdxh3gvi15l62dlb5zqq";
      type = "gem";
    };
    version = "1.8.1";
  };
  fuubar = {
    dependencies = ["rspec-core" "ruby-progressbar"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlv2wisgnim29h47shvqhipbz1wgndfdr7i6y5wcfag0z2660lv";
      type = "gem";
    };
    version = "2.2.0";
  };
  fuzzyurl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03qchs33vfwbsv5awxg3acfmlcrf5xbhnbrc83fdpamwya0glbjl";
      type = "gem";
    };
    version = "0.9.0";
  };
  gapic-common = {
    dependencies = ["faraday" "faraday-retry" "google-protobuf" "googleapis-common-protos" "googleapis-common-protos-types" "googleauth" "grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rlka373b2iva4dz2diz2zx7jyx617hwqvnfx2hs5xs0nh24fc5g";
      type = "gem";
    };
    version = "0.20.0";
  };
  gdk-toogle = {
    dependencies = ["haml" "rails"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jfjp87f4zi5jp8ydwabvfz3dv115ickaaasbs8c096kfqjrgf1q";
      type = "gem";
    };
    version = "0.9.5";
  };
  gemoji = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vgklpmhdz98xayln5hhqv4ffdyrglzwdixkn5gsk9rj94pkymc0";
      type = "gem";
    };
    version = "3.0.1";
  };
  get_process_mem = {
    dependencies = ["ffi"];
    groups = ["default" "puma" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fkyyyxjcx4iigm8vhraa629k2lxa1npsv4015y82snx84v3rzaa";
      type = "gem";
    };
    version = "0.2.7";
  };
  gettext = {
    dependencies = ["erubi" "locale" "prime" "racc" "text"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16h0kda5z4s4zqygyk0f52xzs9mlz9r4lnhjwk729hhmdbz68a19";
      type = "gem";
    };
    version = "3.4.9";
  };
  gettext_i18n_rails = {
    dependencies = ["fast_gettext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rlfmhhampvkzir32yqriry6rc6w66l36kb95lmfav4bjafp796l";
      type = "gem";
    };
    version = "1.13.0";
  };
  git = {
    dependencies = ["addressable" "rchardet"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rf4603ffvdlvnzx1nmh2x5j8lic3p24115sm7bx6p2nwii09f69";
      type = "gem";
    };
    version = "1.18.0";
  };
  gitaly = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05z84knb5f520azqcq0mzwrp3s4c13hpl1bfkkq86paw4hq94ihm";
      type = "gem";
    };
    version = "17.5.0.pre.rc42";
  };
  gitlab = {
    dependencies = ["httparty" "terminal-table"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycnjjk1im5a82k02avix7c5c87vrkl87gsghgq29g2x34z5wr1z";
      type = "gem";
    };
    version = "4.19.0";
  };
  gitlab-backup-cli = {
    dependencies = ["activesupport" "addressable" "concurrent-ruby" "faraday" "google-cloud-storage_transfer" "google-protobuf" "googleauth" "grpc" "json" "jwt" "logger" "minitest" "parallel" "rack" "rainbow" "rexml" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-backup-cli";
      type = "path";
    };
    version = "0.0.1";
  };
  gitlab-chronic = {
    dependencies = ["numerizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xf857vj55r1jafbkdpdzq6c22r964rj9186m1q8hw4vd7f1h3zq";
      type = "gem";
    };
    version = "0.10.5";
  };
  gitlab-dangerfiles = {
    dependencies = ["danger" "danger-gitlab" "rake"];
    groups = ["danger" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nr3llbg4vqs9w3027gmxgv5lhh80fd78kgk7fk79j9famwx09xk";
      type = "gem";
    };
    version = "4.8.0";
  };
  gitlab-duo-workflow-service-client = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/gitlab-duo-workflow-service-client";
      type = "path";
    };
    version = "0.1";
  };
  gitlab-experiment = {
    dependencies = ["activesupport" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j0zs29izmhqc1jvgfsvikqdyg6r8kf3j9azbmsmm02l45sfwc7j";
      type = "gem";
    };
    version = "0.9.1";
  };
  gitlab-fog-azure-rm = {
    dependencies = ["faraday" "faraday-follow_redirects" "faraday-net_http_persistent" "fog-core" "fog-json" "mime-types" "net-http-persistent" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p8bmbkfc0dkq663vxm9nx7kaajnqa5in1mcz0c8z31a86gcvgpm";
      type = "gem";
    };
    version = "2.1.0";
  };
  gitlab-glfm-markdown = {
    dependencies = ["rb_sys"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1vsqblhy9bqw01nsyylmhz0b50n17r7p69c2s757ahpk0hm5nb";
      type = "gem";
    };
    version = "0.0.21";
  };
  gitlab-housekeeper = {
    dependencies = ["activesupport" "awesome_print" "httparty" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-housekeeper";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-http = {
    dependencies = ["activesupport" "concurrent-ruby" "httparty" "ipaddress" "net-http" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-http";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-kas-grpc = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19qwlv3kjszypx8in77llqanlsgdcb16wsgzzfkph79hm7x9nqw8";
      type = "gem";
    };
    version = "17.5.1";
  };
  gitlab-labkit = {
    dependencies = ["actionpack" "activesupport" "grpc" "jaeger-client" "opentracing" "pg_query" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0063h3aksh4jp5s7mrir5r2dr94643x736cgxvf1zz75nx0nkyq4";
      type = "gem";
    };
    version = "0.36.1";
  };
  gitlab-license = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k9zaybfzp7q8w07ghf44q3yngxyrr68l623r9v7il9aki36q5jc";
      type = "gem";
    };
    version = "2.5.0";
  };
  gitlab-mail_room = {
    dependencies = ["jwt" "net-imap" "oauth2" "redis" "redis-namespace"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ivc4cbr5lc6lja947flzlppp3d9s44fwd3x8an0yvrq31yfg12";
      type = "gem";
    };
    version = "0.0.25";
  };
  gitlab-markup = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m3ypny84jyvlxf060p3q3d8pb4yihxa2br5hh012bgc11d09nky";
      type = "gem";
    };
    version = "1.9.0";
  };
  gitlab-net-dns = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1785yfzgpzwkwsxi3wadwc3mlxvdj304aapi34482hwx8xwdj9pp";
      type = "gem";
    };
    version = "0.9.2";
  };
  gitlab-rspec = {
    dependencies = ["activerecord" "activesupport" "rspec"];
    groups = ["development" "monorepo" "test"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-rspec";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-rspec_flaky = {
    dependencies = ["activesupport" "rspec"];
    groups = ["development" "monorepo" "test"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-rspec_flaky";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-safe_request_store = {
    dependencies = ["rack" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-safe_request_store";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-schema-validation = {
    dependencies = ["diffy" "pg_query"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-schema-validation";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-sdk = {
    dependencies = ["activesupport" "rake" "snowplow-tracker"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0457dvz8zsb4fav85ry1v5pdzpyr41q397zgqzvjvfaa9w44kfj8";
      type = "gem";
    };
    version = "0.3.1";
  };
  gitlab-secret_detection = {
    dependencies = ["parallel" "re2" "toml-rb"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-secret_detection";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab-security_report_schemas = {
    dependencies = ["activesupport" "json_schemer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bl0qrmb6xci719zxnaizja2pf0wabzi91b49y0immf9gr43f01h";
      type = "gem";
    };
    version = "0.1.2.min15.0.0.max15.2.1";
  };
  gitlab-sidekiq-fetcher = {
    dependencies = ["json" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/sidekiq-reliable-fetch";
      type = "path";
    };
    version = "0.12.0";
  };
  gitlab-styles = {
    dependencies = ["rubocop" "rubocop-capybara" "rubocop-factory_bot" "rubocop-graphql" "rubocop-performance" "rubocop-rails" "rubocop-rspec" "rubocop-rspec_rails"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gb89c035f32hj8iam4hxlyx6c7f1apq66hzzrvan5djjzz4065z";
      type = "gem";
    };
    version = "13.0.1";
  };
  gitlab-topology-service-client = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/gitlab-topology-service-client";
      type = "path";
    };
    version = "0.1";
  };
  gitlab-utils = {
    dependencies = ["actionview" "activesupport" "addressable" "rake"];
    groups = ["monorepo"];
    platforms = [];
    source = {
      path = "${src}/gems/gitlab-utils";
      type = "path";
    };
    version = "0.1.0";
  };
  gitlab_chronic_duration = {
    dependencies = ["numerizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vf1zw3z45m6ldwjvvzvbc6gr0spcbl1x1vny4qwid8msi26jxhd";
      type = "gem";
    };
    version = "0.12.0";
  };
  gitlab_omniauth-ldap = {
    dependencies = ["net-ldap" "omniauth" "pyu-ruby-sasl" "rubyntlm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1343sax19jidp7nr4s8bxpkyqwy6zb9lfslg99jys8xinfn20kdv";
      type = "gem";
    };
    version = "2.2.0";
  };
  gitlab_quality-test_tooling = {
    dependencies = ["activesupport" "amatch" "fog-google" "gitlab" "http" "influxdb-client" "nokogiri" "parallel" "rainbow" "rspec-parameterized" "table_print" "zeitwerk"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z74fj5gklxpq8bc622f6psaaz8fpkg08q4lf28kj9krcx3b0jw3";
      type = "gem";
    };
    version = "2.1.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kqm5ndzaybpnpxqiqkc41k4ksyxl41ln8qqr6kb130cdxsf2dxk";
      type = "gem";
    };
    version = "1.1.0";
  };
  gon = {
    dependencies = ["actionpack" "i18n" "multi_json" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w6ji15jrl4p6q0gxy5mmqspvzbmgkqj1d3xmbqr0a1rb7b1i9p3";
      type = "gem";
    };
    version = "6.4.0";
  };
  google-apis-androidpublisher_v3 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09almff2kzdkciai63365q18wy0dfjhj48h8wa7lk77pjbfxgqfp";
      type = "gem";
    };
    version = "0.34.0";
  };
  google-apis-cloudbilling_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00hy54g38rwz71l5gh41zm7v9gywrz7mh6m1z3bwrqh98ixq8bga";
      type = "gem";
    };
    version = "0.21.0";
  };
  google-apis-cloudresourcemanager_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gzv5svbj62qcdw5ljva0sh8wifjx9wwx00kfj9bbff052i7597h";
      type = "gem";
    };
    version = "0.31.0";
  };
  google-apis-compute_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s40lzp1nvnpda45lvybira8gll8snkdd4v3x7sl8fmwi9a18ia0";
      type = "gem";
    };
    version = "0.57.0";
  };
  google-apis-container_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0914hq1wcnvg68vcdwpq5kxnm5h38ay7rrdsrzlqn9i7rca2a7bq";
      type = "gem";
    };
    version = "0.43.0";
  };
  google-apis-container_v1beta1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l0k0davbaaqx76jy9vb6vk6j0l9hl68jmkgn7m6r4nvi37qzi38";
      type = "gem";
    };
    version = "0.43.0";
  };
  google-apis-core = {
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "rexml" "webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cly6ycryjhk15d60v3nqvhqpjk9f0nznnslbdnin90f5r54sbpd";
      type = "gem";
    };
    version = "0.11.2";
  };
  google-apis-dns_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ivx6km85mlycb11x2rbkyg3kl4syy3730q7pk8h6zdkibbp7ljx";
      type = "gem";
    };
    version = "0.36.0";
  };
  google-apis-iam_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rhzka4h1zg83zdyalbic25xbp8wrywsdfi6hdp663axdf3y5dqd";
      type = "gem";
    };
    version = "0.36.0";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06smnmn2s460xl9x9rh07a3fkqdrjjy6azmx8iywggqgv2k5d8p9";
      type = "gem";
    };
    version = "0.15.0";
  };
  google-apis-monitoring_v3 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a31sid7p4qn4m1gcq8z1bsqdyzzc84h4frh2dw97k5lwpff2zv7";
      type = "gem";
    };
    version = "0.54.0";
  };
  google-apis-pubsub_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01dj7jx6dfyl4wz88nn7ml45qvck6khl7gli8h6hl9c1qwa4dzhx";
      type = "gem";
    };
    version = "0.45.0";
  };
  google-apis-serviceusage_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmh25nvf8f9p9fribm18nszvamilshavrmwyq3xmrs76q17w2sz";
      type = "gem";
    };
    version = "0.28.0";
  };
  google-apis-sqladmin_v1beta4 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17bljsgmbp80d6wn3wjbzi537a9f5hmcr0zv776z2y8q92v565am";
      type = "gem";
    };
    version = "0.41.0";
  };
  google-apis-storage_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k432qgxf41c4m6d68rascm0gyj18r7ypmrnyzmxh7k7nh543awx";
      type = "gem";
    };
    version = "0.29.0";
  };
  google-cloud-artifact_registry-v1 = {
    dependencies = ["gapic-common" "google-cloud-errors" "google-cloud-location" "grpc-google-iam-v1"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gkq82lsjz3yw9w819ifdqx9ixcbgydr5myy64wnczknx7fd505s";
      type = "gem";
    };
    version = "0.11.0";
  };
  google-cloud-common = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yxmdxx933q48397jsczsmpshr4b61izv3spnhvzxd24s67v13bk";
      type = "gem";
    };
    version = "1.1.0";
  };
  google-cloud-compute-v1 = {
    dependencies = ["gapic-common" "google-cloud-common" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07hly5qbdy0qddw48biw0ybi2cx13861l5i09mj2abzw7yrmjq5r";
      type = "gem";
    };
    version = "2.6.0";
  };
  google-cloud-core = {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dagdfx3rnk9xplnj19gqpqn41fd09xfn8lp2p75psihhnj2i03l";
      type = "gem";
    };
    version = "1.7.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16b9yjbrzal1cjkdbn29fl06ikjn1dpg1vdsjak1xvhpsp3vhjyg";
      type = "gem";
    };
    version = "2.1.1";
  };
  google-cloud-errors = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jynh1s93nl8njm5l5wcy86pnjmv112cq6m0443s52f04hg6h2s5";
      type = "gem";
    };
    version = "1.3.0";
  };
  google-cloud-location = {
    dependencies = ["gapic-common" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l6j0i8flfdzl9c7db990632jmn5v7bmbh1i6x0sqp3f2p59jv1q";
      type = "gem";
    };
    version = "0.6.0";
  };
  google-cloud-profiler-v2 = {
    dependencies = ["gapic-common" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qyknlvwji7vqhani490cacsrzlqfza10hv47him93yhfnqjmz2k";
      type = "gem";
    };
    version = "0.4.0";
  };
  google-cloud-storage = {
    dependencies = ["addressable" "digest-crc" "google-apis-iamcredentials_v1" "google-apis-storage_v1" "google-cloud-core" "googleauth" "mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0033bi8qwm0ksxsv5zhz4nzwsiaapq3xk79z8f8rx3v09vdap07j";
      type = "gem";
    };
    version = "1.45.0";
  };
  google-cloud-storage_transfer = {
    dependencies = ["google-cloud-core" "google-cloud-storage_transfer-v1"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n0nxy4l2kzcmcgx7j8mppyw9gwc8331fqcf6w6jmq4913sh2a8k";
      type = "gem";
    };
    version = "1.2.0";
  };
  google-cloud-storage_transfer-v1 = {
    dependencies = ["gapic-common" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk1i7wg5alcgd9v4f0y3mjgxbsrcp53jhdjdc26wmfvfl1giglx";
      type = "gem";
    };
    version = "0.8.0";
  };
  google-protobuf = {
    groups = ["default" "development" "opentelemetry" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fanhdf3vzghma51w1hqpp8s585mwzxgqkwvxj5is4q9j0pgwcs3";
      type = "gem";
    };
    version = "3.25.5";
  };
  googleapis-common-protos = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types" "grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10p3kl9xdxl4xsijkj2l6qn525xchkbfhx3ch603ammibbxq08ys";
      type = "gem";
    };
    version = "1.4.0";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12w5bwaziz2iqb9dvgnskp2a7ifml6n4lyl9ypvnxj5bfrrwysap";
      type = "gem";
    };
    version = "1.5.0";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ry9v23kndgx2pxq9v31l68k9lnnrcz1w4v75bkxq88jmbddljl1";
      type = "gem";
    };
    version = "1.8.1";
  };
  gpgme = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r1vmql7w7ka5xzj1aqf8pk2a4sv0znwj2zkg1fgvd5b89qcvv2k";
      type = "gem";
    };
    version = "2.0.24";
  };
  grape = {
    dependencies = ["activesupport" "builder" "dry-types" "mustermann-grape" "rack" "rack-accept"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jj98w80ry1ir8lc3347130s0z8yd7gk727r9ynwwk782x6gkvrs";
      type = "gem";
    };
    version = "2.0.0";
  };
  grape-entity = {
    dependencies = ["activesupport" "multi_json"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d16s18k34crhyc44ycj062y81sdahgp8pcll9xggbq7wja9w3z0";
      type = "gem";
    };
    version = "1.0.1";
  };
  grape-path-helpers = {
    dependencies = ["activesupport" "grape" "rake" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mq2cwy0jvprq3wdilds1n865jdl58sqg00im4w6fybf5kjiclmd";
      type = "gem";
    };
    version = "2.0.1";
  };
  grape-swagger = {
    dependencies = ["grape" "rack-test"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "079wa3bn9drp9gysxfyjpvcxlazj1ssylv2nqm8aqv5f3nx8jkgm";
      type = "gem";
    };
    version = "2.1.1";
  };
  grape-swagger-entity = {
    dependencies = ["grape-entity" "grape-swagger"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpcsyzagcmd6pjixvms7mq0nc0aky53aw9mb9vmc6jbjqlfp852";
      type = "gem";
    };
    version = "0.5.5";
  };
  grape_logging = {
    dependencies = ["grape" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lcjqwal3wc2r41wsi01d09cyhxhglxp6y7hd0564pdx5lr3xk7g";
      type = "gem";
    };
    version = "1.8.4";
  };
  graphlient = {
    dependencies = ["faraday" "graphql-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cbwirpx8hclxyrxfbjz5c62l7i6nsqg6x72yplm8d083pd0ii4q";
      type = "gem";
    };
    version = "0.8.0";
  };
  graphlyte = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kc0l67n5zlpwbnb8nrr27nm4fzpb7qih77a00grcvnygnv4mbxm";
      type = "gem";
    };
    version = "1.0.0";
  };
  graphql = {
    dependencies = ["base64" "fiber-storage"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sc2s5yprba7i6x8iskd39fsp93r04xa08wbz1m5bygvj0lb7zpf";
      type = "gem";
    };
    version = "2.4.1";
  };
  graphql-client = {
    dependencies = ["activesupport" "graphql"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdb5fd1vd1zs7kc84ng7lj95081dqwrapyidg8alsv7a7jbhf7j";
      type = "gem";
    };
    version = "0.23.0";
  };
  graphql-docs = {
    dependencies = ["commonmarker" "escape_utils" "extended-markdown-filter" "gemoji" "graphql" "html-pipeline" "sass-embedded"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "011dasgfg93s39p2nnf88v2w9ds2czqxpgxvkxm4nfl0b9pcmfkn";
      type = "gem";
    };
    version = "5.0.0";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ink0ayf14qgs3msn5a7dpg49vm3ck2415r64nfk1i8xv286hsz";
      type = "gem";
    };
    version = "1.63.0";
  };
  grpc-google-iam-v1 = {
    dependencies = ["google-protobuf" "googleapis-common-protos" "grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kip34n9604j2cc9rkplv5ljq0n8f4aizix4yr8rginsa38md8yf";
      type = "gem";
    };
    version = "1.5.0";
  };
  gssapi = {
    dependencies = ["ffi"];
    groups = ["kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qdfhj12aq8v0y961v4xv96a1y2z80h3xhvzrs9vsfgf884g6765";
      type = "gem";
    };
    version = "1.3.1";
  };
  guard = {
    dependencies = ["formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fwgvkmrg97xfswwgfrfcl1nc937yxwazfvpmf8vxj7cvnx7mfki";
      type = "gem";
    };
    version = "2.16.2";
  };
  guard-compat = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-rspec = {
    dependencies = ["guard" "guard-compat" "rspec"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jkm5xp90gm4c5s51pmf92i9hc10gslwwic6mvk72g0yplya0yx4";
      type = "gem";
    };
    version = "4.7.3";
  };
  haml = {
    dependencies = ["temple" "tilt"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "035fgbfr20m08w4603ls2lwqbggr0vy71mijz0p68ib1am394xbf";
      type = "gem";
    };
    version = "5.2.2";
  };
  haml_lint = {
    dependencies = ["haml" "parallel" "rainbow" "rubocop" "sysexits"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cc45znb0fiab69d0x67yakd5kywwl7w9ck128ikzqrgixa2ps12";
      type = "gem";
    };
    version = "0.59.0";
  };
  hamlit = {
    dependencies = ["temple" "thor" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13n3v9kbyrrm48hn1v0028cdrsq7pswb4s4w63x4b29kc99m1s6j";
      type = "gem";
    };
    version = "2.15.0";
  };
  hana = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jf9dxgjz6z7fvymyz2acyvn9iyvwkn6d9sk7y4fxwbmfc75yimm";
      type = "gem";
    };
    version = "1.1.0";
  };
  hashie = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  health_check = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mrv2323hx4lbcr6xii6ry89b3zvly5jsaacwbblxibx4c46a50h";
      type = "gem";
    };
    version = "3.1.0";
  };
  heapy = {
    dependencies = ["thor"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sl56ma851i82g3ax08igbn48igriiy152xzx30wgzv1bn21w53l";
      type = "gem";
    };
    version = "0.2.0";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "180kjksi0sdlqb0aq0bhal96ifwqm25hzb3w709ij55j51qls7ca";
      type = "gem";
    };
    version = "2.14.3";
  };
  html2text = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kxdj8pf9pss9xgs8aac0alj5g1fi225yzdhh33lzampkazg1hii";
      type = "gem";
    };
    version = "0.2.0";
  };
  htmlbeautifier = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y55dx25l3wwc025mwl6jsbcsqrm30gs2d2pxnaxg07yh22ckq4x";
      type = "gem";
    };
    version = "1.4.2";
  };
  htmlentities = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = ["addressable" "http-cookie" "http-form_data" "llhttp-ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bzb8p31kzv6q5p4z5xq88mnqk414rrw0y5rkhpnvpl29x5c3bpw";
      type = "gem";
    };
    version = "5.1.1";
  };
  http-accept = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      type = "gem";
    };
    version = "1.0.5";
  };
  http-form_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
  };
  httparty = {
    dependencies = ["mini_mime" "multi_xml"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "050jzsa6fbfvy2rldhk7mf1sigildaqvbplfz2zs6c0zlzwppvq0";
      type = "gem";
    };
    version = "0.21.0";
  };
  httpclient = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbm33fpb3w06wd2231sg58dwlwgjsvym93m548ajvl6s3mfvpn7";
      type = "gem";
    };
    version = "1.14.4";
  };
  i18n_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rizqqss1bvb668mw72ls7rlj6im82aizz230jxn7d39kaq9kap5";
      type = "gem";
    };
    version = "0.13.1";
  };
  icalendar = {
    dependencies = ["ice_cube"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "022nal50cxz0y3ylbgjndqf97wbhh6knmjyq43r6mb8r8b5cs3np";
      type = "gem";
    };
    version = "2.10.2";
  };
  ice_cube = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dri4mcya1fwzrr9nzic8hj1jr28a2szjag63f9k7p2bw9fpw4fs";
      type = "gem";
    };
    version = "0.16.4";
  };
  ice_nine = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  imagen = {
    dependencies = ["parser"];
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm1jcprs0xys8m72kgm9pasd1xzhiqiyv64baxwcygyshkvgrzx";
      type = "gem";
    };
    version = "0.1.8";
  };
  influxdb-client = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j01r3rhai3h0bgq7npi49xz6ahm5sj6zag8b0l3amdxp82wb7ay";
      type = "gem";
    };
    version = "3.1.0";
  };
  invisible_captcha = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07ibhphcvf9lfaar9g78cazbdrp03dzfks53bcaiss8vxgrm5d02";
      type = "gem";
    };
    version = "2.1.0";
  };
  io-event = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qjcgf02p99r46s0sdr95s0dfc4dik946iqsv9iiahazmi2c192x";
      type = "gem";
    };
    version = "1.6.5";
  };
  ipaddr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ypic2hrmvvcgw7al72raphqv5cs1zvq4w284pwrkvfqsrqrqrsf";
      type = "gem";
    };
    version = "1.2.5";
  };
  ipaddress = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  ipynbdiff = {
    dependencies = ["diffy" "oj"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/ipynbdiff";
      type = "path";
    };
    version = "0.4.8";
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
  jaro_winkler = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10fd3i92897blalxfkgc0jjv0qqx31v7cm7j2b6a3b97an0bfz80";
      type = "gem";
    };
    version = "1.5.6";
  };
  jira-ruby = {
    dependencies = ["activesupport" "atlassian-jwt" "multipart-post" "oauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qpbc97sag426h4hgcizqq2njxx5fridzxq6mq5s93jazxmnxwmb";
      type = "gem";
    };
    version = "2.3.0";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  js_regex = {
    dependencies = ["character_set" "regexp_parser" "regexp_property_values"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1da4ccsq5bycg28iv0smmrra80jad3a8ya10lps5lv8fbbfvqd3r";
      type = "gem";
    };
    version = "3.8.0";
  };
  json = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1prbjd8r4rq6hjc6d5hn8hlpf4g9h62swxj7absjac7qqnzwrhvw";
      type = "gem";
    };
    version = "2.7.3";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "base64" "bindata" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v16kd05ijdmw1q8avpfsjkdiha6c2070hbz2g2fqg3lv2f1yidb";
      type = "gem";
    };
    version = "1.16.6";
  };
  json_schemer = {
    dependencies = ["bigdecimal" "hana" "regexp_parser" "simpleidn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dgbrps0ydiyxcgj5n4dny0cmzwj125x1s792l7m5jjrp1rs27wz";
      type = "gem";
    };
    version = "2.3.0";
  };
  jsonb_accessor = {
    dependencies = ["activerecord" "activesupport" "pg"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q2q9i2kf4p6vw8fbzvsd037wl837gpsiiikjazf6fdfayi803v7";
      type = "gem";
    };
    version = "1.3.10";
  };
  jsonpath = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fkdjic88hh0accp0sbx5mcrr9yaqwampf5c3214212d4i614138";
      type = "gem";
    };
    version = "1.1.2";
  };
  jwt = {
    dependencies = ["base64"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rba9mji57sfa1kjhj0bwff1377vj0i8yx2rd39j5ik4vp60gzam";
      type = "gem";
    };
    version = "2.9.3";
  };
  kaminari = {
    dependencies = ["activesupport" "kaminari-actionview" "kaminari-activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gia8irryvfhcr6bsr64kpisbgdbqjsqfgrk12a11incmpwny1y4";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-actionview = {
    dependencies = ["actionview" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02f9ghl3a9b5q7l079d3yzmqjwkr4jigi7sldbps992rigygcc0k";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-activerecord = {
    dependencies = ["activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c148z97s1cqivzbwrak149z7kl1rdmj7dxk6rpkasimmdxsdlqd";
      type = "gem";
    };
    version = "1.2.2";
  };
  kaminari-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zw3pg6kj39y7jxakbx7if59pl28lhk98fx71ks5lr3hfgn6zliv";
      type = "gem";
    };
    version = "1.2.2";
  };
  knapsack = {
    dependencies = ["rake"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f42akjbdkrg1ihwvls9pkkvz8vikaapzgxl82dd128rfn42chm9";
      type = "gem";
    };
    version = "4.0.0";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic14hdcqxn821dvzki99zhmcy130yhv5fqfffkcf87asv5mnbmn";
      type = "gem";
    };
    version = "2.4.0";
  };
  kramdown-parser-gfm = {
    dependencies = ["kramdown"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8pb3v951f4x7h968rqfsa19c8arz21zw1vaj42jza22rap8fgv";
      type = "gem";
    };
    version = "1.1.0";
  };
  kubeclient = {
    dependencies = ["http" "jsonpath" "recursive-open-struct" "rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k1zi27fnasqpinfxnajm81pyr11k2j510wacr53d37v97bzr1a9";
      type = "gem";
    };
    version = "4.11.0";
  };
  language_server-protocol = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gvb1j8xsqxms9mww01rmdl78zkd72zgxaap56bhv8j45z05hp1x";
      type = "gem";
    };
    version = "3.17.0.3";
  };
  launchy = {
    dependencies = ["addressable"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06r43899384das2bkbrpsdxsafyyqa94il7111053idfalb4984a";
      type = "gem";
    };
    version = "2.5.2";
  };
  lefthook = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bswnpka6w3ph2v3bv1ixmxbszank2a0hkpg4d3qdai2vmnyy9qc";
      type = "gem";
    };
    version = "1.7.18";
  };
  letter_opener = {
    dependencies = ["launchy"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cnv3ggnzyagl50vzs1693aacv08bhwlprcvjp8jcg2w7cp3zwrg";
      type = "gem";
    };
    version = "1.10.0";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties" "rexml"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q4qfi5wnn5bv93zjf10agmzap3sn7gkfmdbryz296wb1vz1wf9z";
      type = "gem";
    };
    version = "3.0.0";
  };
  libyajl2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vx0mv0bbcy0qh3ik08b42vrq4kw1zg51121r18c0vvp4p3zcpda";
      type = "gem";
    };
    version = "2.1.0";
  };
  license_finder = {
    dependencies = ["rubyzip" "thor" "tomlrb" "with_env" "xml-simple"];
    groups = ["development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v66fb85majc816qip42kbwcn41lr6rm5w6zim4a2kgp74v0n0kd";
      type = "gem";
    };
    version = "7.1.0";
  };
  licensee = {
    dependencies = ["dotenv" "octokit" "reverse_markdown" "rugged" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16h8yhk4z2wk2lc0l0m7z2pbbk6mfljhy6hp11dx6lw8dp325q0b";
      type = "gem";
    };
    version = "9.17.1";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0agybr37wpjv3xy4ipcmsvsibgdgphzrwbvcj4vfiykpmakwm01v";
      type = "gem";
    };
    version = "3.7.1";
  };
  llhttp-ffi = {
    dependencies = ["ffi-compiler" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00dh6zmqdj59rhcya0l4b9aaxq6n8xizfbil93k0g06gndyk5xz5";
      type = "gem";
    };
    version = "0.4.0";
  };
  locale = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0997465kxvpxm92fiwc2b16l49mngk7b68g5k35ify0m3q0yxpdn";
      type = "gem";
    };
    version = "2.1.3";
  };
  lockbox = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sm365iplg1iscizckjm6zy57zs0350czi9afqfnvig0wh35i3na";
      type = "gem";
    };
    version = "1.3.0";
  };
  logger = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yyn64c92wx8c37dqh1b080rqc80idq56g2plfqls9f9q8l32i7d";
      type = "gem";
    };
    version = "1.5.3";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vrjm4yqn5l6q5gsl72fmk95fl6j9z1a05gzbrwmsm3gp1a1bgac";
      type = "gem";
    };
    version = "0.11.2";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkjqf37v2d7s11176cb35cl83wls5gm3adnfkn2zcc61h3nxmqh";
      type = "gem";
    };
    version = "2.22.0";
  };
  lookbook = {
    dependencies = ["activemodel" "css_parser" "htmlbeautifier" "htmlentities" "marcel" "railties" "redcarpet" "rouge" "view_component" "yard" "zeitwerk"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01bni0dlqc9blb1akqsna39l2wb9a9dgv75mqhihrb0lnng4qj0n";
      type = "gem";
    };
    version = "2.3.4";
  };
  lru_redux = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yxghzg7476sivz8yyr9nkak2dlbls0b89vc2kg52k0nmg6d0wgf";
      type = "gem";
    };
    version = "1.1.0";
  };
  lumberjack = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07rvqrizmqzbjzhdsh4l4fyif26a7czb506dvch18kr3nkkamim5";
      type = "gem";
    };
    version = "1.2.7";
  };
  mail = {
    dependencies = ["mini_mime" "net-imap" "net-pop" "net-smtp"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bf9pysw1jfgynv692hhaycfxa8ckay1gjw5hz3madrbrynryfzc";
      type = "gem";
    };
    version = "2.8.1";
  };
  mail-smtp_pool = {
    dependencies = ["connection_pool" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/mail-smtp_pool";
      type = "path";
    };
    version = "0.1.0";
  };
  marcel = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kky3yiwagsk8gfbzn3mvl2fxlh3b39v6nawzm4wpjs6xxvvc4x0";
      type = "gem";
    };
    version = "1.0.2";
  };
  marginalia = {
    dependencies = ["actionpack" "activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kw9l9gw9dqmbpjxs3ndifia2204n8n92pjr4xp78hiynqm22qyb";
      type = "gem";
    };
    version = "1.11.1";
  };
  matrix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  memory_profiler = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c81d68r4wx0ckbmqxlfqc2qpd94jwcmqdm0xgr0s46r48pv9k9q";
      type = "gem";
    };
    version = "1.0.1";
  };
  method_source = {
    groups = ["default" "development" "metrics" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  microsoft_graph_mailer = {
    dependencies = ["mail" "oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/microsoft_graph_mailer";
      type = "path";
    };
    version = "0.1.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q8d881k1b3rbsfcdi3fx0b5vpdr5wcrhn88r2d9j7zjdkxp5mw5";
      type = "gem";
    };
    version = "3.5.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yjv0apysnrhbc70ralinfpcqn9382lxr643swp7a5sdwpa9cyqg";
      type = "gem";
    };
    version = "3.2023.1003";
  };
  mini_histogram = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "156xs8k7fqqcbk1fbf0ndz6gfw380fb2jrycfvhb06269r84n4ba";
      type = "gem";
    };
    version = "0.3.1";
  };
  mini_magick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0slh78f9z6n0l1i2km7m48yz7l4fjrk88sj1f4mh1wb39sl2yc37";
      type = "gem";
    };
    version = "4.12.0";
  };
  mini_mime = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      type = "gem";
    };
    version = "1.1.2";
  };
  mini_portile2 = {
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q1f2sdw3y3y9mnym9dhjgsjr72sq975cfg5c4yx7gwv8nmzbvhk";
      type = "gem";
    };
    version = "2.8.7";
  };
  minitest = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  mixlib-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ydxlfgd7nnj3rp1y70k4yk96xz5cywldjii2zbnw3sq9pippwp6";
      type = "gem";
    };
    version = "2.1.8";
  };
  mixlib-config = {
    dependencies = ["tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j0122lv2qgccl61njqi0pj6sp6nb85y07gcmw16bwg4k0c8nx6p";
      type = "gem";
    };
    version = "3.0.27";
  };
  mixlib-log = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n5dm5iz90ijvjn59jfm8gb8hgsvbj0f1kpzbl38b02z0z4a4v7x";
      type = "gem";
    };
    version = "3.0.9";
  };
  mixlib-shellout = {
    dependencies = ["chef-utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zkwg76y96nkh1mv0k92ybq46cr06v1wmic16129ls3yqzwx3xj6";
      type = "gem";
    };
    version = "3.2.7";
  };
  mize = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qr3vf0qc216kyyv2vnp8p9pv73di6zd6v9sx51qw5awrd90y6iz";
      type = "gem";
    };
    version = "0.6.0";
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02af38s49111wglqzcjcpa7bwg6psjgysrjvgk05h3x4zchb6gd5";
      type = "gem";
    };
    version = "1.5.4";
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xy54mjf7xg41l8qrg1bqri75agdqmxap9z466fjismc1rn2jwfr";
      type = "gem";
    };
    version = "1.14.1";
  };
  multi_xml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n0kvnrcrjn31jb97kcx3wj1f5kkjza7yygfq8rxzf3i57g7jaa6";
      type = "gem";
    };
    version = "2.2.3";
  };
  murmurhash3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dh9xnjs98a2by2rd8jlcmx94miryssk1ral2pji21xbx7i2q2ip";
      type = "gem";
    };
    version = "0.1.7";
  };
  mustermann = {
    dependencies = ["ruby2_keywords"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rwbq20s2gdh8dljjsgj5s6wqqfmnbclhvv2c2608brv7jm6jdbd";
      type = "gem";
    };
    version = "3.0.0";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zpmc099rcpxmlfxb71zd6l7f9fcsg1fhi6627r03y1qlgb0jlvg";
      type = "gem";
    };
    version = "1.0.2";
  };
  nap = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xm5xssxk5s03wjarpipfm39qmgxsalb46v1prsis14x1xk935ll";
      type = "gem";
    };
    version = "1.1.0";
  };
  neighbor = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a7bwycd8svpxp5plnm84iyn1cxhc4s7msgpv61axfdi4k6bp5dp";
      type = "gem";
    };
    version = "0.3.2";
  };
  nenv = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
  };
  net-http = {
    dependencies = ["uri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10n2n9aq00ih8v881af88l1zyrqgs5cl3njdw8argjwbl5ggqvm9";
      type = "gem";
    };
    version = "0.4.1";
  };
  net-http-persistent = {
    dependencies = ["connection_pool"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yfypmfg1maf20yfd22zzng8k955iylz7iip0mgc9lazw36g8li7";
      type = "gem";
    };
    version = "4.0.1";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d996zf3g8xz244791b0qsl9vr7zg4lqnnmf9k2kshr9lki5jam8";
      type = "gem";
    };
    version = "0.3.4";
  };
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ycw0qsw3hap8svakl0i30jkj0ffd4lpyrn17a1j0w8mz5ainmsj";
      type = "gem";
    };
    version = "0.17.1";
  };
  net-ntp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z96m7nnb9f634cz4i6p0x89z7g9i9h97cnk5f3x3q5x090kzisv";
      type = "gem";
    };
    version = "2.1.3";
  };
  net-pop = {
    dependencies = ["net-protocol"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = ["timeout"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "051cc82dl41a66c9sxv4lx4slqk7sz1v4iy0hdk6gpjyjszf4hxd";
      type = "gem";
    };
    version = "0.1.3";
  };
  net-scp = {
    dependencies = ["net-ssh"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1si2nq9l6jy5n2zw1q59a5gaji7v9vhy8qx08h4fg368906ysbdk";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6md06hm5bf6rv53sk54dl2vg038pg8kglwv3rayx0vk2mdql9x";
      type = "gem";
    };
    version = "0.3.3";
  };
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jyj6j7w9zpj2zhp4dyhdjiwsn9rqwksj7s7fzpnn7rx2xvz2a1a";
      type = "gem";
    };
    version = "7.2.0";
  };
  netrc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  nio4r = {
    groups = ["default" "puma" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xkjz56qc7hl7zy7i7bhiyw5pl85wwjsa4p70rj6s958xj2sd1lm";
      type = "gem";
    };
    version = "2.7.0";
  };
  no_proxy_fix = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "006dmdb640v1kq0sll3dnlwj1b0kpf3i1p27ygyffv8lpcqlr6sf";
      type = "gem";
    };
    version = "0.1.2";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15gysw8rassqgdq3kwgl4mhqmrgh7nk2qvrcqp4ijyqazgywn6gq";
      type = "gem";
    };
    version = "1.16.7";
  };
  notiffany = {
    dependencies = ["nenv" "shellany"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  numerizer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysxf30qcybh131r98frp38sqqkdhcjwpnajgrxl2w2kxvapd075";
      type = "gem";
    };
    version = "0.2.0";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zwd6v39yqfdrpg1p3d9jvzs9ljg55ana2p06m0l7qn5w0lgx1a0";
      type = "gem";
    };
    version = "0.5.6";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_xml" "rack" "snaky_hash" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yzpaghh8kwzgmvmrlbzf36ks5s2hf34rayzw081dp2jrzprs7xj";
      type = "gem";
    };
    version = "2.0.9";
  };
  octokit = {
    dependencies = ["faraday" "sawyer"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05j3gz79gxkid3lc2balyllqik4v4swnm0rcvxz14m76bkrpz92g";
      type = "gem";
    };
    version = "9.2.0";
  };
  ohai = {
    dependencies = ["chef-config" "chef-utils" "ffi" "ffi-yajl" "ipaddress" "mixlib-cli" "mixlib-config" "mixlib-log" "mixlib-shellout" "plist" "train-core" "wmi-lite"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15fz0ws8q9635rl5y4jyiwxbibr9ilba4askazhrgy4pcmmgs34q";
      type = "gem";
    };
    version = "18.1.3";
  };
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lggrhlihxyfgiqqr9b2fqdxc4d2zff2czq30m3rgn8a0b2gsv90";
      type = "gem";
    };
    version = "3.13.23";
  };
  oj-introspect = {
    dependencies = ["oj"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g9ksljmlkg56xz8ddzsjkhjh89jv4hr99k3x7c70a7dcx2s85f4";
      type = "gem";
    };
    version = "0.7.2";
  };
  omniauth = {
    dependencies = ["hashie" "rack" "rack-protection"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0013azz7kz2q6dy8131b1q5xwl7qa9nz5iqpn8i3ccn9br7j7xxz";
      type = "gem";
    };
    version = "2.1.0";
  };
  omniauth-alicloud = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gh1d69w6p62hj18bh2p5fdykg9za1yifpq18swp9ms0pcx4yp4w";
      type = "gem";
    };
    version = "3.0.0";
  };
  omniauth-atlassian-oauth2 = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jbnbp0pnasyrf0mgyig72hx8bdwhv78na6ffqrs1f4a3155f1zb";
      type = "gem";
    };
    version = "0.2.0";
  };
  omniauth-auth0 = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g24cnisa3ic3kilx1is2h0wq303qlmx2q5a92yxaal1cgwxlzg7";
      type = "gem";
    };
    version = "3.1.0";
  };
  omniauth-azure-activedirectory-v2 = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wnhibz903ssnq9scl65a47d41zcczb3wjvc44y3w8ydabfwx164";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth-github = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m6a7kg3lxz2nm96prln2ja8r4wlm37m5vsy9199vnynqq5fgy4g";
      type = "gem";
    };
    version = "2.0.1";
  };
  omniauth-gitlab = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/omniauth-gitlab";
      type = "path";
    };
    version = "4.0.0";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "oauth2" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fahkghfa2iczmwss9bz5l4rh7siwzjnjp3akh7pdbsfx0kg35j4";
      type = "gem";
    };
    version = "1.1.1";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y4y122xm8zgrxn5nnzwg6w39dnjss8pcq2ppbpx9qn7kiayky5j";
      type = "gem";
    };
    version = "1.8.0";
  };
  omniauth-oauth2-generic = {
    dependencies = ["omniauth-oauth2" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04vnmszmm1jmwvg6cwdy9jxliwa8yawp4w4690pvyplx04wqavnf";
      type = "gem";
    };
    version = "0.2.8";
  };
  omniauth-salesforce = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/omniauth-salesforce";
      type = "path";
    };
    version = "1.0.5";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nn24s74miy7p65y8lwpjfwgcn7fwld61f9ghngal4asgw6pfwa";
      type = "gem";
    };
    version = "2.2.1";
  };
  omniauth-shibboleth-redux = {
    dependencies = ["omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qgzp0xaka6vqpx69mw6nbqaqmyqrawi11cyak4gq19l23ym7cz9";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth_crowd = {
    dependencies = ["activesupport" "nokogiri" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/omniauth_crowd";
      type = "path";
    };
    version = "2.4.0";
  };
  omniauth_openid_connect = {
    dependencies = ["omniauth" "openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "099xg7s6450wlfzs77mbdx78g3dp0glx5q6f44i78akf7283hbqz";
      type = "gem";
    };
    version = "0.8.0";
  };
  open4 = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cgls3f9dlrpil846q0w7h66vsc33jqn84nql4gcqkk221rh7px1";
      type = "gem";
    };
    version = "1.3.4";
  };
  openbao_client = {
    dependencies = ["typhoeus"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/gems/openbao_client";
      type = "path";
    };
    version = "1.0.0";
  };
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "email_validator" "faraday" "faraday-follow_redirects" "json-jwt" "mail" "rack-oauth2" "swd" "tzinfo" "validate_url" "webfinger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k3l4ak1mawrw74qy4xfh81hdfxvamijcjb3f1gadq0ixgprrfqd";
      type = "gem";
    };
    version = "2.3.0";
  };
  openssl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "054d6ybgjdzxw567m7rbnd46yp6gkdbc5ihr536vxd3p15vbhjrw";
      type = "gem";
    };
    version = "3.2.0";
  };
  openssl-signature_algorithm = {
    dependencies = ["openssl"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "103yjl68wqhl5kxaciir5jdnyi7iv9yckishdr52s5knh9g0pd53";
      type = "gem";
    };
    version = "1.3.0";
  };
  opentelemetry-api = {
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j9c2a4wgw0jaw63qscfasw3lf3kr45q83p4mmlf0bndcq2rlgdb";
      type = "gem";
    };
    version = "1.2.5";
  };
  opentelemetry-common = {
    dependencies = ["opentelemetry-api"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "160ws06d8mzx3hwjss2i954h8r86dp3sw95k2wrbq81sb121m2gy";
      type = "gem";
    };
    version = "0.21.0";
  };
  opentelemetry-exporter-otlp = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types" "opentelemetry-api" "opentelemetry-common" "opentelemetry-sdk" "opentelemetry-semantic_conventions"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yl10v1vvb9krvvks0si5nbjpknz8lcbbcryqkf2g0db3kha072d";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-helpers-sql-obfuscation = {
    dependencies = ["opentelemetry-common"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cnlr3gqmd2q9wcaxhvlkxkbjvvvkp4vzcwif1j7kydw7lvz2vmw";
      type = "gem";
    };
    version = "0.1.0";
  };
  opentelemetry-instrumentation-action_mailer = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-active_support" "opentelemetry-instrumentation-base"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03nbn48q5ymk4wyhvnqa1wzvi1mzy2cbc8pmpf26x217zy6dvwl8";
      type = "gem";
    };
    version = "0.2.0";
  };
  opentelemetry-instrumentation-action_pack = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base" "opentelemetry-instrumentation-rack"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16nbkayp8jb2zkqj2rmqd4d1mz4wdf0zg6jx8b0vzkf9mxr89py5";
      type = "gem";
    };
    version = "0.9.0";
  };
  opentelemetry-instrumentation-action_view = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-active_support" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ga079lc2xariw83xc4ly1kab718ripmfb9af7xh6vm9qajka3d";
      type = "gem";
    };
    version = "0.7.3";
  };
  opentelemetry-instrumentation-active_job = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hirfvkg4kf575al080zvnpbxs3y9qlmzdr1w7qwkap7mjdks6r8";
      type = "gem";
    };
    version = "0.7.8";
  };
  opentelemetry-instrumentation-active_record = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j61jv60hdvjs18rj7i3lbkd5zqkfm8fdx15c0ixdxc15q88778r";
      type = "gem";
    };
    version = "0.8.0";
  };
  opentelemetry-instrumentation-active_support = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q07nn9ipq2yd7xjj24hh00cbvlda269k1l0xfkc8d8iw8mixrsg";
      type = "gem";
    };
    version = "0.6.0";
  };
  opentelemetry-instrumentation-aws_sdk = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d8rbbn3qnv0bb4l7mlxd9zlihf8m6k7rrajaj5zmq5p9fq79hx3";
      type = "gem";
    };
    version = "0.7.0";
  };
  opentelemetry-instrumentation-base = {
    dependencies = ["opentelemetry-api" "opentelemetry-registry"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pv064ksiynin8hzvljkwm5vlkgr8kk6g3qqpiwcik860i7l677n";
      type = "gem";
    };
    version = "0.22.3";
  };
  opentelemetry-instrumentation-concurrent_ruby = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1khlhzwb37mqnzr1vr49ljhi4bplmq9w8ndm0k8xbfsr8h8wivq4";
      type = "gem";
    };
    version = "0.21.4";
  };
  opentelemetry-instrumentation-ethon = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6ya4sr4w492qbd16b33qpk52wf3903l2ns6camv79kq1h7vahr";
      type = "gem";
    };
    version = "0.21.8";
  };
  opentelemetry-instrumentation-excon = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14g6dvk31kz9v9qbr2w6ggxk96v3kaadm8wvnw3qsrsc4pd9ycns";
      type = "gem";
    };
    version = "0.22.4";
  };
  opentelemetry-instrumentation-faraday = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0np6wnckn12df6mwcr695fvjy3x2s6541ywr7ahw8a8dszs0qjsh";
      type = "gem";
    };
    version = "0.24.6";
  };
  opentelemetry-instrumentation-grape = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base" "opentelemetry-instrumentation-rack"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dhpapza8qw8clfp7pri6r6sbibrx07sj7xfk3myivmp05rms8m1";
      type = "gem";
    };
    version = "0.2.0";
  };
  opentelemetry-instrumentation-graphql = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v6w0b3q0li5cq0xmc42ngqk9ahx60n5q31alka36ds4inxcrky2";
      type = "gem";
    };
    version = "0.28.4";
  };
  opentelemetry-instrumentation-http = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05mrlg8msp59bagpc18ycr9333760kqp780gw8fgqn1798dl02qr";
      type = "gem";
    };
    version = "0.23.4";
  };
  opentelemetry-instrumentation-http_client = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g6f5zv0bq585ppgzhm6acrpkz32j1h7zyrcy1r8n3ha41daip1z";
      type = "gem";
    };
    version = "0.22.7";
  };
  opentelemetry-instrumentation-net_http = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l26f8sqsjjcc72a5xr9as3gibm4sgj8n004y15i5vbvdgzjfx60";
      type = "gem";
    };
    version = "0.22.7";
  };
  opentelemetry-instrumentation-pg = {
    dependencies = ["opentelemetry-api" "opentelemetry-helpers-sql-obfuscation" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lgkjp0h0hf51n6afgafqaswvm06ybsvj3yf7dxxkzjpnzgxvjvg";
      type = "gem";
    };
    version = "0.29.0";
  };
  opentelemetry-instrumentation-rack = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g94rqqgw1jhqfng2692559wrldl6xji45lhbr4id3l1dd7qp72k";
      type = "gem";
    };
    version = "0.25.0";
  };
  opentelemetry-instrumentation-rails = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-action_mailer" "opentelemetry-instrumentation-action_pack" "opentelemetry-instrumentation-action_view" "opentelemetry-instrumentation-active_job" "opentelemetry-instrumentation-active_record" "opentelemetry-instrumentation-active_support" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13nj66l0jhs4pz4krlncyach5zb1bbb82bfipkvc33b0dmicll88";
      type = "gem";
    };
    version = "0.32.0";
  };
  opentelemetry-instrumentation-rake = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0840gnlr90nbl430yc72czn26bngdp94v4adz7q9ph3pmdm8mppv";
      type = "gem";
    };
    version = "0.2.2";
  };
  opentelemetry-instrumentation-redis = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qrgnk2x64sks9gqb7fycfa6sass6ddqzh5dms4hdbz1bzag581f";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-instrumentation-sidekiq = {
    dependencies = ["opentelemetry-api" "opentelemetry-instrumentation-base"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cfzw1avv52idxvq02y95g3byxsswccck78zch5hmnnzvp5f59nn";
      type = "gem";
    };
    version = "0.25.7";
  };
  opentelemetry-registry = {
    dependencies = ["opentelemetry-api"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08k8zqrg47v1jxcvxz9wxyqm03kjdw98qa8q0y840qvh988vcshi";
      type = "gem";
    };
    version = "0.3.0";
  };
  opentelemetry-sdk = {
    dependencies = ["opentelemetry-api" "opentelemetry-common" "opentelemetry-registry" "opentelemetry-semantic_conventions"];
    groups = ["opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0div7n5wac7x1l9fwdpb3bllw18cns93c7xccy27r4gmvv02f46s";
      type = "gem";
    };
    version = "1.5.0";
  };
  opentelemetry-semantic_conventions = {
    dependencies = ["opentelemetry-api"];
    groups = ["default" "opentelemetry"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xhv5fwwgjj2k8ksprpg1nm5v8k3w6gyw4wiq2k08q3kf484rlhk";
      type = "gem";
    };
    version = "1.10.0";
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
  org-ruby = {
    dependencies = ["rubypants"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x69s7aysfiwlcpd9hkvksfyld34d8kxr62adb59vjvh8hxfrjwk";
      type = "gem";
    };
    version = "0.9.12";
  };
  orm_adapter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
  };
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  pact = {
    dependencies = ["pact-mock_service" "pact-support" "rack-test" "rspec" "term-ansicolor" "thor" "webrick"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3fbwzzzdsbzipv63mcq1q761mqc6w8k1vxkbrbf3aqi2489p8b";
      type = "gem";
    };
    version = "1.64.0";
  };
  pact-mock_service = {
    dependencies = ["find_a_port" "json" "pact-support" "rack" "rspec" "thor" "webrick"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lds3xpkrx91lm74pa3n5167c8mkmqyki9axj7bjj0m18r2ybna2";
      type = "gem";
    };
    version = "3.11.2";
  };
  pact-support = {
    dependencies = ["awesome_print" "diff-lcs" "expgen" "rainbow"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0waq8ywxhljm5sjk7m3q7f6s2pvcfshg3ncs9dl7kcsg2ail7hs1";
      type = "gem";
    };
    version = "1.20.0";
  };
  paper_trail = {
    dependencies = ["activerecord" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yd9kdyyg1wisxi9mx01ar9s6h50x9k2av95xam58v6jx6bwvg0d";
      type = "gem";
    };
    version = "15.1.0";
  };
  parallel = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15wkxrg1sj3n1h2g8jcrn7gcapwcgxr659ypjf75z1ipkgxqxwsv";
      type = "gem";
    };
    version = "1.24.0";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fxw738al3qxa4s4ghqkxb908sav03i3h7xflawwmxzhqiyfdm15";
      type = "gem";
    };
    version = "3.3.6.0";
  };
  parslet = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12nrzfwjphjlakb9pmpj70hgjwgzvnr8i1zfzddifgyd44vspl88";
      type = "gem";
    };
    version = "1.8.2";
  };
  pastel = {
    dependencies = ["tty-color"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  peek = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k1yggixrcj72jlc98hi3jjd04x71dpynn8dxpcdhinyijniwl6n";
      type = "gem";
    };
    version = "1.1.0";
  };
  pg = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "071b55bhsz7mivlnp2kv0a11msnl7xg5awvk8mlflpl270javhsb";
      type = "gem";
    };
    version = "1.5.6";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p8ljf694qvrf5875ljg6kp7gvmndy8490kasjzcq22ghryg9xxp";
      type = "gem";
    };
    version = "5.1.0";
  };
  plist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wzhnbzraz60paxhm48c50fp9xi7cqka4gfhxmiq43mhgh5ajg3h";
      type = "gem";
    };
    version = "3.7.0";
  };
  png_quantizator = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sqhydp5g9ly1kgfiya1fc6srmhf6avrb74j09z3lp0jck8d88v0";
      type = "gem";
    };
    version = "0.2.1";
  };
  premailer = {
    dependencies = ["addressable" "css_parser" "htmlentities"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yvy5lxq287izy7qsz23hry63rc57wkaaalqvxnwjncm56xgdmzh";
      type = "gem";
    };
    version = "1.23.0";
  };
  premailer-rails = {
    dependencies = ["actionmailer" "net-smtp" "premailer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0004f73kgrglida336fqkgx906m6n05nnfc17mypzg5rc78iaf61";
      type = "gem";
    };
    version = "1.12.0";
  };
  prime = {
    dependencies = ["forwardable" "singleton"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1973kz8lbck6ga5v42f55jk8b8pnbgwp9p67dl1xw15gvz55dsfl";
      type = "gem";
    };
    version = "0.1.2";
  };
  prism = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ywvpskabdm0ckg6b3cf1jczg1jkjnb1mr0g73cy5l09xdlx5w25";
      type = "gem";
    };
    version = "1.1.0";
  };
  proc_to_ast = {
    dependencies = ["coderay" "parser" "unparser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14c65w48bbzp5lh1cngqd1y25kqvfnq1iy49hlzshl12dsk3z9wj";
      type = "gem";
    };
    version = "0.1.0";
  };
  prometheus-client-mmap = {
    dependencies = ["rb_sys"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vg47xx3wgg24snqc6ychb08mbcyrjmvxym9fg69cpa4xvj133fx";
      type = "gem";
    };
    version = "1.1.1";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k9kqkd9nps1w1r1rb7wjr31hqzkka2bhi8b518x78dcxppm9zn4";
      type = "gem";
    };
    version = "0.14.2";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y41al94ks07166qbp2200yzyr5y60hm7xaiw4lxpgsm4b1pbyf8";
      type = "gem";
    };
    version = "3.10.1";
  };
  pry-rails = {
    dependencies = ["pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cf4ii53w2hdh7fn8vhqpzkymmchjbwij4l3m7s6fsxvb9bn51j6";
      type = "gem";
    };
    version = "0.3.9";
  };
  pry-shell = {
    dependencies = ["pry" "tty-markdown" "tty-prompt"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "027jd53zjbimqb3n1329q4njs94bagmfnrfylxqv04lrsa14h0md";
      type = "gem";
    };
    version = "0.6.4";
  };
  public_suffix = {
    groups = ["danger" "default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vqcw3iwby3yc6avs1vb3gfd0vcp2v7q310665dvxfswmcf4xm31";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gml1rixrfb0naciq3mrnqkpcvm9ahgps1c04hzxh4b801f69914";
      type = "gem";
    };
    version = "6.4.3";
  };
  pyu-ruby-sasl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcpjiz9lrvyb3rd8k8qni0v4ps08psympffyldmmnrqayyad0sn";
      type = "gem";
    };
    version = "0.0.3.3";
  };
  raabro = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10m8bln9d00dwzjil1k42i5r7l82x25ysbi45fwyv4932zsrzynl";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = ["coverage" "default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ax778fsfvlhj7c11n0d1wdcb8bxvkb190a9lha5d91biwzyx9g4";
      type = "gem";
    };
    version = "2.2.10";
  };
  rack-accept = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jdipx17b4ki33cfqvliapd31sbfvs4mv727awynr6v95a7n936";
      type = "gem";
    };
    version = "0.4.5";
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z6pj5vjgl6swq7a33gssf795k958mss8gpmdb4v4cydcs7px91w";
      type = "gem";
    };
    version = "6.7.0";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ysmn14pdf2wyr7agm0qvvr9pzcgyf39w4yvk2n05w9k4alwpa1";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects" "json-jwt" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19fi42hi9l474ki89y6cs8vrpfmc1h8zpd02iwjy4hw0a1yahfn7";
      type = "gem";
    };
    version = "2.2.1";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "169jzzgvbjrqmz4q55wp9pg4ji2h90mggcdxy152gv5vp96l2hgx";
      type = "gem";
    };
    version = "2.2.2";
  };
  rack-proxy = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12jw7401j543fj8cc83lmw72d8k6bxvkp9rvbifi88hh01blnsj4";
      type = "gem";
    };
    version = "0.7.7";
  };
  rack-session = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ysx29gk9k14a14zsp5a8czys140wacvp91fja8xcja0j1hzqq8c";
      type = "gem";
    };
    version = "2.1.0";
  };
  rack-timeout = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nc7kis61n4q7g78gxxsxygam022glmgwq9snydrkjiwg7lkfwvm";
      type = "gem";
    };
    version = "0.7.0";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sv5jzd3varqzcqm8zxllwiqzgbgcymszw12ci3f9zbzlliq8hby";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151f303jcvs8s149mhx2g5mn67487x0blrf9dzl76q1nb7dlh53l";
      type = "gem";
    };
    version = "1.0.5";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfq2a7kp2x64dzzi5p4cjcbiv62vxh9lyqk2f0rqq3fkzrw8h5i";
      type = "gem";
    };
    version = "2.0.3";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah" "nokogiri"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pm4z853nyz1bhhqr7fzl44alnx4bjachcr6rh6qjj375sfz3sc6";
      type = "gem";
    };
    version = "1.6.0";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jiiv5ni1jrk15g572wc0l1ansbx6aqqsp2mk0pg9h18mkh1dbpg";
      type = "gem";
    };
    version = "7.0.10";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z7lqx0y60bzpkd4v67i9sbdh7djs0mm89h343kidx0gmq0kbh0";
      type = "gem";
    };
    version = "7.0.8.4";
  };
  rainbow = {
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  rb-fsevent = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jm76h8f8hji38z3ggf4bzi8vps6p7sagxn3ab57qc0xyga64005";
      type = "gem";
    };
    version = "0.10.1";
  };
  rb_sys = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jjcxfwwr70l46wylv68mjnazi4zfwn7fn5yb2wnfs4hwzcbwdca";
      type = "gem";
    };
    version = "0.9.94";
  };
  rbs = {
    dependencies = ["logger"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bnb361ca6gizncs8qybfrm1m9pin2siw548pizfd5l711mrzn4f";
      type = "gem";
    };
    version = "3.5.1";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p65p6f917al0f07sn5ca9yj92f7mk52xgnp0ahqpyrb8r6sdjz8";
      type = "gem";
    };
    version = "0.5.1";
  };
  rchardet = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  re2 = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p0kxb1gwrsv2r38jwgsg8b5k2xx966qmrc6aajfncpzm398i79i";
      type = "gem";
    };
    version = "2.7.0";
  };
  recaptcha = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vmpppgdy64qa16bvkss0xyzmyyzxv5hwzvc1i6saw4yvm58kl9p";
      type = "gem";
    };
    version = "5.12.3";
  };
  recursive-open-struct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nnyr6qsqrcszf6c10n4zfjs8h9n67zvsmx6mp8brkigamr8llx3";
      type = "gem";
    };
    version = "1.1.3";
  };
  redcarpet = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sg9sbf9pm91l7lac7fs4silabyn0vflxwaa2x3lrzsm0ff8ilca";
      type = "gem";
    };
    version = "3.6.0";
  };
  RedCloth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15r2h7rfp4bi9i0bfmvgnmvmw0kl3byyac53rcakk4qsv7yv4caj";
      type = "gem";
    };
    version = "4.3.4";
  };
  redis = {
    dependencies = ["redis-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cbjvb61kx2p1mjg2z55mw80760h6d8dnxszqkq8g4c8mv2i1y3b";
      type = "gem";
    };
    version = "5.3.0";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1mx8shrzpcj27k9kw77f4cq7i217vxfd1ksqb4g485md4zc37i";
      type = "gem";
    };
    version = "5.4.0";
  };
  redis-client = {
    dependencies = ["connection_pool"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h5cgdv40zk0ph1nl64ayhn6anzwy6mbxyi7fci9n404ryvy9zii";
      type = "gem";
    };
    version = "0.22.2";
  };
  redis-cluster-client = {
    dependencies = ["redis-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1az0l2q11214gxbi8fcn7xfxj0m31d3wlxcqd0h8qjxqvsjcmrk3";
      type = "gem";
    };
    version = "0.11.0";
  };
  redis-clustering = {
    dependencies = ["redis" "redis-cluster-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ncqm43bcxwll4lkdw5fp34m8pc0fp9lqzhq4qcgn7ax68a90gvp";
      type = "gem";
    };
    version = "5.3.0";
  };
  redis-namespace = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f92i9cwlp6xj6fyn7qn4qsaqvxfw4wqvayll7gbd26qnai1l6p9";
      type = "gem";
    };
    version = "1.11.0";
  };
  redis-rack = {
    dependencies = ["rack-session" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10438w0y1jbgr205zndvmz6md0mrqazh2j9fr88lvb8hms10pddb";
      type = "gem";
    };
    version = "3.0.0";
  };
  redis-store = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "197d1088jw3wl3lfcdj4w4c4da13wsqyd12mj3czvlfw77ig7i7d";
      type = "gem";
    };
    version = "1.11.0";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mm5sykyblc61a82zz3dag6yy3mvflj2z47060kjzjj5793blqzi";
      type = "gem";
    };
    version = "2.6.0";
  };
  regexp_property_values = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03q8dn4fg51mfk5d4sfcr0f9hqbs42ghafi76k9nc7ms1gf9j90n";
      type = "gem";
    };
    version = "1.0.0";
  };
  representable = {
    dependencies = ["declarative" "trailblazer-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      type = "gem";
    };
    version = "3.2.0";
  };
  request_store = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ppgmsbrqah08j06bybd3cddv6dml79yzyjn7r8j1src78h98h7";
      type = "gem";
    };
    version = "1.5.1";
  };
  responders = {
    dependencies = ["actionpack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14kjykc6rpdh24sshg9savqdajya2dislc1jmbzg91w9967f4gv1";
      type = "gem";
    };
    version = "3.0.1";
  };
  rest-client = {
    dependencies = ["http-accept" "http-cookie" "mime-types" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  retriable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
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
    groups = ["coverage" "danger" "default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j9p66pmfgxnzp76ksssyfyqqrg7281dyi3xyknl3wwraaw7a66p";
      type = "gem";
    };
    version = "3.3.9";
  };
  rinku = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11cakxzp7qi04d41hbqkh92n52mm4z2ba8sqyhxbmfi4kypmls9y";
      type = "gem";
    };
    version = "2.0.0";
  };
  rotp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m48hv6wpmmm6cjr6q92q78h1i610riml19k5h1dil2yws3h1m3m";
      type = "gem";
    };
    version = "6.3.0";
  };
  rouge = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0b48945hakgy0y7lg6h1bb7pkfz8jqd0r6777f80ij3sansvbs";
      type = "gem";
    };
    version = "4.4.0";
  };
  rqrcode = {
    dependencies = ["chunky_png" "rqrcode_core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hggzz8i1l62pkkiybhiqv6ypxw7q844sddrrbbfczjcnj5sivi3";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ld6386hbdhy5h0k09axmgn424kavpc8f27k1vjhknjhbf8jjfg";
      type = "gem";
    };
    version = "1.2.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xrp8vq6i9zx37vh0yp4h9m0anx9paw200l1r5ad9fmq559346l";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-benchmark = {
    dependencies = ["benchmark-malloc" "benchmark-perf" "benchmark-trend" "rspec"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kyn7p409n75ikb7z9v3dbzjyyinkwi88f66alj9lnf2gssss50h";
      type = "gem";
    };
    version = "0.6.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s688wfw77fjldzayvczg8bgwcgh6bh552dw7qcj1rhjk3r4zalx";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n3cyrhsa75x5wwvskrrqk56jbjgdi2q1zx0irllf0chkgsmlsqf";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxxkb2sf2b36d8ca2nq84kjf85fz4x7wqcvb8r6a5hfxxfk69r3";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-parameterized = {
    dependencies = ["rspec-parameterized-core" "rspec-parameterized-table_syntax"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hplygik9p5d92lhb9412lzap8msrmry2qrrq5d1f90r170dwmml";
      type = "gem";
    };
    version = "1.0.2";
  };
  rspec-parameterized-core = {
    dependencies = ["parser" "proc_to_ast" "rspec" "unparser"];
    groups = ["default" "test"];
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "134q0hki279np9dv7mgr85wspdrvhpj9lpvxr9kx6pcwzwg9bpyp";
      type = "gem";
    };
    version = "1.0.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ycjggcmzbgrfjk04v26b43c3fj5jq2qic911qk7585wvav2qaxd";
      type = "gem";
    };
    version = "7.0.1";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n6qc0d16h6bgh1xarmc8vc58728mgjcsjj8wcd822c8lcivl0b1";
      type = "gem";
    };
    version = "0.6.2";
  };
  rspec-support = {
    groups = ["default" "development" "monorepo" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03z7gpqz5xkw9rf53835pa8a9vgj4lic54rnix9vfwmp2m7pv1s8";
      type = "gem";
    };
    version = "3.13.1";
  };
  rspec_junit_formatter = {
    dependencies = ["rspec-core"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "059bnq1gcwl9g93cqf13zpz38zk7jxaa43anzz06qkmfwrsfdpa0";
      type = "gem";
    };
    version = "0.6.0";
  };
  rspec_profiling = {
    dependencies = ["activerecord" "get_process_mem" "rails"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "143m9yiawqrjc02wack30k7m5w4d1axlsw0ds71vl55amqnvx6b1";
      type = "gem";
    };
    version = "0.0.9";
  };
  rubocop = {
    dependencies = ["json" "language_server-protocol" "parallel" "parser" "rainbow" "regexp_parser" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "131pbjl7bv9g9qli84j91kgqmcqzdm2flq7r9abskl3ndqiagk4c";
      type = "gem";
    };
    version = "1.67.0";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03zywfpm4540q6hw8srhi8pzp0gg51w65ir8jkaw58vk3j31w820";
      type = "gem";
    };
    version = "1.32.3";
  };
  rubocop-capybara = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aw0n8jwhsr39r9q2k90xjmcz8ai2k7xx2a87ld0iixnv3ylw9jx";
      type = "gem";
    };
    version = "2.21.0";
  };
  rubocop-factory_bot = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aljadsjx7affcarzbhz7pydpy6fgqb8hl951y0cmrffxpa3rqcd";
      type = "gem";
    };
    version = "2.26.1";
  };
  rubocop-graphql = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14j14ld5d3w141r5lgaljcd8q1g3w4xn592cwzqxlxw5n108v21d";
      type = "gem";
    };
    version = "1.5.4";
  };
  rubocop-performance = {
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kkkv073c01px27w69g93gbjwajxji5wmawrmbb5l9s4ll101wjw";
      type = "gem";
    };
    version = "1.21.1";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop" "rubocop-ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bc4xpyx0gldjdmbl9aaqav5bjiqfc2zdw7k2r1zblmgsq4ilmpm";
      type = "gem";
    };
    version = "2.26.2";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03vyjxs5rzrsn5graljffgzy1fgbyn99w5fz69y243dhn6gy5a66";
      type = "gem";
    };
    version = "3.0.5";
  };
  rubocop-rspec_rails = {
    dependencies = ["rubocop" "rubocop-rspec"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ijc1kw81884k0wjq1sgwaxa854n1fdddscp4fnzfzlx7zl150c8";
      type = "gem";
    };
    version = "2.30.0";
  };
  ruby-fogbugz = {
    dependencies = ["crack" "multipart-post"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mznsnhsgh1yg57j5gighr9vjricnix1l7ngf654k3v4fkjcs12y";
      type = "gem";
    };
    version = "0.3.0";
  };
  ruby-lsp = {
    dependencies = ["language_server-protocol" "prism" "rbs" "sorbet-runtime"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vcc2jib05p8lf09mczxyd2rw89gybbk8lkc08ckzq53lqvzj4yh";
      type = "gem";
    };
    version = "0.19.1";
  };
  ruby-lsp-rails = {
    dependencies = ["ruby-lsp"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l8z5m81519ki6p33s8xxy3vbcvp71did91pzvhr129a7cqhxs14";
      type = "gem";
    };
    version = "0.3.17";
  };
  ruby-lsp-rspec = {
    dependencies = ["ruby-lsp"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17dxzzywxy8x78nxm24czdc9jf75ghgqijj396q1mx0nknmd9vni";
      type = "gem";
    };
    version = "0.1.15";
  };
  ruby-magic = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00b15fd74bkrxfqbx1gg2nw78fs7lvmn8mf92bway8vxgf3kh8bv";
      type = "gem";
    };
    version = "0.6.0";
  };
  ruby-openai = {
    dependencies = ["httparty"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l0q3f2sks2i0mdd9p8c1shsh1acjij9iasc4vg2la2y0m65swzv";
      type = "gem";
    };
    version = "3.7.0";
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
  ruby-saml = {
    dependencies = ["nokogiri" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1adq06m684gnpjp6qyb8shgj8jjy2npcfg7y6mg2ab9ilfdq6684";
      type = "gem";
    };
    version = "1.17.0";
  };
  ruby-statistics = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10fwxwhby6n1q1k61bic2s0mddlfwb9x7a7306vir4s60cvh20v1";
      type = "gem";
    };
    version = "3.0.0";
  };
  ruby2_keywords = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyntlm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b8hczk8hysv53ncsqzx4q6kma5gy5lqc7s5yx8h64x3vdb18cjv";
      type = "gem";
    };
    version = "0.6.3";
  };
  rubypants = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vpdkrc4c8qhrxph41wqwswl28q5h5h994gy4c1mlrckqzm3hzph";
      type = "gem";
    };
    version = "0.2.0";
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
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "016bawsahkhxx7p8azxirpl7y2y7i8a027pj8910gwf6ipg329in";
      type = "gem";
    };
    version = "1.6.3";
  };
  safe_yaml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  safety_net_attestation = {
    dependencies = ["jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1khq0y5w7lf2b9a220298hphf3pakd216jc9a4x4a9pdwxs2vgln";
      type = "gem";
    };
    version = "0.4.0";
  };
  sanitize = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kymrjdpbmn4yaml3aaqyj1dzj8gqmm9h030dc2rj5mvja7fpi28";
      type = "gem";
    };
    version = "6.0.2";
  };
  sass-embedded = {
    dependencies = ["google-protobuf" "rake"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nmy052pm46781s7ca6x3l4yb5p3glh8sf201xwcwpk9rv2av9m2";
      type = "gem";
    };
    version = "1.77.5";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jks1qjbmqm8f9kvwa81vqj39avaj9wdnzc531xm29a55bb74fps";
      type = "gem";
    };
    version = "0.9.2";
  };
  sd_notify = {
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c9imnjbakx25r2n7widfp00s19ndzmmwax761mx5vbwm9nariyb";
      type = "gem";
    };
    version = "0.1.1";
  };
  seed-fu = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x6gclryl0hds3zms095d2iyafcvm2kfrm7362vrkxws7r2775pi";
      type = "gem";
    };
    version = "2.3.7";
  };
  selenium-webdriver = {
    dependencies = ["base64" "logger" "rexml" "rubyzip" "websocket"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1md0sixm8dq8a7riv50x4q1z273q47b5jvcbv5hxympxn3ran4by";
      type = "gem";
    };
    version = "4.25.0";
  };
  semver_dialects = {
    dependencies = ["deb_version" "pastel" "thor" "tty-command"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i2wxx2vdpdiwcr4npqxzdzmd7hwzlllsrpxpic13na654r3wxri";
      type = "gem";
    };
    version = "3.4.4";
  };
  sentry-rails = {
    dependencies = ["railties" "sentry-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nn1agy19s3zp7y06zxal6ds8h6w2rlxb6vjk5x7w5gk78l7adm";
      type = "gem";
    };
    version = "5.21.0";
  };
  sentry-ruby = {
    dependencies = ["bigdecimal" "concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ac6yy9nfwak6pi8xp2qx31pap1l4h4qhkiala5y1rzwkbahski9";
      type = "gem";
    };
    version = "5.21.0";
  };
  sentry-sidekiq = {
    dependencies = ["sentry-ruby" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qlh1r1h6lj57bbgzv9r78pp194jl79bqivn9ffrvxiqjb3lxxbd";
      type = "gem";
    };
    version = "5.21.0";
  };
  shellany = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01svmyma958sbqfz0v29lbqbr0ibvgcng352nhx6bsc9k5c207d0";
      type = "gem";
    };
    version = "5.1.0";
  };
  sidekiq = {
    dependencies = ["concurrent-ruby" "connection_pool" "rack" "redis-client"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/sidekiq-7.2.4";
      type = "path";
    };
    version = "7.2.4";
  };
  sidekiq-cron = {
    dependencies = ["fugit" "globalid" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v09lg8kza19jmigqv5hx2ibhm75j6pa639sfy4bv2208l50hqv6";
      type = "gem";
    };
    version = "1.12.0";
  };
  sigdump = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mqf06iw7rymv54y7rgbmfi6ppddgjjmxzi3hrw658n1amp1gwhb";
      type = "gem";
    };
    version = "0.2.4";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fzakk5y7zzii76zlkynpp1c764mzkkfg4mpj18f5pf2xp1aikb6";
      type = "gem";
    };
    version = "0.18.0";
  };
  simple_po_parser = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wybcipkfawg4pragmayiig03xc084x3hbwywsh1dr9x9pa8f9hj";
      type = "gem";
    };
    version = "1.1.6";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html" "simplecov_json_formatter"];
    groups = ["coverage" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "198kcbrjxhhzca19yrdcd6jjj9sb51aaic3b0sc3pwjghg3j49py";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-cobertura = {
    dependencies = ["rexml" "simplecov"];
    groups = ["coverage" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00izmp202y48qvmvwrh5x56cc5ivbjhgkkkjklvqmqzj9pik4r9c";
      type = "gem";
    };
    version = "2.1.0";
  };
  simplecov-html = {
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx01bxa8pbf9ip4hagqkp5m0mqfnwnw2xk8kjraiywz4lrss6jb";
      type = "gem";
    };
    version = "0.12.3";
  };
  simplecov-lcov = {
    groups = ["coverage" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h8kswnshgb9zidvc88f4zjy4gflgz3854sx9wrw8ppgnwfg6581";
      type = "gem";
    };
    version = "0.8.0";
  };
  simplecov_json_formatter = {
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a5l0733hj7sk51j81ykfmlk2vd5vaijlq9d5fn165yyx3xii52j";
      type = "gem";
    };
    version = "0.1.4";
  };
  simpleidn = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  singleton = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m0w97jmwp1ldg8x5jaidqyqf7n9lkdqsirdpkgppcfbgx0v045l";
      type = "gem";
    };
    version = "0.1.1";
  };
  sixarm_ruby_unaccent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11237b8r8p7fc0cpn04v9wa7ggzq0xm6flh10h1lnb6zgc3schq0";
      type = "gem";
    };
    version = "1.2.0";
  };
  slack-messenger = {
    dependencies = ["re2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n367s0wjym1czllgwycgya13r3axgjfpivc6dlvgjzbgmc1wn2q";
      type = "gem";
    };
    version = "2.3.6";
  };
  snaky_hash = {
    dependencies = ["hashie" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pl70rh92wsn15q4lwzikzi7j5a00vm77bqjg07k4sgzx0wjx2zy";
      type = "gem";
    };
    version = "2.0.0";
  };
  snowplow-tracker = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f2afcmwbfxfrkf0scc5yi3x5lyrfbd3xri8zm2ri0is8kqz99kv";
      type = "gem";
    };
    version = "0.8.0";
  };
  solargraph = {
    dependencies = ["backport" "benchmark" "diff-lcs" "e2mmap" "jaro_winkler" "kramdown" "kramdown-parser-gfm" "parser" "reverse_markdown" "rubocop" "thor" "tilt" "yard"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0smcpi3x87chkdqdclhgh36xlbwm7r44r58m3k1w4mcikdwlpjl7";
      type = "gem";
    };
    version = "0.47.2";
  };
  sorbet-runtime = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fsq1k58isarg6ycg2ix9sw9a6391y12ss48m3hcryqi902w7cny";
      type = "gem";
    };
    version = "0.5.11266";
  };
  spamcheck = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xclr7qk6fwpbwx2hlfcbpw9ki4y61p76i68hj28v0sp49sq4q54";
      type = "gem";
    };
    version = "1.3.0";
  };
  spring = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jx3y1krmx7flrp8fldb354cap1xxlln4yl97ik8smfzn07hhzzi";
      type = "gem";
    };
    version = "4.1.0";
  };
  spring-commands-rspec = {
    dependencies = ["spring"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    version = "1.0.4";
  };
  sprite-factory = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18hvn14vz1v3j1gvbqjypa59hgj3c4mqbimby50k407c395551jm";
      type = "gem";
    };
    version = "1.7.1";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7gwm749b3ff6544wxa878fpd1kvf2qc9fafassi8c7735jcin4";
      type = "gem";
    };
    version = "3.5.1";
  };
  ssh_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h5aiqqlk51z12kgvanhdvd0ajvv2i68z6a7450yxgmflfaiwz7c";
      type = "gem";
    };
    version = "1.3.0";
  };
  ssrf_filter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nx0vap3mrh62v37lr45h77ipp4li8x77v4kxr1psh3yhda9zx03";
      type = "gem";
    };
    version = "1.0.8";
  };
  stackprof = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gdqqwnampxmc54nf6zfy9apkmkpdavzipvfssmjlhnrrjy8qh7f";
      type = "gem";
    };
    version = "0.2.26";
  };
  state_machines = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00mi16hg3rhkxz4y58s173cbnjlba41y9bfcim90p4ja6yfj9ri3";
      type = "gem";
    };
    version = "0.5.0";
  };
  state_machines-activemodel = {
    dependencies = ["activemodel" "state_machines"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b4dffzlj38adin6gm0ky72r5c507qdb1jprnm7h9gnlj2qxlcp9";
      type = "gem";
    };
    version = "0.8.0";
  };
  state_machines-activerecord = {
    dependencies = ["activerecord" "state_machines-activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dmaf4f4cg3gamzgga3gamp0kv9lvianqzr9103dw0xbp00vfbq7";
      type = "gem";
    };
    version = "0.8.0";
  };
  strings = {
    dependencies = ["strings-ansi" "unicode-display_width" "unicode_utils"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yynb0qhhhplmpzavfrrlwdnd1rh7rkwzcs4xf0mpy2wr6rr6clk";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      type = "gem";
    };
    version = "0.2.0";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m86fzmwgw0vc8p6fwvnsdbldpgbqdz9cbp2zj9z06bc4jjf5nsc";
      type = "gem";
    };
    version = "2.0.3";
  };
  sync = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z9qlq4icyiv3hz1znvsq1wz2ccqjb1zwd6gkvnwg6n50z65d0v6";
      type = "gem";
    };
    version = "0.5.0";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08bln6c3qmylakgpmpswv4zdis8bf96nkbrxpb9xcal2i7g1j29r";
      type = "gem";
    };
    version = "1.4.3";
  };
  sysexits = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qjng6pllznmprzx8vb0zg0c86hdrkyjs615q41s9fjpmv2430jr";
      type = "gem";
    };
    version = "1.2.0";
  };
  table_print = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jxmd1yg3h0g27wzfpvq1jnkkf7frwb5wy9m4f47nf4k3wl68rj3";
      type = "gem";
    };
    version = "1.5.7";
  };
  tanuki_emoji = {
    dependencies = ["i18n"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14vdkzrfq3sv9dfzz0sgw89z7a6jic43jkndj7nqhvxdbhm1iqny";
      type = "gem";
    };
    version = "0.13.0";
  };
  telesign = {
    dependencies = ["net-http-persistent"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hjcaiy58zg7vpy5vsaaz6ss8w6nlkkvz1p758gdmd5wlxpfkinw";
      type = "gem";
    };
    version = "2.2.4";
  };
  telesignenterprise = {
    dependencies = ["telesign"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cziz60q1pav635fln5xiag7vqvf992sk9xi1l5gxhm8ccra0izi";
      type = "gem";
    };
    version = "2.2.2";
  };
  temple = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "060zzj7c2kicdfk6cpnn40n9yjnhfrr13d0rsbdhdij68chp2861";
      type = "gem";
    };
    version = "0.8.2";
  };
  term-ansicolor = {
    dependencies = ["tins"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xq5kci9215skdh27npyd3y55p812v4qb4x2hv3xsjvwqzz9ycwj";
      type = "gem";
    };
    version = "1.7.1";
  };
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14dfmfjppmng5hwj7c5ka6qdapawm3h6k9lhn8zj001ybypvclgr";
      type = "gem";
    };
    version = "3.0.2";
  };
  terser = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13mj7ds6kwl1z5dp8zg6b9l3vq9012g8yr99hlpf3d1dgsyf1hl0";
      type = "gem";
    };
    version = "1.0.2";
  };
  test-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x0gj68an9nkb8pvlzxs7m5n3ip3fizlw9s4kgkyj5kjqgpw6swn";
      type = "gem";
    };
    version = "1.4.0";
  };
  test_file_finder = {
    dependencies = ["faraday"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16bi2x6n8vwpinlm3n7j666ryq06zndhp4cj32sq89vbl240byw3";
      type = "gem";
    };
    version = "0.3.1";
  };
  text = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  thor = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vq1fjp45az9hfp6fxljhdrkv75cvbab1jfrwcw738pnsiqk8zps";
      type = "gem";
    };
    version = "1.3.1";
  };
  thread_safe = {
    groups = ["default" "test"];
    platforms = [];
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
      sha256 = "1knw2xa3pkfql4np9qazz2mdi1vz21vdsa0wkx648c4ym1p2h8yh";
      type = "gem";
    };
    version = "0.16.0";
  };
  tilt = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "186nfbcsk0l4l86gvng1fw6jq6p6s7rc0caxr23b3pnbfb20y63v";
      type = "gem";
    };
    version = "2.0.11";
  };
  timeout = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pfddf51n5fnj4f9ggwj3wbf23ynj0nbxlxqpz12y1gvl9g7d6r6";
      type = "gem";
    };
    version = "0.3.2";
  };
  timfel-krb5-auth = {
    groups = ["default" "kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105vajc0jkqgcx1wbp0ad262sdry4l1irk7jpaawv8vzfjfqqf5b";
      type = "gem";
    };
    version = "0.8.3";
  };
  tins = {
    dependencies = ["sync"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kxykx7ywc0i3y4dwakz4b46dql4zc7h8b5w1hqhsqswq93s7i2i";
      type = "gem";
    };
    version = "1.31.1";
  };
  toml-rb = {
    dependencies = ["citrus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19nr4wr5accc6l2y3avn7b02lqmk9035zxq42234k7fcqd5cbqm1";
      type = "gem";
    };
    version = "2.2.0";
  };
  tomlrb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00x5y9h4fbvrv4xrjk4cqlkm4vq8gv73ax4alj3ac2x77zsnnrk8";
      type = "gem";
    };
    version = "1.3.0";
  };
  tpm-key_attestation = {
    dependencies = ["bindata" "openssl" "openssl-signature_algorithm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v8y5dibsyskv1ncdgszhxwzq0gzmvb0zl7sgmx0xvsgy86dhcz1";
      type = "gem";
    };
    version = "0.12.0";
  };
  trailblazer-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      type = "gem";
    };
    version = "0.1.2";
  };
  train-core = {
    dependencies = ["addressable" "ffi" "json" "mixlib-shellout" "net-scp" "net-ssh"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fr2hydxs1rzmi7c1c1wcfi0m2piks3vl8hdhh8rpgjz041dm4w4";
      type = "gem";
    };
    version = "3.10.8";
  };
  truncato = {
    dependencies = ["htmlentities" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k4wdj2l6p4ax4y6qxbywkglmbhvfs4j1k868nkd2px39yhfingy";
      type = "gem";
    };
    version = "0.7.12";
  };
  tty-color = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-command = {
    dependencies = ["pastel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14hi8xiahfrrnydw6g3i30lxvvz90wp4xsrlhx8mabckrcglfv0c";
      type = "gem";
    };
    version = "0.10.1";
  };
  tty-cursor = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-markdown = {
    dependencies = ["kramdown" "pastel" "rouge" "strings" "tty-color" "tty-screen"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04f599zn5rfndq4d9l0acllfpc041bzdkkz2h6x0dl18f2wivn0y";
      type = "gem";
    };
    version = "0.7.2";
  };
  tty-prompt = {
    dependencies = ["pastel" "tty-reader"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j4y8ik82azjxshgd4i1v4wwhsv3g9cngpygxqkkz69qaa8cxnzw";
      type = "gem";
    };
    version = "0.23.1";
  };
  tty-reader = {
    dependencies = ["tty-cursor" "tty-screen" "wisper"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cf2k7w7d84hshg4kzrjvk9pkyc2g1m3nx2n1rpmdcf0hp4p4af6";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jr6s1cg8yb26wzkqa6874q0z93rq0y5aw092kdqazk71y6a235";
      type = "gem";
    };
    version = "0.8.1";
  };
  typhoeus = {
    dependencies = ["ethon"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z7gamf6s83wy0yqms3bi4srirn3fc0lc7n65lqanidxcj1xn5qw";
      type = "gem";
    };
    version = "1.4.1";
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  uber = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  undercover = {
    dependencies = ["bigdecimal" "imagen" "rainbow" "rugged"];
    groups = ["coverage" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1blz21yzd3s2ax75lnhlf4gvh273k9jry6fd7yqnyip5id3si6gg";
      type = "gem";
    };
    version = "0.5.0";
  };
  unf = {
    dependencies = ["unf_ext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      type = "gem";
    };
    version = "0.0.8.2";
  };
  unicode-display_width = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gi82k102q7bkmfi7ggn9ciypn897ylln1jk9q67kjhr39fj043a";
      type = "gem";
    };
    version = "2.4.2";
  };
  unicode-emoji = {
    dependencies = ["unicode-version"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zis8a993f4hxmcmmacm7rwzd06hpzfs7aa4zqqik39gg8pxz74l";
      type = "gem";
    };
    version = "4.0.0";
  };
  unicode-version = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qvmcyv9gh5i0x4pzd30jn1j9vn6h67zaiymmklz4b8498srlh2n";
      type = "gem";
    };
    version = "1.4.0";
  };
  unicode_utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      type = "gem";
    };
    version = "1.4.0";
  };
  uniform_notifier = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfvqixshwvm82b9qwdidvnkavdj7s0fbdbmyd4knkl6l3j9xcwr";
      type = "gem";
    };
    version = "1.16.0";
  };
  unleash = {
    dependencies = ["murmurhash3"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fxr4q8bs5pbf3y57f3bckg3ls9k76wzzkhvl1kdw879im4mcvhg";
      type = "gem";
    };
    version = "3.2.2";
  };
  unparser = {
    dependencies = ["diff-lcs" "parser"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j6ym6cn43ry4lvcal7cv0n9g9awny7kcrn1crp7cwx2vwzffhmf";
      type = "gem";
    };
    version = "0.6.7";
  };
  uri = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094gk72ckazf495qc76gk09b5i318d5l9m7bicg2wxlrjcm3qm96";
      type = "gem";
    };
    version = "0.13.0";
  };
  valid_email = {
    dependencies = ["activemodel" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w3587sa7d1a51djyla57pbv9v105jsqvxhkg6vbxi343fsm455q";
      type = "gem";
    };
    version = "0.1.3";
  };
  validate_url = {
    dependencies = ["activemodel" "public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lblym140w5n88ijyfgcvkxvpfj8m6z00rxxf2ckmmhk0x61dzkj";
      type = "gem";
    };
    version = "1.0.15";
  };
  validates_hostname = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06fspma67flsvwl3gfyrv2572l15pjsmqsncz5yp4kqbriw03i7a";
      type = "gem";
    };
    version = "1.0.13";
  };
  version_gem = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "104s7p4zp5yvf0bvbwd9mqmnkgz2z89h4hbvxi8pzd8d08c9a03b";
      type = "gem";
    };
    version = "1.1.0";
  };
  version_sorter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1np1xy15xq5lcp0y5zr7sxnpwwgcq7bvfs6jc27vnkw0lfhz4ir1";
      type = "gem";
    };
    version = "2.3.0";
  };
  view_component = {
    dependencies = ["activesupport" "concurrent-ruby" "method_source"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12r27rq6xlzngc1qv9zhbis0zx2216b8brb0bqg54di91jw94cdc";
      type = "gem";
    };
    version = "3.20.0";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hniwgbdsjxa71qy47n6av8faf8qpwbaapms41rhkk3zxgjdlhc8";
      type = "gem";
    };
    version = "2.0.0";
  };
  vite_rails = {
    dependencies = ["railties" "vite_ruby"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k4bllg0zpmpkjfmk1gybc2ygca4v40l2fmlplf9h0jqwniqa3mr";
      type = "gem";
    };
    version = "3.0.17";
  };
  vite_ruby = {
    dependencies = ["dry-cli" "rack-proxy" "zeitwerk"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fcharh45xwi2cx96m695v9gccny3hgvdkkhcbkhplk1bc6ldwgk";
      type = "gem";
    };
    version = "3.8.2";
  };
  vmstat = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vb5mwc71p8rlm30hnll3lb4z70ipl5rmilskpdrq2mxwfilcm5b";
      type = "gem";
    };
    version = "2.3.0";
  };
  warden = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l7gl7vms023w4clg02pm4ky9j12la2vzsixi2xrv9imbn44ys26";
      type = "gem";
    };
    version = "1.2.9";
  };
  warning = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17h6x3fh0y46gpkzpknbh94qxcp0pqlvacc90r35rgahirfmls93";
      type = "gem";
    };
    version = "1.3.0";
  };
  webauthn = {
    dependencies = ["android_key_attestation" "awrence" "bindata" "cbor" "cose" "openssl" "safety_net_attestation" "tpm-key_attestation"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ri09bf640kkw4v6k2g90q2nw1mx2hsghhngaqgb7958q8id8xrz";
      type = "gem";
    };
    version = "3.0.0";
  };
  webfinger = {
    dependencies = ["activesupport" "faraday" "faraday-follow_redirects"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p39802sfnm62r4x5hai8vn6d1wqbxsxnmbynsk8rcvzwyym4yjn";
      type = "gem";
    };
    version = "2.1.3";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08kixkdp41dw39kqfxf2wp5m4z9b6fxg6yfa6xin0wy7dxzka0dy";
      type = "gem";
    };
    version = "3.24.0";
  };
  webrick = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
  websocket = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a4zc8d0d91c3xqwapda3j3zgpfwdbj76hkb69xn6qvfkfks9h9c";
      type = "gem";
    };
    version = "1.2.10";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nyh873w4lvahcl8kzbjfca26656d5c6z3md4sbqg5y1gfz0157n";
      type = "gem";
    };
    version = "0.7.6";
  };
  websocket-extensions = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  wikicloth = {
    dependencies = ["builder" "expression_parser" "rinku"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jp6c2yzyqbap8jdiw8yz6l08sradky1llhyhmrg934l1b5akj3s";
      type = "gem";
    };
    version = "0.8.1";
  };
  wisper = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rpsi0ziy78cj82sbyyywby4d0aw0a5q84v65qd28vqn79fbq5yf";
      type = "gem";
    };
    version = "2.0.1";
  };
  with_env = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r5ns064mbb99hf1dyxsk9183hznc5i7mn3bi86zka6dlvqf9csh";
      type = "gem";
    };
    version = "1.1.0";
  };
  wmi-lite = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nnx4xz8g40dpi3ccqk5blj1ck06ydx09f9diksn1ghd8yxzavhi";
      type = "gem";
    };
    version = "1.0.7";
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
  xpath = {
    dependencies = ["nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  yajl-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lni4jbyrlph7sz8y49q84pb0sbj82lgwvnjnsiv01xf26f4v5wc";
      type = "gem";
    };
    version = "1.4.3";
  };
  yard = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qzr5j1a1cafv81ib3i51qyl8jnmwdxlqi3kbiraldzpbjh4ln9h";
      type = "gem";
    };
    version = "0.9.26";
  };
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "028ld9qmgdllxrl7d0qkl65s58wb1n3gv8yjs28g43a8b1hplxk1";
      type = "gem";
    };
    version = "2.6.7";
  };
}
