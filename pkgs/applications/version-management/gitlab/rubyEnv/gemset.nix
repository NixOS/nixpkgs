src:
{
  acme-client = {
    dependencies = ["faraday" "faraday-retry"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pl901hwqbx7sa058i006l7addvqg6wv73kkqsq3mgjx7jgxmxpd";
      type = "gem";
    };
    version = "2.0.11";
  };
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y9lj7ra9xf4q4mryydmd498grsndqmz1zwasb4ai9gv62igvw3s";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bzacsr93sxv90nljv3ajw54nmyz1v9k2v2wx1pxsi0jasqg5fvn";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "rails-dom-testing"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rjddp1a5l4amsbibhnf7g2rb69qvq0nc0a2dvr6r57bpkf82hj4";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2y6sqpan68lrx78pvhbxb2917m75s808r6cg1kyygwvg31niza";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "nokogiri"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jx8wi961i34v7x0j3h4wjw3qbyx9bkzb598vg42kidzk2f90dyj";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10g5gk8h4mfhvgqylzbf591fqf5p78ca35cb97p9bclpv9jfy0za";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ililjwy4x52a6x5fidh1iyllf6vx49nz93fd2hxypc5bpryx9mz";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nn17y72fhsynwn11bqg75bazqp6r1g8mpwwyv64harwvh3fh5qj";
      type = "gem";
    };
    version = "6.1.7.2";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k69m3b0lb4jx20jx8vsvdqm1ki1r6riq9haabyddkcpvmgz1wh7";
      type = "gem";
    };
    version = "6.1.7.2";
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
  activestorage = {
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel" "mini_mime"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c3cvc01azfkccg5hsl96wafsxb5hf1nva3cn8rif2mlwx17p8n3";
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
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11hv6pdsr0kd9bmd84sab21sbm209ck1cwqs5jqbf9g1xbh9nh2s";
      type = "gem";
    };
    version = "9.0.0";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      type = "gem";
    };
    version = "2.8.1";
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
      sha256 = "0klhppx4vjfdvgz12wb63bcxy5ymk0mp8wkh01fpgjn2l3fwkwz5";
      type = "gem";
    };
    version = "2.1.0";
  };
  app_store_connect = {
    dependencies = ["activesupport" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03s3x8b6ifjrqk9ian59i9yyxxl65ykvbb4r424j2hjsh8iskmq1";
      type = "gem";
    };
    version = "0.29.0";
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
  asana = {
    dependencies = ["faraday" "faraday_middleware" "faraday_middleware-multi_json" "oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b6pqazhi9922y79763m0alvdmvm90i806qgb1a8l4fnimzx7l1n";
      type = "gem";
    };
    version = "0.10.13";
  };
  asciidoctor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11z3vnd8vh3ny1vx69bjrbck5b2g8zsbj94npyadpn7fdp8y3ldv";
      type = "gem";
    };
    version = "2.0.18";
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
      sha256 = "0dhsickf1i4cr1w3l9imbqizv67yx1iqh2dhj3lvvkk7j4s3yfz5";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "1g22axmi2rhhy7w8c3x6gppsawxqavbrnxpnmphh22fk7cwi0kh2";
      type = "gem";
    };
    version = "1.0.1";
  };
  autoprefixer-rails = {
    dependencies = ["execjs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vlqwy2qkp39ibp7llj7ps53nvxav29c2yl451v1qdhj25zxc49p";
      type = "gem";
    };
    version = "10.2.5.1";
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
      sha256 = "1pyis1nvnbjxk12a43xvgj2gv0mvp4cnkc1gzw0v1018r61399gz";
      type = "gem";
    };
    version = "1.2.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1whf6ppvdibfpsr660ajncig3hyc6q9dvnx645ajrjfz3r7487i9";
      type = "gem";
    };
    version = "1.761.0";
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
      sha256 = "1fbbzcszpdjy2yzxfvl5fzgn0jgznkwxvqpb46nxv69gqhv3dpsg";
      type = "gem";
    };
    version = "3.175.0";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bcm0c9f7xy5qj5f0z3gddqslhb2vzrj9smc39pgqyq4jmn5kpj0";
      type = "gem";
    };
    version = "1.64.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17ya49rwjzimqhzsj6vlc4xfvj2sixy04kr4b6ddg3r6y0jrsixi";
      type = "gem";
    };
    version = "1.126.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4bifmll4hrf4gihr5hdvn59wjpz4qpyg5jj95kp17fykzqg36n";
      type = "gem";
    };
    version = "1.5.1";
  };
  axe-core-api = {
    dependencies = ["dumb_delegator" "virtus"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qkcia7yg50j0ycmzqnl2dzzz9a35wlg5fk30g0qs41z6p1xw38v";
      type = "gem";
    };
    version = "4.6.0";
  };
  axe-core-rspec = {
    dependencies = ["axe-core-api" "dumb_delegator" "virtus"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvlrnxcyam2574gzn44r0ibz4h0s9j3vrp5lixi731qvp4mphhi";
      type = "gem";
    };
    version = "4.6.0";
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
  azure-storage-blob = {
    dependencies = ["azure-storage-common" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qq3knsy7nj7a0r8m19spg2bgzns9b3j5vjbs9mpg49whhc63dv1";
      type = "gem";
    };
    version = "2.0.3";
  };
  azure-storage-common = {
    dependencies = ["faraday" "faraday_middleware" "net-http-persistent" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swmsvvpmy8cdcl305p3dl2pi7m3dqjd7zywfcxmhsz0n2m4v3v0";
      type = "gem";
    };
    version = "2.0.4";
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
  batch-loader = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17d8wwj880zar5h8zxdmw878shgmljmmv957802fw5nkg3gi3xwk";
      type = "gem";
    };
    version = "2.0.1";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02r1c3isfchs5fxivbq99gc3aq4vfyn8snhcy707dal1p8qz12qb";
      type = "gem";
    };
    version = "3.1.16";
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
      sha256 = "1vcg52gwl64xhhal6kwk1pc01y1klzdlnv1awyk89kb91z010x7q";
      type = "gem";
    };
    version = "1.16.0";
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
      sha256 = "10cwf4pi2i1r1hpz06sishj95aa9m65ymd61sl2vp57ncsrqcyab";
      type = "gem";
    };
    version = "7.0.2";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04l9rs56rlvihbr2ybkrigjajgd3swa98lxvmdl8iylj1g5m7n0j";
      type = "gem";
    };
    version = "0.7.0.1";
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
      sha256 = "1qhg45jxxy5h90frmajrrh5sirmj29sbfhbf7q0qhjymc0w1p0r5";
      type = "gem";
    };
    version = "3.39.1";
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
      sha256 = "1w8k7bbwknqmq64mygl2a137vx3cs8xrjmdp8l3whm6f5vg480hg";
      type = "gem";
    };
    version = "1.3.3";
  };
  cbor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0511idr8xps9625nh3kxr68sdy6l3xy2kcz7r57g47fxb1v18jj3";
      type = "gem";
    };
    version = "0.5.9.6";
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
    dependencies = ["sorted_set"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ql0kxnpbblggyn8hx511pghpqf8xv3ng2kbybwwdi11bg1il6zp";
      type = "gem";
    };
    version = "1.4.1";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hybw8jw9ryvz5zrki3gc9r88jqy373m6v46ynxsdzv1ysiyr40p";
      type = "gem";
    };
    version = "0.7.7";
  };
  chef-config = {
    dependencies = ["addressable" "chef-utils" "fuzzyurl" "mixlib-config" "mixlib-shellout" "tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z3lashvhqy9v5b3xn8vzzf07gnjw4mgdiiryxsg6kdasvj62j8z";
      type = "gem";
    };
    version = "16.10.17";
  };
  chef-utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cypir7fza7jfqaj1j1jh37d3i6bvrmm6jamjlngk3xbdbd56hm7";
      type = "gem";
    };
    version = "16.10.17";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vf0axgrm95bs3y0x5gdb76xawfh210yxplj7jbwr6z7n88i1axn";
      type = "gem";
    };
    version = "1.3.5";
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
      sha256 = "074162raa8pc92q6833hgqdlfr3z5jgid9avdz5k25cnls2rqwrf";
      type = "gem";
    };
    version = "0.23.9";
  };
  concurrent-ruby = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nj4r58m5cpfdsijj6gjfs3yzcnxq2halagjk07wjcrgj6z8ayb7";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "1n6zbkkinlv2hp4ig5c170d1ckbbdf8rgxmykfm3m3gn865vapnr";
      type = "gem";
    };
    version = "8.6.1";
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
  database_cleaner = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i0nf2aj70m61y3fspypdkc6d1qgibf5kav05a71b5gjz0k7y5x";
      type = "gem";
    };
    version = "1.7.0";
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
      sha256 = "01c8vv0xwbhlyhiagj93b1hlm2n0rmj4sw62nbc0jhyj90jhj6as";
      type = "gem";
    };
    version = "2.3.2";
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
      sha256 = "1n4yxjijplg0klcnjdhk7kxmvlb0szchk1ad8flg5hb2j59c8a6r";
      type = "gem";
    };
    version = "0.0.19.pre.alpha1";
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
      sha256 = "0gl0b4jqf7ysv3rg99sgxa5y9va2k13p0si3a88pr7m8g6z8pm7x";
      type = "gem";
    };
    version = "4.8.1";
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
      sha256 = "04f5rb8fg4cvzm32v413z3h53wc0fgxg927q8rqd546hdrlx4j35";
      type = "gem";
    };
    version = "4.0.2";
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
      remotes = ["https://rubygems.org"];
      sha256 = "03n4g4w2pwiygmqq5lfhqrpbs9g6kv0jhb3vrffz3vgaryzmfq5k";
      type = "gem";
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
      sha256 = "1czaak53w8n13y1fr0q23gp0fhklvxjac5n562qj3xk6sh5ad0x2";
      type = "gem";
    };
    version = "0.6.4";
  };
  discordrb-webhooks = {
    dependencies = ["rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viw73jd9vs9f92a9q2vxcd29755h7w8jwz36jmvcdl2najainyg";
      type = "gem";
    };
    version = "3.4.2";
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
      sha256 = "1q2pywgyn6cbnm0fh3dln5z1qgd1g8hvb4x8rppjc1bpfxnfhi13";
      type = "gem";
    };
    version = "5.6.6";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11p7p3b0yb12xfdhxxsifc2mz0rj1hlgi8sbcwjzxvld24rszvbi";
      type = "gem";
    };
    version = "1.8.7";
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
  dry-core = {
    dependencies = ["concurrent-ruby" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01gks2hrp7nl3pzb487azvd25dlbrc40d5cpk4n0szwnf2c0k4ks";
      type = "gem";
    };
    version = "1.0.0";
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
  ecma-re-validator = {
    dependencies = ["regexp_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mz0nsl2093jd94nygw8qs13rwfwl1ax76xz3ypinr5hqbc5pab6";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "0havyxmvl157a653prspnbhgdchlx44xqxl170v1im5ggxwavcaq";
      type = "gem";
    };
    version = "7.13.3";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bmssarkk7lqkjdn8c9j7jvxcnn4hg1zcmhsky8bfvc99k33b3w8";
      type = "gem";
    };
    version = "7.13.3";
  };
  elasticsearch-model = {
    dependencies = ["activesupport" "elasticsearch" "hashie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ivcz5pcrp0760j26590bm3jvwc8548wcy7z7v2274k18l583h9c";
      type = "gem";
    };
    version = "7.2.0";
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
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0blfii8qvj0m6bg9sbfynxc40in7zfmw2wpi4clv7d9gclk053db";
      type = "gem";
    };
    version = "7.13.3";
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
      path = "${src}/vendor/gems/error_tracking_open_api";
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
      sha256 = "0qminivnyzwmqjhrh3b92halwbk0zcl9xn828p5rnap1szl2yag5";
      type = "gem";
    };
    version = "1.2.1";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d2z4ky2v15dpcz672i2p7lb2nc793dasq3yq3660h2az53kss9v";
      type = "gem";
    };
    version = "1.2.7";
  };
  ethon = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kd7c61f28f810fgxg480j7457nlvqarza9c2ra0zhav0dd80288";
      type = "gem";
    };
    version = "0.15.0";
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
      sha256 = "17mi5qayplfaa6p3mfwa36il84ixr0bimqvl0q73lw5i81blp126";
      type = "gem";
    };
    version = "0.6.0";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04vxmjr200akcil9fqxc9ghbb9q0lyrh2q03xxncycd5vln910fi";
      type = "gem";
    };
    version = "6.2.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18fhcihkc074gk62iwqgbdgc3ymim4fm0b4p3ipffy5hcsb9d2r7";
      type = "gem";
    };
    version = "6.2.0";
  };
  faraday = {
    dependencies = ["faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-multipart" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "faraday-retry" "ruby2_keywords"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00palwawk897p5gypw5wjrh93d4p0xz2yl9w93yicb4kq7amh8d4";
      type = "gem";
    };
    version = "1.10.0";
  };
  faraday-cookie_jar = {
    dependencies = ["faraday" "http-cookie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00hligx26w9wdnpgsrf0qdnqld4rdccy8ym6027h5m735mpvxjzk";
      type = "gem";
    };
    version = "0.0.7";
  };
  faraday-em_http = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
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
  faraday-httpclient = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
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
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bw8mfh4yin2xk7138rg3fhb2p5g2dlmdma88k82psah9mbmvlfy";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday_middleware-aws-sigv4 = {
    dependencies = ["aws-sigv4" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gk2qakcvvbgfvvfd8cgf13sligv5mp816ykmra9llqmbfym8ikl";
      type = "gem";
    };
    version = "0.3.0";
  };
  faraday_middleware-multi_json = {
    dependencies = ["faraday_middleware" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0651sxhzbq9xfq3hbpmrp0nbybxnm9ja3m97k386m4bqgamlvz1q";
      type = "gem";
    };
    version = "0.0.6";
  };
  fast_blank = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16s1ilyvwzmkcgmklbrn0c2pch5n02vf921njx0bld4crgdr6z56";
      type = "gem";
    };
    version = "1.0.0";
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
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01z5lpssjc0n8lm4xrlja0hh8lv4ngzbybjvd4rdkc5x9ddvh8s3";
      type = "gem";
    };
    version = "2.10.0";
  };
  ffi = {
    groups = ["default" "development" "kerberos" "puma" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
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
      sha256 = "1pfmn0gprc3c15baxa9rx64pqllk64m60f5vg4gp0icpafkp0jx5";
      type = "gem";
    };
    version = "2.3.4";
  };
  filelock = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "085vrb6wf243iqqnrrccwhjd4chphfdsybkvjbapa2ipfj1ja1sj";
      type = "gem";
    };
    version = "1.1.1";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pbsd7p9aij9ffw621wl841hj319vv677n69jk4qndxqa9kpgcnc";
      type = "gem";
    };
    version = "0.25.0";
  };
  flipper-active_record = {
    dependencies = ["activerecord" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zxn7qp16xwk289xa3f8sqy4dg8difcsjc8rx44nmk72cnack9c5";
      type = "gem";
    };
    version = "0.25.0";
  };
  flipper-active_support_cache_store = {
    dependencies = ["activesupport" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06skgdfb43g6i40b5rx61yqgq16wwd8knvswnrva1l889fcvz0kj";
      type = "gem";
    };
    version = "0.25.0";
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
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0127b2jx7lj82h96sm0rnmlgqzgiz5013m6z27vxnkmwrw78iigl";
      type = "gem";
    };
    version = "3.18.0";
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
    dependencies = ["fog-core" "fog-json" "fog-xml" "google-apis-compute_v1" "google-apis-dns_v1" "google-apis-iamcredentials_v1" "google-apis-monitoring_v3" "google-apis-pubsub_v1" "google-apis-sqladmin_v1beta4" "google-apis-storage_v1" "google-cloud-env"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "127l22c7lhg166sylfhxys41p0i3nlkxkpzzgw8q9zip10irm41w";
      type = "gem";
    };
    version = "1.19.0";
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
      sha256 = "1awn2k5b2sji74vr0xhg0v68h1y0msqpkwq5z8k31mp2ii9mmmbg";
      type = "gem";
    };
    version = "0.18.0";
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
    dependencies = ["locale" "text"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04xlj00sm4mbgvyq0qkbxim75i7cpyn6iylpfwnyagl35wdvsszf";
      type = "gem";
    };
    version = "3.3.6";
  };
  gettext_i18n_rails = {
    dependencies = ["fast_gettext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vs918a03mqvx9aczaqdg9d2q9s3c6swqavzn82qgq5i822czrcm";
      type = "gem";
    };
    version = "1.8.0";
  };
  gettext_i18n_rails_js = {
    dependencies = ["gettext" "gettext_i18n_rails" "po_to_json" "rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11yn5cf92wsmlj5c1065mg6swf8gq9l6g9ahikvvyf9npvjay42x";
      type = "gem";
    };
    version = "1.3.0";
  };
  git = {
    dependencies = ["rchardet"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wd0rvz6cybqm9svcx427hgpcz804am64s0sxxrh72i9m16vm5by";
      type = "gem";
    };
    version = "1.11.0";
  };
  gitaly = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bz3i05lr1nzm35xg11blaq78v96sg49aw1yh4hj7wfk3cbdn1q0";
      type = "gem";
    };
    version = "16.1.0.pre.rc2";
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
      sha256 = "0ha0n6wkw8xm42v4wx9815ivpwjydp88jv9laq19qljj3w2zwk6z";
      type = "gem";
    };
    version = "3.10.0";
  };
  gitlab-experiment = {
    dependencies = ["activesupport" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "093q9b2nv010n10axlhz68gxdi0xs176hd9wm758nhl3marxsv8n";
      type = "gem";
    };
    version = "0.7.1";
  };
  gitlab-fog-azure-rm = {
    dependencies = ["azure-storage-blob" "azure-storage-common" "fog-core" "fog-json" "mime-types" "ms_rest_azure"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hix4q2ibrq0r97bn492vzxj4fgijc209kbak8jlrbal7ja6g74n";
      type = "gem";
    };
    version = "1.7.0";
  };
  gitlab-labkit = {
    dependencies = ["actionpack" "activesupport" "grpc" "jaeger-client" "opentracing" "pg_query" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nz0g5s65wkicsn9ianqxi7ys2w666n226gfblzllcfy1z9siyyi";
      type = "gem";
    };
    version = "0.33.0";
  };
  gitlab-license = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ms1kf5nmclsnmd2xa9k273asmb73ivaykwrb3g7sq263j3y7jk0";
      type = "gem";
    };
    version = "2.3.0";
  };
  gitlab-mail_room = {
    dependencies = ["jwt" "net-imap" "oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15wrq4v6xsfql4k6l10gbcfk0a02zh0shr2c3l0wakmjvaj4ymi3";
      type = "gem";
    };
    version = "0.0.23";
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
  gitlab-sidekiq-fetcher = {
    dependencies = ["json" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/sidekiq-reliable-fetch";
      type = "path";
    };
    version = "0.9.0";
  };
  gitlab-styles = {
    dependencies = ["rubocop" "rubocop-graphql" "rubocop-performance" "rubocop-rails" "rubocop-rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kd66l92ckv5z3gqfifhkny8ipxx4cckpdyign0lgknpvj06wa";
      type = "gem";
    };
    version = "10.0.0";
  };
  gitlab_chronic_duration = {
    dependencies = ["numerizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yq5a4vs96xz5yxqkfwcvzw0riww7mf87j1s2s7rb6yagpz4rnkd";
      type = "gem";
    };
    version = "0.10.6.2";
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
    dependencies = ["activesupport" "gitlab" "http" "nokogiri" "parallel" "rainbow" "table_print" "zeitwerk"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02xwchhhfv8jkypap5pn1wjkdx92jxk4wsp71i2s0ymnqw98y401";
      type = "gem";
    };
    version = "0.8.1";
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
      sha256 = "02fqn9505q3d3m6lpa5ic2j3pa81k2x440qyw2fairsidrms5jk8";
      type = "gem";
    };
    version = "0.10.0";
  };
  google-apis-dns_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k7k1nanm4wqyx19m5x9xzzm3nvf89gg5vr1dq4nfyvkl8g668zm";
      type = "gem";
    };
    version = "0.28.0";
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
      sha256 = "0skk42y2y81jlj0qfk790wqz3sdaxrykrc4mp1ysr0zsinp654id";
      type = "gem";
    };
    version = "0.37.0";
  };
  google-apis-pubsub_v1 = {
    dependencies = ["google-apis-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gg1br0pj16iag3xax942g101zk4rk48isdpz5abyhc070amk45q";
      type = "gem";
    };
    version = "0.30.0";
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
      sha256 = "17qamcjnf22zvw1g169g8a2gkzdsxx4ij3a4ganihyrcf9r62asj";
      type = "gem";
    };
    version = "0.19.0";
  };
  google-cloud-core = {
    dependencies = ["google-cloud-env" "google-cloud-errors"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0amp8vd16pzbdrfbp7k0k38rqxpwd88bkyp35l3x719hbb6l85za";
      type = "gem";
    };
    version = "1.6.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05gshdqscg4kil6ppfzmikyavsx449bxyj47j33r4n4p8swsqyb1";
      type = "gem";
    };
    version = "1.6.0";
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
      sha256 = "1skhlpcykxxzw3050cwngdyc3n746wfx443w1w9chxwjbh2ix6i9";
      type = "gem";
    };
    version = "1.44.0";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aczvz5jdslr1bfx08xrycp6ggdpaifdlh5hrdyd774mvcl0mg2d";
      type = "gem";
    };
    version = "3.23.3";
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
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hpwgwhk0lmnknkw8kbdfxn95qqs6aagpq815l5fkw9w6mi77pai";
      type = "gem";
    };
    version = "1.3.0";
  };
  gpgme = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qn87vxdsaq1szcvq39rnz38cgqllncdxmiyghnbzl7x5aah8sbw";
      type = "gem";
    };
    version = "2.0.22";
  };
  grape = {
    dependencies = ["activesupport" "builder" "dry-types" "mustermann-grape" "rack" "rack-accept"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbgysx2d64hsck11jajc4gwikj5nd82809bz0jibrnp4yb1lcw8";
      type = "gem";
    };
    version = "1.7.0";
  };
  grape-entity = {
    dependencies = ["activesupport" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zic5fx8s0424vdarhslmxdqmfnlfv3k4prfyxrrwvf9pdy1xvcs";
      type = "gem";
    };
    version = "0.10.0";
  };
  grape-path-helpers = {
    dependencies = ["activesupport" "grape" "rake" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ql1acy68n9xkvjzda1vpscf20zqqwjm959b7cx3w1yl40d2f9rf";
      type = "gem";
    };
    version = "1.7.1";
  };
  grape-swagger = {
    dependencies = ["grape"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17y6smk7shplblgic4jvi5njhd0x91n1xrvds3l6cjsjfs2d7lhg";
      type = "gem";
    };
    version = "1.6.1";
  };
  grape-swagger-entity = {
    dependencies = ["grape-entity" "grape-swagger"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08smc3c2li1xa2nmgjkn742sp1xj9qzppy28v68cz5mc00nkf7pm";
      type = "gem";
    };
    version = "0.5.1";
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
  graphiql-rails = {
    dependencies = ["railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lcf0gc88i3wk8cs71qm62ac9lrc1a8v5sd0369c5ip2ic4wbqh2";
      type = "gem";
    };
    version = "1.8.0";
  };
  graphlient = {
    dependencies = ["faraday" "faraday_middleware" "graphql-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14pjw0hd9rmfc687yj1cfd8jjy8gh7k6zn6w9syvcl1f2hb98b0g";
      type = "gem";
    };
    version = "0.5.0";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hvsv6ig6d8syr4vasa8vcc090kbawwflk5m1j6kl681y9n6d0hx";
      type = "gem";
    };
    version = "1.13.12";
  };
  graphql-client = {
    dependencies = ["activesupport" "graphql"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pgb1r4vkyrq8hzhkii48hn7cdlkmnrswzjsl0xqxg1diz705bss";
      type = "gem";
    };
    version = "0.17.0";
  };
  graphql-docs = {
    dependencies = ["commonmarker" "escape_utils" "extended-markdown-filter" "gemoji" "graphql" "html-pipeline" "sass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xmmifirvm4hay8qy6hjsdwms56sk973cq1b9c85b97xz0129f3y";
      type = "gem";
    };
    version = "2.1.0";
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
      sha256 = "00j8wdi731wy8qnn5g4laynswxlw0d0s69wsn509wfa5n8p34n5n";
      type = "gem";
    };
    version = "0.40.1";
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
  hangouts-chat = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dmnv3723c22683bzys8walkl6wi74xzawxjbhwqzjdbwk3bdgmx";
      type = "gem";
    };
    version = "0.0.5";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
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
    dependencies = ["mime-types" "multi_xml"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rs8c5wga6f1acyaj90d2hlv307gh2flfpb8y48wdk2si812l3a9";
      type = "gem";
    };
    version = "0.20.0";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
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
      sha256 = "11zfs0l8y2a6gpf0krm91d0ap2mnf04qky89dyzxwaspqxqgj174";
      type = "gem";
    };
    version = "2.8.0";
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
  invisible_captcha = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hn06njrwbxhxs2myr04fq3spqn38b8wm3irvkll91qv3p5yv0d3";
      type = "gem";
    };
    version = "2.0.0";
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
      path = "${src}/vendor/gems/ipynbdiff";
      type = "path";
    };
    version = "0.4.7";
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
      sha256 = "1y8l6k34svmdyqxya3iahpwbpvmn3fswhwsvrz0nk1wyb8yfihsh";
      type = "gem";
    };
    version = "1.5.4";
  };
  jira-ruby = {
    dependencies = ["activesupport" "atlassian-jwt" "multipart-post" "oauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17nv98nz3jp7q5hbnniscavqh4xv53mnda1vxyg3ncn8raaw0rs2";
      type = "gem";
    };
    version = "2.1.4";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nalhin1gda4v8ybk6lq8f407cgfrj6qzn234yra4ipkmlbfmal6";
      type = "gem";
    };
    version = "2.6.3";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "bindata" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04315mf4p9qa97grdfqv922paghzdfrbb982ap0p99rqwla4znv6";
      type = "gem";
    };
    version = "1.15.3";
  };
  json_schemer = {
    dependencies = ["ecma-re-validator" "hana" "regexp_parser" "uri_template"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rkb7gz819g82n3xshb5g8kgv1nvgwg1lm2fk7715pggzcgc4qik";
      type = "gem";
    };
    version = "0.2.18";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kcmnx6rgjyd7sznai9ccns2nh7p7wnw3mi8a7vf2wkm51azwddq";
      type = "gem";
    };
    version = "2.5.0";
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
  kas-grpc = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nhdllr7zi19b73q0flbc0lhqb5mn0jrw4bqdang7wfxgfdwf6dj";
      type = "gem";
    };
    version = "0.1.0";
  };
  knapsack = {
    dependencies = ["rake"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056g86ndhq51303k4g3fhdfwhpr6cpzypxhlnp0wxjpbmli09xw2";
      type = "gem";
    };
    version = "1.21.1";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0757lqaq593z8hzdv98nai73ag384dkk7jgj3mcq2r6ix7130ifb";
      type = "gem";
    };
    version = "2.3.2";
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
  launchy = {
    dependencies = ["addressable"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xdyvr5j0gjj7b10kgvh8ylxnwk3wx19my42wqn9h82r4p246hlm";
      type = "gem";
    };
    version = "2.5.0";
  };
  lefthook = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hqffqr2krk6gcjapriwwmdrjz56dczshxafnwrkipyxi51vwgvh";
      type = "gem";
    };
    version = "1.4.2";
  };
  letter_opener = {
    dependencies = ["launchy"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09a7kgsmr10a0hrc9bwxglgqvppjxij9w8bxx91mnvh0ivaw0nq9";
      type = "gem";
    };
    version = "1.7.0";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties" "rexml"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vvvaz2ngaxv0s6sj25gdvp73vd8pfl8q3jharadg18p3va0m1ik";
      type = "gem";
    };
    version = "2.0.0";
  };
  libyajl2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n5j0p8dxf9xzb9n4bkdr8w0a8gg3jzrn9indri3n0fv90gcs5qi";
      type = "gem";
    };
    version = "1.2.0";
  };
  license_finder = {
    dependencies = ["rubyzip" "thor" "tomlrb" "with_env" "xml-simple"];
    groups = ["development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sig4ifxzvcz3fwjnz93dpv61v6sxpmlknj5f8n112ragrbcj8hb";
      type = "gem";
    };
    version = "7.0.1";
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
      sha256 = "1h1a3h3rfv3094pn5zn7d3c066dmhx9i380mhqa1qyagqla6pw8a";
      type = "gem";
    };
    version = "1.1.1";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p744kjpb5zk2ihklbykzii77alycjc04vpnm2ch2f3cp65imlj3";
      type = "gem";
    };
    version = "2.21.3";
  };
  lookbook = {
    dependencies = ["activemodel" "css_parser" "htmlbeautifier" "htmlentities" "marcel" "railties" "redcarpet" "rouge" "view_component" "yard" "zeitwerk"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpwfdf6wk77ri85ksmsbxvfb4jpba3bx84j0zg10a4rijf7450g";
      type = "gem";
    };
    version = "2.0.1";
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
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
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
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
  };
  mime-types-data = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "003gd7mcay800k2q4pb2zn8lwwgci4bhi42v2jvlidm8ksx03i6q";
      type = "gem";
    };
    version = "3.2022.0105";
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
      sha256 = "0lpq12z70n10c1qshcddd5nib2pkcbkwzvmiqqzj60l01k3x4fg9";
      type = "gem";
    };
    version = "4.10.1";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z7f38iq37h376n9xbl4gajdrnwzq284c9v1py4imw3gri2d5cj6";
      type = "gem";
    };
    version = "2.8.2";
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
      sha256 = "1askip583sfnz25gywd508l3vj5wnvx9vp7gm1sfnixm7amssrwq";
      type = "gem";
    };
    version = "3.0.9";
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
      sha256 = "1g99c3s5zvrwvlv3gjw5fvpdimybpfazqyszjim5kdjjbq0586hj";
      type = "gem";
    };
    version = "3.2.5";
  };
  ms_rest = {
    dependencies = ["concurrent-ruby" "faraday" "timeliness"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jiha1bda5knpjqjymwik6i41n69gb0phcrgvmgc5icl4mcisai7";
      type = "gem";
    };
    version = "0.7.6";
  };
  ms_rest_azure = {
    dependencies = ["concurrent-ruby" "faraday" "faraday-cookie_jar" "ms_rest"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06i37b84r2q206kfm5vsi9s1qiiy09091vhvc5pzb7320h0hc1ih";
      type = "gem";
    };
    version = "0.12.0";
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
      sha256 = "1r9k34xz7x7fpd18bix0cd5bk2wv6mj8z67f8fr7l30d2717m23h";
      type = "gem";
    };
    version = "0.2.3";
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
    dependencies = ["net-protocol" "uri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11mymfxpsgpwr1qbv8vwj8av9kksqj0632p9s3x35bzrnq4y393m";
      type = "gem";
    };
    version = "0.1.1";
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
      sha256 = "0xqcffn3c1564c4fizp10dzw2v5g2pabdzrcn25hq05bqhsckbar";
      type = "gem";
    };
    version = "0.18.0";
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
      sha256 = "0b4h3ip8d1gkrc0znnw54hbxillk73mdnaf5pz330lmrcl1wiilg";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "1l0kgd7w08fx2522aw8grlfzwmrgw4jgjakpkgkwm0134g5xv432";
      type = "gem";
    };
    version = "6.0.0";
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
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    version = "2.5.8";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mr2ibfk874ncv0qbdkynay738w2mfinlkhnbd5lyk5yiw5q1p10";
      type = "gem";
    };
    version = "1.15.2";
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
      sha256 = "15lvy06h276jryxg19258b2yqaykf0567sp0n16yipywhbp94860";
      type = "gem";
    };
    version = "4.25.1";
  };
  ohai = {
    dependencies = ["chef-config" "chef-utils" "ffi" "ffi-yajl" "ipaddress" "mixlib-cli" "mixlib-config" "mixlib-log" "mixlib-shellout" "plist" "train-core" "wmi-lite"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01jlkb75ic3aw39q5mxyd8dnb65kqmzfq4shp0gli9n04ihz3765";
      type = "gem";
    };
    version = "17.9.0";
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
      sha256 = "1ls87xxzhh1bbm4iqz221hz57y7iq1ifn33i7vvx1d02r9dl4k5i";
      type = "gem";
    };
    version = "2.0.1";
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
  omniauth-azure-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      path = "${src}/vendor/gems/omniauth-azure-oauth2";
      type = "path";
    };
    version = "0.0.10";
  };
  omniauth-dingtalk-oauth2 = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16qkd51f1ab1hw4az27qj3vk958aal67by8djsplwd1q3h7nfib5";
      type = "gem";
    };
    version = "1.0.1";
  };
  omniauth-facebook = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03zjla9i446fk1jkw7arh67c39jfhp5bhkmhvbw8vczxr1jkbbh5";
      type = "gem";
    };
    version = "4.0.0";
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
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yw2vzx633p9wpdkd4jxsih6mw604mj7f6myyfikmj4d95c8d9z7";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "01k9rkg97npcgm8r4x3ja8y20hsg4zy0dcjpzafx148q4yxbg74n";
      type = "gem";
    };
    version = "2.1.0";
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
  omniauth-twitter = {
    dependencies = ["omniauth-oauth" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r5j65hkpgzhvvbs90id3nfsjgsad6ymzggbm7zlaxvnrmvnrk65";
      type = "gem";
    };
    version = "1.4.0";
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
      sha256 = "08yl0x203k6nrshc70zawfqh79ap1c3fyka9zwwy61cvn7sih4sz";
      type = "gem";
    };
    version = "0.6.1";
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
  openid_connect = {
    dependencies = ["activemodel" "attr_required" "json-jwt" "rack-oauth2" "swd" "tzinfo" "validate_email" "validate_url" "webfinger"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w474bz3s1hqhilvrddr33l2nkyikypaczp3808w0345jr88b5m7";
      type = "gem";
    };
    version = "1.3.0";
  };
  openssl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c649921vg2l939z5cc3jwd8p1v49099pdhxfk7sb9qqx5wi5873";
      type = "gem";
    };
    version = "3.1.0";
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
      sha256 = "0ldi3j95dh3c29w4bliykfdd08r95d4zvbdblk385w9b4knr2afc";
      type = "gem";
    };
    version = "1.63.0";
  };
  pact-mock_service = {
    dependencies = ["filelock" "find_a_port" "json" "pact-support" "rack" "rspec" "term-ansicolor" "thor" "webrick"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09syv4y0g0pvjshxj8i0yg7mrvszgp503is1b78k86bgv6wc73l9";
      type = "gem";
    };
    version = "3.10.0";
  };
  pact-support = {
    dependencies = ["awesome_print" "diff-lcs" "expgen" "rainbow"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xh4idg0m1mr0pkywj5f79nlr4g6n4waism86gj34h8wicf9c9aa";
      type = "gem";
    };
    version = "1.18.1";
  };
  parallel = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vnk6bb54k4yc06xnwck7php50l09vvlw1ga8wdz0pia461zpzb";
      type = "gem";
    };
    version = "1.22.1";
  };
  parser = {
    dependencies = ["ast" "racc"];
    groups = ["coverage" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1swigds85jddb5gshll1g8lkmbcgbcp9bi1d4nigwvxki8smys0h";
      type = "gem";
    };
    version = "3.2.2.3";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zcvxmfa8hxkhpp59fhxyxy1arp70f11zi1jh9c7bsdfspifb7kb";
      type = "gem";
    };
    version = "1.5.3";
  };
  pg_query = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cs8c0f903phs3yjjbrhlyaipvmvm95xids06a761hf0s6lj0j5h";
      type = "gem";
    };
    version = "4.2.1";
  };
  plist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1whhr897z6z6av85x2cipyjk46bwh6s4wx6nbrcd3iifnzvbqs7l";
      type = "gem";
    };
    version = "3.6.0";
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
  po_to_json = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xvanl437305mry1gd57yvcg7xrfhri91czr32bjr8j2djm8hwba";
      type = "gem";
    };
    version = "1.0.1";
  };
  premailer = {
    dependencies = ["addressable" "css_parser" "htmlentities"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11j7d6abxivj15yax47z3f751wz4pnl02qszzc9swswf8hn41r03";
      type = "gem";
    };
    version = "1.16.0";
  };
  premailer-rails = {
    dependencies = ["actionmailer" "premailer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqi7d4f15vy3f1g0xb3bxmncfbzv9dd3ilhqj0plvw64xqbkp3w";
      type = "gem";
    };
    version = "1.10.3";
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
      sha256 = "14m09ysq0l6kih9pdy1mmdabdyjk09hvx4rzqh6phgb34s1w4pfp";
      type = "gem";
    };
    version = "0.25.0";
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
      sha256 = "031nacdzds5821p384qzhliim1h6d60nc63ml572gpz4zwynp6m9";
      type = "gem";
    };
    version = "0.6.1";
  };
  public_suffix = {
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sqw1zls6227bgq38sxb2hs8nkdz4hn1zivs27mjbniswfy4zvi6";
      type = "gem";
    };
    version = "5.0.0";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7fmv0n4bhdcwh60dgza44iqai5pg34f5pzm4vh4i5fwx7mpqxh";
      type = "gem";
    };
    version = "6.3.0";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jgz6r0f7v84a7jz9an85q8vvmp743dqcsdm3z9c8rqcqv6pljq";
      type = "gem";
    };
    version = "1.6.2";
  };
  rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w217k9z02c4hqizym8dkj6bqmmzx4qdvqpnskgzf174a5pwdxk";
      type = "gem";
    };
    version = "2.2.7";
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
      sha256 = "049s3y3dpl6dn478g912y6f9nzclnnkl30psrbc2w5kaihj5szhq";
      type = "gem";
    };
    version = "6.6.1";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvs0mq8jrsz86jva91mgql16daprpa3qaipzzfvngnnqr5680j7";
      type = "gem";
    };
    version = "1.1.1";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "httpclient" "json-jwt" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fknwsxz4429w1hndl6y30cmm2n34wmmaaj2hhp6jrm8ssfsfwjf";
      type = "gem";
    };
    version = "1.21.3";
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
      sha256 = "1a62439xwn5v6hsl9s11hdk4wj58czhcbg7lminv23mnkc0ca147";
      type = "gem";
    };
    version = "0.7.6";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rjl709krgf499dhjdapg580l2qaj9d91pwzk8ck8fpnazlx1bdd";
      type = "gem";
    };
    version = "2.0.2";
  };
  rack-timeout = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cqa9lh2rdqqvhfxbrdys7mj2x4vxhqmf57iww2x8961mhp8jm0p";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b7ggchi3d7pwzmj8jn9fhbazr5fr4dy304f0hz7kqbg23s9c1ym";
      type = "gem";
    };
    version = "6.1.7.2";
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
    dependencies = ["loofah"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ygav4xyq943qqyhjmi3mzirn180j565mc9h5j4css59x1sn0cmz";
      type = "gem";
    };
    version = "1.5.0";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lrbrx88ic42adcj36wip3dk1svmqld1f7qksngi4b9kqnc8w5g3";
      type = "gem";
    };
    version = "7.0.3";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mm3nf3y715ln6v8k6g4351ggkr1bcwc5637vr979yw8vsmdi42k";
      type = "gem";
    };
    version = "6.1.7.2";
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
      sha256 = "09kszvsa9av8yb8pm9nz6p5jgshin3cqvknlvd1m927qfvdpalk3";
      type = "gem";
    };
    version = "0.9.78";
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
  rbtree = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z0h1x7fpkzxamnvbw1nry64qd6n0nqkwprfair29z94kd3a9vhl";
      type = "gem";
    };
    version = "0.4.6";
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
  rdoc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19h5g3g7k7wggy9amfx8b3m09ss7wrakbrva2xnda9sw4chagx6y";
      type = "gem";
    };
    version = "6.3.2";
  };
  re2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1habsrf67d3m5p12wc2bydsa7bj87r7w1266x8in59znf5wz4drf";
      type = "gem";
    };
    version = "1.6.0";
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
      sha256 = "0m9dv7ya9q93r8x1pg2gi15rxlbck8m178j1fz7r5v6wr1avrrqy";
      type = "gem";
    };
    version = "4.3.2";
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
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h4iq67p5jjkg9kny7ki6yzkivyakmhbp6ckkhl6mlnriw5avc9z";
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
      sha256 = "04l61lpb3s2xkwj36l7b543lhciv19z514kxnmnbh5fg70grc8q9";
      type = "gem";
    };
    version = "1.9.0";
  };
  redis-rack = {
    dependencies = ["rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k3pn706wnf7lb24l6hwsi00c8rx693hvgfnccw3qj1y635ywwh8";
      type = "gem";
    };
    version = "2.1.4";
  };
  redis-store = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0787fwmlvpx5k360dxlcs8r7vijgl2iyvh3zyvl7qyvgshw78k3v";
      type = "gem";
    };
    version = "1.9.1";
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
      sha256 = "1p7pqcfq33q1z4xlp4qm94w4h3fzc1yvr3cny16d00i8b20v4rx2";
      type = "gem";
    };
    version = "3.0.0";
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
    groups = ["danger" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
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
      sha256 = "11q7rkjx40yi6lpylgl2jkpy162mjw7mswrcgcax86vgpbpjx6i3";
      type = "gem";
    };
    version = "6.2.0";
  };
  rouge = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pym2zjwl6dwdfvbn7rbvmds32r70jx9qddhvvi6pqy6987ack1v";
      type = "gem";
    };
    version = "4.1.2";
  };
  rqrcode = {
    dependencies = ["chunky_png"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "188n1mvc7klrlw30bai16sdg4yannmy7cz0sg0nvm6f1kjx5qflb";
      type = "gem";
    };
    version = "0.7.0";
  };
  rqrcode-rails3 = {
    dependencies = ["rqrcode"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i28rwmj24ssk91chn0g7qsnvn003y3s5a7jsrg3w4l5ckr841bg";
      type = "gem";
    };
    version = "0.1.7";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171rc90vcgjl8p1bdrqa92ymrj8a87qf6w20x05xq29mljcigi6c";
      type = "gem";
    };
    version = "3.12.0";
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
    groups = ["test"];
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
      sha256 = "0d3fnabkaw8n0na2dpnlg2xygggj51djzpj9x6y5rkiqbfyqwv01";
      type = "gem";
    };
    version = "6.0.1";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12y52zwwb3xr7h91dy9k3ndmyyhr3mjcayk0nnarnrzz8yr48kfx";
      type = "gem";
    };
    version = "3.12.0";
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
    dependencies = ["activerecord" "pg" "rails" "sqlite3"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vkfizrwxgs029s9imz8g3p55ggncls709hf98brmv6wg5znjibs";
      type = "gem";
    };
    version = "0.0.6";
  };
  rubocop = {
    dependencies = ["json" "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1imdfx3mx2p1k7bhc5qm35zvqw12hyz52yy2k9xj3dwrdpzjg0fh";
      type = "gem";
    };
    version = "1.43.0";
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
  rubocop-capybara = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h4qcjkz0365qlhi7y1ni94qj14k397cad566zygm20p15ypbp5v";
      type = "gem";
    };
    version = "2.17.0";
  };
  rubocop-graphql = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hryrjmcl04br06ibjzzrbb2am8ybbhnl2l7w13xl3wz3k4jyjxs";
      type = "gem";
    };
    version = "0.19.0";
  };
  rubocop-performance = {
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n7g0vg06ldjaq4f8c11c7yqy99zng1qdrkkk4kfziippy24yxnc";
      type = "gem";
    };
    version = "1.16.0";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxyifly45y7dfiaf0ql8aq7xykrg0sh1l7dxmn3sb9p2jd18140";
      type = "gem";
    };
    version = "2.17.4";
  };
  rubocop-rspec = {
    dependencies = ["rubocop" "rubocop-capybara"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vmmin3ymgq7bhv2hl4pd0zpwawy709p816axc4vi67w61b4bij1";
      type = "gem";
    };
    version = "2.18.1";
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
      sha256 = "18vnbzin5ypxrgcs9lllg7x311b69dyrdw2w1pwz84438hmxm79s";
      type = "gem";
    };
    version = "1.15.0";
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
  ruby_parser = {
    dependencies = ["sexp_processor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qybplg87pv6kxwyh4nkfn7pa4cisiajbfvh22dzkkbzxyxwil0p";
      type = "gem";
    };
    version = "3.20.0";
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
      sha256 = "0wnfgxx59nq2wpvi8ll7bqw9x99x5hps6i38xdjrwbb5a3896d58";
      type = "gem";
    };
    version = "1.5.1";
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
      sha256 = "1zq8pxmsd1abw18zz6mazsm2jfpwmbgdxbpawb7bmwvkb2c5yyc1";
      type = "gem";
    };
    version = "6.0.0";
  };
  sass = {
    dependencies = ["sass-listen"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10401m2xlv6vaxfwzy4xxmk51ddcnkvwi918cw3jkki0qqdl7d8v";
      type = "gem";
    };
    version = "3.5.5";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  sassc = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gpqv48xhl8mb8qqhcifcp0pixn206a7imc07g48armklfqa4q2c";
      type = "gem";
    };
    version = "2.4.0";
  };
  sassc-rails = {
    dependencies = ["railties" "sassc" "sprockets" "sprockets-rails" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18mgdjxdzpbw92zrllynxw7jn7yihi85j3dg7i4f6c39w1scqkbn";
      type = "gem";
    };
    version = "2.1.0";
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
    dependencies = ["rexml" "rubyzip" "websocket"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kxnv3ywssagv2q453hasrrrvsv68d5f3ccm33pyacdji88w8pqg";
      type = "gem";
    };
    version = "4.9.0";
  };
  semver_dialects = {
    dependencies = ["pastel" "thor" "tty-command"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08zb8rlr20f1985hyakd9z7f9hc9n34qx1g8cyk5377pb5vgd8b0";
      type = "gem";
    };
    version = "1.2.1";
  };
  sentry-rails = {
    dependencies = ["railties" "sentry-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06vklzpziqryd25k71k8qia4sy7xh10zci9wg7dbzhp2kn82s6y1";
      type = "gem";
    };
    version = "5.8.0";
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
  sentry-ruby = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "043isdlj6x9rymj74gh8m6li6yr8b8k4a6lr9swrydxy6ca15sya";
      type = "gem";
    };
    version = "5.8.0";
  };
  sentry-sidekiq = {
    dependencies = ["sentry-ruby" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yf7fwc4wczi87bdmb9bksprw66xcsvr1ldskpcmzz592qyi5lch";
      type = "gem";
    };
    version = "5.8.0";
  };
  set = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p8raic4vlif3r4crjm3x32hmkpikjd456c126hrv3kkyj6zwsfi";
      type = "gem";
    };
    version = "1.0.1";
  };
  sexp_processor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p0r92dyffx6wkgazv3wi4m2yfm39kvvr9cjp2f57az5pgsdpajw";
      type = "gem";
    };
    version = "4.16.1";
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
    dependencies = ["connection_pool" "rack" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p2mj2jj5b9wqmpvkngx87lfr2qgwhqvwx38bmhl5aa29pc6z5kx";
      type = "gem";
    };
    version = "6.5.7";
  };
  sidekiq-cron = {
    dependencies = ["fugit" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jmh5vc2gdy0a161hgq0vlbwaviqj51pqzmgda4p2nyffg575nj7";
      type = "gem";
    };
    version = "1.8.0";
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
      sha256 = "0100rclkhagf032rg3r0gf3f4znrvvvqrimy6hpa73f21n9k2a0x";
      type = "gem";
    };
    version = "0.17.0";
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
      sha256 = "1hrv046jll6ad1s964gsmcq4hvkr3zzr6jc7z1mns22mvfpbc3cr";
      type = "gem";
    };
    version = "0.21.2";
  };
  simplecov-cobertura = {
    dependencies = ["simplecov"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07ikl2y382g6ibzfflsamh13qlsr2769bx09kxdcs894cl882wwv";
      type = "gem";
    };
    version = "1.3.1";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h89asinyyyq88v89fdc3nw0g74vq2f7p59s18jrq3svpv913ij9";
      type = "gem";
    };
    version = "2.3.4";
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
  sorted_set = {
    dependencies = ["rbtree" "set"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0brpwv68d7m9qbf5js4bg8bmg4v7h4ghz312jv9cnnccdvp8nasg";
      type = "gem";
    };
    version = "1.0.3";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b9i14qb27zs56hlcc2hf139l0ghbqnjpmfi0054dxycaxvk5min";
      type = "gem";
    };
    version = "3.4.2";
  };
  sqlite3 = {
    dependencies = ["mini_portile2"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f24qp50mc1qg8yvv7b3x73mh78d6mzd3b7rqib1ixfbsdiayx1x";
      type = "gem";
    };
    version = "1.6.0";
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
      sha256 = "0bhdgfb0pmw9mav1kw9fn0ka012sa0i3h5ppvqssw5xq48nhxnr8";
      type = "gem";
    };
    version = "0.2.25";
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
    dependencies = ["activesupport" "attr_required" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12b3q2sw42nnilfb51nlqdv07f31vdv2j595kd99asnkw4cjlf5w";
      type = "gem";
    };
    version = "1.3.0";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0an1311bpyhd9kzak1qpd4jks336i47gbvx3zdrnn1rdxppimsac";
      type = "gem";
    };
    version = "0.6.0";
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
      sha256 = "09phq7jxfgamv03kjcgibw0f6w3g3mlb9yapji3bxh7cbjvwk2pa";
      type = "gem";
    };
    version = "1.2.1";
  };
  test_file_finder = {
    dependencies = ["faraday"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kgak2xqyp2wf7y1c1q1dpxw56iq9mgpqjji6vfbjkxckqrxhdmw";
      type = "gem";
    };
    version = "0.1.4";
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
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
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
  timeliness = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gvp9b7yn4pykn794cibylc9ys1lw7fzv7djx1433icxw4y26my3";
      type = "gem";
    };
    version = "0.3.10";
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
      sha256 = "1pbfbmi9l5hxr1zly1bc72fk8a6by4d19wdap8q3mi3rlflqzbfp";
      type = "gem";
    };
    version = "3.4.9";
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
      sha256 = "1m22yrkmbj81rzhlny81j427qdvz57yk5wbcf3km0nf3bl6qiygz";
      type = "gem";
    };
    version = "1.4.0";
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
    dependencies = ["imagen" "rainbow" "rugged"];
    groups = ["coverage" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fgkhqg7npixc95h060ykbjz0a07ldl3dp9y7wd2qgi5irq5vfr7";
      type = "gem";
    };
    version = "0.4.5";
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
      sha256 = "1vigw7nfszfqgikr6n574k9bfh0rvs74z8xq46rz2zsm8249l8cc";
      type = "gem";
    };
    version = "0.12.1";
  };
  uri_template = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p8qbxlpmg3msw0ihny6a3gsn0yvydx9ksh5knn8dnq06zhqyb1i";
      type = "gem";
    };
    version = "0.7.0";
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
  validate_email = {
    dependencies = ["activemodel" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1fz29l699arka177c9xw7409d1a3ff95bf7a6pmc97slb91zlx";
      type = "gem";
    };
    version = "0.1.6";
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
      sha256 = "1hxqza44pvk6x6vb91cvllhw71hqziby06dk1s94rh9f6khbl1nm";
      type = "gem";
    };
    version = "1.0.11";
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
      sha256 = "08jc9k4qqazbf5frhdril5084adm90rs1lqbnqq3yfdm2dgaiyhx";
      type = "gem";
    };
    version = "3.2.0";
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
    dependencies = ["activesupport" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jj50b44a471ig7hw1ax90wxaaz40acmrf6cm7m2iyshlffy53q";
      type = "gem";
    };
    version = "1.2.0";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1myj44wvbbqvv18ragv3ihl0h61acgnfwrnj3lccdgp49bgmbjal";
      type = "gem";
    };
    version = "3.18.1";
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
      sha256 = "0dib6p55sl606qb4vpwrvj5wh881kk4aqn2zpfapf8ckx7g14jw8";
      type = "gem";
    };
    version = "1.2.9";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a3bwxd9v3ghrxzjc4vxmf4xa18c6m4xqy5wb0yk5c6b9psc7052";
      type = "gem";
    };
    version = "0.7.5";
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
      sha256 = "110dv4arvwyky6f2pq19f20f1xcjpiz3zfbals0y49ijpq8agvql";
      type = "gem";
    };
    version = "1.0.5";
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
      sha256 = "09pqhdi6q4sqv0p1gnjpbcy4az0yv8hrpykjngdgh9qiqd87nfdv";
      type = "gem";
    };
    version = "2.6.6";
  };
}
