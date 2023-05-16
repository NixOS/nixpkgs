{
  aasm = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1xnhpdpi11f7kkyngfspvd9jkkncqfpirz4sylzq32rh47kcd8p3";
      type = "gem";
    };
    version = "5.5.0";
  };
  actioncable = {
    dependencies = ["actionpack" "activesupport" "nio4r" "websocket-driver"];
=======
      sha256 = "05j0rdhdzc628v5nyzrazp4704hh96j5sjbn48zxyk4v3a61f4m2";
      type = "gem";
    };
    version = "5.2.0";
  };
  actioncable = {
    dependencies = ["actionpack" "nio4r" "websocket-driver"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0bndmmby5qxq8rs42fbb2ax3hhbjj2ds8wja08s0iadkbrn7shvf";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "1csrylhksddsarr6wcsiyd0sni106djabswz5gwqqgm2hp992hkz";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  actionmailbox = {
    dependencies = ["actionpack" "activejob" "activerecord" "activestorage" "activesupport" "mail"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0cx00kf0syq5gdhlrmw0q9v92ki55drbsk4gzy86ls2q8xkd792s";
      type = "gem";
    };
    version = "6.1.7.3";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "activesupport" "mail" "rails-dom-testing"];
=======
      sha256 = "0wm2g9f9vppxpv7dyvi5y6dg2k3cdd3x8635cswhpxlfd707sr4p";
      type = "gem";
    };
    version = "6.0.4.7";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0vbif021cyndq3v3m61dkmgdbbirqk9zcsszb9nisq24m3gx1aai";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "1iv2hgqynqlynl2gfaxazb5zzz7qdvdbvl0w695s9ry36ap6mlyi";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0k6hc7klvn8m88b88vykl83jrpqhn4zz67l2zx9v266xga6fhala";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "01fc5lhy6g602xpwdc4pb0sbsfy3kpkc6w99k3fcrq1p14d4kbv5";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  actiontext = {
    dependencies = ["actionpack" "activerecord" "activestorage" "activesupport" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "16ldxyxlxl9scggpmkww2fxzim7sl2b4js610pvddcsr74z9fjs7";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "11n4aaxwjq0iaddvlcdpfip1dpva7hhl2bd883gm0ijw2klaf17n";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubi" "rails-dom-testing" "rails-html-sanitizer"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0ck02cfc17s6g05qn0k7khwvvazwbf2rxbjcma8px2nw2j1ngvcn";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "1gjcbrav25klh8gfj29hfd352if746v7rww77m1mj2adak02sjd1";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05bkw9qgjgj2nxzjj2fh6jp1fcvgff0aa4r77k0gcfmnzc1g8wdl";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "1pvf0hl372y6lsar7svykbvdb3rn5jbis8z7vnqm57l2wvzzp6gv";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activemodel = {
    dependencies = ["activesupport"];
    groups = ["default" "nulldb"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "03hy5bwghdklcxbdylmsq70y0qzslck5slb2zkvp7g6mmvk86kwd";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "0kznd1n0rffhd0vvhxzqdm4m9qp3y7xgqz34vmq2919m3zygqihx";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport"];
    groups = ["default" "nulldb"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1alshkgbcxp9s4vqb2b0yrrnyg15kxhlp1slsb03a61w7h42pspw";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "19kw1mcd6a1lyy8k3wk55pb2qdavwwpqn63ikfyb90ylvnr36g2q";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activerecord-import = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1cwm95795c6j5hk76csdkfg7ad228cmp086shkcmhnad4mycbh4m";
      type = "gem";
    };
    version = "1.4.1";
=======
      sha256 = "0nagy0b82ims0pc9mvg1fq8hlrnn6z8r9kpaas83f4yyrwr9h359";
      type = "gem";
    };
    version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activerecord-nulldb-adapter = {
    dependencies = ["activerecord"];
    groups = ["nulldb"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c0f7fn06fzc7pn0dydchnq6xgcaga9rbzhmin5z5xvg5nkv783c";
      type = "gem";
    };
    version = "0.8.0";
  };
  activerecord-session_store = {
    dependencies = ["actionpack" "activerecord" "multi_json" "rack" "railties"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ddhz1b2yg72iv09n48gcd3ix5da7hxlzi7vvj13nrps2qwlffg";
      type = "gem";
    };
    version = "2.0.0";
  };
  activestorage = {
<<<<<<< HEAD
    dependencies = ["actionpack" "activejob" "activerecord" "activesupport" "marcel" "mini_mime"];
=======
    dependencies = ["actionpack" "activejob" "activerecord" "marcel"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "06w4wlabqqr9bwdig44r5vdwkcbbivwgwn2fl775w7h05vrccgp8";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "0ync0w5mnmyk3pczc0k44iic35a5ij25fi5jwjhl9k7jr6wdhi2b";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo" "zeitwerk"];
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "06mihpy83a5xmavvn7l8vbix472dsi0vh30xj6g594k0679m0ir6";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "15pwg27li00rrzq4drmxx9l4w8fmxapnigvhh9m4xl0asmy1k207";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  acts_as_list = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qdb3g1ha8ir198rw6a7wmmdz4vm3gsk5j5j1s5sa50hdbgc9m06";
      type = "gem";
    };
    version = "1.1.0";
=======
      sha256 = "12p22h59c45dnccb51pqk275ziyi502azf9w3qcnkcsq827ma5jm";
      type = "gem";
    };
    version = "1.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      type = "gem";
    };
    version = "2.8.1";
=======
      sha256 = "022r3m9wdxljpbya69y2i3h9g3dhhfaqzidf95m6qjzms792jvgp";
      type = "gem";
    };
    version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  argon2 = {
    dependencies = ["ffi" "ffi-compiler"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1wdllcqlr81nzyf485ldv1p660xsi476p79ghbj7zsf3n9n86gwd";
      type = "gem";
    };
    version = "2.2.0";
=======
      sha256 = "0g4qsdq072fyrsa7r0sg456dhrb017jmzdbnnzl2c80ha40bbmhg";
      type = "gem";
    };
    version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  autodiscover = {
    dependencies = ["httpclient" "logging" "nokogiri" "nori"];
    groups = ["default"];
    platforms = [];
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
    dependencies = ["execjs"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "020v30xd1v2yvyfshbii497c83n4kafc6967pwmgl54sxkx04xwq";
      type = "gem";
    };
    version = "10.4.7.0";
=======
      sha256 = "1ssfcicmmwx50491wns3aa9i0yamp2x6qk04yrgn51h9kzhp7frf";
      type = "gem";
    };
    version = "10.4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  biz = {
    dependencies = ["clavius" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n2d7cs9jlnpi75nbssv77qlw0jsqnixaikpxsrbxz154q43gvlc";
      type = "gem";
    };
    version = "1.8.2";
  };
  bootsnap = {
    dependencies = ["msgpack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1vcg52gwl64xhhal6kwk1pc01y1klzdlnv1awyk89kb91z010x7q";
      type = "gem";
    };
    version = "1.16.0";
=======
      sha256 = "0bjhh8pngmvnrsri2h6a753pgv0xdkbbgi1bmv6c7q137sp37jbg";
      type = "gem";
    };
    version = "1.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  brakeman = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0lcxxlrzgpi9z2mr2v19xda6fdysmn5psa9bsp2rksa915v91fds";
      type = "gem";
    };
    version = "5.4.0";
=======
      sha256 = "197bvfm4rpczyrpbjzn7zh4q6rxigwnxnnmvvgfg9451k3jjygyy";
      type = "gem";
    };
    version = "5.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  buftok = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rzsy1vy50v55x9z0nivf23y0r9jkmq6i130xa75pq9i8qrn1mxs";
      type = "gem";
    };
    version = "0.2.0";
  };
  builder = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045wzckxpwcqzrjr353cxnyaxgf0qg22jh00dcx7z38cys5g1jlr";
      type = "gem";
    };
    version = "3.2.4";
  };
  byebug = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nx3yjf4xzdgb8jkmk2344081gqr22pgjqnmjg2q64mj5d6r9194";
      type = "gem";
    };
    version = "11.1.3";
  };
<<<<<<< HEAD
  byk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cw26m1977kk6awns8h3d10f9bq9j467s0a4srdvkhgy6ar2jagn";
      type = "gem";
    };
    version = "1.1.0";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  capybara = {
    dependencies = ["addressable" "matrix" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "123198zk2ak8mziwa5jc3ckgpmsg08zn064n3aywnqm9s1bwjv3v";
      type = "gem";
    };
    version = "3.38.0";
=======
      sha256 = "1dv75hs45456mi76h720gxk959gpg4f6091hmk42y0ln6kp2x7i0";
      type = "gem";
    };
    version = "3.36.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  childprocess = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lvcp8bsd35g57f7wz4jigcw2sryzzwrpcgjwwf3chmjrjcww5in";
      type = "gem";
    };
    version = "4.1.0";
  };
  chunky_png = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  clavius = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y58v8k860vafm1psm69f2ndcqmcifyvswsjdy8bxbxy30zrgad1";
      type = "gem";
    };
    version = "1.0.4";
  };
  clearbit = {
    dependencies = ["nestful"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccgvxzgpll1wr5i9wjm1h0m2z600j6c4yf6pww423qhg8a25lbl";
      type = "gem";
    };
    version = "0.3.3";
  };
  coderay = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  coffee-rails = {
    dependencies = ["coffee-script" "railties"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "170sp4y82bf6nsczkkkzypzv368sgjg6lfrkib4hfjgxa6xa3ajx";
      type = "gem";
    };
    version = "5.0.0";
  };
  coffee-script = {
    dependencies = ["coffee-script-source" "execjs"];
<<<<<<< HEAD
    groups = ["assets" "default"];
=======
    groups = ["assets" "default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
<<<<<<< HEAD
    groups = ["assets" "default"];
=======
    groups = ["assets" "default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1907v9q1zcqmmyqzhzych5l7qifgls2rlbnbhy5vzyr7i7yicaz1";
      type = "gem";
    };
    version = "1.12.2";
  };
<<<<<<< HEAD
=======
  coffeelint = {
    dependencies = ["coffee-script" "execjs" "json"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k6nqia44m6jzzkav6wz1aafjipbygla3g6nl6i7sks854bwgdg1";
      type = "gem";
    };
    version = "1.16.1";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  composite_primary_keys = {
    dependencies = ["activerecord"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1izh9vf2rjjxphidgf00wdmvmvlrbsy4n2a99fds59qkbd5cy0i9";
      type = "gem";
    };
    version = "13.0.7";
=======
      sha256 = "08w8rns5dgjmvavqf1apfbd59dyqyv4igni940rklnqps297w2bn";
      type = "gem";
    };
    version = "12.0.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  concurrent-ruby = {
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qnsflsbjj38im8xq35g0vihlz96h09wjn2dad5g543l3vvrkrx5";
      type = "gem";
    };
    version = "1.2.0";
=======
      sha256 = "0nwad3211p7yv9sda31jmbyw6sdafzmdi2i2niaz6f0wk5nq9h0f";
      type = "gem";
    };
    version = "1.1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  crack = {
    dependencies = ["rexml"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cr1kfpw3vkhysvkk3wg7c54m75kd68mbm9rs5azdjdq57xid13r";
      type = "gem";
    };
    version = "0.4.5";
  };
  crass = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pfl5c0pyqaparxaqxi6s4gfl21bdldwiawrc0aknyvflli60lfw";
      type = "gem";
    };
    version = "1.0.6";
  };
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0l5f5cq8ki3h4djh7pb8yqdkywqd08vjy3vd64yqh7qd6pdwky6w";
      type = "gem";
    };
    version = "3.2.6";
=======
      sha256 = "0xqp6d3k3qcfybfibv6jx315800j1zvm1wwrdmfbs35g3wi9sb2c";
      type = "gem";
    };
    version = "3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  daemons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07cszb0zl8mqmwhc8a2yfg36vi6lbgrp4pa5bvmryrpcz9v6viwg";
      type = "gem";
    };
    version = "1.4.1";
  };
  dalli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0xyza6gjci6qp83srcvsg3i225x17n27bwci4wqzpmn9bykjac2n";
      type = "gem";
    };
    version = "3.2.3";
  };
  date = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03skfikihpx37rc27vr3hwrb057gxnmdzxhmzd4bf4jpkl0r55w1";
      type = "gem";
    };
    version = "3.3.3";
=======
      sha256 = "0wb7lqiza98cb76bq1jwvzr1j0r2nxkihaaa3dk17wjshd02jyn3";
      type = "gem";
    };
    version = "3.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  delayed_job = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0s2xg72ljg4cwmr05zi67vcyz8zib46gvvf7rmrdhsyq387m2qcq";
      type = "gem";
    };
    version = "4.1.11";
=======
      sha256 = "1f1vzxi1xcm1mq7nw3xr9j4q6a5pr5xply15s0n1hl1gahsgnlfa";
      type = "gem";
    };
    version = "4.1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  delayed_job_active_record = {
    dependencies = ["activerecord" "delayed_job"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh1146hg0b85zv336dn00jx9mzw5ma0maj67is7bvz5l35hd6yk";
      type = "gem";
    };
    version = "4.1.7";
  };
  deprecation_toolkit = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0q7av58hr1armdn4nr9kw7hhgry2v576dwn4d80ngax9g0hdw9cv";
      type = "gem";
    };
    version = "2.0.3";
=======
      sha256 = "1fh4d98irhph3ri7c2rrvvmmjd4z14702r8baq9flh5f34dap8d8";
      type = "gem";
    };
    version = "1.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  diffy = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qcsv29ljfhy76gq4xi8zpn6dc6nv15c41r131bdr38kwpxjzd1n";
      type = "gem";
    };
    version = "3.4.2";
=======
      sha256 = "0nrg7kpgz6cn1gv2saj2fa5sfiykamvd7vn9lw2v625k7pjwf31l";
      type = "gem";
    };
    version = "3.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "0fxrvqv3l5w9p20s129rg41zc6agf1n4yrmganancnvykbkygki2";
      type = "gem";
    };
    version = "5.6.4";
=======
      sha256 = "188ybg2cgghcp5r1jpfnbx3anf0z8fzlla72jra0vgwkdylk7qkz";
      type = "gem";
    };
    version = "5.5.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  dotenv = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1n0pi8x8ql5h1mijvm8lgn6bhq4xjb5a500p5r1krq4s6j9lg565";
      type = "gem";
    };
    version = "2.8.1";
  };
  dry-cli = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ffdpd18n1h1fxsl4yz7wpjlxb0nw8s0wxzwypi9vcyzij0d993s";
      type = "gem";
    };
    version = "0.7.0";
  };
  dry-core = {
    dependencies = ["concurrent-ruby" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01gks2hrp7nl3pzb487azvd25dlbrc40d5cpk4n0szwnf2c0k4ks";
      type = "gem";
    };
    version = "1.0.0";
  };
  dry-inflector = {
    groups = ["default"];
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05nldkc154r0qzlhss7n5klfiyyz05x2fkq08y13s34py6023vcr";
      type = "gem";
    };
    version = "1.5.0";
  };
  dry-struct = {
    dependencies = ["dry-core" "dry-types" "ice_nine" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rnlgn4wif0dvkvi10xwh1vd1q6mp35q6a7lwva0zmbc79dh4drp";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-types = {
    dependencies = ["concurrent-ruby" "dry-core" "dry-inflector" "dry-logic" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s5cqx3i7bigfhy8pniswdhinc9k2xxvkk05ikqy0kmwiy4bc991";
      type = "gem";
    };
    version = "1.7.0";
=======
      sha256 = "0iym172c5337sm1x2ykc2i3f961vj3wdclbyg1x6sxs3irgfsl94";
      type = "gem";
    };
    version = "2.7.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  eco = {
    dependencies = ["coffee-script" "eco-source" "execjs"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jiwb7pkg0sxk730maxahra4whqw5l47zd7yg7fvd71pikdwdr0";
      type = "gem";
    };
    version = "1.0.0";
  };
  eco-source = {
    groups = ["assets" "default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ccxrvaac6mw5kdj1i490b5xb1wdka3a5q4jhvn8dvg41594yba1";
      type = "gem";
    };
    version = "1.1.0.rc.1";
  };
  em-websocket = {
    dependencies = ["eventmachine" "http_parser.rb"];
<<<<<<< HEAD
    groups = ["default"];
=======
    groups = ["default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a66b0kjk6jx7pai9gc7i27zd0a128gy73nmas98gjz6wjyr4spm";
      type = "gem";
    };
    version = "0.5.3";
  };
<<<<<<< HEAD
  email_address = {
    dependencies = ["simpleidn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09clyyp65ry2dqg4kwr4lbyi40c9nci282qxpfgmvq75z8clia8y";
      type = "gem";
    };
    version = "0.2.4";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  equalizer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubi = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11bz1v1cxabm8672gabrw542zyg51dizlcvdck6vvwzagxbjv9zx";
      type = "gem";
    };
    version = "1.11.0";
  };
  eventmachine = {
    groups = ["default"];
=======
      sha256 = "09l8lz3j00m898li0yfsnb6ihc63rdvhw3k5xczna5zrjk104f2l";
      type = "gem";
    };
    version = "1.10.0";
  };
  eventmachine = {
    groups = ["default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
<<<<<<< HEAD
    groups = ["assets"];
=======
    groups = ["assets" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "121h6af4i6wr3wxvv84y53jcyw2sk71j5wsncm6wq6yqrwcrk4vd";
      type = "gem";
    };
    version = "2.8.1";
  };
  factory_bot = {
    dependencies = ["activesupport"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pfk942d6qwhw151hxaz7n4knk6whyxqvvywdx2cdw9yhykyaqzq";
      type = "gem";
    };
    version = "6.2.1";
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
  faker = {
    dependencies = ["i18n"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1b8772jybi0vxzbcs5zw17k40z661c8adn2rd6vqqr7ay71bzl09";
      type = "gem";
    };
    version = "3.1.1";
  };
  faraday = {
    dependencies = ["faraday-net_http" "ruby2_keywords"];
=======
      sha256 = "1694ndj701a8q4c4bwxz53kx94ih1rr4pgr4gk7a6c8k4jsbjgwi";
      type = "gem";
    };
    version = "2.20.0";
  };
  faraday = {
    dependencies = ["faraday-em_http" "faraday-em_synchrony" "faraday-excon" "faraday-httpclient" "faraday-multipart" "faraday-net_http" "faraday-net_http_persistent" "faraday-patron" "faraday-rack" "faraday-retry" "ruby2_keywords"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1f20vjx0ywx0zdb4dfx4cpa7kd51z6vg7dw5hs35laa45dy9g9pj";
      type = "gem";
    };
    version = "2.7.4";
  };
  faraday-mashify = {
    dependencies = ["faraday" "hashie"];
=======
      sha256 = "00palwawk897p5gypw5wjrh93d4p0xz2yl9w93yicb4kq7amh8d4";
      type = "gem";
    };
    version = "1.10.0";
  };
  faraday-em_http = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1fiy1bqwx7sj3dmydlyqzj4lapkb2p84pmp4f6i2g0ypj1wbrcml";
      type = "gem";
    };
    version = "0.1.1";
=======
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vgrbhkp83sngv6k4mii9f2s9v5lmp693hylfxp2ssfc60fas3a6";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  faraday-multipart = {
    dependencies = ["multipart-post"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "09871c4hd7s5ws1wl4gs7js1k2wlby6v947m2bbzg43pnld044lh";
      type = "gem";
    };
    version = "1.0.4";
=======
      sha256 = "03qfi9020ynf7hkdiaq01sd2mllvw7fg4qiin3pk028b4wv23j3j";
      type = "gem";
    };
    version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  faraday-net_http = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "13byv3mp1gsjyv8k0ih4612y6vw5kqva6i03wcg4w2fqpsd950k8";
      type = "gem";
    };
    version = "3.0.2";
=======
      sha256 = "1fi8sda5hc54v1w3mqfl5yz09nhx35kglyx72w7b8xxvdr0cwi9j";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-net_http_persistent = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = ["default" "development" "test"];
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bw8mfh4yin2xk7138rg3fhb2p5g2dlmdma88k82psah9mbmvlfy";
      type = "gem";
    };
    version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  ffi = {
    groups = ["assets" "default" "development" "test"];
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
<<<<<<< HEAD
=======
  formatador = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l06bv4avphbdmr1y4g0rqlczr38k6r65b3zghrbj2ynyhm3xqjl";
      type = "gem";
    };
    version = "1.1.0";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  gli = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rv8dlq9nqpias29jh40qb6xzznlk6ra41nan6s5hy56402f0k29";
      type = "gem";
    };
    version = "2.21.0";
  };
  globalid = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "040bxzfd7mz1p6z4bc9vk5yrf762hdllvf98hmk848fq28xc5dsk";
      type = "gem";
    };
    version = "1.0.1";
=======
      sha256 = "1n5yc058i8xhi1fwcp1w7mfi6xaxfmrifdb4r4hjfff33ldn8lqj";
      type = "gem";
    };
    version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  gmail_xoauth = {
    dependencies = ["oauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dslnb1kffcygcbs8sqw58w6ba0maq4w7k1i7kjrqpq0kxx6wklq";
      type = "gem";
    };
    version = "0.4.2";
  };
<<<<<<< HEAD
  graphql = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14knjmj2csrl9s890ikvipsbxn01xn6vdb64iwlbv6xnc20scwxf";
      type = "gem";
    };
    version = "2.0.17";
  };
  graphql-batch = {
    dependencies = ["graphql" "promise.rb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nsjfi47h9ma8gkqi7v6ky3jqp1zb05l4y2xdsa13f0s8vmq04jv";
      type = "gem";
    };
    version = "0.5.2";
=======
  guard = {
    dependencies = ["formatador" "listen" "lumberjack" "nenv" "notiffany" "pry" "shellany" "thor"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zqy994fr0pf3pda0x3mmkhgnfg4hd12qp5bh1s1xm68l00viwhj";
      type = "gem";
    };
    version = "2.18.0";
  };
  guard-compat = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zj6sr1k8w59mmi27rsii0v8xyy2rnsi09nqvwpgj1q10yq1mlis";
      type = "gem";
    };
    version = "1.2.1";
  };
  guard-livereload = {
    dependencies = ["em-websocket" "guard" "guard-compat" "multi_json"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yd74gdbbv2yz2caqwpsavzw8d5fd5y446wp8rdjw8wan0yd6k8j";
      type = "gem";
    };
    version = "2.5.2";
  };
  guard-symlink = {
    dependencies = ["guard" "guard-compat"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s5lwl8v55lq0bbvj9k3fv0l4nkl0ydd7gr1k26ycs2a80cgd5mq";
      type = "gem";
    };
    version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  hashdiff = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
  };
  hashie = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nh3arcrbz1rc1cr59qm53sdhqm137b258y8rcb4cvd3y98lwv4x";
      type = "gem";
    };
    version = "5.0.0";
  };
  hiredis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04jj8k7lxqxw24sp0jiravigdkgsyrpprxpxm71ba93x1wr2w1bz";
      type = "gem";
    };
    version = "0.6.3";
  };
  htmlentities = {
    groups = ["default"];
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
<<<<<<< HEAD
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      type = "gem";
    };
    version = "1.0.5";
=======
      sha256 = "19370bc97gsy2j4hanij246hv1ddc85hw0xjb6sj7n1ykqdlx9l9";
      type = "gem";
    };
    version = "1.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      sha256 = "18qqvckvqjffh88hfib6c8pl9qwk9gp89w89hl3f2s1x8hgyqka1";
      type = "gem";
    };
    version = "1.2.3";
  };
  "http_parser.rb" = {
<<<<<<< HEAD
    groups = ["default"];
=======
    groups = ["default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
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
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
=======
      sha256 = "0b2qyvnk4yynlg17ymkq4g5xgr275637fhl1mjh0valw3cb1fhhg";
      type = "gem";
    };
    version = "1.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  icalendar = {
    dependencies = ["ice_cube"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11zfs0l8y2a6gpf0krm91d0ap2mnf04qky89dyzxwaspqxqgj174";
      type = "gem";
    };
    version = "2.8.0";
=======
      sha256 = "1wv5wq6pzq6434bnxfanvijswj2rnfvjmgisj1qg399mc42g46ls";
      type = "gem";
    };
    version = "2.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  icalendar-recurrence = {
    dependencies = ["icalendar" "ice_cube"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06li3cdbwkd9y2sadjlbwj54blqdaa056yx338s4ddfxywrngigh";
      type = "gem";
    };
    version = "1.1.3";
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
<<<<<<< HEAD
  ice_nine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  inflection = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mfkk0j0dway3p4gwzk8fnpi4hwaywl2v0iywf1azf98zhk9pfnf";
      type = "gem";
    };
    version = "1.0.0";
  };
  iniparse = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wb1qy4i2xrrd92dc34pi7q7ibrjpapzk9y465v0n9caiplnb89n";
      type = "gem";
    };
    version = "1.5.0";
  };
  interception = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01vrkn28psdx1ysh5js3hn17nfp1nvvv46wc1pwqsakm6vb1hf55";
      type = "gem";
    };
    version = "0.5";
  };
  json = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0nalhin1gda4v8ybk6lq8f407cgfrj6qzn234yra4ipkmlbfmal6";
      type = "gem";
    };
    version = "2.6.3";
=======
      sha256 = "1z9grvjyfz16ag55hg522d3q4dh07hf391sf9s96npc0vfi85xkz";
      type = "gem";
    };
    version = "2.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bg8pjx0mpvl10k6d8a6gc8dzlv2z5jkqcjbjcirnk032iriq838";
      type = "gem";
    };
    version = "2.3.0";
  };
  kgio = {
    groups = ["default" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ipzvw7n0kz1w8rkqybyxvf3hb601a770khm0xdqm68mc4aa59xx";
      type = "gem";
    };
    version = "2.11.4";
  };
  koala = {
<<<<<<< HEAD
    dependencies = ["addressable" "faraday" "faraday-multipart" "json" "rexml"];
=======
    dependencies = ["addressable" "faraday" "json" "rexml"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "14jq1q8314x5qncmfgs53iv1ycz1fm887gnp7w04h963gbwr3yhc";
      type = "gem";
    };
    version = "3.4.0";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rgkfar8pp31z1aamxf5y7cfq88wv6rxxcwy7cmm177qq508ycn";
      type = "gem";
    };
    version = "3.8.0";
=======
      sha256 = "028cfg3i8kysv7vvrscakx5b809jbmlrbykr727sngh3hxq1wknb";
      type = "gem";
    };
    version = "3.1.0";
  };
  libv8 = {
    groups = ["mini_racer"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0317sr3nrl51sp844bps71smkrwim3fjn47wdfpbycixnbxspivm";
      type = "gem";
    };
    version = "8.4.255.0";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  little-plugger = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1zflchpx4g8c110gjdcs540bk5a336nq6nmx379rdg56xw0pjd02";
      type = "gem";
    };
    version = "2.3.1";
=======
      sha256 = "0pkmhcxi8lp74bq5gz9lxrvaiv5w0745kk7s4bw2b1x07qqri0n9";
      type = "gem";
    };
    version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "08qhzck271anrx9y6qa6mh8hwwdzsgwld8q0000rcd7yvvpnjr3c";
      type = "gem";
    };
    version = "2.19.1";
  };
  mail = {
    dependencies = ["mini_mime" "net-imap" "net-pop" "net-smtp"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bf9pysw1jfgynv692hhaycfxa8ckay1gjw5hz3madrbrynryfzc";
      type = "gem";
    };
    version = "2.8.1";
=======
      sha256 = "0z8bdcmw66j3dy6ivcc02yq32lx3n9bavx497llln8qy014xjm4w";
      type = "gem";
    };
    version = "2.14.0";
  };
  lumberjack = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06pybb23hypc9gvs2p839ildhn26q68drb6431ng3s39i3fkkba8";
      type = "gem";
    };
    version = "1.2.8";
  };
  mail = {
    dependencies = ["mini_mime"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "9265cf75bbe376f595944bd10d2dd953f863e765";
      sha256 = "04jxql35kwijapl37h9an6127hzz0y4pnj82a9iw39kz9vva890s";
      type = "git";
      url = "https://github.com/zammad-deps/mail";
    };
    version = "2.7.2.edge";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  marcel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kky3yiwagsk8gfbzn3mvl2fxlh3b39v6nawzm4wpjs6xxvvc4x0";
      type = "gem";
    };
    version = "1.0.2";
  };
  matrix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      type = "gem";
    };
    version = "0.4.2";
  };
  memoizable = {
    dependencies = ["thread_safe"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v42bvghsvfpzybfazl14qhkrjvx0xlmxz0wwqc960ga1wld5x5c";
      type = "gem";
    };
    version = "0.4.2";
  };
  messagebird-rest = {
<<<<<<< HEAD
    dependencies = ["jwt"];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0zghnl12l22adm6lgswj4im3qm70lfnsyl9gg6gd9c89hj467hsk";
      type = "gem";
    };
    version = "4.0.0";
=======
      sha256 = "1nj994h4ziwb72g54ma3ivb3rbfkv3yk81wwcmgykl2ik3g7q2bm";
      type = "gem";
    };
    version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  method_source = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
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
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1pky3vzaxlgm9gw5wlqwwi7wsw3jrglrfflrppvvnsrlaiz043z9";
      type = "gem";
    };
    version = "3.2023.0218.1";
=======
      sha256 = "003gd7mcay800k2q4pb2zn8lwwgci4bhi42v2jvlidm8ksx03i6q";
      type = "gem";
    };
    version = "3.2022.0105";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1af4yarhbbx62f7qsmgg5fynrik0s36wjy3difkawy536xg343mp";
      type = "gem";
    };
    version = "2.8.1";
=======
      sha256 = "0rapl1sfmfi3bfr68da4ca16yhc0pp93vjwkj7y3rdqrzy3b41hy";
      type = "gem";
    };
    version = "2.8.0";
  };
  mini_racer = {
    dependencies = ["libv8"];
    groups = ["mini_racer"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zi36qcg5qj4g1c11vwmc7lknjihirrmc6yxi6q8j6v4lfnyjbyg";
      type = "gem";
    };
    version = "0.2.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  minitest = {
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1kjy67qajw4rnkbjs5jyk7kc3lyhz5613fwj1i8f6ppdk4zampy0";
      type = "gem";
    };
    version = "5.17.0";
  };
  minitest-profile = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13h4nwbq6yv7hsaa7dpj90lry4rc5qqnpzvm9n2s57mm2xi31xfa";
      type = "gem";
    };
    version = "0.0.2";
=======
      sha256 = "06xf558gid4w8lwx13jwfdafsch9maz8m0g85wnfymqj63x5nbbd";
      type = "gem";
    };
    version = "5.15.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  msgpack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1q03pb0vq8388s431nbxabsfxnch6p304c8vnjlk0zzpcv713yr3";
      type = "gem";
    };
    version = "1.6.0";
  };
  multi_json = {
    groups = ["default"];
=======
      sha256 = "1cshgsx3hmpgx639xyqjqa2q3hgrhlyr9rpwhsglsx529alqq125";
      type = "gem";
    };
    version = "1.4.5";
  };
  multi_json = {
    groups = ["default" "development" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
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
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0lgyysrpl50wgcb9ahg29i4p01z0irb3p9lirygma0kkfr5dgk9x";
      type = "gem";
    };
    version = "2.3.0";
=======
      sha256 = "1zgw9zlwh2a6i1yvhhc4a84ry1hv824d6g2iw2chs3k5aylpmpfj";
      type = "gem";
    };
    version = "2.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mysql2 = {
    groups = ["mysql"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0xsy70mg4p854jska7ff7cy8fyn9nhlkrmfdvkkfmk8qxairbfq1";
      type = "gem";
    };
    version = "0.5.4";
=======
      sha256 = "0d14pcy5m4hjig0zdxnl9in5f4izszc7v9zcczf2gyi5kiyxk8jw";
      type = "gem";
    };
    version = "0.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  naught = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wwjx35zgbc0nplp8a866iafk4zsrbhwwz4pav5gydr2wm26nksg";
      type = "gem";
    };
    version = "1.1.0";
  };
<<<<<<< HEAD
=======
  nenv = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r97jzknll9bhd8yyg2bngnnkj8rjhal667n7d32h8h7ny7nvpnr";
      type = "gem";
    };
    version = "0.3.0";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nestful = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sn7lrdhp1dwn9xkqwkarby5bxx1g30givy3fi1dwp1xvqbrqikw";
      type = "gem";
    };
    version = "1.1.4";
  };
<<<<<<< HEAD
  net-ftp = {
    dependencies = ["net-protocol" "time"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bqy9xg5225x102873j1qqq1bvnwfbi8lnf4357mpq6wimnw9pf9";
      type = "gem";
    };
    version = "0.2.0";
  };
  net-http = {
    dependencies = ["uri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y55ib1v2b8prqfi9ij7hca60b1j94s2bzr6vskwi3i5735472wq";
      type = "gem";
    };
    version = "0.3.2";
  };
  net-imap = {
    dependencies = ["date" "net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d996zf3g8xz244791b0qsl9vr7zg4lqnnmf9k2kshr9lki5jam8";
      type = "gem";
    };
    version = "0.3.4";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  net-ldap = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1ycw0qsw3hap8svakl0i30jkj0ffd4lpyrn17a1j0w8mz5ainmsj";
      type = "gem";
    };
    version = "0.17.1";
  };
  net-pop = {
    dependencies = ["net-protocol"];
=======
      sha256 = "1j19yxrz7h3hj7kiiln13c7bz7hvpdqr31bwi88dj64zifr7896n";
      type = "gem";
    };
    version = "0.17.0";
  };
  netrc = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
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
      sha256 = "0dxckrlw4q1lcn3qg4mimmjazmg9bma5gllv72f8js3p36fb3b91";
      type = "gem";
    };
    version = "0.2.1";
  };
  net-smtp = {
    dependencies = ["net-protocol"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c6md06hm5bf6rv53sk54dl2vg038pg8kglwv3rayx0vk2mdql9x";
      type = "gem";
    };
    version = "0.3.3";
=======
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nio4r = {
    groups = ["default" "puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xk64wghkscs6bv2n22853k2nh39d131c6rfpnlw12mbjnnv9v1v";
      type = "gem";
    };
    version = "2.5.8";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0n79k78c5vdcyl0m3y3l5x9kxl6xf5lgriwi2vd665qmdkr01vnk";
      type = "gem";
    };
    version = "1.13.10";
=======
      sha256 = "1g43ii497cwdqhfnaxfl500bq5yfc5hfv5df1lvf6wcjnd708ihd";
      type = "gem";
    };
    version = "1.13.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  nori = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "066wc774a2zp4vrq3k7k8p0fhv30ymqmxma1jj7yg5735zls8agn";
      type = "gem";
    };
    version = "2.6.0";
  };
<<<<<<< HEAD
  oauth = {
    dependencies = ["oauth-tty" "snaky_hash" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1syx3hfimaqycy21kn8gmal1cb3bw3hzalv3in2ixnay1xzjp41q";
      type = "gem";
    };
    version = "1.1.0";
  };
  oauth-tty = {
    dependencies = ["version_gem"];
=======
  notiffany = {
    dependencies = ["nenv" "shellany"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f47h3bmg1apr4x51szqfv3rh2vq58z3grh4w02cp3bzbdh6jxnk";
      type = "gem";
    };
    version = "0.1.3";
  };
  oauth = {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05wb5n36i4h23hh9dx2m2cwjxx5vj0vgyrn2xr6rsl54glq5rqil";
      type = "gem";
    };
    version = "1.0.5";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_xml" "rack" "snaky_hash" "version_gem"];
=======
      sha256 = "0h6nfg2pibc17fch0795d4bcy41a92im5zrsrgs31zdhrl6zf4w0";
      type = "gem";
    };
    version = "0.5.8";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1yzpaghh8kwzgmvmrlbzf36ks5s2hf34rayzw081dp2jrzprs7xj";
      type = "gem";
    };
    version = "2.0.9";
=======
      sha256 = "16sk9h6a6vzqxf8v1fisa8jq5cj9sw4mwc7azy5gj2w1whkfa5dp";
      type = "gem";
    };
    version = "1.4.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1jn9j54l5h7xcba2vjq74l1dk0xrwvsjxam4qhylpi52nw0h5502";
      type = "gem";
    };
    version = "1.9.2";
=======
      sha256 = "002vi9gwamkmhf0dsj2im1d47xw2n1jfhnzl18shxf3ampkqfmyz";
      type = "gem";
    };
    version = "1.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  omniauth-facebook = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m7q38kjm94wgq6h7hk9546yg33wcs3vf1v6zp0vx7nwkvfxh2j4";
      type = "gem";
    };
    version = "9.0.0";
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
      sha256 = "1nbrg93p0nqxs1i2ddyij2rr7jn4vr3la4la39q4fknpin535k3z";
      type = "gem";
    };
    version = "2.0.0";
  };
  omniauth-google-oauth2 = {
<<<<<<< HEAD
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
=======
    dependencies = ["jwt" "oauth2" "omniauth" "omniauth-oauth2"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "17pgqasl048irs2c6w6g57zvk0ygb5ml1krwir4qi4b6y53zyr55";
      type = "gem";
    };
    version = "0.8.0";
=======
      sha256 = "10pnxvb6wpnf58dja3yz4ja527443x3q13hzhcbays4amnnp8i4a";
      type = "gem";
    };
    version = "0.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  omniauth-linkedin-oauth2 = {
    dependencies = ["omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ydkj9f2hd3fskpc2gazz9dim70z2k6z6pb8j3glnlhkd67iyzci";
      type = "gem";
    };
    version = "1.0.0";
  };
  omniauth-microsoft-office365 = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vw6418gykxqd9z32ddq0mr6wa737la1zwppb1ilw9sgii24rg1v";
      type = "gem";
    };
    version = "0.0.8";
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
<<<<<<< HEAD
      sha256 = "0ia73zcbmhf02krlkq2rxmksx93jp777ax5x58fzkq3jzacqyniz";
      type = "gem";
    };
    version = "1.7.3";
=======
      sha256 = "1ry65f309rnzhgdjvqybkd5i4qp9rpk1gbp4dz02h4l6bkk6ya10";
      type = "gem";
    };
    version = "1.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  omniauth-rails_csrf_protection = {
    dependencies = ["actionpack" "omniauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgkxwg17w39q3yjqcj0fm6hdkw37qm1l82dvm9zxn6q2pbzm2zv";
      type = "gem";
    };
    version = "0.1.2";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxl14lbksnjkl8dfn23lsjkk63md77icm5racrh6fsp5n4ni9d4";
      type = "gem";
    };
    version = "1.10.3";
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
  omniauth-weibo-oauth2 = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02cz73lj38cjqkbrdnfr7iymzqdcxgqcjy992r5hmawgpqqgxvwb";
      type = "gem";
    };
    version = "0.5.2";
  };
  openssl = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0c649921vg2l939z5cc3jwd8p1v49099pdhxfk7sb9qqx5wi5873";
      type = "gem";
    };
    version = "3.1.0";
=======
      sha256 = "1azzx975qr078isvg8i0hmsr2l98kgnlfrnbb2jdm9b5kwifx1h4";
      type = "gem";
    };
    version = "3.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  overcommit = {
    dependencies = ["childprocess" "iniparse" "rexml"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0slqmsycbqx746liwq0qw0c81xrp4051iff8s574a4fmj941gkia";
      type = "gem";
    };
    version = "0.60.0";
=======
      sha256 = "0wbczp2pxwiggx5n925mdr2q17c6m9hq7h0q7ml2spmla29609sr";
      type = "gem";
    };
    version = "0.58.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  parallel = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "07vnk6bb54k4yc06xnwck7php50l09vvlw1ga8wdz0pia461zpzb";
      type = "gem";
    };
    version = "1.22.1";
=======
      sha256 = "1hkfpm78c2vs1qblnva3k1grijvxh87iixcnyd83s3lxrxsjvag4";
      type = "gem";
    };
    version = "1.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  parser = {
    dependencies = ["ast"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0zk8mdyr0322r11d63rcp5jhz4lakxilhvyvdv0ql5dw4lb83623";
      type = "gem";
    };
    version = "3.2.0.0";
=======
      sha256 = "0zaghgvva2q4jqbachg8jvpwgbg3w1jqr0d00m8rqciqznjgsw3c";
      type = "gem";
    };
    version = "3.1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  pg = {
    groups = ["postgres"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "13mfrysrdrh8cka1d96zm0lnfs59i5x2g6ps49r2kz5p3q81xrzj";
      type = "gem";
    };
    version = "1.2.3";
=======
      sha256 = "00vhasqwc4f98qb4wxqn2h07fjwzhp5lwyi41j2gndi2g02wrdqh";
      type = "gem";
    };
    version = "0.21.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  PoParser = {
    dependencies = ["simple_po_parser"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ldw5ba6xfn2k97n75n52qs4f0fy8xmn58c4247xf476nfvg035";
      type = "gem";
    };
    version = "3.2.6";
  };
  power_assert = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "17yx4bc0k182lhydwa8aqn0kx776kqymziydpb2szmxzx5q2sghx";
      type = "gem";
    };
    version = "2.0.2";
  };
  "promise.rb" = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a819sikcqvhi8hck1y10d1nv2qkjvmmm553626fmrh51h2i089d";
      type = "gem";
    };
    version = "0.7.4";
=======
      sha256 = "01z44m715rb6nzfrc90c5rkkdiy42dv3q94jw1q8baf9dg33nwi5";
      type = "gem";
    };
    version = "2.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m445x8fwcjdyv2bc0glzss2nbm1ll51bq45knixapc7cl3dzdlr";
      type = "gem";
    };
    version = "0.14.1";
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
  pry-rescue = {
    dependencies = ["interception" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wn72y8y3d3g0ng350ld92nyjln012432q2z2iy9lhwzjc4dwi65";
      type = "gem";
    };
    version = "1.5.2";
  };
  pry-stack_explorer = {
    dependencies = ["binding_of_caller" "pry"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h7kp99r8vpvpbvia079i58932qjz2ci9qhwbk7h1bf48ydymnx2";
      type = "gem";
    };
    version = "0.6.1";
  };
  public_suffix = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0hz0bx2qs2pwb0bwazzsah03ilpf3aai8b7lk7s35jsfzwbkjq35";
      type = "gem";
    };
    version = "5.0.1";
=======
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  puma = {
    dependencies = ["nio4r"];
    groups = ["puma"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0df9bknc2dllk8v9fhgidzbvbryaxa8fgifrk40cdz9csjsphbky";
      type = "gem";
    };
    version = "4.3.12";
  };
  pundit = {
    dependencies = ["activesupport"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1wb03yzy1j41822rbfh9nn77im3zh1f5v8di05cd8rsrdpws542b";
      type = "gem";
    };
    version = "2.3.0";
=======
      sha256 = "17z2f7w3syh3c04c8m1v9pvb9pfpymk8b5plszr5l24hx374xvsd";
      type = "gem";
    };
    version = "2.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  pundit-matchers = {
    dependencies = ["rspec-rails"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0hs0z7flj8yibk8jm5x7pnnfnl0rh0rhrvmq27b6pxvqxxvywsq3";
      type = "gem";
    };
    version = "1.8.4";
=======
      sha256 = "10kvf0pj5339fh3dgf9lvsv94d74x7x1wxdb0hp8a1ac7w5l6vmm";
      type = "gem";
    };
    version = "1.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  racc = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "09jgz6r0f7v84a7jz9an85q8vvmp743dqcsdm3z9c8rqcqv6pljq";
      type = "gem";
    };
    version = "1.6.2";
=======
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rack = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qgwkcb8kxns8d5187cxjaxf18b7dmg9gh6cr9c1125m0bj2pnfk";
      type = "gem";
    };
    version = "2.2.6.4";
=======
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rack-attack = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "049s3y3dpl6dn478g912y6f9nzclnnkl30psrbc2w5kaihj5szhq";
      type = "gem";
    };
    version = "6.6.1";
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
=======
      sha256 = "1rc6simyql7ax5zzp667x6krl0xxxh3asc1av6gcn8j6cyl86wsx";
      type = "gem";
    };
    version = "6.6.0";
  };
  rack-livereload = {
    dependencies = ["rack"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1slzlmvlapgp2pc7389i0zndq3nka0s6sh445vf21cxpz7vz3p5i";
      type = "gem";
    };
    version = "0.3.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0rjl709krgf499dhjdapg580l2qaj9d91pwzk8ck8fpnazlx1bdd";
      type = "gem";
    };
    version = "2.0.2";
=======
      sha256 = "0rh8h376mx71ci5yklnpqqn118z3bl67nnv5k801qaqn1zs62h8m";
      type = "gem";
    };
    version = "1.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rails = {
    dependencies = ["actioncable" "actionmailbox" "actionmailer" "actionpack" "actiontext" "actionview" "activejob" "activemodel" "activerecord" "activestorage" "activesupport" "railties" "sprockets-rails"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "07cs7qdkx6vwp66diwdy9g6mx52rsd8rxhbnsqf9bqam58g2aynj";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "1r9b9bxa7s3mw8dz8bl61pyazk880jmpngy3rkpyjc5cckawqbnb";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rails-controller-testing = {
    dependencies = ["actionpack" "actionview" "activesupport"];
    groups = ["development" "test"];
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
    groups = ["assets" "default" "development" "test"];
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
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1mcb75qvldfz6zsr4inrfx7dmb0ngxy507awx28khqmnla3hqpc9";
      type = "gem";
    };
    version = "1.4.4";
=======
      sha256 = "09qrfi3pgllxb08r024lln9k0qzxs57v0slsj8616xf9c0cwnwbk";
      type = "gem";
    };
    version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "method_source" "rake" "thor"];
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1d2snjnx1j848axppj2napy3zjgbka3fnw2528rcamhm6dp694nd";
      type = "gem";
    };
    version = "6.1.7.3";
=======
      sha256 = "03kwdd874sjaag082ia3zf4bng6dgsjk4nkkkn28l7n89i062ca3";
      type = "gem";
    };
    version = "6.0.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  raindrops = {
    groups = ["default" "unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wb2x51parf6v78w0cic90m33bdc92y5h8rj4wqs75dhw1b69hc7";
      type = "gem";
    };
    version = "0.20.0";
  };
  rake = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  rb-fsevent = {
<<<<<<< HEAD
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zmf31rnpm8553lqwibvv3kkx0v7majm1f341xbxc0bk5sbhp423";
      type = "gem";
    };
    version = "0.11.2";
=======
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06c50pvxib7wqnv6q0f3n7gzfcrp5chi3sa48hxpkfxc3hhy11fm";
      type = "gem";
    };
    version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  rchardet = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1isj1b3ywgg2m1vdlnr41lpvpm3dbyarf1lla4dfibfmad9csfk9";
      type = "gem";
    };
    version = "1.8.0";
  };
  redis = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0fikjg6j12ka6hh36dxzhfkpqqmilzjfzcdf59iwkzsgd63f0ziq";
      type = "gem";
    };
    version = "4.8.1";
=======
      sha256 = "1lhdfkl4r6dnhlr8jpz4a21ca6c76jfy7fj7gf4j2qpbh8ld8qyb";
      type = "gem";
    };
    version = "4.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  regexp_parser = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0d6241adx6drsfzz74nx1ld3394nm6fjpv3ammzr0g659krvgf7q";
      type = "gem";
    };
    version = "2.7.0";
=======
      sha256 = "155f6cr4rrfw5bs5xd3m5kfw32qhc5fsi4nk82rhif56rc6cs0wm";
      type = "gem";
    };
    version = "2.2.1";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rexml = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1ibb81slc35q5yp276sixp3yrvj9q92wlmi1glbnwlk6g49z8rn4";
      type = "gem";
    };
    version = "3.12.0";
=======
      sha256 = "118hkfw9b11hvvalr7qlylwal5h8dihagm9xg7k4gskg7587hca6";
      type = "gem";
    };
    version = "3.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qldsmjhqr4344zdlamzggr3y98wdk2c4hihkhwx8imk800gkl8v";
      type = "gem";
    };
    version = "3.12.0";
=======
      sha256 = "001ihayil7jpfxdlxlhakvz02kx0nk5m1w0bz6z8izdx0nc8bh53";
      type = "gem";
    };
    version = "3.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1yvwnb0x5d6d4ff3wlgahk0wcw72ic51gd2snr1xxc5ify41kabv";
      type = "gem";
    };
    version = "3.12.0";
=======
      sha256 = "0y38dc66yhnfcf4ky3k47c20xak1rax940s4a96qkjxqrniy5ys3";
      type = "gem";
    };
    version = "3.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0d3fnabkaw8n0na2dpnlg2xygggj51djzpj9x6y5rkiqbfyqwv01";
      type = "gem";
    };
    version = "6.0.1";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n6qc0d16h6bgh1xarmc8vc58728mgjcsjj8wcd822c8lcivl0b1";
      type = "gem";
    };
    version = "0.6.2";
=======
      sha256 = "0jj5zs9h2ll8iz699ac4bysih7y4csnf8h5h80bm6ppbf02ly8fa";
      type = "gem";
    };
    version = "5.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rspec-support = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "12y52zwwb3xr7h91dy9k3ndmyyhr3mjcayk0nnarnrzz8yr48kfx";
      type = "gem";
    };
    version = "3.12.0";
=======
      sha256 = "0xfk4pla77251n39zf4n792m1rhg5sn1kp63yvpvvysany34la03";
      type = "gem";
    };
    version = "3.11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rszr = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "080ykjdkviqi1l27pd7dzjvbrkf2ybfd89dlpkp7pp81kywbvzjw";
      type = "gem";
    };
    version = "1.3.0";
  };
  rubocop = {
    dependencies = ["json" "parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
=======
      sha256 = "0ns5qxdkgbqw1d52nz29lwx6xgs5bqwx1js1227n6l4q36g3snpp";
      type = "gem";
    };
    version = "0.5.2";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "rainbow" "regexp_parser" "rexml" "rubocop-ast" "ruby-progressbar" "unicode-display_width"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1jsiy93y5c2sx2sr5jmdah208idw038m2fpihgan4klmldm3r1pm";
      type = "gem";
    };
    version = "1.45.1";
=======
      sha256 = "03c6v6bfqdw8vnda0if0sx7aff0iq6xnv1adyfs0bi9msgggafcr";
      type = "gem";
    };
    version = "1.26.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rubocop-ast = {
    dependencies = ["parser"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
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
=======
      sha256 = "1bd2z82ly7fix8415gvfiwzb6bjialz5rs3sr72kv1lk68rd23wv";
      type = "gem";
    };
    version = "1.16.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rubocop-faker = {
    dependencies = ["faker" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05d2mpi8xq50xh1s53h75hgvdhcz76lv9cnfn4jg35nbg67j1pdz";
      type = "gem";
    };
    version = "1.1.0";
  };
<<<<<<< HEAD
  rubocop-graphql = {
    dependencies = ["rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hryrjmcl04br06ibjzzrbb2am8ybbhnl2l7w13xl3wz3k4jyjxs";
      type = "gem";
    };
    version = "0.19.0";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  rubocop-inflector = {
    dependencies = ["activesupport" "rubocop" "rubocop-rspec"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qdhwixqiix90a4n52g2b26mi66mrkx8b91pf7yda60m331jfbfr";
      type = "gem";
    };
    version = "0.2.1";
=======
      sha256 = "1v5ijrpvvibkzfdbih0c0rvfpvifirj2fmy237ph48r5q0xm1fzl";
      type = "gem";
    };
    version = "0.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rubocop-performance = {
    dependencies = ["rubocop" "rubocop-ast"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1n7g0vg06ldjaq4f8c11c7yqy99zng1qdrkkk4kfziippy24yxnc";
      type = "gem";
    };
    version = "1.16.0";
=======
      sha256 = "17ny81dy5gjrvris8mni7la8yjg57snphyg9nmvnc3al7yhwr74x";
      type = "gem";
    };
    version = "1.13.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rubocop-rails = {
    dependencies = ["activesupport" "rack" "rubocop"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1nxyifly45y7dfiaf0ql8aq7xykrg0sh1l7dxmn3sb9p2jd18140";
      type = "gem";
    };
    version = "2.17.4";
  };
  rubocop-rspec = {
    dependencies = ["rubocop" "rubocop-capybara"];
=======
      sha256 = "0vibx4jhpxaxa8w3wyhasskcgrxfjiyqdwrrc7l2lb0mbxqcs1ly";
      type = "gem";
    };
    version = "2.13.2";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1vmmin3ymgq7bhv2hl4pd0zpwawy709p816axc4vi67w61b4bij1";
      type = "gem";
    };
    version = "2.18.1";
=======
      sha256 = "051gq9pz49iv4gq34d3n089iaa6cb418n2fhin6gd6fpysbi3nf6";
      type = "gem";
    };
    version = "2.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
      sha256 = "1irn32sy9gx6xj9jxc28h7dax7vp9z8j6hjjfsb2f5hd4qz0z20x";
      type = "gem";
    };
    version = "1.14.0";
  };
  ruby2_keywords = {
    groups = ["default" "development" "test"];
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
  rubyzip = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grps9197qyxakbpw02pda59v45lfgbgiyw48i0mq9f2bn9y6mrz";
      type = "gem";
    };
    version = "2.3.2";
  };
  sassc = {
    dependencies = ["ffi"];
    groups = ["assets" "default"];
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
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d9djmwn36a5m8a83bpycs48g8kh1n2xkyvghn7dr6zwh4wdyksz";
      type = "gem";
    };
    version = "2.1.2";
  };
  selenium-webdriver = {
<<<<<<< HEAD
    dependencies = ["rexml" "rubyzip" "websocket"];
=======
    dependencies = ["childprocess" "rexml" "rubyzip"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1dkcyq2hfvf4wdj7q5cqqlka1dw6gz28dckxf4r17jmd53ymwg28";
      type = "gem";
    };
    version = "4.8.0";
=======
      sha256 = "17hilxa40cj7q48k6wcx1cbdb1v3q9c4nx89fji7gyqpcfm16vq7";
      type = "gem";
    };
    version = "4.1.0";
  };
  shellany = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
      type = "gem";
    };
    version = "0.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "11igjgh16dl5pwqizdmclzlzpv7mbmnh8fx7m9b5kfsjhwxqdfpn";
      type = "gem";
    };
    version = "5.3.0";
=======
      sha256 = "01svmyma958sbqfz0v29lbqbr0ibvgcng352nhx6bsc9k5c207d0";
      type = "gem";
    };
    version = "5.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  simple_oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dw9ii6m7wckml100xhjc6vxpjcry174lbi9jz5v7ibjr3i94y8l";
      type = "gem";
    };
    version = "0.3.1";
  };
  simple_po_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wybcipkfawg4pragmayiig03xc084x3hbwywsh1dr9x9pa8f9hj";
      type = "gem";
    };
    version = "1.1.6";
  };
<<<<<<< HEAD
  simpleidn = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06f7w6ph3bzzqk212yylfp4jfx275shgp9zg3xszbpv1ny2skp9m";
      type = "gem";
    };
    version = "0.2.1";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  slack-notifier = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001bipchr45sny33nlavqgxca9y1qqxa7xpi7pvjfqiybwzvm6nd";
      type = "gem";
    };
    version = "2.4.0";
  };
  slack-ruby-client = {
<<<<<<< HEAD
    dependencies = ["faraday" "faraday-mashify" "faraday-multipart" "gli" "hashie" "websocket-driver"];
=======
    dependencies = ["faraday" "faraday_middleware" "gli" "hashie" "websocket-driver"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "110rhsxxf0g4qdrhy1ahyfjg1hqqwwwf4rjn8vrrbvpfd04b8xa5";
      type = "gem";
    };
    version = "2.0.0";
=======
      sha256 = "0i067a99sr4m80gimcrymkic9da7zrszlfr87mhlgy5s7z4j70gw";
      type = "gem";
    };
    version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  snaky_hash = {
    dependencies = ["hashie" "version_gem"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cfwvdcr46pk0c7m5aw2w3izbrp1iba0q7l21r37mzpwaz0pxj0s";
      type = "gem";
    };
    version = "2.0.1";
=======
  spring = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ihmqcqylfx04bigg0fswmlvp0639f1j47kdir4g9lc76yw3c6ia";
      type = "gem";
    };
    version = "4.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    groups = ["assets"];
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
    groups = ["assets" "default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b9i14qb27zs56hlcc2hf139l0ghbqnjpmfi0054dxycaxvk5min";
      type = "gem";
    };
    version = "3.4.2";
  };
  tcr = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14678jlva69bxx24sz5i882x25h357xmbmqsichvq8vdiw2xf6aa";
      type = "gem";
    };
    version = "0.2.2";
  };
<<<<<<< HEAD
  telegram-bot-ruby = {
    dependencies = ["dry-struct" "faraday" "faraday-multipart" "zeitwerk"];
=======
  telegramAPI = {
    dependencies = ["rest-client"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1hbyr2c2i0bmyynchwg8nhxna64jr9xw6q5p8bxzj762hfj27gcj";
      type = "gem";
    };
    version = "1.0.0";
=======
      sha256 = "043blxqk5qps62jgjyr7hbf2y2fg5ldcmii8mxk09b3c6ps9ji6g";
      type = "gem";
    };
    version = "1.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  telephone_number = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1c5cnx7w3wp6ddsw84s131asfs6pr650fhwqhzwx2v3987d38kz1";
      type = "gem";
    };
    version = "1.4.19";
  };
  terser = {
    dependencies = ["execjs"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01c8wp7z6v71jqgn6fgi8wfw62488i4arxdjqjg8zkn0jsflyd8b";
      type = "gem";
    };
    version = "1.1.13";
=======
      sha256 = "0ai25w1g5g6lr6mz2yxma2px78gfx50bk66kbakkx0dczdybxd1r";
      type = "gem";
    };
    version = "1.4.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  test-unit = {
    dependencies = ["power_assert"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1rdhpdi8mlk7jwv9pxz3mhchpd5q93jxzijqhw334w5yv1ajl5hf";
      type = "gem";
    };
    version = "3.5.7";
=======
      sha256 = "0h0gpi3fggfa76sbm5kh48ma79z41yh6y7n3lxmaqrbf3zqyjlcw";
      type = "gem";
    };
    version = "3.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  thor = {
    groups = ["assets" "default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
  };
  thread_safe = {
<<<<<<< HEAD
    groups = ["default"];
=======
    groups = ["assets" "default" "development" "nulldb" "test"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    groups = ["assets" "default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "186nfbcsk0l4l86gvng1fw6jq6p6s7rc0caxr23b3pnbfb20y63v";
      type = "gem";
    };
    version = "2.0.11";
  };
  time = {
    dependencies = ["date"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13pzdsgf3v06mymzipcpa7p80shyw328ybn775nzpnhc6n8y9g30";
      type = "gem";
    };
    version = "0.2.2";
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
=======
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  twilio-ruby = {
    dependencies = ["faraday" "jwt" "nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1wn7ybr54i8p6rrg79k0z4pga4n91d9rvrlvwgms8mx3aq9dpbib";
      type = "gem";
    };
    version = "5.74.3";
=======
      sha256 = "0x8md052pya691vjzzvpmpf0j42m017p3d8xr2js6j5ir69iya0j";
      type = "gem";
    };
    version = "5.65.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  twitter = {
    dependencies = ["addressable" "buftok" "equalizer" "http" "http-form_data" "http_parser.rb" "memoizable" "multipart-post" "naught" "simple_oauth"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13dmkjgsnym1avym9f7y2i2h3mlk8crqvc87drrzr4f0sf9l8g2y";
      type = "gem";
    };
    version = "7.0.0";
  };
  tzinfo = {
<<<<<<< HEAD
    dependencies = ["concurrent-ruby"];
=======
    dependencies = ["thread_safe"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
  };
  tzinfo-data = {
    dependencies = ["tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0drm9pygji01pyimxq65ngdvgpn228g7fhffmrqw0xn7l2rdhclp";
      type = "gem";
    };
    version = "1.2022.7";
=======
      sha256 = "0zwqqh6138s8b321fwvfbywxy00lw1azw4ql3zr0xh1aqxf8cnvj";
      type = "gem";
    };
    version = "1.2.9";
  };
  uglifier = {
    dependencies = ["execjs"];
    groups = ["assets"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wgh7bzy68vhv9v68061519dd8samcy8sazzz0w3k8kqpy3g4s5f";
      type = "gem";
    };
    version = "4.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      type = "gem";
    };
    version = "0.0.8.2";
=======
      sha256 = "0jmbimpnpjdzz8hlrppgl9spm99qh3qzbx0b81k3gkgwba8nk3yd";
      type = "gem";
    };
    version = "0.0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  unicode-display_width = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1gi82k102q7bkmfi7ggn9ciypn897ylln1jk9q67kjhr39fj043a";
      type = "gem";
    };
    version = "2.4.2";
=======
      sha256 = "0csjm9shhfik0ci9mgimb7hf3xgh7nx45rkd9rzgdz6vkwr8rzxn";
      type = "gem";
    };
    version = "2.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    groups = ["unicorn"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h0gma14jjxiz6piyi6p99q7lya2mxrq79l03160hascvmx9ipa5";
      type = "gem";
    };
    version = "6.1.0";
  };
<<<<<<< HEAD
  uri = {
=======
  valid_email2 = {
    dependencies = ["activemodel" "mail"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1vigw7nfszfqgikr6n574k9bfh0rvs74z8xq46rz2zsm8249l8cc";
      type = "gem";
    };
    version = "0.12.1";
=======
      sha256 = "0mm92c0p2cgsydcn1va624yzpsdp9bnh24c68lw45j43rca88kq7";
      type = "gem";
    };
    version = "4.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  vcr = {
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xzd8f17mmcq9f6lxg4w0x4nd9pyp41lr77gjzxwynijzp8rcgjl";
      type = "gem";
    };
    version = "6.1.0";
  };
<<<<<<< HEAD
  version_gem = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v2vj7q1rk3wd7hdqa3i1d4hq7sfcgf55qc70g6dsichsbgacb9w";
      type = "gem";
    };
    version = "1.1.1";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  viewpoint = {
    dependencies = ["httpclient" "logging" "nokogiri" "rubyntlm"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14bvihfs0gzmam680xqqs07isxjk677yi3ph2pdvyyhhkbfys0l0";
      type = "gem";
    };
    version = "1.1.1";
  };
<<<<<<< HEAD
  vite_rails = {
    dependencies = ["railties" "vite_ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "035bjh0db28bgjx6hf01ykrrl4088gygnsva1x7asznzd9aq4669";
      type = "gem";
    };
    version = "3.0.14";
  };
  vite_ruby = {
    dependencies = ["dry-cli" "rack-proxy" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "119adbqdx4qb0hl5f34346j2w8a6z5xxy19wc6ad7bnc98v7l0hw";
      type = "gem";
    };
    version = "3.2.14";
  };
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1myj44wvbbqvv18ragv3ihl0h61acgnfwrnj3lccdgp49bgmbjal";
      type = "gem";
    };
    version = "3.18.1";
  };
  websocket = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dib6p55sl606qb4vpwrvj5wh881kk4aqn2zpfapf8ckx7g14jw8";
      type = "gem";
    };
    version = "1.2.9";
=======
      sha256 = "1l8vh8p0g92cqcvv0ra3mblsa4nczh0rz8nbwbkc3g3yzbva85xk";
      type = "gem";
    };
    version = "3.14.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a3bwxd9v3ghrxzjc4vxmf4xa18c6m4xqy5wb0yk5c6b9psc7052";
      type = "gem";
    };
    version = "0.7.5";
  };
  websocket-extensions = {
    groups = ["default" "development" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  writeexcel = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0waaf1drp17m5qdchxqlqzj51sfa9hxqccw7d71qdg73gzay1x34";
      type = "gem";
    };
    version = "1.0.5";
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
    groups = ["assets" "default" "development" "nulldb" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "028ld9qmgdllxrl7d0qkl65s58wb1n3gv8yjs28g43a8b1hplxk1";
      type = "gem";
    };
    version = "2.6.7";
  };
  zendesk_api = {
    dependencies = ["faraday" "faraday-multipart" "hashie" "inflection" "mini_mime" "multipart-post"];
=======
      sha256 = "09bq7j2p6mkbxnsg71s253dm2463kg51xc7bmjcxgyblqbh4ln7m";
      type = "gem";
    };
    version = "2.5.4";
  };
  zendesk_api = {
    dependencies = ["faraday" "hashie" "inflection" "mini_mime" "multipart-post"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0yizpglgfwml6a2w696m97d1q50hq3v0vldja431rv93s9sjbgly";
      type = "gem";
    };
    version = "1.38.0.rc1";
=======
      sha256 = "1sl5a01sl58pxxcx9qdvjwm04my1waysaik7y6l5564wbx4xczyr";
      type = "gem";
    };
    version = "1.35.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
