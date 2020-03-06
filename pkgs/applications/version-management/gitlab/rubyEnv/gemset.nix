{
  abstract_type = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09330cmhrc2wmfhdj9zzg82sv6cdhm3qgdkva5ni5xfjril2pf14";
      type = "gem";
    };
    version = "0.0.7";
  };
  ace-rails-ap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14wj9gsiy7rm0lvs27ffsrh92wndjksj6rlfj3n7jhv1v77w9v2h";
      type = "gem";
    };
    version = "4.1.2";
  };
  acme-client = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9pddds2kfw0br2c153csly4248w9rppkvslx46gncadp9gdb4n";
      type = "gem";
    };
    version = "2.0.5";
  };
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dngxp5r9ww4xgryn458ngq2h3ylx7d6d258wcfqhibpyjr7qvpj";
      type = "gem";
    };
    version = "6.0.2";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11wpcjc806y82p1nn3ly9savcdqcf4b0qml5ri5bmd6r2g802s2z";
      type = "gem";
    };
    version = "6.0.2";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ych434bbim8n65png7hg35xfgmpv0qxvkngpvrr3qgj7l1xgdi5";
      type = "gem";
    };
    version = "6.0.2";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zg96vjjw1kbli6nk6cyk64zfh4lgpl7fqx38ncbgfacl4dq7y0b";
      type = "gem";
    };
    version = "6.0.2";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "nokogiri"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1acw3yypd4w35ra87d0kzwwcwj3hps6j0g108rnxy7pscvzajw8q";
      type = "gem";
    };
    version = "6.0.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bfh9z3n98c76c6jdp6avh75wsckxyp74r59hmgnqdhfznbkppv4";
      type = "gem";
    };
    version = "6.0.2";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bhf4lxnrmz73zshl5rzvw65x3kd18yligf11lcg7ik9b2i9j6pi";
      type = "gem";
    };
    version = "6.0.2";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09p7si419x0fb5cw8cbfmzplyk2bdrx0m5cy9pwja89rnhp8yhl0";
      type = "gem";
    };
    version = "6.0.2";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w60vnkg88frbpsixfm9immh211pbqg9dwm0gqrr17kdjd00r5z4";
      type = "gem";
    };
    version = "6.0.2";
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
    dependencies = ["actionpack" "activejob" "activerecord" "marcel"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qsjhyrjcklqf7dqw6yjvmbfd8yhqyz0dy9apmpd0swiwxnn8kds";
      type = "gem";
    };
    version = "6.0.2";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1brlp5pmawb2hqdybjb732zxxkamcmis6px3wyh09rjlc0gqnzzz";
      type = "gem";
    };
    version = "6.0.2";
  };
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nvhd986xa6llyjnhikq4h1nrcf5b9r9s11if25qsj8358inrpga";
      type = "gem";
    };
    version = "6.5.0";
  };
  adamantium = {
    dependencies = ["ice_nine" "memoizable"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0165r2ikgfwv2rm8dzyijkp74fvg0ni72hpdx8ay2v7cj08dqyak";
      type = "gem";
    };
    version = "0.2.0";
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  aes_key_wrap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0li86k0g812jkzrppb2fvqngvzp09nygywjpn81nx90s01wxqw07";
      type = "gem";
    };
    version = "1.0.1";
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
  apollo_upload_server = {
    dependencies = ["graphql" "rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0riijpyicbkqsr46w4mfhh3pq2yrmakkz8mmgbrfjhzbyzac25na";
      type = "gem";
    };
    version = "2.0.0.beta.3";
  };
  asana = {
    dependencies = ["faraday" "faraday_middleware" "faraday_middleware-multi_json" "oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19yr6ibz481jizvx0cjfvql142v8izi474c4vmwy9qzksyq2xhdj";
      type = "gem";
    };
    version = "0.9.3";
  };
  asciidoctor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b2ajs3sabl0s27r7lhwkacw0yn0zfk4jpmidg9l8lzp2qlgjgbz";
      type = "gem";
    };
    version = "2.0.10";
  };
  asciidoctor-include-ext = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1alaqfh31hd98yhqq8fsc50zzqw04p3d83pc35gdx3x9p3j1ds7d";
      type = "gem";
    };
    version = "0.3.1";
  };
  asciidoctor-plantuml = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bnrz4ywaq7vaw66fy3kkbwf07fvyqwngm3vb83s9h5zvr4n593b";
      type = "gem";
    };
    version = "0.0.10";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "184ssy3w93nkajlz2c70ifm79jp3j737294kbc5fjw69v1w0n9x7";
      type = "gem";
    };
    version = "2.4.0";
  };
  atlassian-jwt = {
    dependencies = ["jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ckfiiwv7dnifra7zhbggj96g0x0kzkv0x9n1is7lb86svlm7rjj";
      type = "gem";
    };
    version = "0.2.0";
  };
  attr_encrypted = {
    dependencies = ["encryptor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ncv2az1zlj33bsllr6q1qdvbw42gv91lxq0ryclbv8l8xh841jg";
      type = "gem";
    };
    version = "3.1.0";
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
  awesome_print = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14arh1ixfsd6j5md0agyzvksm5svfkvchb90fp32nn7y3avcmc2h";
      type = "gem";
    };
    version = "1.8.0";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "100g77a5ixg4p5zwq77f28n2pdkk0y481f7v83qrlmnj22318qq6";
      type = "gem";
    };
    version = "1.0.3";
  };
  aws-sdk = {
    dependencies = ["aws-sdk-resources"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yvl9bxzaxgcyzix2yw46cgll9nl0xfg5qx1j6y3xc1i78rk7vy0";
      type = "gem";
    };
    version = "2.11.374";
  };
  aws-sdk-core = {
    dependencies = ["aws-sigv4" "jmespath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d7nw1jihv7rglcmkd3hhidjflbzq5ik63n43q27pmx8ki108rd9";
      type = "gem";
    };
    version = "2.11.374";
  };
  aws-sdk-resources = {
    dependencies = ["aws-sdk-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qx2a67vsw8rz1y0m04f97p1q4zx7miy06a5ck78hm77nvsigjj4";
      type = "gem";
    };
    version = "2.11.374";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dfc8i5cxjwlvi4b665lbpbwvks8a6wfy3vfmwr3pjdmxwdmc2cs";
      type = "gem";
    };
    version = "1.1.0";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    groups = ["default"];
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
      sha256 = "05rgxg4pz4bc4xk34w5grv0yp1j94wf571w84lf3xgqcbs42ip2f";
      type = "gem";
    };
    version = "1.0.2";
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
      sha256 = "09jaxxddqpgq8ynwd2gpjq5rkhw00zdjnqisk9qbpjgxzk6f8gwi";
      type = "gem";
    };
    version = "1.4.0";
  };
  bcrypt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysblqxkclmnhrd0kmb5mr8p38mbar633gdsb14b7dhkhgawgzfy";
      type = "gem";
    };
    version = "3.1.12";
  };
  bcrypt_pbkdf = {
    groups = ["ed25519"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cj4k13c7qvvck7y25i3xarvyqq8d27vl61jddifkc7llnnap1hv";
      type = "gem";
    };
    version = "1.0.0";
  };
  benchmark-ips = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh681m54qdsdyvpvflj1wpnj3ybspbpjkr4cnlrl4nk4yikli0j";
      type = "gem";
    };
    version = "2.3.0";
  };
  benchmark-memory = {
    dependencies = ["memory_profiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11qw8k6rl79ri00njrf1x9v6vzwgv12rkcvgzvg0sk8pfrkzwyxa";
      type = "gem";
    };
    version = "0.1.2";
  };
  better_errors = {
    dependencies = ["coderay" "erubi" "rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pqnxxsqqs7vnqvamk5bzs84dv584g9s0qaf2vqb1v2aj5dabcg7";
      type = "gem";
    };
    version = "2.5.0";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kxy917xyxckifmnawff65j7g6yb3wh2s45npjq9lqjbi1p86lsr";
      type = "gem";
    };
    version = "2.4.3";
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
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05syqlks7463zsy1jdfbbdravdhj9hpj5pv2m74blqpv8bq4vv5g";
      type = "gem";
    };
    version = "0.8.0";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dyjk2irr0d3d3am2dzipg1zyv2nz69a16g8xkprxfa0na07wvs0";
      type = "gem";
    };
    version = "1.4.5";
  };
  bootstrap_form = {
    dependencies = ["actionpack" "activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "044pi097jwh3z68g1zfmbcl9xchqfcsls1j1nvx1bkyj034v6y7m";
      type = "gem";
    };
    version = "4.2.0";
  };
  brakeman = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "161l4ln7x1vnqrcvbvglznf46f0lvq305vq211xaxp4fv4wwv89v";
      type = "gem";
    };
    version = "4.2.1";
  };
  browser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sdx0ny34i6vqxdsc7sy9g0nafdbrw8kvvb5xh9m18x1bzpqk92f";
      type = "gem";
    };
    version = "2.5.3";
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
      sha256 = "1h16vrqblcdlizgbidk7bgmhcfb96a9y5jw117my5yhs07yp0i3s";
      type = "gem";
    };
    version = "6.0.2";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gr7k6m9fda7m66irxzydm8v9xbmlryjj65cagwm1zyi5f317srb";
      type = "gem";
    };
    version = "0.5.0";
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
      sha256 = "1vv7s88w8jb1qg4qz3jrs3x3y5d9jfyyl7wfiz78b5x95ydvx41q";
      type = "gem";
    };
    version = "9.1.0";
  };
  capybara = {
    dependencies = ["addressable" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y7ncfji4s3h3wdr2hwsrd32k0va92a6lyx2x8w6a3vkbc94kpch";
      type = "gem";
    };
    version = "3.22.0";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x90lh7nf3zi54arjf430s9xdxr3c12xjq1l28izgxqdk8s40q7q";
      type = "gem";
    };
    version = "1.0.22";
  };
  carrierwave = {
    dependencies = ["activemodel" "activesupport" "mime-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10rz94kajilffp83sb767lr62b5f8l4jzqq80cr92wqxdgbszdks";
      type = "gem";
    };
    version = "1.3.1";
  };
  cause = {
    groups = ["default" "metrics"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
      type = "gem";
    };
    version = "0.1";
  };
  character_set = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "114npdbw1ivyx4vnid8ncnjw4wnjcipf2lvihlg3ibbh7an0m9s9";
      type = "gem";
    };
    version = "1.1.2";
  };
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf1l31n10yaark2rrg5qzyzcx9w80681449s3j09qmnipsl8rl5";
      type = "gem";
    };
    version = "0.7.6";
  };
  childprocess = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic028k8xgm2dds9mqnvwwx3ibaz32j8455zxr9f4bcnviyahya5";
      type = "gem";
    };
    version = "3.0.0";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kasxsms24fgcdsq680nz99d5lazl9rmz1qkil2y5gbbssx89g0z";
      type = "gem";
    };
    version = "1.0.3";
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
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    groups = ["default"];
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
    dependencies = ["ruby-enum"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19zd9na1g2d0zzbqhmfj8rjfzcxj34vja3i52gvv859i8fifa461";
      type = "gem";
    };
    version = "0.20.1";
  };
  concord = {
    dependencies = ["adamantium" "equalizer"];
    groups = ["default" "development" "test"];
    platforms = [];
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
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  connection_pool = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lflx29mlznf1hn0nihkgllzbj8xp5qasn8j7h838465pi399k68";
      type = "gem";
    };
    version = "2.2.2";
  };
  contracts = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11kj7hdr94hxgxad9wazncvaxzaxlbvw6laq179ivhw9za746vnz";
      type = "gem";
    };
    version = "0.11.0";
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
  countries = {
    dependencies = ["i18n_data" "sixarm_ruby_unaccent" "unicode_utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w278pjhwkbin7jpr7m47wac7gj5n4l2him9k2q4ngzq6rs2id7c";
      type = "gem";
    };
    version = "3.0.0";
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
  css_parser = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y4vc018b5mzp7winw4pbb22jk0dpxp22pzzxq7w0rgvfxzi89pd";
      type = "gem";
    };
    version = "1.7.0";
  };
  daemons = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lxqq6dgb8xhliywar2lvkwqy2ssraf9dk4b501pb4ixc2mvxbp2";
      type = "gem";
    };
    version = "1.2.6";
  };
  danger = {
    dependencies = ["claide" "claide-plugins" "colored2" "cork" "faraday" "faraday-http-cache" "git" "kramdown" "kramdown-parser-gfm" "no_proxy_fix" "octokit" "terminal-table"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gyxfs7pkcg90llhpl2nwfqqcqi0qngqhk8gpyrffj6m0lm1m6wl";
      type = "gem";
    };
    version = "6.0.9";
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
  debug_inspector = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vxr0xa1mfbkfcrn71n7c4f2dj7la5hvphn904vh20j3x4j5lrx0";
      type = "gem";
    };
    version = "0.0.3";
  };
  debugger-ruby_core_source = {
    groups = ["default" "development"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lp5dmm8a8dpwymv6r1y6yr24wxsj0gvgb2b8i7qq9rcv414snwd";
      type = "gem";
    };
    version = "1.3.8";
  };
  deckar01-task_list = {
    dependencies = ["html-pipeline"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18bwkvxjr7khxj95xrg1vj7va522vbm2li9wsiiw01cg5b10hni0";
      type = "gem";
    };
    version = "2.3.1";
  };
  declarative = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0642xvwzzbgi3kp1bg467wma4g3xqrrn0sk369hjam7w579gnv5j";
      type = "gem";
    };
    version = "0.0.10";
  };
  declarative-option = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g4ibxq566f1frnhdymzi9hxxcm4g2gw4n21mpjk2mhwym4q6l0p";
      type = "gem";
    };
    version = "0.1.0";
  };
  default_value_for = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08hwnnqm3bxd4n627isliq79zysdlmfkf813403v0b4mkhika5my";
      type = "gem";
    };
    version = "3.3.0";
  };
  derailed_benchmarks = {
    dependencies = ["benchmark-ips" "get_process_mem" "heapy" "memory_profiler" "rack" "rake" "ruby-statistics" "thor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bsxrmrjhjvvxpl3sgq0c6yyzspazgmxcpdkfipqknd7p8r0hd53";
      type = "gem";
    };
    version = "1.4.2";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
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
      sha256 = "0a64xq0dj6p0firpg4mrrfmlakpv17hky5yfrjhchs2sybmymr9i";
      type = "gem";
    };
    version = "4.7.1";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkldws5lga4mlv4xmcrfb0yivl6qad0l8qyb2hdb50adv6ny4gs";
      type = "gem";
    };
    version = "3.0.0";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
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
      sha256 = "1azibizfv91sjbzhjqj1pg2xcv8z9b8a7z6kb3wpl4hpj5hil5kj";
      type = "gem";
    };
    version = "3.1.0";
  };
  discordrb-webhooks-blackst0ne = {
    dependencies = ["rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f0dw6ci5cbrxrvvqw2kqabpzyjisd4hflbi370rpb4cakkzgw39";
      type = "gem";
    };
    version = "3.3.0";
  };
  docile = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04d2izkna3ahfn6fwq4xrcafa715d3bbqczxm16fq40fqy87xn17";
      type = "gem";
    };
    version = "1.3.1";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abdlwb64ns7ssmiqhdwgl27ly40x2l27l8hs8hn0z4kb3zd2x3v";
      type = "gem";
    };
    version = "0.5.20180417";
  };
  doorkeeper = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0488m6nwp31mxrhayj60gsb7jgyw1lzh73r2kldx00a9bw3634d4";
      type = "gem";
    };
    version = "5.0.2";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "json-jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qcl11dw9b0si45id7sqwv19g8am4i221sqkigimnvhc1cci2yfw";
      type = "gem";
    };
    version = "1.6.3";
  };
  ed25519 = {
    groups = ["ed25519"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5kr8za7hvla38fc0n9jiv55iq62k5bzclsa5kdb14l3r4w6qnw";
      type = "gem";
    };
    version = "1.2.4";
  };
  elasticsearch = {
    dependencies = ["elasticsearch-api" "elasticsearch-transport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jp7amblk18dag3w0yrzdzkhkbfap2d6xpbyv9314parxw98mgq0";
      type = "gem";
    };
    version = "6.8.0";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kq6ljssd5nd2fjaznbnyf4bhkk5q17ava5rq3bjfvjh1wyzagca";
      type = "gem";
    };
    version = "6.8.0";
  };
  elasticsearch-model = {
    dependencies = ["activesupport" "elasticsearch" "hashie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ifm8vh8nr9r1wnpnfa6kjm7v54jwsgvpg060r08haydqcv5lbsy";
      type = "gem";
    };
    version = "6.1.0";
  };
  elasticsearch-rails = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zxqj7pgb0b32qda84jlg6kay4b9qbpjlfk2b0m23hxnkbbmf1bd";
      type = "gem";
    };
    version = "6.1.0";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c1scz8l4z84x7g3iwf9kmvrpgjjq0gaxaswviiy9zg3csn720mc";
      type = "gem";
    };
    version = "6.8.0";
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
  equalizer = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nwzxnqhr31fn7nbqmffcysvxjdfl3bhxi0bld5qqhcnfc1xd13x";
      type = "gem";
    };
    version = "1.9.0";
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
      sha256 = "1swgjb3h2hs5xflb68837l0vd32masbz9c66b1963mxlnnxf5gsg";
      type = "gem";
    };
    version = "1.2.1";
  };
  eventmachine = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  excon = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nn8wk7j22ly4lzdp5pnm7qsrjxbgspiyxkw70g1qf9bn6pslmxr";
      type = "gem";
    };
    version = "0.71.1";
  };
  execjs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grlxwiccbnflxs30r3h7g23xnps5knav1jyqkk3anvm8363ifjw";
      type = "gem";
    };
    version = "2.6.0";
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
      sha256 = "04mvwcdh1056r79vq969vlncrcy53fkhw0iixpqvp8gnx5ajbsv6";
      type = "gem";
    };
    version = "5.1.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02q7lwfdilwahza2jz0p0kc2rragv617q9r2yy72syv6lfy923sx";
      type = "gem";
    };
    version = "5.1.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s72m05jvzc1pd6cw1i289chas399q0a14xrwg4rvkdwy7bgzrh0";
      type = "gem";
    };
    version = "0.15.4";
  };
  faraday-http-cache = {
    dependencies = ["faraday"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08j86fgcwl7z792qyijdsq680arzpfiydqd24ja405z2rbm7r2i0";
      type = "gem";
    };
    version = "2.0.0";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7icfl28nvl8qqdsngryz1snqic9l8x6bk0dxd7ygn230y0k41d";
      type = "gem";
    };
    version = "0.12.2";
  };
  faraday_middleware-aws-signers-v4 = {
    dependencies = ["aws-sdk-resources" "faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y88xcbq8k2ijhsqdava5493p26k49agvnzca6vkl3qwfv3ambhp";
      type = "gem";
    };
    version = "0.1.7";
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
      sha256 = "1s42dsy3rh9h37d16pwhswf2q9cx25v5fn3q881b5iz6fvdjixv3";
      type = "gem";
    };
    version = "1.6.0";
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
    groups = ["default" "development" "kerberos" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10ay35dm0lkcqprsiya6q2kwvyid884102ryipr4vrk790yfp8kd";
      type = "gem";
    };
    version = "1.11.3";
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
  flipper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01gbn1qmcvn49gjcbvd5fga57qc8l3915kb04ikkffvb6n09q7f7";
      type = "gem";
    };
    version = "0.17.1";
  };
  flipper-active_record = {
    dependencies = ["activerecord" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "154q9xajqs64gxa9fv4hwpad44x3rmwgpldrb941i8wi37dpzskg";
      type = "gem";
    };
    version = "0.17.1";
  };
  flipper-active_support_cache_store = {
    dependencies = ["activesupport" "flipper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mkbyn3mx3f411x4z1l1djc9vix3wrfzd5rhrmxb83iqp60r42hg";
      type = "gem";
    };
    version = "0.17.1";
  };
  flowdock = {
    dependencies = ["httparty" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrvg4gzgabf5mnnhccl8bwrkvn3y4pm7a1dqzqhpvfr4m5pafg";
      type = "gem";
    };
    version = "0.7.1";
  };
  fog-aliyun = {
    dependencies = ["fog-core" "fog-json" "ipaddress" "xml-simple"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vl5zf9wr6qwm1awxscyifvrrfqnyacidxgzhkba2wqlgizk3anh";
      type = "gem";
    };
    version = "0.3.3";
  };
  fog-aws = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "ipaddress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "086kyvdhf1k8nk7f4gmybjc3k0m88f9pw99frddcy1w96pj5kyg4";
      type = "gem";
    };
    version = "3.5.2";
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
    dependencies = ["fog-core" "fog-json" "fog-xml" "google-api-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1784xynmgvj1x9phy42nbd3fcgj040zps6wn7msi6vnj1sg4wpfy";
      type = "gem";
    };
    version = "1.9.1";
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
      sha256 = "0ba4lln35nryi6dcbz68vxg9ml6v8cc8s8c82f7syfd84bz76x21";
      type = "gem";
    };
    version = "0.6.0";
  };
  fog-openstack = {
    dependencies = ["fog-core" "fog-json" "ipaddress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "171xnsl6w0j7yi6sp26dcqahx4r4gb2cf359gmy11g5iwnsll5wg";
      type = "gem";
    };
    version = "1.0.8";
  };
  fog-rackspace = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "ipaddress"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y2bli061g37l9p4w0ljqbmg830rp2qz6sf8b0ck4cnx68j7m32a";
      type = "gem";
    };
    version = "0.1.1";
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
  font-awesome-rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a32q69rdsdw9zhmf2cflvvnikg20amidhn40sv2afw2qk91fcrz";
      type = "gem";
    };
    version = "4.7.0.5";
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
      sha256 = "1x5h31hl75x0p5s36hinywg18ijlxjhnlb5p02aqcjjkx777rcav";
      type = "gem";
    };
    version = "1.2.1";
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
  gemojione = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ayk8r147k1s38nj18pwk76npx1p7jhi86silk800nj913pjvrhj";
      type = "gem";
    };
    version = "3.3.0";
  };
  get_process_mem = {
    dependencies = ["ffi"];
    groups = ["default" "puma" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q7pivp9z9pdxc2ha32q7x9zgqy8m9jf87g6n5mvi5l6knxya8sh";
      type = "gem";
    };
    version = "0.2.5";
  };
  gettext = {
    dependencies = ["locale" "text"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0764vj7gacn0aypm2bf6m46dzjzwzrjlmbyx6qwwwzbmi94r40wr";
      type = "gem";
    };
    version = "3.2.9";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bf83icwypi3p3pd97vlqbnp3hvf31ncd440m9kh9y7x6yk74wyh";
      type = "gem";
    };
    version = "1.5.0";
  };
  gitaly = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14ihiw3xsr3r7pk4mbwarasakhq31vzg87bm8g4qaym9ihpf7y77";
      type = "gem";
    };
    version = "1.86.0";
  };
  github-markup = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17g6g18gdjg63k75sfwiskjzl9i0hfcnrkcpb4fwrnb20v3jgswp";
      type = "gem";
    };
    version = "1.7.0";
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
  gitlab-labkit = {
    dependencies = ["actionpack" "activesupport" "grpc" "jaeger-client" "opentracing" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s1cgnnzlnfglsh5r0iihgvyasa2zbqkyrrnbxshvnkddb10i94z";
      type = "gem";
    };
    version = "0.9.1";
  };
  gitlab-license = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q26cgp3ln3b36n3sc69r6hxafkxjwdr3m0d7jlch5j7vyib9bih";
      type = "gem";
    };
    version = "1.0.0";
  };
  gitlab-markup = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rqf3jmyn78r3ysy3bjyx7s4yv3xipxlmqlmbyrbksna19rrx08d";
      type = "gem";
    };
    version = "1.7.0";
  };
  gitlab-net-dns = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jylfc47477imjmzc4jq7zsxklhrws6q4bb0zzl33drirf6s1ldw";
      type = "gem";
    };
    version = "0.9.1";
  };
  gitlab-puma = {
    dependencies = ["nio4r"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a0kihx7ps6hc1a5xbpbssqnh1k0gzfvln7xkjinpqipvk53l094";
      type = "gem";
    };
    version = "4.3.1.gitlab.2";
  };
  gitlab-puma_worker_killer = {
    dependencies = ["get_process_mem" "gitlab-puma"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iagbqh4djbxfd18srvfg9qcxn845ibs3kf0q1sd57k27lxj0har";
      type = "gem";
    };
    version = "0.1.1.gitlab.1";
  };
  gitlab-sidekiq-fetcher = {
    dependencies = ["sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dvx2klf1a1xyf15q34fn59291v6jwx3z315rxb2dmkvcr9873m1";
      type = "gem";
    };
    version = "0.5.2";
  };
  gitlab-styles = {
    dependencies = ["rubocop" "rubocop-gitlab-security" "rubocop-performance" "rubocop-rails" "rubocop-rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qh80nxwxgk76bhwrxw0a0jjcfvyxzmcd773k6axwklp5wvas7x";
      type = "gem";
    };
    version = "3.1.0";
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
      sha256 = "1f8cjbzlhckarmm59l380jjy33a3hlljg69b3zkh8rhy1xd3xr90";
      type = "gem";
    };
    version = "2.1.1";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkxndvck72bfw235bd9nl2ii0lvs5z88q14706cmn702ww2mxv1";
      type = "gem";
    };
    version = "0.4.2";
  };
  gon = {
    dependencies = ["actionpack" "multi_json" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q9nvnw98mbb40h7mlzn1zk40r2l29yybhinmiqhrq8a6adsv806";
      type = "gem";
    };
    version = "6.2.0";
  };
  google-api-client = {
    dependencies = ["addressable" "googleauth" "httpclient" "mime-types" "representable" "retriable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05h2lca9b334ayabgs3h0mzc2wg3csvkqv1lv3iirpgf90ypbk1k";
      type = "gem";
    };
    version = "0.23.4";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0by3289irdklb9gjqw41fq6mg6yja3iyzh99dj8p8z9l4brllqn4";
      type = "gem";
    };
    version = "3.8.0";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hyr94cafiqj0k8q19hnl658pmbz2b404akikzfv4hdb1j1bwsg1";
      type = "gem";
    };
    version = "1.0.4";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1747p1dhpvz76i98xnjrvaj785y1232svm0nc8g9by6pz835gp2l";
      type = "gem";
    };
    version = "0.6.6";
  };
  gpgme = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jbqajngi5ndqfarw9dxkhbphva0j71jav5wfym3fsiisvk5gg6p";
      type = "gem";
    };
    version = "2.0.19";
  };
  grape = {
    dependencies = ["activesupport" "builder" "mustermann-grape" "rack" "rack-accept" "virtus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04bam0iq9sad1df361317zz4knwci905yig502khl8gm1lp1168c";
      type = "gem";
    };
    version = "1.1.0";
  };
  grape-entity = {
    dependencies = ["activesupport" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w78wylkhdkc0s6n6d20hggbb3pl3ladzzd5lx6ack2iswybx7b9";
      type = "gem";
    };
    version = "0.7.1";
  };
  grape-path-helpers = {
    dependencies = ["activesupport" "grape" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "170aw6yvr8l5srlfjz1yqpxr7klr8jypr4i0gj41gn6v4iamyl79";
      type = "gem";
    };
    version = "1.2.0";
  };
  grape_logging = {
    dependencies = ["grape" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x6cmmj0wi1m689r8d4yhyhpl8dwj5skn8b29igm4xvw3swkg94x";
      type = "gem";
    };
    version = "1.8.3";
  };
  graphiql-rails = {
    dependencies = ["railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q5zipwgjgaan9lfqakdkm5ry8afgkq79bkimgksn6jyyvpz6w8";
      type = "gem";
    };
    version = "1.4.10";
  };
  graphql = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17p5c1432fxcqpj7yl70a1667n9774chmam6zswdm021vn8cfwmv";
      type = "gem";
    };
    version = "1.9.12";
  };
  graphql-docs = {
    dependencies = ["commonmarker" "escape_utils" "extended-markdown-filter" "gemoji" "graphql" "html-pipeline" "sass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12wzsikbn54b2hcv100hz7isq5gdjm5w5b8xya64ra5sw6sabq8d";
      type = "gem";
    };
    version = "1.6.0";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18wikj9qd4jb4lks55cs2cf3q7fifnanm9z9ywnxhpj57vbnilpf";
      type = "gem";
    };
    version = "1.24.0";
  };
  gssapi = {
    dependencies = ["ffi"];
    groups = ["kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j93nsf9j57p7x4aafalvjg8hia2mmqv3aky7fmw2ck5yci343ix";
      type = "gem";
    };
    version = "1.2.0";
  };
  guard = {
    dependencies = ["formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "000hn5cdqz3wl99b245q958c5byi2dlsqi814q5gmyljv7i47zwf";
      type = "gem";
    };
    version = "2.15.1";
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
      sha256 = "0dwarfbc04bblljs4xg9fy57b5y8xrck6slhssa6bd7x58bh222c";
      type = "gem";
    };
    version = "5.1.2";
  };
  haml_lint = {
    dependencies = ["haml" "rainbow" "rubocop" "sysexits"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iaaa5as4nlblnbvy6pxj8z9k3jqspbh4f43il519f28lgi0llsn";
      type = "gem";
    };
    version = "0.34.0";
  };
  hamlit = {
    dependencies = ["temple" "thor" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13wkrvyldk21xlc9illam495fpgf7w7bksaj8y6n00y036wmbg60";
      type = "gem";
    };
    version = "2.11.0";
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
      sha256 = "19ykg5pax8798nh1yv71adkx0zzs7gn2rxjj86v7nsw0jba5lask";
      type = "gem";
    };
    version = "0.3.8";
  };
  hashie = {
    groups = ["default" "kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13bdzfp25c8k51ayzxqkbzag3wj5gc1jd8h7d985nsq6pn57g5xh";
      type = "gem";
    };
    version = "3.6.0";
  };
  hashie-forbidden_attributes = {
    dependencies = ["hashie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1chgg5d2iddja6ww02x34g8avg11fzmzcb8yvnqlykii79zx6vis";
      type = "gem";
    };
    version = "0.1.1";
  };
  health_check = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mfa180nyzz1j0abfihm5nm3lmzq99362ibcphky6rh5vwhckvm8";
      type = "gem";
    };
    version = "2.6.0";
  };
  heapy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r9f38fpgjgaxskkwvsliijj6vfmgsff9pnranvvvzkdl67hk1hw";
      type = "gem";
    };
    version = "0.1.4";
  };
  hipchat = {
    dependencies = ["httparty" "mimemagic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hgy5jav479vbzzk53lazhpjj094dcsqw6w1d6zjn52p72bwq60k";
      type = "gem";
    };
    version = "1.5.2";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19hc7njr029pzqljpfhzhdi0p2rgn8ihn3bdnai2apy6nj1g1sg2";
      type = "gem";
    };
    version = "2.12.2";
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
    dependencies = ["addressable" "http-cookie" "http-form_data" "http-parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gsn0jmri7cavw1pv3pbynq6nldsff0r5dr6pa0mxz0rkpjsgjwl";
      type = "gem";
    };
    version = "4.2.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  http-form_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15lpn604byf7cyxnw949xz4rvpcknqp7a48q73nm630gqxsa76f3";
      type = "gem";
    };
    version = "2.1.1";
  };
  http-parser = {
    dependencies = ["ffi-compiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10wz818i7dq5zkcll0yf7pbjz1zqvs7mgh3xg3x6www2f2ccwxqj";
      type = "gem";
    };
    version = "1.2.1";
  };
  httparty = {
    dependencies = ["mime-types" "multi_xml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109xvhl35dsk9zp65n5pdkhiijhqxdyvajbs74nkp4z8yl09vj32";
      type = "gem";
    };
    version = "0.16.4";
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
      sha256 = "0jwrd1l4mxz06iyx6053lr6hz2zy7ah2k3ranfzisvych5q19kwm";
      type = "gem";
    };
    version = "1.8.2";
  };
  i18n_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v0cdwxiaqdwhaljd7z0fbx29q3r5kjl93xnjm5abi1x37645ncj";
      type = "gem";
    };
    version = "0.8.0";
  };
  icalendar = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xsydpp2xph00awi25axv2mwjd5p2rlgd4qb3kh05lvq795kirxd";
      type = "gem";
    };
    version = "2.4.1";
  };
  ice_nine = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  influxdb = {
    dependencies = ["cause" "json"];
    groups = ["metrics"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vhg5nd88nwvfa76lqcczld916nljswwq6clsixrzi3js8ym9y1w";
      type = "gem";
    };
    version = "0.2.3";
  };
  invisible_captcha = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15510dh1vh7l2xs2a4956nhxpnf10168r62i497nmcbyqpp1df88";
      type = "gem";
    };
    version = "0.12.1";
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
  jaeger-client = {
    dependencies = ["opentracing" "thrift"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "198m72c9w3wfwr1mq22dcjjm7d4jd0bci4lrq6zq2zvlzhi04n8l";
      type = "gem";
    };
    version = "0.10.0";
  };
  jaro_winkler = {
    groups = ["default" "development" "test"];
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
      sha256 = "0hb3645x0p3bkmqcgc9b2q4b5kn02wgmb03brx7ag1h5y79an4q5";
      type = "gem";
    };
    version = "1.7.1";
  };
  jmespath = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d4wac0dcd1jf6kc57891glih9w57552zgqswgy74d1xhgnk0ngf";
      type = "gem";
    };
    version = "1.4.0";
  };
  js_regex = {
    dependencies = ["character_set" "regexp_parser" "regexp_property_values"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wi4h4f3knb0yp4zq2spks3dpmdzz9wa54d6xk88md0h4v2x33cq";
      type = "gem";
    };
    version = "3.1.1";
  };
  json = {
    groups = ["default" "development" "metrics" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18rf9v20i0dk5dblr7m22di959xpch2h7gsx0cl585cryr7apwp3";
      type = "gem";
    };
    version = "1.11.0";
  };
  json-schema = {
    dependencies = ["addressable"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11di8qyam6bmqn0fvvvf3crgaqy4sil0d406ymx0jacn3ff98ymz";
      type = "gem";
    };
    version = "2.8.0";
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kaqrbl71cq9sbnixc20x5lqah3hs2i93xmhlfdg2y3by7yzky";
      type = "gem";
    };
    version = "2.1.0";
  };
  kaminari = {
    dependencies = ["activesupport" "kaminari-actionview" "kaminari-activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0invfvfb252ihsdr65rylkvd1x2wy004jval52v3i8ybb0jhc5hi";
      type = "gem";
    };
    version = "1.0.1";
  };
  kaminari-actionview = {
    dependencies = ["actionview" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mhhsm6xhmwqc7hfw7xnk1kdbfg468bqs5awcqm5j6j8b9zyjvdi";
      type = "gem";
    };
    version = "1.0.1";
  };
  kaminari-activerecord = {
    dependencies = ["activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kb5aj6iy1cwcq5548jd3w1ipxicnzmnx2ay1s4hvad2gvrd4g93";
      type = "gem";
    };
    version = "1.0.1";
  };
  kaminari-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r2n293ad1xr9wgn8cr53nfzwls4w3p1xi4kjfjgl1z0yf05mpwr";
      type = "gem";
    };
    version = "1.0.1";
  };
  kgio = {
    groups = ["default" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1528pyj1szzzp3pgj05fzjd36qjrxm9yj2x5radc9p1z7vl67y50";
      type = "gem";
    };
    version = "2.11.2";
  };
  knapsack = {
    dependencies = ["rake"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c69rcwfrdrnx8ddl6k1qxhw9f2dj5x5bbddz435isl2hfr5zh92";
      type = "gem";
    };
    version = "1.17.0";
  };
  kramdown = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dl840bvx8d9nq6lg3mxqyvbiqnr6lk3jfsm6r8zhz7p5srmd688";
      type = "gem";
    };
    version = "2.1.0";
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
    dependencies = ["http" "recursive-open-struct" "rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1djf4zll2alrwv7wg4wk9v504wbri717wqaq773i1azg7cbisbw6";
      type = "gem";
    };
    version = "4.6.0";
  };
  launchy = {
    dependencies = ["addressable"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
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
    dependencies = ["actionmailer" "letter_opener" "railties"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17qhwrkncrrp1bi2f7fbkm5lpnkdsiwy8jcvgr2wa97ck8y4x2bb";
      type = "gem";
    };
    version = "1.3.4";
  };
  license_finder = {
    dependencies = ["rubyzip" "thor" "toml" "with_env" "xml-simple"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01rhqm5m3m22gq6q9f1x9fh3x3wrf9khnnsycblj0xg5frdjv77v";
      type = "gem";
    };
    version = "5.4.0";
  };
  licensee = {
    dependencies = ["rugged"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6d2smhg3kzcx4m2ii06akakypwhiglansk51bpx290hhc8h3pc";
      type = "gem";
    };
    version = "8.9.2";
  };
  liquid = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zhg5ha8zy8zw9qr3fl4wgk4r5940n4128xm2pn4shpbzdbsj5by";
      type = "gem";
    };
    version = "4.0.3";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify" "ruby_dep"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v5mrnfqm6sgm8xn2v5swxsn1wlmq7rzh2i48d4jzjsc7qvb6mx";
      type = "gem";
    };
    version = "3.1.5";
  };
  locale = {
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
  };
  lograge = {
    dependencies = ["actionpack" "activesupport" "railties" "request_store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00lcn7s3slfn32di4qwlx2yj5f9r2pcnd0naxrvqqwypcg1z2sdd";
      type = "gem";
    };
    version = "0.10.0";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7ps9m3s14cajhxrfgbzahv9i3gy47s4hqrv3mpybpj5cyr0srn";
      type = "gem";
    };
    version = "2.4.0";
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
      sha256 = "06im7gcg42x77yhz2w5da2ly9xz0n0c36y5ks7xs53v0l9g0vf5n";
      type = "gem";
    };
    version = "1.0.13";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wwz6ys0502dpk8xprwcqfwyf3hmnx6lgxaiq6vj43mkx43sapc";
      type = "gem";
    };
    version = "2.7.1";
  };
  mail_room = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q06fkv6wka68gbva17jknm57jnjwk57f9ng1lvyvwki2v4jnkz4";
      type = "gem";
    };
    version = "0.10.0";
  };
  marcel = {
    dependencies = ["mimemagic"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nxbjmcyg8vlw6zwagf17l9y2mwkagmmkg95xybpn4bmf3rfnksx";
      type = "gem";
    };
    version = "0.3.3";
  };
  marginalia = {
    dependencies = ["actionpack" "activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1akbiibmg64liw8ya6xzf9lavh2n2707hxsnf9sfslsk36iwx0yn";
      type = "gem";
    };
    version = "1.8.0";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pq8fhqh8w25qcw9v3vzfb0i6jp0k3949ahxc3wrwz2791dpbgbh";
      type = "gem";
    };
    version = "0.16.0";
  };
  memoizable = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v42bvghsvfpzybfazl14qhkrjvx0xlmxz0wwqc960ga1wld5x5c";
      type = "gem";
    };
    version = "0.4.2";
  };
  memory_profiler = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ivhv1bilwqm33jv28gar2vwzsichb5nipaq395d3axabv8qmfy";
      type = "gem";
    };
    version = "0.9.14";
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
      sha256 = "1pviwzvdqd90gn6y7illcdd9adapw8fczml933p5vl739dkvl3lq";
      type = "gem";
    };
    version = "0.9.2";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m00pg19cm47n1qlcxgl91ajh2yq0fszvn1vy8fy0s1jkrp9fw4a";
      type = "gem";
    };
    version = "3.2019.0331";
  };
  mimemagic = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04cp5sfbh1qx82yqxn0q75c7hlcx8y1dr5g3kyzwm4mx6wi2gifw";
      type = "gem";
    };
    version = "0.3.3";
  };
  mini_magick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qy09qrd5bwh8mkbj514n5vcw9ni73218h9s3zmvbpmdwrnzi8j4";
      type = "gem";
    };
    version = "4.9.5";
  };
  mini_mime = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm0rxyx3ss93wbmfkm78a6x03l8y4qy60rhkkiq0aza0vwq3ha";
      type = "gem";
    };
    version = "1.0.2";
  };
  mini_portile2 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
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
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qr2mkm2i3m76zarvy7qgjl9596hmvjrg7x6w42vx8cfsbf5p0y1";
      type = "gem";
    };
    version = "1.3.1";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
  };
  murmurhash3 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1szwcm44z5jg1l4dq73zyjw4rjin23ihkhrw5cpcjrb6cg8hd3y7";
      type = "gem";
    };
    version = "0.1.6";
  };
  mustermann = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lycgkmnyy0bf29nnd2zql5a6pcf8sp69g9v4xw0gcfcxgpwp7i1";
      type = "gem";
    };
    version = "1.0.3";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10xdggddjl8nraq7pbli31lwgrzxzz8gp558i811lsv71fqbmhzr";
      type = "gem";
    };
    version = "1.0.0";
  };
  nakayoshi_fork = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mj5czi7rxxmfq4v9qjz74lcqypvnjxhxqfs71zhb2rsfa97a6jg";
      type = "gem";
    };
    version = "0.0.4";
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
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vzfhivjfr9q65hkln7xig3qcba6fw9y4kb4384fpm7d7ww0b7xg";
      type = "gem";
    };
    version = "0.16.2";
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
  net-ssh = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101wd2px9lady54aqmkibvy4j62zk32w0rjz4vnigyg974fsga40";
      type = "gem";
    };
    version = "5.2.0";
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
      sha256 = "0gnmvbryr521r135yz5bv8354m7xn6miiapfgpg1bnwsvxz8xj6c";
      type = "gem";
    };
    version = "2.5.2";
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
    dependencies = ["mini_portile2"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0qpgf80h764k176yr63gqbs2z0xbsp8vlvs2a79d5r9vs83kln";
      type = "gem";
    };
    version = "1.10.7";
  };
  nokogumbo = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09qc1c7acv9qm48vk2kzvnrq4ij8jrql1cv33nmv2nwmlggy0jyj";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "1zszdg8q1b135z7l7crjj234k4j0m347hywp5kj6zsq7q78pw09y";
      type = "gem";
    };
    version = "0.5.4";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0av6nlb5y2sm6m8fx669ywrqa9858yqaqfqzny75nqp3anag89qh";
      type = "gem";
    };
    version = "1.4.1";
  };
  octokit = {
    dependencies = ["faraday" "sawyer"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yg6dhd028j74sm8hpw9w7bwfwlkml9wiis7nq20ivfsbcz4g8ac";
      type = "gem";
    };
    version = "4.15.0";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default" "kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p16h1rp8by05k8gfw17xjhgwp60dk8qmj1xalv1n23kmxfsxb1x";
      type = "gem";
    };
    version = "1.9.0";
  };
  omniauth-auth0 = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0id5gn14av81kh41cq4q6c9knyvzl7vc4rs3m4pmpd43g2z6jdw2";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth-authentiq = {
    dependencies = ["jwt" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k7vajxwplsp188xfj4mi9iqbc7f7djqh02by4mphc51hl87kcqi";
      type = "gem";
    };
    version = "0.3.3";
  };
  omniauth-azure-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3iqy63l1jd6na4y0bj4a8mlp7gcn3a0awnz9g79fa8n4v2g8n4";
      type = "gem";
    };
    version = "0.0.10";
  };
  omniauth-cas3 = {
    dependencies = ["addressable" "nokogiri" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "191b4jm4djmmy54yxfxj3c889r2wn3g6sfsdj6l1rjy0kw1m2qgx";
      type = "gem";
    };
    version = "1.1.4";
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
      sha256 = "0xbk0dbxqfpyfb33ghz6vrlz3m6442rp18ryf13gwzlnifcawhlb";
      type = "gem";
    };
    version = "1.4.0";
  };
  omniauth-gitlab = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19ydk2zd2mz8zi80z3l03pajpm9357sg3lrankrcb3pirkkdb9fp";
      type = "gem";
    };
    version = "1.0.3";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03v2gqpsbdhkqaxhvzr83za885awm6pgskv3mkyfvang7mr321df";
      type = "gem";
    };
    version = "0.6.0";
  };
  omniauth-kerberos = {
    dependencies = ["omniauth-multipassword" "timfel-krb5-auth"];
    groups = ["kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05xsv76qjxcxzrvabaar2bchv7435y8l2j0wk4zgchh3yv85kiq7";
      type = "gem";
    };
    version = "0.3.0";
  };
  omniauth-multipassword = {
    dependencies = ["omniauth"];
    groups = ["default" "kerberos"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qykp76hw80lkgb39hyzrv68hkbivc8cv0vbvrnycjh9fwfp1lv8";
      type = "gem";
    };
    version = "0.4.2";
  };
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n5vk4by7hkyc09d9blrw2argry5awpw4gbw1l4n2s9b3j4qz037";
      type = "gem";
    };
    version = "1.1.0";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11mi36l9d97r77q99jnafdc1yaa0a9wahhpp7dj7ank8q52g7g79";
      type = "gem";
    };
    version = "1.6.0";
  };
  omniauth-oauth2-generic = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m6vpip3rm1spx1x9y1kjczzailsph1xqgaakqylzq3jqkv18273";
      type = "gem";
    };
    version = "0.2.2";
  };
  omniauth-salesforce = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sr7xmffx6dbsrvnh6spka5ljyzf69iac754xw5r1736py41qhpj";
      type = "gem";
    };
    version = "1.0.5";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17lji8i4q9k3yi8lmjwlw8rfpp2sc74jv8d6flgq85lg5brfqq1p";
      type = "gem";
    };
    version = "1.10.0";
  };
  omniauth-shibboleth = {
    dependencies = ["omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04yin7j8xpr8llvank3ivzahqkc6ss5bppc7q6znzdswxmf75fxh";
      type = "gem";
    };
    version = "1.3.0";
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
  omniauth-ultraauth = {
    dependencies = ["omniauth_openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z8gz8ql4vb8y5n4lr67afnjmp23bpqi18dmda5psigvd2jddyn8";
      type = "gem";
    };
    version = "0.0.2";
  };
  omniauth_crowd = {
    dependencies = ["activesupport" "nokogiri" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12g5ck05h6kr9mnp870x8pkxsadg81ca70hg8n3k8xx007lfw2q7";
      type = "gem";
    };
    version = "2.2.3";
  };
  omniauth_openid_connect = {
    dependencies = ["addressable" "omniauth" "openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0awybp2jnai0w2qfgqnr3f478g3nbg5r0vcm6pa5g8k5f4rs19qr";
      type = "gem";
    };
    version = "0.3.3";
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
      sha256 = "0r50vwf9hsf6r8gx5mwqs3w3w92l864ikiz9d0fcibqsr1489pbg";
      type = "gem";
    };
    version = "1.1.8";
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
      sha256 = "05jxrp3nbn5iilc1k7ir90mfnwc5abc9h78s5rpm3qafwqxvcj4j";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "1s401gvhqgs2r8hh43ia205mxsy1wc0ib4k76wzkdpspfcnfr1rk";
      type = "gem";
    };
    version = "1.0.0";
  };
  parallel = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12jijkap4akzdv11lm08dglsc8jmc87xcgq6947i1s3qb69f4zn2";
      type = "gem";
    };
    version = "1.19.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09davv4ld6caqlczw64vhwf8hr41apys3cj8v2h96yxs4qg1m2iw";
      type = "gem";
    };
    version = "2.6.5.0";
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
      sha256 = "1r01bqqhnk272dsyhg3cqx6j0aiwbcdnrwp7vxzc969mb5dgnnrl";
      type = "gem";
    };
    version = "1.2.2";
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
      sha256 = "1xrhmialxn5vlp1nmf40a4db9gji4h2wbzd7f43sz64z8lvrjj6h";
      type = "gem";
    };
    version = "1.11.1";
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
  procto = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13imvg1x50rz3r0yyfbhxwv72lbf7q28qx9l9nfbb91h2n9ch58c";
      type = "gem";
    };
    version = "0.0.3";
  };
  prometheus-client-mmap = {
    groups = ["metrics"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00d2c79xhz5k3fcclarjr1ffxbrvc6236f4rrvriad9kwqr7c1mp";
      type = "gem";
    };
    version = "0.10.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mh312k3y94sj0pi160wpia0ps8f4kmzvm505i6bvwynfdh7v30g";
      type = "gem";
    };
    version = "0.11.3";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f9kj1qp14qb8crg2rdzf22pr6ngxvy4n6ipymla8q1yjr842625";
      type = "gem";
    };
    version = "3.5.1";
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
  public_suffix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6kq6s13idl2036b5lch8r7390f8w82cal8hcp4ml76fm2vdac7";
      type = "gem";
    };
    version = "4.0.3";
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
      sha256 = "0xzdmbn48753f6k0ckirp8ja5p0xn1a92wbwxfyggyhj0hza9ylq";
      type = "gem";
    };
    version = "1.1.6";
  };
  rack = {
    groups = ["default" "development" "kerberos" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z90vflxbgjy2n84r7mbyax3i2vyvvrxxrf86ljzn5rw65jgnn2i";
      type = "gem";
    };
    version = "2.0.7";
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
      sha256 = "1sqjqwa18c0l59zdymcvvvnh5nk3pjggnzaydb2q1qbrk3rypcnq";
      type = "gem";
    };
    version = "6.2.0";
  };
  rack-cors = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dppmm1ah1gs31sb5byrkkady9vqzwjmpd92c8425nc6yzwknik";
      type = "gem";
    };
    version = "1.0.6";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "httpclient" "json-jwt" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kmxj9hbjhhcs3yyb433s82hkpmzb536m0mwfadjiaisganx1cii";
      type = "gem";
    };
    version = "1.9.3";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15167q25rmxipqwi6hjqj3i1byi9iwl3xq9b7mdar7qiz39pmjsk";
      type = "gem";
    };
    version = "2.0.5";
  };
  rack-proxy = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpbcb9ch94ha2q7gdri88ry7ch0z6ian289kah9ayxyqg19j6f4";
      type = "gem";
    };
    version = "0.6.0";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
  };
  rack-timeout = {
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15xph8h6v0lvq9pxm3bc9i9pnk2k68rgdr1mp0dw4l7v1xvhs78a";
      type = "gem";
    };
    version = "0.5.1";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02sxw1f3n2ydmhacakmgjjwv84vqplgr1888cv5dyflb11a3f8mm";
      type = "gem";
    };
    version = "6.0.2";
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m1rklj6pvzi4fydxcmcv4q0xd7913hhhw1hw530nfz1wkl7vjlf";
      type = "gem";
    };
    version = "1.0.4";
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
      sha256 = "1icpqmxbppl4ynzmn6dx7wdil5hhq6fz707m9ya6d86c7ys8sd4f";
      type = "gem";
    };
    version = "1.3.0";
  };
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05mcgv748vppnm3fnml37wjy3dw61wj8vfw14ldaj1yx1bmkhb07";
      type = "gem";
    };
    version = "6.0.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lpzw7bwvg42x6mwfv7d3bhcnyy8p7rcd8yy8cj5qq5mjznhawca";
      type = "gem";
    };
    version = "6.0.2";
  };
  rainbow = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fpjspydr6x0s8pn1pqkzmxszvkfapv0p4627mywl7ky4zkhk";
      type = "gem";
    };
    version = "3.0.0";
  };
  raindrops = {
    groups = ["metrics" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qpbd9jif40c53fz2r0l8khfl016y8s8bkx37ibcaafclbl3xygp";
      type = "gem";
    };
    version = "0.19.0";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cvaqarr1m84mhc006g3l1vw7sa5qpkcw0138lsxlf769zdllsgp";
      type = "gem";
    };
    version = "12.3.3";
  };
  rb-fsevent = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fbpmjypwxkb8r7y1kmhmyp6gawa4byw0yb3jc3dn9ly4ld9lizf";
      type = "gem";
    };
    version = "0.10.2";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  rblineprof = {
    dependencies = ["debugger-ruby_core_source"];
    groups = ["development"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m58kdjgncwf0h1qry3qk5h4bg8sj0idykqqijqcrr09mxfd9yc6";
      type = "gem";
    };
    version = "0.3.6";
  };
  rbtrace = {
    dependencies = ["ffi" "msgpack" "optimist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lwsq08i0aj8na5q5ba3gg02sx3wl58fi6m52svl5p7cy56ycdwi";
      type = "gem";
    };
    version = "0.4.11";
  };
  rdoc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zh39dpsqlhhi4aba1sbrk504d88p38djk8cansjq0fwndq7w4zb";
      type = "gem";
    };
    version = "6.1.2";
  };
  re2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wf9k1hkv3z3nfkrnfyyfq9ah0l7k14awqys3h2hqz4c21pqd2i";
      type = "gem";
    };
    version = "1.1.1";
  };
  recaptcha = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121pkq8kwqjh4l751xzx15bjp5vmf5pirfmpb11h71zsiavjqv6w";
      type = "gem";
    };
    version = "4.13.1";
  };
  recursive-open-struct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wfcyigmf5mwrxy76p0bi4sdb4h9afs8jc73pjav5cnqszljjl3c";
      type = "gem";
    };
    version = "1.1.0";
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
      sha256 = "08v2y91q1pmv12g9zsvwj66w3s8j9d82yrmxgyv4y4gz380j3wyh";
      type = "gem";
    };
    version = "4.1.3";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hvai5ygkyii9wq8h98wim8shgrm7vkv0js62zpm85vdl1xzvphz";
      type = "gem";
    };
    version = "5.1.0";
  };
  redis-activesupport = {
    dependencies = ["activesupport" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14a3z8810j02ysvg53f3mvcfb4rw34m91yfd19zy9y5lb3yv2g59";
      type = "gem";
    };
    version = "5.2.0";
  };
  redis-namespace = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r7daagrjjribn098dxwbv9zivrbq2rsffbkj2ccxyn9lmjjbgah";
      type = "gem";
    };
    version = "1.6.0";
  };
  redis-rack = {
    dependencies = ["rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pa19ydbk0l6wilwbxcjn6knfs4ffgj0rhaaldrlhf76pjgkaiqb";
      type = "gem";
    };
    version = "2.0.6";
  };
  redis-rails = {
    dependencies = ["redis-actionpack" "redis-activesupport" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hjvkyaw5hgz7v6fgwdk8pb966z44h1gv8jarmb0gwhkqmjnsh40";
      type = "gem";
    };
    version = "5.0.2";
  };
  redis-store = {
    dependencies = ["redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isqzzds9kszc2nn8jiy8ikry01qspn7637ba9z2k6sk7vky46d9";
      type = "gem";
    };
    version = "1.8.1";
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dsgjb3kszk6a82s6gl0h6a8vncjrxmcbk0r4mcxcdcad2b7vb2d";
      type = "gem";
    };
    version = "1.5.1";
  };
  regexp_property_values = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05ka0bkhghs9b9pv6q443k8y1c5xalmm0vylj9zd450ksncxj1yr";
      type = "gem";
    };
    version = "0.3.4";
  };
  representable = {
    dependencies = ["declarative" "declarative-option" "uber"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qm9rgi1j5a6nv726ka4mmixivlxfsg91h8rpp72wwd4vqbkkm07";
      type = "gem";
    };
    version = "3.0.4";
  };
  request_store = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1va9x0b3ww4chcfqlmi8b14db39di1mwa7qrjbh7ma0lhndvs2zv";
      type = "gem";
    };
    version = "1.3.1";
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
    dependencies = ["http-cookie" "mime-types" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hzcs2r7b5bjkf2x2z3n8z6082maz0j8vqjiciwgg3hzb63f958j";
      type = "gem";
    };
    version = "2.0.2";
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
      sha256 = "1w8d6svhq3y9y952r8cqirxvdx12zlkb7zxjb44bcbidb2sisy4d";
      type = "gem";
    };
    version = "2.1.2";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ipgdir89a6pp1zscl2fkb99pppa7c513pk4wvis157bn8p9hlrx";
      type = "gem";
    };
    version = "3.15.0";
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
      sha256 = "0spjgmd3yx6q28q950r32bi0cs8h2si53zn6rq8s7n1i4zp4zwbf";
      type = "gem";
    };
    version = "3.8.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x3iddjjaramqb0yb51c79p2qajgi9wb5b59bzv25czddigyk49r";
      type = "gem";
    };
    version = "3.8.4";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12zplnsv4p6wvvxsk8xn6nm87a5qadxlkk497zlxfczd0jfawrni";
      type = "gem";
    };
    version = "3.8.1";
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
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "164dni69b9imgv33rxzsy3272ni10xny0f4dbx6k90zr1cgzmj5s";
      type = "gem";
    };
    version = "4.0.0.beta3";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nnqcg2yd3nn187zbvh4cgx8xsvdk56lz1985qy7232v7i8yidw6";
      type = "gem";
    };
    version = "0.6.1";
  };
  rspec-set = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06vw8b5w1a58838cw9ssmy3r6f8vrjh54h7dp97rwv831gn5zlyk";
      type = "gem";
    };
    version = "0.1.3";
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "139mbhfdr10flm2ffryvxkyqgqs1gjdclc1xhyh7i7njfqayxk7g";
      type = "gem";
    };
    version = "3.8.2";
  };
  rspec_junit_formatter = {
    dependencies = ["rspec-core"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aynmrgnv26pkprrajvp7advb8nbh0x4pkwk6jwq8qmwzarzk21p";
      type = "gem";
    };
    version = "0.4.1";
  };
  rspec_profiling = {
    dependencies = ["activerecord" "pg" "rails" "sqlite3"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7q7gav26bpiprx4dhlvdh4zdrhwiky9jbmsp14gyfiabqdz4sz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubocop = {
    dependencies = ["jaro_winkler" "parallel" "parser" "rainbow" "ruby-progressbar" "unicode-display_width"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wpyass9qb2wvq8zsc7wdzix5xy2ldiv66wnx8mwwprz2dcvzayk";
      type = "gem";
    };
    version = "0.74.0";
  };
  rubocop-gitlab-security = {
    dependencies = ["rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v0040kpx46fxz3p7dsdjgvsx89qjhwy17n8vxnqg9a7g1rfvxln";
      type = "gem";
    };
    version = "0.1.1";
  };
  rubocop-performance = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ssizdnyai2hxdp6nd4b9hqyrc4gwhjlznhrdliz8wj4p8cvas44";
      type = "gem";
    };
    version = "1.4.1";
  };
  rubocop-rails = {
    dependencies = ["rack" "rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vvrwcxzbqiqdjxakxmjg4c3dcrlpb00i1d3i0s1gdk0ch79byag";
      type = "gem";
    };
    version = "2.4.0";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dypzxzrm8lh1gip9pn93p1nwamzkqsljy6mcv2ngw9zqsial233";
      type = "gem";
    };
    version = "1.37.0";
  };
  ruby-enum = {
    dependencies = ["i18n"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h62avini866kxpjzqxlqnajma3yvj0y25l6hn9h2mv5pp6fcrhx";
      type = "gem";
    };
    version = "0.7.2";
  };
  ruby-fogbugz = {
    dependencies = ["crack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jj0gpkycbrivkh2q3429vj6mbgx6axxisg69slj3c4mgvzfgchm";
      type = "gem";
    };
    version = "0.2.1";
  };
  ruby-prof = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ac3mv3x468s820f6wnp5whzl59y5844wmdjg47a8mbp0kkmnn58";
      type = "gem";
    };
    version = "1.0.0";
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
  ruby-saml = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k9d88fa8bp5szivbwq0qi960y3r2kp6jhnkmsp3n2rvwpn936i3";
      type = "gem";
    };
    version = "1.7.2";
  };
  ruby-statistics = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5mpzb1way683klgggsj029a4kw7krj72i17ggmvlp83804s6a3";
      type = "gem";
    };
    version = "2.1.1";
  };
  ruby_dep = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1bkl97i9mkcvkn1jks346ksnvnnp84cs22gwl0vd7radybrgy5";
      type = "gem";
    };
    version = "1.5.0";
  };
  ruby_parser = {
    dependencies = ["sexp_processor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s3hsccsmrirc2hy3r51kl8g9cfmcn7jxaa0asadg1kn78h1sgr7";
      type = "gem";
    };
    version = "3.13.1";
  };
  rubyntlm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "1gz0ri0pa2xr7b6bf66yjc2wfvk51f4gi6yk7bklwl1nr65zc4gz";
      type = "gem";
    };
    version = "2.0.0";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rdidxgpk1b6y1jq9v77lcx5khq0s9q0s253lr8x57d3hk43iskx";
      type = "gem";
    };
    version = "0.28.4.1";
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
  sanitize = {
    dependencies = ["crass" "nokogiri" "nokogumbo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j4j2a2mkk1a70vbx959pvx0gvr1zb9snjwvsppwj28bp0p0b2bv";
      type = "gem";
    };
    version = "4.6.6";
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
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sr4825rlwsrl7xrsm0sgalcpf5zgp4i56dbi3qxfa9lhs8r6zh4";
      type = "gem";
    };
    version = "2.0.1";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yrdchs3psh583rjapkv33mljdivggqn99wkydkjdckcjn43j3cz";
      type = "gem";
    };
    version = "0.8.2";
  };
  scss_lint = {
    dependencies = ["rake" "sass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01bfkrjn1i0hfg1ifwn1rs7vqwdbdw158krwr5fm6iasd9zgl10g";
      type = "gem";
    };
    version = "0.56.0";
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
    dependencies = ["childprocess" "rubyzip"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11abil34dr8p1kw7hlaqd6kr430v4srmhzf72zzqvhcimlfvm4yb";
      type = "gem";
    };
    version = "3.142.6";
  };
  sentry-raven = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1j9rwbig24ry0smgvmkzdjrzyszniaswipinvflzxzzaz52v7483";
      type = "gem";
    };
    version = "2.9.0";
  };
  settingslogic = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ria5zcrk1nf0b9yia15mdpzw0dqr6wjpbj8dsdbbps81lfsj9ar";
      type = "gem";
    };
    version = "2.0.9";
  };
  sexp_processor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w24rgmyjf7yz0xr2qhbr8z48h4m6gvbggr8nc1pldwn9rbi04b7";
      type = "gem";
    };
    version = "4.12.0";
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
      sha256 = "1s6a2i39lsqq8rrkk2pddqcb10bsihxy3v5gpnc2gk8xakj1brdq";
      type = "gem";
    };
    version = "4.0.1";
  };
  sidekiq = {
    dependencies = ["connection_pool" "rack" "rack-protection" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "131zv8i341bkacxx7n1id2cmblkbs379farnibqg8c7bycd1iajq";
      type = "gem";
    };
    version = "5.2.7";
  };
  sidekiq-cron = {
    dependencies = ["fugit" "sidekiq"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aliswahmpxn1ib2brn4126gk97ac3zdnwr71mn8vzbr3vdd7fl0";
      type = "gem";
    };
    version = "1.0.4";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f5d3bz5bjc4b0r2jmqd15qf07lgsqkgd25f0h46jihrf9l5fsi4";
      type = "gem";
    };
    version = "0.11.0";
  };
  simple_po_parser = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08wkp4gcrd89k5yari9j94if9ffkj3rka4llcwrhdgsi3l15p5f3";
      type = "gem";
    };
    version = "1.1.2";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sfyfgf7zrp2n42v7rswkqgk3bbwk1bnsphm24y7laxv3f8z0947";
      type = "gem";
    };
    version = "0.16.1";
  };
  simplecov-html = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lihraa4rgxk8wbfl77fy9sf0ypk31iivly8vl3w04srd7i0clzn";
      type = "gem";
    };
    version = "0.10.2";
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
  slack-notifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xavibxh00gy62mm79l6id9l2fldjmdqifk8alqfqy5z38ffwah6";
      type = "gem";
    };
    version = "1.5.1";
  };
  snowplow-tracker = {
    dependencies = ["contracts"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05136477ifa567aym9k8nqqmwv3plbczgh9x9fbz86860vym5v4w";
      type = "gem";
    };
    version = "0.6.1";
  };
  spring = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "168yz9c1fv21wc5i8q7n43b9nk33ivg3ws1fn6x0afgryz3ssx75";
      type = "gem";
    };
    version = "2.0.2";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ab42pm8p5zxpv3sfraq45b9lj39cz9mrpdirm30vywzrwwkm5p1";
      type = "gem";
    };
    version = "3.2.1";
  };
  sqlite3 = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  sshkey = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03bkn55qsng484iqwz2lmm6rkimj01vsvhwk661s3lnmpkl65lbp";
      type = "gem";
    };
    version = "2.0.0";
  };
  stackprof = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g2zzasjdr1qnwmpmn28ddv2z9jsnv4w5raiz26y9h1jh03sagqd";
      type = "gem";
    };
    version = "0.2.15";
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
      sha256 = "05c2dw3115zj3pmyyqh2iypc7afj8ibhrghisg0d61z7gzmir1rd";
      type = "gem";
    };
    version = "0.7.1";
  };
  state_machines-activerecord = {
    dependencies = ["activerecord" "state_machines-activemodel"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12g7yqy11fpfiprzc86pwa9jjky1h3haxj37kg47467fgg43p511";
      type = "gem";
    };
    version = "0.6.0";
  };
  swd = {
    dependencies = ["activesupport" "attr_required" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2vjb6f13za7p1iycl2p73d3p202xa6xny9fjrp8ynwsqix7lyd";
      type = "gem";
    };
    version = "1.1.2";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "092wj7936i5inzafi09wqh5c8dbak588q21k652dsrdjf5qi10zq";
      type = "gem";
    };
    version = "1.1.6";
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
  terminal-table = {
    dependencies = ["unicode-display_width"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1512cngw35hsmhvw4c05rscihc59mnj09m249sm9p3pik831ydqk";
      type = "gem";
    };
    version = "1.8.0";
  };
  test-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ag33hv8ky8nxpsra9jkam9npi1jjwb7f7zmvi2najci5mdr10nr";
      type = "gem";
    };
    version = "0.10.0";
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
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nagbf9pwy1vg09k6j4xqhbjjzrg5dwzvkn4ffvlj76fsn6vv61f";
      type = "gem";
    };
    version = "1.7.2";
  };
  thor = {
    groups = ["default" "development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
  };
  thread_safe = {
    groups = ["default" "development" "test"];
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
      sha256 = "02p107kwx7jnkh6fpdgvaji0xdg6xkaarngkqjml6s4zny4m8slv";
      type = "gem";
    };
    version = "0.11.0.0";
  };
  tilt = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
  timecop = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vwbkwqyxhavzvr1820hqwz43ylnfcf6w4x6sag0nghi44sr9kmx";
      type = "gem";
    };
    version = "0.8.1";
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
  toml = {
    dependencies = ["parslet"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xj460rkyqvg74xc8kivmbvgc46c6mm7r8mbjs5m2gq8khf8sbki";
      type = "gem";
    };
    version = "0.2.0";
  };
  toml-rb = {
    dependencies = ["citrus"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pz6z1mc7rnv4chkbx3mdn4q1lpp0j596dq57kbq39jv0wn0wi4d";
      type = "gem";
    };
    version = "1.0.0";
  };
  truncato = {
    dependencies = ["htmlentities" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z36dprfj9l4jwgwb2wv4v3cilm53v7i1ywfmm5f1dl352id3ak4";
      type = "gem";
    };
    version = "0.7.11";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04f18jdv6z3zn3va50rqq35nj3izjpb72fnf21ixm7vanq6nc4fp";
      type = "gem";
    };
    version = "1.2.6";
  };
  u2f = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lsm1hvwcaa9sq13ab1l1zjk0fgcy951ay11v2acx0h6q1iv21vr";
      type = "gem";
    };
    version = "0.2.1";
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
  uglifier = {
    dependencies = ["execjs" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mzs64z3m1b98rh6ssxpqfz9sc87f6ml6906b0m57vydzfgrh1cz";
      type = "gem";
    };
    version = "2.7.2";
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
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08kfiniak1pvg3gn5k6snpigzvhvhyg7slmm0s2qx5zkj62c1z2w";
      type = "gem";
    };
    version = "1.6.0";
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
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    groups = ["unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qfhvzs4i6ja1s43j8p1kfbzm10n7a02ngki30a38y5m46a2qrak";
      type = "gem";
    };
    version = "5.4.1";
  };
  unicorn-worker-killer = {
    dependencies = ["get_process_mem" "unicorn"];
    groups = ["unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rrdxpwdsapx47axjin8ymxb4f685qlpx8a26bql4ay1559c3gva";
      type = "gem";
    };
    version = "0.4.4";
  };
  uniform_notifier = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vm4aix8jmv42s1x58m3lj3xwkbxyn9qn6lzhhig0d1j8fv6j30c";
      type = "gem";
    };
    version = "1.13.0";
  };
  unleash = {
    dependencies = ["murmurhash3"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xs2ml9cwskddsxick3a9wnasy7q6wmc0dbydfcaspfl2cjmp1rk";
      type = "gem";
    };
    version = "0.1.5";
  };
  unparser = {
    dependencies = ["abstract_type" "adamantium" "concord" "diff-lcs" "equalizer" "parser" "procto"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03vjj74kj86vlazhiclf63kf6gajs66k8ni34q70fdhf97d7b60c";
      type = "gem";
    };
    version = "0.4.5";
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
      sha256 = "1k0bfxzvdcf1nrqhvnyhijc4mwab9wn4qvqb0ynq6p8dj0f866zi";
      type = "gem";
    };
    version = "1.0.8";
  };
  validates_hostname = {
    dependencies = ["activerecord" "activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04p1l0v98j4ffvaks1ig9mygx5grpbpdgz7haq3mygva9iy8ykja";
      type = "gem";
    };
    version = "1.0.6";
  };
  version_sorter = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hbdw3vh856f5yg5mbj4498l6vh90cd3pn22ikr3ranzkrh73l3s";
      type = "gem";
    };
    version = "2.2.4";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker" "equalizer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06iphwi3c4f7y9i2rvhvaizfswqbaflilziz4dxqngrdysgkn1fk";
      type = "gem";
    };
    version = "1.0.5";
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
      sha256 = "1fr9n9i9r82xb6i61fdw4xgc7zjv7fsdrr4k0njchy87iw9fl454";
      type = "gem";
    };
    version = "1.2.8";
  };
  webfinger = {
    dependencies = ["activesupport" "httpclient"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m0jh8k7c0ifh2jhbn7ihqrmn5fi754wflva97zgy70hpdvxyjar";
      type = "gem";
    };
    version = "1.1.0";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gg0c2sxq7rni0b93w47h7p7cn590xdhf5va7ska48inpipwlgxp";
      type = "gem";
    };
    version = "3.5.1";
  };
  webpack-rails = {
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fsjxw730bh4k1dfnbjm645fgjyqrh830l1z7brqbsm6306ig1rr";
      type = "gem";
    };
    version = "0.9.11";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bxamwqldmy98hxs5pqby3andws14hl36ch78g0s81gaz9b91nj2";
      type = "gem";
    };
    version = "0.7.1";
  };
  websocket-extensions = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00i624ng1nvkz1yckj3f8yxxp6hi7xaqf40qh9q3hj2n1l9i8g6m";
      type = "gem";
    };
    version = "0.1.4";
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
  xml-simple = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
      type = "gem";
    };
    version = "1.1.5";
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
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jywi63w1m2b2w9fj9rjb9n3imf6p5bfijfmml1xzdnsrdrjz0x1";
      type = "gem";
    };
    version = "2.2.2";
  };
}