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
  acme-client = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nwkzjamvg946xh2pv82hkwxb7vqq6gakig014gflss0cwx7bbxp";
      type = "gem";
    };
    version = "2.0.6";
  };
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y3aa0965cdsqamxk8ac6brcvijl1zv4pvqils6xy3pbcrv0ljid";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vb9s4frq22h5j6gyw2598k1jc29lg2czm95hf284l3mi4qly6a";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ykn5qkwdlcv5aa1gjhhmrxpjccwa7df6n4amvkmvxv5lggyma52";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fbjpnh5hrihc9l35q9why6ip0hcdj42axzbp6b4j1xcy1v1bicj";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "nokogiri"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0j0m76ynjspmvj5qbzl06kl9i920v269iz62y62009xydv6rqz";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gdz31cq08nrqq6bxqim2qcbzv0fr34z6ycl73dmawpafj33wdkj";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d0p8gjplrgym38dmchyzhv7lrrxngz0yrxl6xyvwxfxm1hgdk2k";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00jj8namy5niq7grl5lrsr4y351rxpj1b69k1i9gvb1hnpghl099";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06qvvp73z8kq9sd2mhw6p9124q5pfkswjga2fidz4c73zbr79r3g";
      type = "gem";
    };
    version = "6.0.3.4";
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
      sha256 = "0q734331wb7cfsh4jahj3lphpxvglzb17yvibwss1ml4g01xxm52";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axidc4mikgi4yxs0ynw2c54jyrs5lxprxmzv6m3aayi9rg6rk5j";
      type = "gem";
    };
    version = "6.0.3.4";
  };
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m7lvm6id8mm8y9qycjr54l9gyqfb43x6yjz23cggisjg0px1fv";
      type = "gem";
    };
    version = "7.0.0";
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
    dependencies = ["graphql" "rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk54h9mmzhrbgbmk33v38pavb8w6421mx2yrgsdarkfl9fr90y3";
      type = "gem";
    };
    version = "2.0.2";
  };
  asana = {
    dependencies = ["faraday" "faraday_middleware" "faraday_middleware-multi_json" "oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14cs2k802hlvlmn0nwnx4k3g44944x0a8dsj3k14mjnbvcw1fkxh";
      type = "gem";
    };
    version = "0.10.3";
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
  asciidoctor-kroki = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10yc07x2z9f122wnncf34s91vlfcd4wy8y9wshxc7j2m4a2jlzm5";
      type = "gem";
    };
    version = "0.2.2";
  };
  asciidoctor-plantuml = {
    dependencies = ["asciidoctor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02knhmyd3h1yryn66xjfciz7jjsq676kl7ama0r0cf92vyyvm12x";
      type = "gem";
    };
    version = "0.0.12";
  };
  ast = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l3468czzjmxl93ap40hp7z94yxp4nbag0bxqs789bm30md90m2a";
      type = "gem";
    };
    version = "2.4.1";
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
  awrence = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zwdli370jfsj6jypv7vrqf4vv4ac4784faw7ar5v88fk4q9rcv";
      type = "gem";
    };
    version = "1.1.1";
  };
  aws-eventstream = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0pn66yqrdkrfdin7qdim0yj2x75miyg4wp6mijckhzhrjb7cv5";
      type = "gem";
    };
    version = "1.1.0";
  };
  aws-partitions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12q3swh4f44iqlq2md9lphg8csi0hd35jhgmkkkji9n0mgay4ggh";
      type = "gem";
    };
    version = "1.345.0";
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
      sha256 = "1xfv8nfz8n700z29di51mcyyrnmbpq7flff4hx9mm92avnly1ysy";
      type = "gem";
    };
    version = "3.104.3";
  };
  aws-sdk-kms = {
    dependencies = ["aws-sdk-core" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rpwpj4f4q9wdrbgiqngzwfdaaqyz0iif8sv16z6z0mm6y3cb06q";
      type = "gem";
    };
    version = "1.36.0";
  };
  aws-sdk-s3 = {
    dependencies = ["aws-sdk-core" "aws-sdk-kms" "aws-sigv4"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "068xx6wp86wkmikdzg4wqxmg570hc3ydp8211j02g13djjr3k28n";
      type = "gem";
    };
    version = "1.75.0";
  };
  aws-sigv4 = {
    dependencies = ["aws-eventstream"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aknh3q37rq3ixxa84x2p26g8a15zmiig2rm1pmailsb9vqhfh3j";
      type = "gem";
    };
    version = "1.2.1";
  };
  azure-storage-blob = {
    dependencies = ["azure-storage-common" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01psx005lkrfk3zm816z76fa2pv4hd8jk7hxrjyy4hbvgcqi6rfy";
      type = "gem";
    };
    version = "2.0.1";
  };
  azure-storage-common = {
    dependencies = ["faraday" "faraday_middleware" "net-http-persistent" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h5bwswc5768hblcxsschjz3y0lf9kvz3k7qqwypdhy8sr1lfxg8";
      type = "gem";
    };
    version = "2.0.2";
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
      sha256 = "0kn7rv81i2r462k56v29i3s8abcmfcpfj9axia736mwjvv0app2k";
      type = "gem";
    };
    version = "2.7.1";
  };
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bmlqjb5h1ry6wm2d903d6yxibpqzzxwqczvlicsqv0vilaca5ic";
      type = "gem";
    };
    version = "2.4.8";
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
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bz62p9vc7lcrmzhiz4pf7myww086mq287cw3jjj7fyc7jhmamw0";
      type = "gem";
    };
    version = "1.4.6";
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
      sha256 = "0q1yzvbqp0mykswipq3w00ljw9fgkhjfrij3hkwi7cx85r14n6gw";
      type = "gem";
    };
    version = "4.2.0";
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
      sha256 = "18ifwnvn13755qkfigapyj5bflpby3phxzbb7x5336d0kzv5k7d9";
      type = "gem";
    };
    version = "6.1.0";
  };
  bundler-audit = {
    dependencies = ["thor"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pm22xpn3xyymsainixnrk8v3l3xi9bzwkjkspx00cfzp84xvxbq";
      type = "gem";
    };
    version = "0.6.1";
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
    dependencies = ["addressable" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i1bm7r8n67cafd9p3ck7vdmng921b41n9znvlfaz7cy8a3gsrgm";
      type = "gem";
    };
    version = "3.34.0";
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
  character_set = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0affq9n77vwy897ri2zhmfinfagf37hcwwimrccy1bcxan9mj3h3";
      type = "gem";
    };
    version = "1.4.0";
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
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
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
      sha256 = "0vwpkmwfr8lx8b6cfvwh56f1ygyf2da5ah37mxbdr9mxmfwig5fr";
      type = "gem";
    };
    version = "0.21.0";
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
      sha256 = "1vnxrbhi7cq3p4y2v9iwd10v1c7l15is4var14hwnb2jip4fyjzz";
      type = "gem";
    };
    version = "1.1.7";
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
  cose = {
    dependencies = ["cbor" "openssl-signature_algorithm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h1vcirk1vpr992xmnwf5z77fpizjwn4xzq2vrrjhvdmjynvl3jj";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "0lrifb0kbjk9033pzjnp8qqqkg2z212h8dgj71k15c6wb6rycqa7";
      type = "gem";
    };
    version = "8.0.6";
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
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
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
    dependencies = ["benchmark-ips" "get_process_mem" "heapy" "memory_profiler" "mini_histogram" "rack" "rake" "ruby-statistics" "thor"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05nryqr18w61dyk9amajh7chn07zxardxnywayyis72kmd8f9q29";
      type = "gem";
    };
    version = "1.8.1";
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
      sha256 = "0syqkh0q9mcdgj68m2cf1innpxb8fv6xsayk1kgsdmq539rkv3ic";
      type = "gem";
    };
    version = "4.7.3";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzk7phrryxlq4k3jrcxm8faifmbqrbfxq7jx089ncsixwd69bn4";
      type = "gem";
    };
    version = "3.1.0";
  };
  diff-lcs = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m925b8xc6kbpnif9dldna24q1szg4mk0fvszrki837pfn46afmz";
      type = "gem";
    };
    version = "1.4.4";
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
      sha256 = "0qhx743lcx61r2d3925jk61c6r8clfjmpf5g93cdy5sq00ig76lh";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "0qrwiyagxzl8zlx3dafb0ay8l14ib7imb2rsmx70i5cp420v8gif";
      type = "gem";
    };
    version = "1.3.2";
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
      sha256 = "01scvhvrw44ksv1aaywpp9kfm4c8qs4gwnnha40r5mq0vpc0qrny";
      type = "gem";
    };
    version = "5.3.3";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "json-jwt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yylcg4j7msxma0s8rx8990bfgr0c414a7vafs3gpgmbwy47wq45";
      type = "gem";
    };
    version = "1.7.4";
  };
  dry-configurable = {
    dependencies = ["concurrent-ruby" "dry-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rvwvxrvcygvgfc3xjrihvdvnr0dh2144s8x80zfgfnz0jd5gac7";
      type = "gem";
    };
    version = "0.12.0";
  };
  dry-container = {
    dependencies = ["concurrent-ruby" "dry-configurable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1npnhs3x2xcwwijpys5c8rpcvymrlab0y8806nr4h425ld5q4wd0";
      type = "gem";
    };
    version = "0.7.2";
  };
  dry-core = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14s45hxcqpp2mbvwlwzn018i8qhcjzgkirigdrv31jd741rpgy9s";
      type = "gem";
    };
    version = "0.5.0";
  };
  dry-equalizer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rsqpk0gjja6j6pjm0whx2px06cxr3h197vrwxp6k042p52r4v46";
      type = "gem";
    };
    version = "0.3.0";
  };
  dry-inflector = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17mkdwglqsd9fg272y3zms7rixjgkb1km1xcb88ir5lxvk1jkky7";
      type = "gem";
    };
    version = "0.2.0";
  };
  dry-logic = {
    dependencies = ["concurrent-ruby" "dry-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17dnc3g9y2nj42rdx2bdvsvvms10vgw4qzjb2iw2gln9hj8b797c";
      type = "gem";
    };
    version = "1.1.0";
  };
  dry-types = {
    dependencies = ["concurrent-ruby" "dry-container" "dry-core" "dry-equalizer" "dry-inflector" "dry-logic"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1px1r5khlf4lw32gsrnnnsx7dvl2d94axx3h0b6zwxrhvfq3n038";
      type = "gem";
    };
    version = "1.4.0";
  };
  ecma-re-validator = {
    dependencies = ["regexp_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hjnd6phkhwmd846hqkzbiiyf7n6v9s85agizkxrkha1z0g3q5fc";
      type = "gem";
    };
    version = "0.2.1";
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
      sha256 = "152z76sp2ymyaqrbm8c6y0p1ydkckwrr6iif66mdsc5s0433va3f";
      type = "gem";
    };
    version = "6.8.2";
  };
  elasticsearch-api = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12rjfamnqspvkjs90bvpa5zs7g0nlr9pvlvj228mj71k5pym1x8p";
      type = "gem";
    };
    version = "6.8.2";
  };
  elasticsearch-model = {
    dependencies = ["activesupport" "elasticsearch" "hashie"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q66mp28696qnr6xgsl1dym2l5wk4j2ifd673r09yi70hn9y5ji8";
      type = "gem";
    };
    version = "6.1.1";
  };
  elasticsearch-rails = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06k97w4xdkdj982b2mgz4bv0gvkpbscn4wxsrqj6kr1x7dxia394";
      type = "gem";
    };
    version = "6.1.1";
  };
  elasticsearch-transport = {
    dependencies = ["faraday" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z7b26vl0wmvkzy10qp530vx5c7pdv2ynfsd7mc5qmz6m0z5pxp";
      type = "gem";
    };
    version = "6.8.2";
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
      sha256 = "1yz55sf2nd3l666ms6xr18sm2aggcvmb8qr3v53lr4rir32y1yp1";
      type = "gem";
    };
    version = "2.7.0";
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
      sha256 = "11ij9s4hasy963qjqbrrf0m8lm9m9pxkh2vf4wrnafa6gw6r9qk8";
      type = "gem";
    };
    version = "6.1.0";
  };
  factory_bot_rails = {
    dependencies = ["factory_bot" "railties"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hfxkq6rarg0b8xfzqg200xyj176sn1xplqqqcrz5drhkqp30m14";
      type = "gem";
    };
    version = "6.1.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wwks9652xwgjm7yszcq5xr960pjypc07ivwzbjzpvy9zh2fw6iq";
      type = "gem";
    };
    version = "1.0.1";
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
  faraday-http-cache = {
    dependencies = ["faraday"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lhfwlk4mhmw9pdlgdsl2bq4x45w7s51jkxjryf18wym8iiw36g7";
      type = "gem";
    };
    version = "2.2.0";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jik2kgfinwnfi6fpp512vlvs0mlggign3gkbpkg5fw1jr9his0r";
      type = "gem";
    };
    version = "1.0.0";
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
    groups = ["default" "development" "kerberos" "puma" "test" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12lpwaw82bb0rm9f52v1498bpba8aj2l2q359mkwbxsswhpga5af";
      type = "gem";
    };
    version = "1.13.1";
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
      sha256 = "1q7n8r03akjbdz3r2bgsl6wcjvdlf0k508z8bsd9zgs43qg14vc9";
      type = "gem";
    };
    version = "3.8.0";
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
    dependencies = ["fog-core" "fog-json" "fog-xml" "google-api-client" "google-cloud-env"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cl6rprichdn1i40c2ndri1c53cfb0x2xk58l9arwip9ivkasln4";
      type = "gem";
    };
    version = "1.12.0";
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
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y8n1m2kys3q79b9kp8bs4803isshpf0f401a2hfy4iyh5jwzx11";
      type = "gem";
    };
    version = "1.7.0";
  };
  gitaly = {
    dependencies = ["grpc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kns9lw8gdxm61vyvf3jin448zrl2h3qdx2ggilzxig28hdi0vha";
      type = "gem";
    };
    version = "13.8.0.pre.rc2";
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
  gitlab-experiment = {
    dependencies = ["activesupport" "scientist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v8ygrc2c98rz72za59g313n1mmr18jdbzr965lkp2zv2rw7cs9n";
      type = "gem";
    };
    version = "0.4.5";
  };
  gitlab-fog-azure-rm = {
    dependencies = ["azure-storage-blob" "azure-storage-common" "fog-core" "fog-json" "mime-types" "ms_rest_azure"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04l7ps0vvrqq8i25q7ic2zy2n8f8f1l7sn1shf5wccy1cbyj9pig";
      type = "gem";
    };
    version = "1.0.0";
  };
  gitlab-labkit = {
    dependencies = ["actionpack" "activesupport" "gitlab-pg_query" "grpc" "jaeger-client" "opentracing" "redis"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l4sbvlk6qc0x8372rp1gc2ihmx3vp0afrm5cy55xhflq16y7sl1";
      type = "gem";
    };
    version = "0.14.0";
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
  gitlab-mail_room = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05j8rpsbl2l5q4xnfh2cnws9axy1a19asg8nlw6jngba94raw5ir";
      type = "gem";
    };
    version = "0.0.8";
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
  gitlab-pg_query = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rybirjyclavp641qdx27483xx0zpmc577wdzfgdnjd7753bya7g";
      type = "gem";
    };
    version = "1.3.1";
  };
  gitlab-pry-byebug = {
    dependencies = ["byebug" "pry"];
    groups = ["development" "test"];
    platforms = [{
      engine = "maglev";
    } {
      engine = "ruby";
    }];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sp33vzzw8b7q9d8kb4pw8cl5fzlbffdpwz125x1g3kdiwz8xp3j";
      type = "gem";
    };
    version = "3.9.0";
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
      sha256 = "17d238cy031gnjmrk6wl3qyk5kqhqjxrb68813n4y9ia817xmwyp";
      type = "gem";
    };
    version = "6.0.0";
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
    dependencies = ["addressable" "googleauth" "httpclient" "mini_mime" "representable" "retriable" "rexml" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05ynbapd26wppcqa81kw6kb8a39mzp0fql1rwmk3lgr95ybmxr1s";
      type = "gem";
    };
    version = "0.50.0";
  };
  google-cloud-env = {
    dependencies = ["faraday"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bjgxyvagy6hjj8yg7fqq24rwdjxb6hx7fdd1bmn4mwd846lci2i";
      type = "gem";
    };
    version = "1.4.0";
  };
  google-protobuf = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m3la0yid3bqx9b30raisqbp27d0q7vdrlslazrdasf8v1vhifxj";
      type = "gem";
    };
    version = "3.12.4";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aava1b75n056s24gn7ajrkmm6s3xa3swl62dl5q9apw4marghji";
      type = "gem";
    };
    version = "1.0.5";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cm60nbmwzf83fzy06f3iyn5a6sw91siw8x9bdvpwwmjsmivana6";
      type = "gem";
    };
    version = "0.14.0";
  };
  gpgme = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xbgh9d8nbvsvyzqnd0mzhz0nr9hx4qn025kmz6d837lry4lc6gw";
      type = "gem";
    };
    version = "2.0.20";
  };
  grape = {
    dependencies = ["activesupport" "builder" "dry-types" "mustermann-grape" "rack" "rack-accept"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lizcma35sygkd3q7zjv13mrr905ncn80f1ym6n305s75kc0pk9n";
      type = "gem";
    };
    version = "1.5.1";
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
    dependencies = ["activesupport" "grape" "rake" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xdp7b5fnvm89szy8ghpl6wm125iq7f0qnhibj5bxqrvg3xyhc2m";
      type = "gem";
    };
    version = "1.6.1";
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
  graphlient = {
    dependencies = ["faraday" "faraday_middleware" "graphql-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04c32rcn3j4d8sh039lkdfzn8xpifsbpsp7f90vlp2s531wbs16a";
      type = "gem";
    };
    version = "0.4.0";
  };
  graphql = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ldxhn59lfg5ivxc9m11v1qhw29ql95qcvwwcap49n0z7d1i3k5";
      type = "gem";
    };
    version = "1.11.4";
  };
  graphql-client = {
    dependencies = ["activesupport" "graphql"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g971rccyrs3rk8812r6az54p28g66m4ngdcbszg31mvddjaqkr4";
      type = "gem";
    };
    version = "0.16.0";
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
      sha256 = "1rsglf7ag17n465iff7vlw83pn2rpl4kv9sb1rpf17nx6xpi7yl5";
      type = "gem";
    };
    version = "1.30.2";
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
      sha256 = "0dwarfbc04bblljs4xg9fy57b5y8xrck6slhssa6bd7x58bh222c";
      type = "gem";
    };
    version = "5.1.2";
  };
  haml_lint = {
    dependencies = ["haml" "parallel" "rainbow" "rubocop" "sysexits"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0imdiwxqyca1i158yrqkdv6fa8sdfk8wwx2kaq6ad9i7k7jj365a";
      type = "gem";
    };
    version = "0.36.0";
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
  hana = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ij5clmkfl5ij9wdzr62b0w7j2qg7pb65mhvxa6mf1kv1xp6l585";
      type = "gem";
    };
    version = "1.3.6";
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
    dependencies = ["railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07wrbfsfsprfmykc0qbkkgxpf8vlx4a8sp77acqrjsh395f6qcqv";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "00xqmlny1b4ixff8sk0rkl4wcgwqc6v93qv8l3rn8d1dppvq7pm1";
      type = "gem";
    };
    version = "2.13.2";
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
      sha256 = "0z8vmvnkrllkpzsxi94284di9r63g9v561a16an35izwak8g245y";
      type = "gem";
    };
    version = "4.4.1";
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
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "1kr0bx9323fv5ys6nlhsy05kmwcbs94h6ac7ka9qqywy0vbdvrrv";
      type = "gem";
    };
    version = "1.8.7";
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
  invisible_captcha = {
    dependencies = ["rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lmlx3g4z894vwsgbpxhpmkn63n74mynklbwy07l7ccak552jw1n";
      type = "gem";
    };
    version = "1.1.0";
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
      sha256 = "1a2qlkc1hkr5hkj2574l1a63sm04bdx98gfhh9m8vvp6psdrnpnb";
      type = "gem";
    };
    version = "1.1.0";
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
      sha256 = "1zia0pxa2lrybwv51xzhj26rf3gx8zwg1cghbdk640rbsyr8sf9a";
      type = "gem";
    };
    version = "3.4.0";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nrmw2r4nfxlfgprfgki3hjifgrcrs3l5zvm3ca3gb4743yr25mn";
      type = "gem";
    };
    version = "2.3.0";
  };
  json-jwt = {
    dependencies = ["activesupport" "aes_key_wrap" "bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nzbk1mrbf9mnvjpn3bxy8a85rjf94qmfdnvk78mjzk8pa0fvgdr";
      type = "gem";
    };
    version = "1.13.0";
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
  json_schemer = {
    dependencies = ["ecma-re-validator" "hana" "regexp_parser" "uri_template"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "194898b70ylkjqg7vhy4lps4a5g31n7xxb3vfacwfs40azkn83zm";
      type = "gem";
    };
    version = "0.2.12";
  };
  jsonpath = {
    dependencies = ["multi_json" "to_regexp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bwgk17dwraaf6grv6v99xjjy3ds1sqsf1v49fnlyfjkniy6ap8q";
      type = "gem";
    };
    version = "1.0.5";
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
      sha256 = "1vxkqciny5v4jgmjxl8qrgbmig2cij2iskqbwh4bfcmpxf467ch3";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-actionview = {
    dependencies = ["actionview" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w0p1hyv6lgf6h036cmn2kbkdv4x7g0g9q9kc5gzkpz7amlxr8ri";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-activerecord = {
    dependencies = ["activerecord" "kaminari-core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02n5xxv6ilh39q2m6vcz7qrdai7ghk3s178dw6f0b3lavwyq49w3";
      type = "gem";
    };
    version = "1.2.1";
  };
  kaminari-core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h04cr4y1jfn81gxy439vmczifghc2cvsyw47aa32is5bbxg1wlz";
      type = "gem";
    };
    version = "1.2.1";
  };
  kgio = {
    groups = ["default" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ai6bzlvxbzpdl466p1qi4dlhx8ri2wcrp6x1l19y3yfs3a29rng";
      type = "gem";
    };
    version = "2.11.3";
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
    dependencies = ["rexml"];
    groups = ["default" "development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vmw752c26ny2jwl0npn0gbyqwgz4hdmlpxnsld9qi9xhk5b1qh7";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "07ygwvdrdhqmvqj3g7hsrgwimr1xcphk9d6qjdxr0iynqaahn0l7";
      type = "gem";
    };
    version = "4.9.1";
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
    groups = ["development" "omnibus" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kc4bkaxy6mm6kpbpg8hdjsqpzybh7cy5b45qydc7bfa9c35vr93";
      type = "gem";
    };
    version = "6.0.0";
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
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w923wmdi3gyiky0asqdw5dnh3gcjs2xyn82ajvjfjwh6sn0clgi";
      type = "gem";
    };
    version = "3.2.1";
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
      sha256 = "0sgbs0frk601yc7bb33pz5z9cyadvj077vwy9k5zapsbn2rxf5aj";
      type = "gem";
    };
    version = "0.3.3";
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
      sha256 = "0ndimir6k3kfrh8qrb7ir1j836l4r3qlwyclwjh88b86clblhszh";
      type = "gem";
    };
    version = "2.8.0";
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
      sha256 = "1003hf828anbd3pxwzs9ir9sclh64mgj971n4a7ilgj9xs8r0a38";
      type = "gem";
    };
    version = "1.10.0";
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
      sha256 = "1pnyh44qycnf9mzi1j6fywd5fkskv3x7nmsqrrws0rjn5dd4ayfp";
      type = "gem";
    };
    version = "1.0.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj12l9qk62anvk9bjvandpa6vy4xslil15wl6wlivyf51z773vh";
      type = "gem";
    };
    version = "3.3.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z75svngyhsglx0y2f9rnil2j08f9ab54b3l95bpgz67zq2if753";
      type = "gem";
    };
    version = "3.2020.0512";
  };
  mimemagic = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qfqb9w76kmpb48frbzbyvjc0dfxh5qiw1kxdbv2y2kp6fxpa1kf";
      type = "gem";
    };
    version = "0.3.5";
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
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
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
      sha256 = "1lva6bkvb4mfa0m3bqn4lm4s4gi81c40jvdcsrxr6vng49q9daih";
      type = "gem";
    };
    version = "1.3.3";
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
    dependencies = ["ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ccm54qgshr1lq3pr1dfh7gphkilc19dp63rw6fcx7460pjwy88a";
      type = "gem";
    };
    version = "1.1.1";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0djlbi7nh161a5mwjdm1ya4hc6lyzc493ah48gn37gk6vyri5kh0";
      type = "gem";
    };
    version = "1.0.1";
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
  net-http-persistent = {
    dependencies = ["connection_pool"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sbdvkn7mzl883iykz74hgp14qj041gldf2vdk9g3gyqc843l2vr";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13lh6qizxi8fza8py73b2dvjp9p010dvbaq7diagir9nh8plsinv";
      type = "gem";
    };
    version = "0.16.3";
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
      sha256 = "1cbwp1kbv6b2qfxv8sarv0d0ilb257jihlvdqj8f5pdm0ksq1sgk";
      type = "gem";
    };
    version = "2.5.4";
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
      sha256 = "1ajwkqr28hwqbyl1l3czx4a34c88acxywyqp8cjyy0zgsd6sbhj2";
      type = "gem";
    };
    version = "1.11.1";
  };
  nokogumbo = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sxjnpjvrn10gdmfw2dimhch861lz00f28hvkkz0b1gc2rb65k9s";
      type = "gem";
    };
    version = "2.0.2";
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
      sha256 = "1bhakjh30vi8scqwnhd1c9qkac9r8hh2lr0dbs5ynwmrc5djxknm";
      type = "gem";
    };
    version = "1.4.4";
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
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zik71a9dj2c0cnbqxjfzgrg6r2l3f7584813z6asl50nfdbf7jw";
      type = "gem";
    };
    version = "3.10.6";
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
  omniauth_crowd = {
    dependencies = ["activesupport" "nokogiri" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wiq1vnwjddzw2qzkpr3nqzx6glmcz5pfylw10pc7vkzdcmkpy37";
      type = "gem";
    };
    version = "2.4.0";
  };
  omniauth_openid_connect = {
    dependencies = ["addressable" "omniauth" "openid_connect"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wxf52yggvwmyg6f9fiykh1sk51xx34i6x6m8f06ia56npslc4aw";
      type = "gem";
    };
    version = "0.3.5";
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
  openssl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03wbynzkhay7l1x76srjkg91q48mxl575vrxb3blfxlpqwsvvp0w";
      type = "gem";
    };
    version = "2.2.0";
  };
  openssl-signature_algorithm = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14d95jr5z6dgvpwf52p7ckjf3w3cihin2k6g9599711pfxdj4fp5";
      type = "gem";
    };
    version = "0.4.0";
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
      sha256 = "12fli64wz5j9868gpzv5wqsingk1jk457qyqksv9ksmq9b0zpc9x";
      type = "gem";
    };
    version = "1.1.1";
  };
  parallel = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0055br0mibnqz0j8wvy20zry548dhkakws681bhj3ycb972awkzd";
      type = "gem";
    };
    version = "1.20.1";
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jixakyzmy0j5c1rb0fjrrdhgnyryvrr6vgcybs14jfw09akv5ml";
      type = "gem";
    };
    version = "3.0.0.0";
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
      sha256 = "13mfrysrdrh8cka1d96zm0lnfs59i5x2g6ps49r2kz5p3q81xrzj";
      type = "gem";
    };
    version = "1.2.3";
  };
  pg_query = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i9l3y502ddm2lq3ajhxhqq17vs9hgxkxm443yw221ccibcfh6qf";
      type = "gem";
    };
    version = "1.3.0";
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
      sha256 = "1i0h9ixdvxw1n9ynxsrbc1lkx3dvd6r78iiwgwnqfz3fap6jgd9p";
      type = "gem";
    };
    version = "0.12.0";
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
      sha256 = "0iyw4q4an2wmk8v5rn2ghfy2jaz9vmw2nk8415nnpx2s866934qk";
      type = "gem";
    };
    version = "0.13.1";
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
  pry-remote = {
    dependencies = ["pry" "slop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10g1wrkcy5v5qyg9fpw1cag6g5rlcl1i66kn00r7kwqkzrdhd7nm";
      type = "gem";
    };
    version = "0.1.8";
  };
  public_suffix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13640p5fk19705ygp8j6p07lccag3d80bx8bmjgpd5zsxxsdc50b";
      type = "gem";
    };
    version = "5.1.1";
  };
  puma_worker_killer = {
    dependencies = ["get_process_mem" "puma"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jk1bhmx5px8y1ip4ky80cq5cwdaybdg4y55shd2vsdmjv938mcw";
      type = "gem";
    };
    version = "0.3.1";
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
  racc = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rack = {
    groups = ["default" "development" "kerberos" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
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
      sha256 = "15b8lk54j2abqhpn588b1wvbzwmxwa7iql6241kxpjc0gyb51p0z";
      type = "gem";
    };
    version = "6.3.0";
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
      sha256 = "1b0h0rlfl0p0drymwfc71g87fp66ck3205pl32z89xsgh0lzw25k";
      type = "gem";
    };
    version = "1.16.0";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d4dgbf8rgqx03lwsm8j6i20lzawk1bsvzfj5bhzrsycfyfk25aj";
      type = "gem";
    };
    version = "0.5.2";
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vs4kfgp5pr5032nnhdapq60ga6karann06ilq1yjx8qck87cfxg";
      type = "gem";
    };
    version = "6.0.3.4";
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
      sha256 = "0x28620cvfja8r06lk6f90pw5lvijz9qi4bjsa4z1d1rkr3v4r3w";
      type = "gem";
    };
    version = "6.0.3.4";
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
      sha256 = "0zjja00mzgx2lddb7qrn14k7qrnwhf4bpmnlqj78m1pfxh7svync";
      type = "gem";
    };
    version = "0.19.1";
  };
  rake = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67";
      type = "gem";
    };
    version = "13.0.3";
  };
  rb-fsevent = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k9bsj7ni0g2fd7scyyy1sk9dy2pg9akniahab0iznvjmhn54h87";
      type = "gem";
    };
    version = "0.10.4";
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
      sha256 = "0s8prj0klfgpmpfcpdzbf149qrrsdxgnb6w6kkqc9gyars4vyaqn";
      type = "gem";
    };
    version = "0.4.14";
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
      sha256 = "16q71cc9wx342c697q18pkz19ym4ncjd97hcw4v6f1mgflkdv400";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "12manni00r5qn50z8w316pnm8mqn858i5kj6s9sr9sfl8qx8ws5g";
      type = "gem";
    };
    version = "1.1.2";
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
      sha256 = "0c2276zzc0044zh37a8frx1v7hnra7z7k126154ps7njbqngfdv3";
      type = "gem";
    };
    version = "5.2.0";
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
      sha256 = "1wb4x8bg2d0plv3izpmi1sd7nd1ix8nxw7b43hd9bac08f4w62mx";
      type = "gem";
    };
    version = "1.7.0";
  };
  redis-rack = {
    dependencies = ["rack" "redis-store"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ldw5sxyd80pv0gr89kvn6ziszlbs8lv1a573fkm6d0f11fps413";
      type = "gem";
    };
    version = "2.1.2";
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
      sha256 = "0x4s82lgf0l71y3xc9gp4qxkrgx1kv8f6avdqd68l46ijbyvicdm";
      type = "gem";
    };
    version = "1.8.2";
  };
  regexp_property_values = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iwapp91sbvafqp12cq834rgy1ydrmrsh5w1a0wfsk4scdxcdwlb";
      type = "gem";
    };
    version = "0.3.5";
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
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cx74kispmnw3ljwb239j65a2j14n8jlsygy372hrsa8mxc71hxi";
      type = "gem";
    };
    version = "1.5.0";
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
  rexml = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkvkcw9fhpaizrhca0pdgjcrbns48rlz4g6lavl5gjjq3rk2sq3";
      type = "gem";
    };
    version = "3.2.4";
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
      sha256 = "0b4b300i3m4m4kw7w1n9wgxwy16zccnb7271miksyzd0wq5b9pm3";
      type = "gem";
    };
    version = "3.26.0";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dwai7jnwmdmd7ajbi2q0k0lx1dh88knv5wl7c34wjmf94yv8w5q";
      type = "gem";
    };
    version = "3.10.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n2rdv8f26yw8c6asymc0mgddyr5d2b5n6mfvpd3n6lnpf1jdyv2";
      type = "gem";
    };
    version = "3.10.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j37dvnvfbjwj8dqx27yfvz0frl7f2jc1abqg99h0ppriz9za6dc";
      type = "gem";
    };
    version = "3.10.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pz89y1522i6f8wzrg72ykmch3318ih87nlpl0y1ghsrs5hqymw3";
      type = "gem";
    };
    version = "3.10.0";
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
      sha256 = "0lzik01ziaskgpdpy8knffpw0fsy9151f5lfigyhb89wq4q45hfs";
      type = "gem";
    };
    version = "4.0.1";
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
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j0n28i6zci5j7gg370bdy87dy43hlwx6dw428d9kamf5a0i2klz";
      type = "gem";
    };
    version = "3.10.0";
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
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19nmdwz6mc5ah0xqlj1j58ylcp9zsckb1xm7p1z51abnqhcq5c06";
      type = "gem";
    };
    version = "0.91.1";
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "165ws2vwnw33nlqgzvzzjjp1zhkc712a92lbpbjx8j83g44dmdy4";
      type = "gem";
    };
    version = "0.8.0";
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
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01aahh54r9mwhdj7v2s6kmkdm1k1n1z27dlknlbgm281ny1aswrk";
      type = "gem";
    };
    version = "1.9.2";
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h656la1g644g54g3gidz45p6v8i1156nw6bi66cfx7078y1339d";
      type = "gem";
    };
    version = "2.9.1";
  };
  rubocop-rspec = {
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0albi9zn8zrz1bb105xkcn5xdv6q7i7r34h9m4jsj5ygsvkkh8kv";
      type = "gem";
    };
    version = "1.44.1";
  };
  ruby-enum = {
    dependencies = ["i18n"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d3dyx2z41zd6va9dwn3q8caf710vzdaf57xspc0y17aqmnprwnw";
      type = "gem";
    };
    version = "0.8.0";
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
      sha256 = "0g1j37fy53ly6351asfcnik033gwkp4kjma7lji1yklmj86d4dg7";
      type = "gem";
    };
    version = "1.3.1";
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
      sha256 = "0xmd9dk1fcmii38apwn3py00qfqxd5yzylafm49n24plzwv913nh";
      type = "gem";
    };
    version = "2.1.2";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17pcc0wgvh3ikrkr7bm3nx0qhyiqwidd13ij0fa50k7gsbnr2p0l";
      type = "gem";
    };
    version = "0.0.2";
  };
  ruby_parser = {
    dependencies = ["sexp_processor"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b6l5bxbamaplp904i7f088j806v0pqi0kvhb8xx81v4whl40y2k";
      type = "gem";
    };
    version = "3.15.0";
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
    dependencies = ["crass" "nokogiri" "nokogumbo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18m3zcf207gcrmghx288w3n2kpphc22lbmbc1wdx1nzcn8g2yddh";
      type = "gem";
    };
    version = "5.2.1";
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
  scientist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09565ppvd851zxpspn5d5q28wqkfjyfxhvda9w80i16p3y937155";
      type = "gem";
    };
    version = "1.5.0";
  };
  scss_lint = {
    dependencies = ["sass"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6dzk4n9pnmqciliggwpiny43vc3cx3n2d5gqa9aqng77ff7yv7";
      type = "gem";
    };
    version = "0.59.0";
  };
  securecompare = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ay65wba4i7bvfqyvf5i4r48q6g70s5m724diz9gdvdavscna36b";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "0adcvp86dinaqq3nhf8p3m0rl2g6q0a4h52k0i7kdnsg1qz9k86y";
      type = "gem";
    };
    version = "3.142.7";
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
      sha256 = "0p0jj2la8bhb7kgqmqbksaq7idnpgjv6asgfd18d2l3z4kra14cj";
      type = "gem";
    };
    version = "4.15.1";
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
      sha256 = "0kw4z9mr8h1rddx6f81gf7glw9pf90w0kvgc2fx4g9hspgh9xh7y";
      type = "gem";
    };
    version = "5.2.9";
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
      sha256 = "10g2667fvxnc50hcd1aywgsbf8j7nrckg3n7zjvywmyz82pwmpqp";
      type = "gem";
    };
    version = "0.14.0";
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
    dependencies = ["docile" "simplecov-html"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ycx5q699ycbjhp28sjbkrd62vwxlrb7fh4v2m7sjsp2qhi6cf6r";
      type = "gem";
    };
    version = "0.18.5";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v7b4mf7njw8kv4ghl4q7mwz3q0flbld7v8blp4m4m3n3aq11bn9";
      type = "gem";
    };
    version = "0.12.2";
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
  slop = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
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
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x2wz1y2b0kp7mlk9k8zkl39rddk2l3x34b7dar3bh3axd1cs30d";
      type = "gem";
    };
    version = "2.1.1";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mwmz36265646xqfyczgr1mhkm1hfxgxxvgdgr4xfcbf2g72p1k2";
      type = "gem";
    };
    version = "3.2.2";
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
      sha256 = "1pdb0szrj4mbczhlx2inszpj54rgnayvy2f2fff4q7jll2iz61i0";
      type = "gem";
    };
    version = "0.12.0";
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
      sha256 = "1v4q8wlc4kr952r24q9x60cvimn27g34h0j23imwqkrjcbngsj5n";
      type = "gem";
    };
    version = "0.14.0";
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
      sha256 = "0d7mm786180v4kzvn1f77rhfppsg5n0sq2bdx63x9nv114zm8jrp";
      type = "gem";
    };
    version = "0.9.1";
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
  to_regexp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rgabfhnql6l4fx09mmj5d0vza924iczqf2blmn82l782b6qqi9v";
      type = "gem";
    };
    version = "0.2.1";
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
  tpm-key_attestation = {
    dependencies = ["bindata" "openssl-signature_algorithm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kdqyanz211wmxjzfiz2wg17gj6p4431qvjr0i6sp3d6268sssg4";
      type = "gem";
    };
    version = "0.9.0";
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
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    version = "1.2.9";
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
      sha256 = "0wc47r23h063l8ysws8sy24gzh74mks81cak3lkzlrw4qkqb3sg4";
      type = "gem";
    };
    version = "0.0.7.7";
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
      sha256 = "1cznkq0agsm7s66nbqbalmq5nlc5cdpd2h88r8jdzsc7wsi5a098";
      type = "gem";
    };
    version = "5.5.5";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qg1apxlnf4kxfj9jpm6hhv73jsncbs4zpsgyan32p5r331q1gmx";
      type = "gem";
    };
    version = "0.4.7";
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
      sha256 = "1hxqza44pvk6x6vb91cvllhw71hqziby06dk1s94rh9f6khbl1nm";
      type = "gem";
    };
    version = "1.0.11";
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
  webauthn = {
    dependencies = ["android_key_attestation" "awrence" "bindata" "cbor" "cose" "openssl" "safety_net_attestation" "securecompare" "tpm-key_attestation"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17nqmi6n4s3i6pmcd7myf7w49q9xd5xlcvz9vbqijlm4yicyxywn";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "0z9k677j9f6jrsj6nkxl2h969q0zyfzqj2ibxldznd5jaqj85xmw";
      type = "gem";
    };
    version = "3.9.1";
  };
  webrick = {
    groups = ["metrics"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z6nv626lzfl7wx407l5x5688layh9qd82k97hrm6pwgj6miwk8b";
      type = "gem";
    };
    version = "1.6.1";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i3rs4kcj0jba8idxla3s6xd1xfln3k8b4cb1dik2lda3ifnp3dh";
      type = "gem";
    };
    version = "0.7.3";
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
  yajl-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16v0w5749qjp13xhjgr2gcsvjv6mf35br7iqwycix1n2h7kfcckf";
      type = "gem";
    };
    version = "1.4.1";
  };
  zeitwerk = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1746czsjarixq0x05f7p3hpzi38ldg6wxnxxw74kbjzh1sdjgmpl";
      type = "gem";
    };
    version = "2.4.2";
  };
}
