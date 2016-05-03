{
  ace-rails-ap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "082n12rkd9j7d89030nhmi4fx1gqaf13knps6cknsyvwix7fryvv";
      type = "gem";
    };
    version = "2.0.1";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "8cee5f2f1e58c8ada17cca696377443c0cbc9675df2b7eef97a04318876484b5";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "a22e1818f06b707433c9a76867932929751b5d57edbeacc258635a7b23da12cf";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "e8ce01cf6cc822ec023a15a856a0fae0e078ebb232b95b722c23af4117d2d635";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "cecb9bbc55292dee064ca479990c6e50fa3e2273aac6722ce058d18c22383026";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ce967be3086b34ae9fcbd919e714b2bdf72b8ab6e89b64aa74627267d93962";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "c2b1b6a4c6b8542c2464b457dce4cac4915efcbd3d5acfba57102e58474c33f2";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  activerecord-deprecated_finders = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03xplckz7v3nm6inqkwdd44h6gpbpql0v02jc1rz46a38rd6cj6m";
      type = "gem";
    };
    version = "1.0.4";
  };
  activerecord-nulldb-adapter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ym3paxp5lqr2kr4hkqj6xxqvgl57fv8jqhvgjfxb9lk7k5jlfmp";
      type = "gem";
    };
    version = "0.3.2";
  };
  activerecord-session_store = {
    dependencies = ["actionpack" "activerecord" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rp5q0q5i5syfgw7qpiq3a42x13p7myyv1c5hmnczpdlh57axs3p";
      type = "gem";
    };
    version = "0.1.2";
  };
  activesupport = {
    dependencies = ["i18n" "json" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "80ad345adf7e2b72c5d90753c0df91eacc34f4de02b34cfbf60bcf6c83483031";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bz0z8dlp3fjzah9y9b6rr9mkidsav9l4hdm51fnq1gd05yv3pr7";
      type = "gem";
    };
    version = "3.5.0";
  };
  addressable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1533axm85gpz267km9gnfarf9c78g2scrysd6b8yw33vmhkz2km6";
      type = "gem";
    };
    version = "2.3.8";
  };
  after_commit_queue = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jrhvj4335dsrj0xndbf7a7m2inbwbx1knc0bwgvmkk1w47l43s0";
      type = "gem";
    };
    version = "1.3.0";
  };
  akismet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hqpn25iyypkwkrqaibjm5nss5jmlkrddhia7frmz94prvyjr02w";
      type = "gem";
    };
    version = "2.0.0";
  };
  allocations = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iynf7gkbnbr5mgl2wgbgvxmjdiawh7ywwbnyjm94bj3pkybzgkc";
      type = "gem";
    };
    version = "1.0.4";
  };
  annotate = {
    dependencies = ["activerecord" "rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wdw9phsv2dndgid3pd8h0hl4zycwy11jc9iz6prwza0xax0i7hg";
      type = "gem";
    };
    version = "2.6.10";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a270mlajhrmpqbhxcqjqypnvgrq4pgixpv3w9gwp1wrrapnwrzk";
      type = "gem";
    };
    version = "6.0.3";
  };
  asana = {
    dependencies = ["faraday" "faraday_middleware" "faraday_middleware-multi_json" "oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1560p13g57pl4xqkmhwn1vpqhm7mw9fwmmswk38k3i2r7g0b5y9z";
      type = "gem";
    };
    version = "0.4.0";
  };
  asciidoctor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q9yhan2mkk1lh15zcfd9g2fn6faix9yrf5skg23dp1y77jv7vm0";
      type = "gem";
    };
    version = "1.5.3";
  };
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "102bywfxrv0w3n4s6lg25d7xxshd344sc7ijslqmganj5bany1pk";
      type = "gem";
    };
    version = "2.1.0";
  };
  astrolabe = {
    dependencies = ["parser"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ybbmjxaf529vvhrj4y8d4jpf87f3hgczydzywyg1d04gggjx7l7";
      type = "gem";
    };
    version = "1.3.1";
  };
  attr_encrypted = {
    dependencies = ["encryptor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hm2844qm37kflqq5v0x2irwasbhcblhp40qk10m3wlkj4m9wp8p";
      type = "gem";
    };
    version = "1.3.4";
  };
  attr_required = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pawa2i7gw9ppj6fq6y288da1ncjpzsmc6kx7z63mjjvypa5q3dc";
      type = "gem";
    };
    version = "1.0.0";
  };
  autoprefixer-rails = {
    dependencies = ["execjs" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m1w42ncz0p48r5hbyglayxkzrnplw18r99dc1ia2cb3nizkwllx";
      type = "gem";
    };
    version = "6.2.3";
  };
  awesome_print = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k85hckprq0s9pakgadf42k1d5s07q23m3y6cs977i6xmwdivyzr";
      type = "gem";
    };
    version = "1.2.0";
  };
  axiom-types = {
    dependencies = ["descendants_tracker" "ice_nine" "thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
      type = "gem";
    };
    version = "0.1.1";
  };
  babosa = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05rgxg4pz4bc4xk34w5grv0yp1j94wf571w84lf3xgqcbs42ip2f";
      type = "gem";
    };
    version = "1.0.2";
  };
  bcrypt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15cf7zzlj9b0xcx12jf8fmnpc8g1b0yhxal1yr5p7ny3mrz5pll6";
      type = "gem";
    };
    version = "3.1.10";
  };
  benchmark-ips = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh681m54qdsdyvpvflj1wpnj3ybspbpjkr4cnlrl4nk4yikli0j";
      type = "gem";
    };
    version = "2.3.0";
  };
  better_errors = {
    dependencies = ["coderay" "erubis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v0q8bdkqqlcsfqbk4wvc3qnz8an44mgz720v5f11a4nr413mjgf";
      type = "gem";
    };
    version = "1.0.1";
  };
  binding_of_caller = {
    dependencies = ["debug_inspector"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15jg6dkaq2nzcd602d7ppqbdxw3aji961942w93crs6qw4n6h9yk";
      type = "gem";
    };
    version = "0.7.2";
  };
  bootstrap-sass = {
    dependencies = ["autoprefixer-rails" "sass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12hhw42hk9clwfj6yz5v0c5p35wrn5yjnji7bnzsfs99vi2q00ld";
      type = "gem";
    };
    version = "3.3.6";
  };
  brakeman = {
    dependencies = ["erubis" "fastercsv" "haml" "highline" "multi_json" "ruby2ruby" "ruby_parser" "safe_yaml" "sass" "slim" "terminal-table"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15v13yizpvp1rm86raqggmsmm51v6p8fqw3pfgi6xpvx1ba06cfm";
      type = "gem";
    };
    version = "3.1.4";
  };
  browser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01bkb64w2ld2q5r3chc4f6spbjrmginyg8wlzg130zmx2z4jia2h";
      type = "gem";
    };
    version = "1.0.1";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
      type = "gem";
    };
    version = "3.2.2";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h3iaflcz5a1xr32bdb8sk4nx06yhh5d8y7w294w49xigfv4hzj3";
      type = "gem";
    };
    version = "4.14.10";
  };
  bundler-audit = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0msv3k2277y7al5lbnw7q9lmb5fnrscpkmsb36wpn189pdq0akfv";
      type = "gem";
    };
    version = "0.4.0";
  };
  byebug = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yx89b7vh5mbvxyi8n7zl25ia1bqdj71995m4daj6d41rnkmrpnc";
      type = "gem";
    };
    version = "8.2.1";
  };
  cal-heatmap-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrmcyj3iixkprqi9fb9vcn97wpp779sl5hxxgx57r3rb7l4d20w";
      type = "gem";
    };
    version = "3.5.1";
  };
  capybara = {
    dependencies = ["mime-types" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "114k4xi4nfbp3jfbxgwa3fksbwsyibx74gbdqpcgg3dxpmzkaa4f";
      type = "gem";
    };
    version = "2.4.4";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17v1wihr3aqrxhrwswkdpdklj1xsfcaksblh1y8hixvm9bqfyz3y";
      type = "gem";
    };
    version = "1.0.11";
  };
  carrierwave = {
    dependencies = ["activemodel" "activesupport" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b1av1ancby6brhmypl5k8xwrasd8bd3kqp9ri8kbq7z8nj6k445";
      type = "gem";
    };
    version = "0.9.0";
  };
  cause = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
      type = "gem";
    };
    version = "0.1";
  };
  CFPropertyList = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mjb46368z4hiax3fcsgxk14fxrhwnvcmakc2f5sx8nz0wvvkwg2";
      type = "gem";
    };
    version = "2.3.2";
  };
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jsl6k27wjmssxbwv9wpf7hgp9r0nvizcf6qpjnr7qs2nia53lf7";
      type = "gem";
    };
    version = "0.7.3";
  };
  chunky_png = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vf0axgrm95bs3y0x5gdb76xawfh210yxplj7jbwr6z7n88i1axn";
      type = "gem";
    };
    version = "1.3.5";
  };
  cliver = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "096f4rj7virwvqxhkavy0v55rax10r4jqf8cymbvn4n631948xc7";
      type = "gem";
    };
    version = "0.3.2";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "059wkzlap2jlkhg460pkwc1ay4v4clsmg1bp4vfzjzkgwdckr52s";
      type = "gem";
    };
    version = "1.1.0";
  };
  coercible = {
    dependencies = ["descendants_tracker"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
      type = "gem";
    };
    version = "1.0.0";
  };
  coffee-rails = {
    dependencies = ["coffee-script" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p3zhs44gsy1p90nmghihzfyl7bsk8kv6j3q7rj3bn74wg8w7nqs";
      type = "gem";
    };
    version = "4.1.0";
  };
  coffee-script = {
    dependencies = ["coffee-script-source" "execjs"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k4fg39rrkl3bpgchfj94fbl9s4ysaz16w8dkqncf2vyf79l3qz0";
      type = "gem";
    };
    version = "1.10.0";
  };
  colorize = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16bsjcqb6pg3k94dh1l5g3hhx5g2g4g8rlr76dnc78yyzjjrbayn";
      type = "gem";
    };
    version = "0.7.7";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qqdgcfkzv90nznrpsvg3cgg5xiqz4c8hnv7va5gm4fp4lf4k85v";
      type = "gem";
    };
    version = "1.0.0";
  };
  connection_pool = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b2bb3k39ni5mzcnqlv9y4yjkbin20s7dkwzp0jw2jf1rmzcgrmy";
      type = "gem";
    };
    version = "2.2.0";
  };
  coveralls = {
    dependencies = ["json" "rest-client" "simplecov" "term-ansicolor" "thor" "tins"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03vnvcw1fdmkp3405blcxpsjf89jxd2061474a32fchsmv2das9y";
      type = "gem";
    };
    version = "0.8.9";
  };
  crack = {
    dependencies = ["safe_yaml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  creole = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00rcscz16idp6dx0dk5yi5i0fz593i3r6anbn5bg2q07v3i025wm";
      type = "gem";
    };
    version = "0.5.0";
  };
  d3_rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12vxiiflnnkcxak2wmbajyf5wzmcv9wkl4drsp0am72azl8a6g9x";
      type = "gem";
    };
    version = "3.5.11";
  };
  daemons = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
      type = "gem";
    };
    version = "1.2.3";
  };
  database_cleaner = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n5r7kvsmknk876v3scdphfnvllr9157fa5q7j5fczg8j5qm6kf0";
      type = "gem";
    };
    version = "1.4.1";
  };
  debug_inspector = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109761g00dbrw5q0dfnbqg8blfm699z4jj70l4zrgf9mzn7ii50m";
      type = "gem";
    };
    version = "0.0.2";
  };
  debugger-ruby_core_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lp5dmm8a8dpwymv6r1y6yr24wxsj0gvgb2b8i7qq9rcv414snwd";
      type = "gem";
    };
    version = "1.3.8";
  };
  default_value_for = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z4lrba4y1c3y0rxw8321qbwsb3nr6c2igrpksfvz93yhc9m6xm0";
      type = "gem";
    };
    version = "3.0.1";
  };
  descendants_tracker = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
      type = "gem";
    };
    version = "0.0.4";
  };
  devise = {
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "thread_safe" "warden"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00h0xdl4a8pjpb0gbgy4w6q9j2mpczkmj23195zmjrg2b1gl8f2q";
      type = "gem";
    };
    version = "3.5.4";
  };
  devise-async = {
    dependencies = ["devise"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11llg7ggzpmg4lb9gh4sx55spvp98sal5r803gjzamps9crfq6mm";
      type = "gem";
    };
    version = "0.9.0";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v2wva971ds48af47rj4ywavlmz7qzbmf1jpf1l3xn3mscz52hln";
      type = "gem";
    };
    version = "2.0.1";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
      type = "gem";
    };
    version = "1.2.5";
  };
  diffy = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0il0ri511g9rm88qbvncbzgwc6wk6265hmnf7grcczmrs1z49vl0";
      type = "gem";
    };
    version = "3.0.7";
  };
  docile = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
      type = "gem";
    };
    version = "1.1.5";
  };
  domain_name = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16qvfrmcwlzz073aas55mpw2nhyhjcn96s524w0g1wlml242hjav";
      type = "gem";
    };
    version = "0.5.25";
  };
  doorkeeper = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wim84wkvx758cfb8q92w3hhvnfbwr990x1mmfv1ss1ivjz8fmm0";
      type = "gem";
    };
    version = "2.2.2";
  };
  dropzonejs-rails = {
    dependencies = ["rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vqqxzv6qdqy47m2q28adnmccfvc17p2bmkkaqjvrczrhvkkha64";
      type = "gem";
    };
    version = "0.7.2";
  };
  email_reply_parser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k2p229mv7xn7q627zwmvhrcvba4b9m70pw2jfjm6iimg2vmf22r";
      type = "gem";
    };
    version = "0.5.8";
  };
  email_spec = {
    dependencies = ["launchy" "mail"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00p1cc69ncrgg7m45va43pszip8anx5735w1lsb7p5ygkyw8nnpv";
      type = "gem";
    };
    version = "1.6.0";
  };
  encryptor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04wqqda081h7hmhwjjx1yqxprxjk8s5jgv837xqv1bpxiv7f4v1y";
      type = "gem";
    };
    version = "1.3.0";
  };
  equalizer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
      type = "gem";
    };
    version = "0.0.11";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  escape_utils = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hb8nmrgmd9n5dhih86fp91sf26mmw14sdn5vswg5g20svrqxc7x";
      type = "gem";
    };
    version = "1.1.0";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frvpk3p73xc64qkn0ymll3flvn4xcycq5yx8a43zd3gyzc1ifjp";
      type = "gem";
    };
    version = "1.0.8";
  };
  excon = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1shb4g3dhsfkywgjv6123yrvp2c8bvi8hqmq47iqa5lp72sn4b4w";
      type = "gem";
    };
    version = "0.45.4";
  };
  execjs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0grlxwiccbnflxs30r3h7g23xnps5knav1jyqkk3anvm8363ifjw";
      type = "gem";
    };
    version = "2.6.0";
  };
  expression_parser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1938z3wmmdabqxlh5d5c56xfg1jc6z15p7zjyhvk7364zwydnmib";
      type = "gem";
    };
    version = "0.9.0";
  };
  factory_girl = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13z20a4b7z1c8vbz0qz5ranssdprldwvwlgjmn38x311sfjmp9dz";
      type = "gem";
    };
    version = "4.3.0";
  };
  factory_girl_rails = {
    dependencies = ["factory_girl" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jj0yl6mfildb4g79dwgc1q5pv2pa65k9b1ml43mi8mg62j8mrhz";
      type = "gem";
    };
    version = "4.3.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kplqkpn2s2yl3lxdf6h7sfldqvkbkpxwwxhyk7mdhjplb5faqh6";
      type = "gem";
    };
    version = "0.9.2";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nxia26xzy8i56qfyz1bg8dg9yb26swpgci8n5jry8mh4bnx5r5h";
      type = "gem";
    };
    version = "0.10.0";
  };
  faraday_middleware-multi_json = {
    dependencies = ["faraday_middleware" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0651sxhzbq9xfq3hbpmrp0nbybxnm9ja3m97k386m4bqgamlvz1q";
      type = "gem";
    };
    version = "0.0.6";
  };
  fastercsv = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1df3vfgw5wg0s405z0pj0rfcvnl9q6wak7ka8gn0xqg4cag1k66h";
      type = "gem";
    };
    version = "1.5.5";
  };
  ffaker = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19fnbbsw87asyb1hvkr870l2yldah2jcjb8074pgyrma5lynwmn0";
      type = "gem";
    };
    version = "2.0.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
      type = "gem";
    };
    version = "1.9.10";
  };
  fission = {
    dependencies = ["CFPropertyList"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09pmp1j1rr8r3pcmbn2na2ls7s1j9ijbxj99xi3a8r6v5xhjdjzh";
      type = "gem";
    };
    version = "0.5.0";
  };
  flay = {
    dependencies = ["ruby_parser" "sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zcp9nmnfqixdcqa2dzwwjy5np4n2n16bj25gw7bbzbjp9hqzhn6";
      type = "gem";
    };
    version = "2.6.1";
  };
  flog = {
    dependencies = ["ruby_parser" "sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1asrcdj6gh5mxcimqak94jjyyi5cxnqn904lc8pmrljg1nv1bxpm";
      type = "gem";
    };
    version = "4.3.2";
  };
  flowdock = {
    dependencies = ["httparty" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrvg4gzgabf5mnnhccl8bwrkvn3y4pm7a1dqzqhpvfr4m5pafg";
      type = "gem";
    };
    version = "0.7.1";
  };
  fog = {
    dependencies = ["fog-aliyun" "fog-atmos" "fog-aws" "fog-brightbox" "fog-core" "fog-dynect" "fog-ecloud" "fog-google" "fog-json" "fog-local" "fog-powerdns" "fog-profitbricks" "fog-radosgw" "fog-riakcs" "fog-sakuracloud" "fog-serverlove" "fog-softlayer" "fog-storm_on_demand" "fog-terremark" "fog-vmfusion" "fog-voxel" "fog-xenserver" "fog-xml" "ipaddress" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ml31jdycqdm8w7w3l9pbyrgbnmrrnhmkppa2x4bwi9as1n1jmwq";
      type = "gem";
    };
    version = "1.36.0";
  };
  fog-aliyun = {
    dependencies = ["fog-core" "fog-json" "ipaddress" "xml-simple"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i76g8sdskyfc0gcnd6n9i757s7dmwg3wf6spcr2xh8wzyxkm1pj";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-atmos = {
    dependencies = ["fog-core" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aaxgnw9zy96gsh4h73kszypc32sx497s6bslvhfqh32q9d1y8c9";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-aws = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "ipaddress"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pzfahq8h3alfflb5dr8lm02q27x81vm96qn5zyfdlx86yy7bq96";
      type = "gem";
    };
    version = "0.8.1";
  };
  fog-brightbox = {
    dependencies = ["fog-core" "fog-json" "inflecto"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p7rbx587hb1d1am90dcr3zdp6y50c2zddh97yfgl62vji0pbkkd";
      type = "gem";
    };
    version = "0.10.1";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z91r3f5a64hlalm6h39v0778yl2kk3qvva0zvplpp9hpwbwzhl";
      type = "gem";
    };
    version = "1.35.0";
  };
  fog-dynect = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18lqmdkm22254z86jh3aa9v9vqk8bgbd3d1m0w7az3ij47ak7kch";
      type = "gem";
    };
    version = "0.0.2";
  };
  fog-ecloud = {
    dependencies = ["fog-core" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18rb4qjad9xwwqvvpj8r2h0hi9svy71pm4d3fc28cdcnfarmdi06";
      type = "gem";
    };
    version = "0.3.0";
  };
  fog-google = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z4vmswpqwph04c0wqzrscns1d1wdm8kbxx457bv156mawzrhfj3";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-json = {
    dependencies = ["fog-core" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0advkkdjajkym77r3c0bg2rlahl2akj0vl4p5r273k2qmi16n00r";
      type = "gem";
    };
    version = "1.0.2";
  };
  fog-local = {
    dependencies = ["fog-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5hxwzmc2ag3z9nlligsaf679kp2pz39cd8n2s9cmxaamnlh2s3";
      type = "gem";
    };
    version = "0.2.1";
  };
  fog-powerdns = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08zavzwfkk344gz83phz4sy9nsjznsdjsmn1ifp6ja17bvydlhh7";
      type = "gem";
    };
    version = "0.1.1";
  };
  fog-profitbricks = {
    dependencies = ["fog-core" "fog-xml" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "154sqs2dcmvg21v4m3fj8f09z5i70sq8a485v6rdygsffs8xrycn";
      type = "gem";
    };
    version = "0.0.5";
  };
  fog-radosgw = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nslgv8yp5qkiryj3zsm91gs7s6i626igj61kwxjjwk2yv6swyr6";
      type = "gem";
    };
    version = "0.0.5";
  };
  fog-riakcs = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbxc4dky3agfwrmgm1aqmi59p6vnvfnfbhhg7xpg4c2cf41whxm";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-sakuracloud = {
    dependencies = ["fog-core" "fog-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08krsn9sk5sx0aza812g31r169bd0zanb8pq5am3a64j6azarimd";
      type = "gem";
    };
    version = "1.7.5";
  };
  fog-serverlove = {
    dependencies = ["fog-core" "fog-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hxgmwzygrw25rbsy05i6nzsyr0xl7xj5j2sjpkb9n9wli5sagci";
      type = "gem";
    };
    version = "0.1.2";
  };
  fog-softlayer = {
    dependencies = ["fog-core" "fog-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zax2wws0q8pm787jnlxd2xlj23f2acz0s6jl5nzczyxjgll571r";
      type = "gem";
    };
    version = "1.0.3";
  };
  fog-storm_on_demand = {
    dependencies = ["fog-core" "fog-json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fif1x8ci095b2yyilf65n7x6iyvn448azrsnmwsdkriy8vxxv3y";
      type = "gem";
    };
    version = "0.1.1";
  };
  fog-terremark = {
    dependencies = ["fog-core" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lfkh9jppj0iknlklmwyb7ym3bfhkq58m3absb6rf5a5mcwi3lf";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-vmfusion = {
    dependencies = ["fission" "fog-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g0l0k9ylxk1h9pzqr6h2ba98fl47lpp3j19lqv4jxw0iw1rqxn4";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-voxel = {
    dependencies = ["fog-core" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10skdnj59yf4jpvq769njjrvh2l0wzaa7liva8n78qq003mvmfgx";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-xenserver = {
    dependencies = ["fog-core" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ngw8hh8ljk7wi0cp8n4b4jcy2acx0yqzjk7851m3mp0kji5dlgl";
      type = "gem";
    };
    version = "0.2.2";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1576sbzza47z48p0k9h1wg3rhgcvcvdd1dfz3xx1cgahwr564fqa";
      type = "gem";
    };
    version = "0.1.2";
  };
  font-awesome-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09x1bg98sp2v1lsg9h2bal915q811xq84h9d74p1f3378ga63c1x";
      type = "gem";
    };
    version = "4.5.0.0";
  };
  foreman = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1caz8mi7gq1hs4l1flcyyw1iw1bdvdbhppsvy12akr01k3s17xaq";
      type = "gem";
    };
    version = "0.78.0";
  };
  formatador = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
      type = "gem";
    };
    version = "0.2.5";
  };
  fuubar = {
    dependencies = ["rspec" "ruby-progressbar"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xwqs24y8s73aayh39si17kccsmr0bjgmi6jrjyfp7gkjb6iyhpv";
      type = "gem";
    };
    version = "2.0.0";
  };
  gemnasium-gitlab-service = {
    dependencies = ["rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qv7fkahmqkah3770ycrxd0x2ais4z41hb43a0r8q8wcdklns3m3";
      type = "gem";
    };
    version = "0.2.6";
  };
  gemojione = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0av60lajn64z1csmkzfaf5wvpd3x48lcshiknkqr8m0zx3sg7w3h";
      type = "gem";
    };
    version = "2.2.1";
  };
  get_process_mem = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "025f7v6bpbgsa2nr0hzv2riggj8qmzbwcyxfgjidpmwh5grh7j29";
      type = "gem";
    };
    version = "0.2.0";
  };
  gherkin-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ay7yiibf4sl9n94k7mbi4k5zj2igl4j71qcmkswv69znyx0sn1";
      type = "gem";
    };
    version = "0.3.2";
  };
  github-linguist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xxm2lbabkc1xmx2myv56a4fkw3wwg9n8w2bzwrl4s33kf6x62ag";
      type = "gem";
    };
    version = "4.7.5";
  };
  github-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01r901wcgn0gs0n9h684gs5n90y1vaj9lxnx4z5ig611jwa43ivq";
      type = "gem";
    };
    version = "1.3.3";
  };
  gitlab-flowdock-git-hook = {
    dependencies = ["flowdock" "gitlab-grit" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s3a10cdbh4xy732b92zcsm5zyc1lhi5v29d76j8mwbqmj11a2p8";
      type = "gem";
    };
    version = "1.0.1";
  };
  gitlab-grit = {
    dependencies = ["charlock_holmes" "diff-lcs" "mime-types" "posix-spawn"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nv8shx7w7fww8lf5a2rbvf7bq173rllm381m6x7g1i0qqc68q1b";
      type = "gem";
    };
    version = "2.7.3";
  };
  gitlab_emoji = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dy746icdmyc548mb5xkavvkn37pk7vv3gznx0p6hff325pan8dj";
      type = "gem";
    };
    version = "0.3.1";
  };
  gitlab_git = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0311dl4vh6h7k8xarmpr61fndrhbmfskzjzkkj1rr8321gn8znfv";
      type = "gem";
    };
    version = "8.2.0";
  };
  gitlab_meta = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14vahv7gblcypbvip845sg3lvawf3kij61mkxz5vyfcv23niqvp9";
      type = "gem";
    };
    version = "7.0";
  };
  gitlab_omniauth-ldap = {
    dependencies = ["net-ldap" "omniauth" "pyu-ruby-sasl" "rubyntlm"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbdyi57vvlrigyfhmqrnkw801x57fwa3gxvj1rj2bn9ig5186ri";
      type = "gem";
    };
    version = "1.2.1";
  };
  globalid = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "145xrpsfx1qqjy33r6qa588wb16dvdhxzj2aysh755vhg6hgm291";
      type = "gem";
    };
    version = "0.3.6";
  };
  gollum-grit_adapter = {
    dependencies = ["gitlab-grit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02c5qfq0s0kx2ifnpbnbgz6258fl7rchzzzc7vpx72shi8gbpac7";
      type = "gem";
    };
    version = "1.0.0";
  };
  gollum-lib = {
    dependencies = ["github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01s8pgzhc3cgcmsy6hh79wrcbn5vbadniq2a7d4qw87kpq7mzfdm";
      type = "gem";
    };
    version = "4.1.0";
  };
  gon = {
    dependencies = ["actionpack" "json" "multi_json" "request_store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f359cd9zsa4nrng35bij5skvjrj5ywn2dhmlg41b97vmza26bxr";
      type = "gem";
    };
    version = "6.0.1";
  };
  grape = {
    dependencies = ["activesupport" "builder" "hashie" "multi_json" "multi_xml" "rack" "rack-accept" "rack-mount" "virtus"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxfal5jspxq612jjkqbd7xgp5dswdyllbbfq6fj2m7s21pismmh";
      type = "gem";
    };
    version = "0.13.0";
  };
  grape-entity = {
    dependencies = ["activesupport" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hxghs2p9ncvdwhp6dwr1a74g552c49dd0jzy0szp4pg2xjbgjk8";
      type = "gem";
    };
    version = "0.4.8";
  };
  haml = {
    dependencies = ["tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mrzjgkygvfii66bbylj2j93na8i89998yi01fin3whwqbvx0m1p";
      type = "gem";
    };
    version = "4.0.7";
  };
  haml-rails = {
    dependencies = ["actionpack" "activesupport" "haml" "html2haml" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hbfznkxab663hxp1v6gpsa7sv6w1fnw9r8b3flixwylnwh3c5dz";
      type = "gem";
    };
    version = "0.9.0";
  };
  hashie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iv5hd0zcryprx9lbcm615r3afc0d6rhc27clywmhhgpx68k8899";
      type = "gem";
    };
    version = "3.4.3";
  };
  highline = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf5lgdn6ni2lpfdn4gk3gi47fmnca2bdirabbjbz1fk9w4p8lkr";
      type = "gem";
    };
    version = "1.7.8";
  };
  hike = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i6c9hrszzg3gn2j41v3ijnwcm8cc2931fnjiv6mnpl4jcjjykhm";
      type = "gem";
    };
    version = "1.2.3";
  };
  hipchat = {
    dependencies = ["httparty" "mimemagic"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hgy5jav479vbzzk53lazhpjj094dcsqw6w1d6zjn52p72bwq60k";
      type = "gem";
    };
    version = "1.5.2";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yckdlrn4v5d7bgl8mbffax16640pgg9ny693kqi4j7g17vx2q9l";
      type = "gem";
    };
    version = "1.11.0";
  };
  html2haml = {
    dependencies = ["erubis" "haml" "nokogiri" "ruby_parser"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "069zcy8lr010hn4qmbi8g5srdf69brk8nbgx4zcqcgbgsl4m8d4i";
      type = "gem";
    };
    version = "2.0.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
      type = "gem";
    };
    version = "1.0.2";
  };
  "http_parser.rb" = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fwf5d573j1sw52kz057dw0nx2wlivczmx6ybf6mk065n5g54kyn";
      type = "gem";
    };
    version = "0.5.3";
  };
  httparty = {
    dependencies = ["json" "multi_xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c9gvg6dqw2h3qyaxhrq1pzm6r69zfcmfh038wyhisqsd39g9hr2";
      type = "gem";
    };
    version = "0.13.7";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k6bqsaqq6c824vrbfb5pkz8bpk565zikd10w85rzj2dy809ik6c";
      type = "gem";
    };
    version = "2.7.0.1";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  ice_nine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i674zq0hl6rd0wcd12ni38linfja4k0y3mk5barjb4a6f7rcmkd";
      type = "gem";
    };
    version = "0.11.1";
  };
  inflecto = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "085l5axmvqw59mw5jg454a3m3gr67ckq9405a075isdsn7bm3sp4";
      type = "gem";
    };
    version = "0.0.2";
  };
  influxdb = {
    dependencies = ["cause" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vhg5nd88nwvfa76lqcczld916nljswwq6clsixrzi3js8ym9y1w";
      type = "gem";
    };
    version = "0.2.3";
  };
  ipaddress = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sl0ldvhd6j0qbwhz18w24qy65mdj448b2vhgh2cwn7xrkksmv9l";
      type = "gem";
    };
    version = "0.8.2";
  };
  jquery-atwho-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g8239cddyi48i5n0hq2acg9k7n7jilhby9g36zd19mwqyia16w9";
      type = "gem";
    };
    version = "1.3.2";
  };
  jquery-rails = {
    dependencies = ["rails-dom-testing" "railties" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "028dv2n0r2r8qj1bqcbzmih0hwzh5km6cvscn2808v5gd44z48r1";
      type = "gem";
    };
    version = "4.0.5";
  };
  jquery-scrollto-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12ic0zxw60ryglm1qjq5ralqd6k4jawmjj7kqnp1nkqds2nvinvp";
      type = "gem";
    };
    version = "1.4.3";
  };
  jquery-turbolinks = {
    dependencies = ["railties" "turbolinks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d23mnl3lgamk9ziw4yyv2ixck6d8s8xp4f9pmwimk0by0jq7xhc";
      type = "gem";
    };
    version = "2.1.0";
  };
  jquery-ui-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gfygrv4bjpjd2c377lw7xzk1b77rxjyy3w6wl4bq1gkqvyrkx77";
      type = "gem";
    };
    version = "5.0.5";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
      type = "gem";
    };
    version = "1.8.3";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0is8973si98rsry5igqdag2jb1knj6jhmfkr9r4mc5n0yvgr5n2q";
      type = "gem";
    };
    version = "1.5.2";
  };
  kaminari = {
    dependencies = ["actionpack" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14vx3kgssl4lv2kn6grr5v2whsynx5rbl1j9aqiq8nc3d7j74l67";
      type = "gem";
    };
    version = "0.16.3";
  };
  kgio = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y6wl3vpp82rdv5g340zjgkmy6fny61wib7xylyg0d09k5f26118";
      type = "gem";
    };
    version = "2.10.0";
  };
  launchy = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
      type = "gem";
    };
    version = "2.4.3";
  };
  letter_opener = {
    dependencies = ["launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kzbmc686hfh4jznyckq6g40kn14nhb71znsjjm0rc13nb3n0c5l";
      type = "gem";
    };
    version = "1.1.2";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182wd2pkf690ll19lx6zbk01a3rqkk5lwsyin6kwydl7lqxj5z3g";
      type = "gem";
    };
    version = "3.0.5";
  };
  loofah = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "109ps521p0sr3kgc460d58b4pr1z4mqggan2jbsf0aajy9s6xis8";
      type = "gem";
    };
    version = "2.0.3";
  };
  macaddr = {
    dependencies = ["systemu"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1clii8mvhmh5lmnm95ljnjygyiyhdpja85c5vy487rhxn52scn0b";
      type = "gem";
    };
    version = "1.7.1";
  };
  mail = {
    dependencies = ["mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
      type = "gem";
    };
    version = "2.6.3";
  };
  mail_room = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jpybhgw9yi50g422qvnwadn5jnj563vh70qaml5cxzdqxbd7fj1";
      type = "gem";
    };
    version = "0.6.1";
  };
  method_source = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
      type = "gem";
    };
    version = "0.8.2";
  };
  mime-types = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mhzsanmnzdshaba7gmsjwnv168r1yj8y0flzw88frw1cickrvw8";
      type = "gem";
    };
    version = "1.25.1";
  };
  mimemagic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "101lq4bnjs7ywdcicpw3vbz9amg5gbb4va1626fybd2hawgdx8d9";
      type = "gem";
    };
    version = "0.3.0";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056drbn5m4khdxly1asmiik14nyllswr6sh3wallvsywwdiryz8l";
      type = "gem";
    };
    version = "2.0.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rxqfakp629mp3vwda7zpgb57lcns5znkskikbfd0kriwv8i1vq8";
      type = "gem";
    };
    version = "5.7.0";
  };
  mousetrap-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00n13r5pwrk4vq018128vcfh021dw0fa2bk4pzsv0fslfm8ayp2m";
      type = "gem";
    };
    version = "1.4.6";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
      type = "gem";
    };
    version = "1.11.2";
  };
  multi_xml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i8r7dsz4z79z3j023l8swan7qpbgxbwwz11g38y2vjqjk16v4q8";
      type = "gem";
    };
    version = "0.5.5";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  mysql2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n075x14n9kziv0qdxqlzhf3j1abi1w6smpakfpsg4jbr8hnn5ip";
      type = "gem";
    };
    version = "0.3.20";
  };
  nested_form = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f053j4zfagxyym28msxj56hrpvmyv4lzxy2c5c270f7xbbnii5i";
      type = "gem";
    };
    version = "0.3.2";
  };
  net-ldap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z1j0zklbbx3vi91zcd2v0fnkfgkvq3plisa6hxaid8sqndyak46";
      type = "gem";
    };
    version = "0.12.1";
  };
  net-ssh = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dzqkgwi9xm6mbfk1rkk17rzmz8m5xakqi21w1b97ybng6kkw0hf";
      type = "gem";
    };
    version = "3.0.1";
  };
  netrc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
  newrelic_rpm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "155aj845rxn8ikcs15gphr8svnsrki8wzps794ddbi90h0ypr319";
      type = "gem";
    };
    version = "3.14.1.311";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11sbmpy60ynak6s3794q32lc99hs448msjy8rkp84ay7mq7zqspv";
      type = "gem";
    };
    version = "1.6.7.2";
  };
  nprogress-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylq2208i95661ba0p1ng2i38z4978ddwiidvpb614amfdq5pqvn";
      type = "gem";
    };
    version = "0.1.6.7";
  };
  oauth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k5j09p3al3clpjl6lax62qmhy43f3j3g7i6f9l4dbs6r5vpv95w";
      type = "gem";
    };
    version = "0.4.7";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zaa7qnvizv363apmxx9vxa8f6c6xy70z0jm0ydx38xvhxr8898r";
      type = "gem";
    };
    version = "1.0.0";
  };
  octokit = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vmknh0vz1g734q32kgpxv0qwz9ifmnw2jfpd2w5rrk6xwq1k7a8";
      type = "gem";
    };
    version = "3.8.0";
  };
  omniauth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vsqxgzkcfi10b7k6vpv3shmlphbs8grc29hznwl9s0i16n8962p";
      type = "gem";
    };
    version = "1.3.1";
  };
  omniauth-azure-oauth2 = {
    dependencies = ["jwt" "omniauth" "omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qay454zvyas8xfnfkycqpjkafaq5pw4gaji176cdfw0blhviz0s";
      type = "gem";
    };
    version = "0.0.6";
  };
  omniauth-bitbucket = {
    dependencies = ["multi_json" "omniauth" "omniauth-oauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lals2z1yixffrc97zh7zn1jpz9l6vpb3alcp13im42dq9q0g845";
      type = "gem";
    };
    version = "0.0.2";
  };
  omniauth-cas3 = {
    dependencies = ["addressable" "nokogiri" "omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13swm2hi2z63nvb2bps6g41kki8kr9b5c7014rk8259bxlpflrk7";
      type = "gem";
    };
    version = "1.1.3";
  };
  omniauth-facebook = {
    dependencies = ["omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0plj56sna4b6c71k03jsng6gq3r5yxhj7h26ndahc9caasgk869c";
      type = "gem";
    };
    version = "3.0.0";
  };
  omniauth-github = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbx3c8m1llhdxrqdciq8jh428bxj1nvf4yhziv2xqmqpjcqz617";
      type = "gem";
    };
    version = "1.1.2";
  };
  omniauth-gitlab = {
    dependencies = ["omniauth" "omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "083yyc8612kq8ygd8y7s8lxg2d51jcsakbs4pa19aww67gcm72iz";
      type = "gem";
    };
    version = "1.0.1";
  };
  omniauth-google-oauth2 = {
    dependencies = ["addressable" "jwt" "multi_json" "omniauth" "omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lm4fk6ig9vwzv7398qd861325g678sfr1iv2mm60xswl69964fi";
      type = "gem";
    };
    version = "0.2.10";
  };
  omniauth-kerberos = {
    dependencies = ["omniauth-multipassword" "timfel-krb5-auth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05xsv76qjxcxzrvabaar2bchv7435y8l2j0wk4zgchh3yv85kiq7";
      type = "gem";
    };
    version = "0.3.0";
  };
  omniauth-multipassword = {
    dependencies = ["omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qykp76hw80lkgb39hyzrv68hkbivc8cv0vbvrnycjh9fwfp1lv8";
      type = "gem";
    };
    version = "0.4.2";
  };
  omniauth-oauth = {
    dependencies = ["oauth" "omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n5vk4by7hkyc09d9blrw2argry5awpw4gbw1l4n2s9b3j4qz037";
      type = "gem";
    };
    version = "1.1.0";
  };
  omniauth-oauth2 = {
    dependencies = ["oauth2" "omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mskwlw5ibx9mz7ywqji6mm56ikf7mglbnfc02qhg6ry527jsxdm";
      type = "gem";
    };
    version = "1.3.1";
  };
  omniauth-saml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c7pypskq9y6wbl7c8gnp48j256snph11br3csgwvy9whjfisx65";
      type = "gem";
    };
    version = "1.4.2";
  };
  omniauth-shibboleth = {
    dependencies = ["omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8pwy23aybxhn545357zdjy0hnpfgldwqk5snmz9kxingpq12jl";
      type = "gem";
    };
    version = "1.2.1";
  };
  omniauth-twitter = {
    dependencies = ["json" "omniauth-oauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hqjpb1zx0pp3s12c83pkpk4kkx41f001jc5n8qz0h3wll0ld833";
      type = "gem";
    };
    version = "1.2.1";
  };
  omniauth_crowd = {
    dependencies = ["activesupport" "nokogiri" "omniauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12g5ck05h6kr9mnp870x8pkxsadg81ca70hg8n3k8xx007lfw2q7";
      type = "gem";
    };
    version = "2.2.3";
  };
  org-ruby = {
    dependencies = ["rubypants"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x69s7aysfiwlcpd9hkvksfyld34d8kxr62adb59vjvh8hxfrjwk";
      type = "gem";
    };
    version = "0.9.12";
  };
  orm_adapter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
      type = "gem";
    };
    version = "0.5.0";
  };
  paranoia = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z2smnnghjhcs4l5fkz9scs1kj0bvj2n8xmzcvw4rg9yprdnlxr0";
      type = "gem";
    };
    version = "2.1.4";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14db0gam24j04iprqz4m3hxygkb8h0plnbm0yk4k3lzq6j5wzcac";
      type = "gem";
    };
    version = "2.2.3.0";
  };
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dv4ma9xd75xpsnnwwg1yrpwpji7ydy0q1d9dl0yfqbzpidrw32";
      type = "gem";
    };
    version = "0.18.4";
  };
  poltergeist = {
    dependencies = ["capybara" "cliver" "multi_json" "websocket-driver"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ppm4isvbxm739508yjhvisq1iwp1q6h8dx4hkndj2krskavz4i9";
      type = "gem";
    };
    version = "1.8.1";
  };
  posix-spawn = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "052lnxbkvlnwfjw4qd7vn2xrlaaqiav6f5x5bcjin97bsrfq6cmr";
      type = "gem";
    };
    version = "0.3.11";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
  };
  pry = {
    dependencies = ["coderay" "method_source" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x78rvp69ws37kwig18a8hr79qn36vh8g1fn75p485y3b3yiqszg";
      type = "gem";
    };
    version = "0.10.3";
  };
  pry-rails = {
    dependencies = ["pry"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a2iinvabis2xmv0z7z7jmh7bbkkngxj2qixfdg5m6qj9x8k1kx6";
      type = "gem";
    };
    version = "0.3.4";
  };
  pyu-ruby-sasl = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcpjiz9lrvyb3rd8k8qni0v4ps08psympffyldmmnrqayyad0sn";
      type = "gem";
    };
    version = "0.0.3.3";
  };
  quiet_assets = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q4azw4j1xsgd7qwcig110mfdn1fm0y34y87zw9j9v187xr401b1";
      type = "gem";
    };
    version = "1.0.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09bs295yq6csjnkzj7ncj50i6chfxrhmzg1pk6p0vd2lb9ac8pj5";
      type = "gem";
    };
    version = "1.6.4";
  };
  rack-accept = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jdipx17b4ki33cfqvliapd31sbfvs4mv727awynr6v95a7n936";
      type = "gem";
    };
    version = "0.4.5";
  };
  rack-attack = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ihic8ar2ddfv15p5gia8nqzsl3y7iayg5v4rmg72jlvikgsabls";
      type = "gem";
    };
    version = "4.3.1";
  };
  rack-cors = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sz9d9gjmv2vjl3hddzk269hb1k215k8sp37gicphx82h3chk1kw";
      type = "gem";
    };
    version = "0.4.0";
  };
  rack-mount = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09a1qfaxxsll1kbgz7z0q0nr48sfmfm7akzaviis5bjpa5r00ld2";
      type = "gem";
    };
    version = "0.8.3";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "httpclient" "multi_json" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1szfnb74p5s7k0glpmiv16rfl4wx9mnrr7riapgpbcx163zzkxad";
      type = "gem";
    };
    version = "1.2.1";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails = {
    dependencies = ["actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activesupport" "railties" "sprockets-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "aa93c1b9eb8b535eee58280504e30237f88217699fe9bb016e458e5122eefa2e";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v8jl6803mbqpxh4hn0szj081q1a3ap0nb8ni0qswi7z4la844v8";
      type = "gem";
    };
    version = "1.0.7";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "138fd86kv073zqfx0xifm646w6bgw2lr8snk16lknrrfrss8xnm7";
      type = "gem";
    };
    version = "1.0.3";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "cfff64cbc0e409341003c35fa2e576e6a8cd8259a9894d09f15c6123be73f146";
      type = "gem";
    };
    version = "4.2.5.2";
  };
  rainbow = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dsnzfjiih2w8npsjab3yx1ssmmvmgjkbxny0i9yzrdy7whfw7b4";
      type = "gem";
    };
    version = "2.0.0";
  };
  raindrops = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hv0xhr762axywr937czi92fs0x3zk7k22vg6f4i7rr8d05sp560";
      type = "gem";
    };
    version = "0.15.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jcabbgnjc788chx31sihc5pgbqnlc1c75wakmqlbjdm8jns2m9b";
      type = "gem";
    };
    version = "10.5.0";
  };
  raphael-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sjiaymvfn4al5dr1pza5i142byan0fxnj4rymziyql2bzvdm2bc";
      type = "gem";
    };
    version = "2.1.2";
  };
  rb-fsevent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq57by28iv0ijz8pk9ynih0xdg7vnl1010xjcijfklrcv89a1j2";
      type = "gem";
    };
    version = "0.9.6";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kddx2ia0qylw3r52nhg83irkaclvrncgy2m1ywpbhlhsz1rymb9";
      type = "gem";
    };
    version = "0.9.5";
  };
  rblineprof = {
    dependencies = ["debugger-ruby_core_source"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m58kdjgncwf0h1qry3qk5h4bg8sj0idykqqijqcrr09mxfd9yc6";
      type = "gem";
    };
    version = "0.3.6";
  };
  rdoc = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v9k4sp5yzj2bshngckdvivj6bszciskk1nd2r3wri2ygs7vgqm8";
      type = "gem";
    };
    version = "3.12.2";
  };
  recaptcha = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190qqklirmi31s6ih7png4h9xmx1p5h2n5fi45z90y8hsp5w1sh1";
      type = "gem";
    };
    version = "1.0.2";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14i3wypp97bpk20679d1csy88q4hsgfqbnqw6mryl77m2g0d09pk";
      type = "gem";
    };
    version = "3.3.3";
  };
  RedCloth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06pahxyrckhgb7alsxwhhlx1ib2xsx33793finj01jk8i054bkxl";
      type = "gem";
    };
    version = "4.2.9";
  };
  redis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0255w9izzs04hw9wivn05yqiwi34w28ylxs0xvpmwc1vrh18fwcl";
      type = "gem";
    };
    version = "3.2.2";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jjl6dhhpdapdaywq5iqz7z36mwbw0cn0m30wcc5wcbv7xmiiygw";
      type = "gem";
    };
    version = "4.0.1";
  };
  redis-activesupport = {
    dependencies = ["activesupport" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10y3kybz21n2z11478sf0cp4xzclvxf0b428787brmgpc6i7p7zg";
      type = "gem";
    };
    version = "4.1.5";
  };
  redis-namespace = {
    dependencies = ["redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rp8gfkznfxqzxk9s976k71jnljkh0clkrhnp6vgx46s5yhj9g25";
      type = "gem";
    };
    version = "1.5.2";
  };
  redis-rack = {
    dependencies = ["rack" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y1mxx8gn0krdrpwllv7fqsbvki1qjnb2dz8b4q9gwc326829gk8";
      type = "gem";
    };
    version = "1.5.0";
  };
  redis-rails = {
    dependencies = ["redis-actionpack" "redis-activesupport" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0igww7hb58aq74mh50dli3zjg78b54y8nhd0h1h9vz4vgjd4q8m7";
      type = "gem";
    };
    version = "4.0.0";
  };
  redis-store = {
    dependencies = ["redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gf462p0wx4hn7m1m8ghs701n6xx0ijzm5cff9xfagd2s6va145m";
      type = "gem";
    };
    version = "1.1.7";
  };
  request_store = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01rxi2hw84y133z0r91jns4aaywd8d83wjq0xgb42iaicf0a90p9";
      type = "gem";
    };
    version = "1.2.1";
  };
  rerun = {
    dependencies = ["listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0av239bpmy55fdx4qaw9n71aapjy2myr51h5plzjxsyr0fdwn1xq";
      type = "gem";
    };
    version = "0.11.0";
  };
  responders = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i00bxp8fa67rzl50wfiaw16w21j5d5gwjjkdiwr0sw9q6ixmpz1";
      type = "gem";
    };
    version = "2.1.1";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
      type = "gem";
    };
    version = "1.8.0";
  };
  rinku = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jh6nys332brph55i6x6cil6swm086kxjw34wq131nl6mwryqp7b";
      type = "gem";
    };
    version = "1.7.3";
  };
  rotp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nzsc9hfxijnyzjbv728ln9dm80bc608chaihjdk63i2wi4m529g";
      type = "gem";
    };
    version = "2.1.1";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wp8as9ypdy18kdj9h70kny1rdfq71mr8cj2bpahr9vxjjvjasqz";
      type = "gem";
    };
    version = "1.10.1";
  };
  rqrcode = {
    dependencies = ["chunky_png"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "188n1mvc7klrlw30bai16sdg4yannmy7cz0sg0nvm6f1kjx5qflb";
      type = "gem";
    };
    version = "0.7.0";
  };
  rqrcode-rails3 = {
    dependencies = ["rqrcode"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i28rwmj24ssk91chn0g7qsnvn003y3s5a7jsrg3w4l5ckr841bg";
      type = "gem";
    };
    version = "0.1.7";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bn5zs71agc0zyns2r3c8myi5bxw3q7xnzp7f3v5b7hbil1qym4r";
      type = "gem";
    };
    version = "3.3.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw5qi936j6nz9fixi2mwy03f406761cd72bzyvd61pr854d7hy1";
      type = "gem";
    };
    version = "3.3.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d0b5hpkxlr9f3xpsbhvl3irnk4smmycx2xnmc8qv3pqaa7mb7ah";
      type = "gem";
    };
    version = "3.3.1";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lfbzscmpyixlbapxmhy2s69596vs1z00lv590l51hgdw70z92vg";
      type = "gem";
    };
    version = "3.3.2";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m66n9p3a7d3fmrzkbh8312prb6dhrgmp53g1amck308ranasv2a";
      type = "gem";
    };
    version = "3.3.3";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cyagig8slxjas8mbg5f8bl240b8zgr8mnjsvrznag1fwpkh4h27";
      type = "gem";
    };
    version = "3.3.0";
  };
  rubocop = {
    dependencies = ["astrolabe" "parser" "powerpack" "rainbow" "ruby-progressbar" "tins"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1grqda2fdknm43zyagh8gcmnhjkypyfw98q92hmvprprwghkq2sg";
      type = "gem";
    };
    version = "0.35.1";
  };
  ruby-fogbugz = {
    dependencies = ["crack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jj0gpkycbrivkh2q3429vj6mbgx6axxisg69slj3c4mgvzfgchm";
      type = "gem";
    };
    version = "0.2.1";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hynaavnqzld17qdx9r7hfw00y16ybldwq730zrqfszjwgi59ivi";
      type = "gem";
    };
    version = "1.7.5";
  };
  ruby-saml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "151jbak16y87dbj3ma2nc03rh37z7lixcwgaqahncq80rgnv45a8";
      type = "gem";
    };
    version = "1.1.1";
  };
  ruby2ruby = {
    dependencies = ["ruby_parser" "sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kmc0503s9mqnjyypx51wsi6zz9zj550ch43rag23wpj4qd6i6pm";
      type = "gem";
    };
    version = "2.2.0";
  };
  ruby_parser = {
    dependencies = ["sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rip6075b4k5a7s8w2klwc3jaqx31h69k004ac5nhl8y0ja92qvz";
      type = "gem";
    };
    version = "3.7.2";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04l8686hl0829x4acsnbz0licf8n6794p7shz8iyahin1jnqg3d7";
      type = "gem";
    };
    version = "0.5.2";
  };
  rubypants = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vpdkrc4c8qhrxph41wqwswl28q5h5h994gy4c1mlrckqzm3hzph";
      type = "gem";
    };
    version = "0.2.0";
  };
  rufus-scheduler = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04bmvvvri7ni7dvlq3gi1y553f6rp6bw2kmdfp9ny5bh3l7qayrh";
      type = "gem";
    };
    version = "3.1.10";
  };
  rugged = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v0cvdw8cgy1hf5h3cx796zpxhbad8d5cm50nykyhwjc00q80zrr";
      type = "gem";
    };
    version = "0.24.0b13";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  sanitize = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xsv6xqrlz91rd8wifjknadbl3z5h6qphmxy0hjb189qbdghggn3";
      type = "gem";
    };
    version = "2.1.0";
  };
  sass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04rpdcp258arh2wgdk9shbqnzd6cbbbpi3wpi9a0wby8awgpxmyf";
      type = "gem";
    };
    version = "3.4.20";
  };
  sass-rails = {
    dependencies = ["railties" "sass" "sprockets" "sprockets-rails" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f6357vw944w2ayayqmz8ai9myl6xbnry06sx5b5ms4r9lny8hj8";
      type = "gem";
    };
    version = "5.0.4";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fk43bzwn816qj1ksiicm2i1kmzv5675cmnvk57kmfmi4rfsyjpy";
      type = "gem";
    };
    version = "0.6.0";
  };
  sdoc = {
    dependencies = ["json" "rdoc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17l8qk0ld47z4h5avcnylvds8nc6dp25zc64w23z8li2hs341xf2";
      type = "gem";
    };
    version = "0.3.20";
  };
  seed-fu = {
    dependencies = ["activerecord" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11xja82yxir1kwccrzng29h7w911i9j0xj2y7y949yqnw91v12vw";
      type = "gem";
    };
    version = "2.3.5";
  };
  select2-rails = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ni2k74n73y3gv56gs37gkjlh912szjf6k9j483wz41m3xvlz7fj";
      type = "gem";
    };
    version = "3.5.9.3";
  };
  sentry-raven = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iqnwfmf6rnpgrvl3c8gh2gkix91nhm21j5qf389g4mi2rkc0ky8";
      type = "gem";
    };
    version = "0.15.6";
  };
  settingslogic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ria5zcrk1nf0b9yia15mdpzw0dqr6wjpbj8dsdbbps81lfsj9ar";
      type = "gem";
    };
    version = "2.0.9";
  };
  sexp_processor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gxlcpg81wfjf5gpggf8h6l2dbq3ikgavbrr2yfw3m2vqy88yjg2";
      type = "gem";
    };
    version = "4.6.0";
  };
  sham_rack = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zs6hpgg87x5jrykjxgfp2i7m5aja53s5kamdhxam16wki1hid3i";
      type = "gem";
    };
    version = "1.3.6";
  };
  shoulda-matchers = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d3ryqcsk1n9y35bx5wxnqbgw4m8b3c79isazdjnnbg8crdp72d0";
      type = "gem";
    };
    version = "2.8.0";
  };
  sidekiq = {
    dependencies = ["concurrent-ruby" "connection_pool" "json" "redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x7jfc2va0x6fcfffdf0wdiyk4krjw8053jzwffa63wkqr5jvg3y";
      type = "gem";
    };
    version = "4.0.1";
  };
  sidekiq-cron = {
    dependencies = ["redis-namespace" "rufus-scheduler" "sidekiq"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnbvh8kjv6954vsiwfcpp7bn8sgpwvnyapnq7b94w8h7kj3ykqy";
      type = "gem";
    };
    version = "0.4.0";
  };
  simple_oauth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb06p88xsdw4fxll1ikv5i5k58sl6y323ss0wp1hqjm3xw1jgvj";
      type = "gem";
    };
    version = "0.1.9";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q2iq2vgrdvvla5y907gkmqx6ry2qvnvc7a90hlcbwgp1w0sv6z4";
      type = "gem";
    };
    version = "0.10.0";
  };
  simplecov-html = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qni8g0xxglkx25w54qcfbi4wjkpvmb28cb7rj5zk3iqynjcdrqf";
      type = "gem";
    };
    version = "0.10.0";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
      type = "gem";
    };
    version = "1.4.6";
  };
  six = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bhapiyjh5r5qjpclfw8i65plvy6k2q4azr5xir63xqglr53viw3";
      type = "gem";
    };
    version = "0.2.0";
  };
  slack-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08z6fv186yw1nrpl6zwp3lwqksin145aa1jv6jf00bnv3sicliiz";
      type = "gem";
    };
    version = "1.2.1";
  };
  slim = {
    dependencies = ["temple" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1szs71hh0msm5gj6qbcxw44m3hqnwybx4yh02scwixnwg576058k";
      type = "gem";
    };
    version = "3.0.6";
  };
  slop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
      type = "gem";
    };
    version = "3.6.0";
  };
  spinach = {
    dependencies = ["colorize" "gherkin-ruby" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0phfjs4iw2iqxdaljzwk6qxmi2x86pl3hirmpgw2pgfx76wfx688";
      type = "gem";
    };
    version = "0.8.10";
  };
  spinach-rails = {
    dependencies = ["capybara" "railties" "spinach"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nfacfylkncfgi59g2wga6m4nzdcjqb8s50cax4nbx362ap4bl70";
      type = "gem";
    };
    version = "0.2.1";
  };
  spring = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xvz2x6nvza5i53p7mddnf11j2wshqmbaphi6ngd6nar8v35y0k1";
      type = "gem";
    };
    version = "1.3.6";
  };
  spring-commands-rspec = {
    dependencies = ["spring"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
      type = "gem";
    };
    version = "1.0.4";
  };
  spring-commands-spinach = {
    dependencies = ["spring"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "138jardqyj96wz68njdgy55qjbpl2d0g8bxbkz97ndaz3c2bykv9";
      type = "gem";
    };
    version = "1.0.0";
  };
  spring-commands-teaspoon = {
    dependencies = ["spring"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7n4m2s9d0frh7y1xibzpphqajfnx4fvgfc66nh545dd91w2nqz";
      type = "gem";
    };
    version = "0.0.2";
  };
  sprockets = {
    dependencies = ["hike" "multi_json" "rack" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15818683yz27w4hgywccf27n91azy9a4nmb5qkklzb08k8jw9gp3";
      type = "gem";
    };
    version = "2.12.4";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vsl6ryxdjpp97nl4ghhk1v6p50zh3sx9qv81bhmlffc234r91wn";
      type = "gem";
    };
    version = "2.3.3";
  };
  state_machines = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xg84kdglz0k1pshf2q604zybjpribzcz2b651sc1j27kd86w787";
      type = "gem";
    };
    version = "0.4.0";
  };
  state_machines-activemodel = {
    dependencies = ["activemodel" "state_machines"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bshcm53v2vfpapvhws1h0dq1h4f3p6bvpdkjpydb52a3m0w2z0y";
      type = "gem";
    };
    version = "0.3.0";
  };
  state_machines-activerecord = {
    dependencies = ["activerecord" "state_machines-activemodel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10dplkn4cm49xby8s0sn7wxww4hnxi4dgikfsmhp1rbsa24d76vx";
      type = "gem";
    };
    version = "0.3.0";
  };
  stringex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "150adm7rfh6r9b5ra6vk75mswf9m3wwyslcf8f235a08m29fxa17";
      type = "gem";
    };
    version = "2.5.2";
  };
  systemu = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gmkbakhfci5wnmbfx5i54f25j9zsvbw858yg3jjhfs5n4ad1xq1";
      type = "gem";
    };
    version = "2.6.5";
  };
  task_list = {
    dependencies = ["html-pipeline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iv1fizb04463c4mp4gxd8v0414fhvmiwvwvjby5b9qq79d8zwab";
      type = "gem";
    };
    version = "1.0.2";
  };
  teaspoon = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cprz18vgf0jgcggcxf4pwx8jcwbiyj1p0dnck5aavlvaxaic58s";
      type = "gem";
    };
    version = "1.0.2";
  };
  teaspoon-jasmine = {
    dependencies = ["teaspoon"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00wygrv1jm4aj15p1ab9d5fdrj6y83kv26xgp52mx4lp78h2ms9q";
      type = "gem";
    };
    version = "2.2.0";
  };
  temple = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ysraljv7lkb04z5vdyrkijab7j1jzj1mgz4bj82744dp7d0rhb0";
      type = "gem";
    };
    version = "0.7.6";
  };
  term-ansicolor = {
    dependencies = ["tins"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ydbbyjmk5p7fsi55ffnkq79jnfqx65c3nj8d9rpgl6sw85ahyys";
      type = "gem";
    };
    version = "1.3.2";
  };
  terminal-table = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6qyj9ir1agbbi32li9c0c34dcl0klyxqif6mxy0dbvq7kqfp8f";
      type = "gem";
    };
    version = "1.5.2";
  };
  test_after_commit = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fzg8qan6f0n0ynr594bld2k0rwwxj99yzhiga2f3pkj9ina1abb";
      type = "gem";
    };
    version = "0.4.2";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pyc602sa8fqwjyssn9yvf3fqrr14jk7hj9hsjlan1mq4zvim1lf";
      type = "gem";
    };
    version = "1.6.4";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
      type = "gem";
    };
    version = "0.19.1";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
      type = "gem";
    };
    version = "0.3.5";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
      type = "gem";
    };
    version = "1.4.1";
  };
  timfel-krb5-auth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105vajc0jkqgcx1wbp0ad262sdry4l1irk7jpaawv8vzfjfqqf5b";
      type = "gem";
    };
    version = "0.8.3";
  };
  tinder = {
    dependencies = ["eventmachine" "faraday" "faraday_middleware" "hashie" "json" "mime-types" "multi_json" "twitter-stream"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kwj0wd540wb2ws86d3jdva175dx00w2j8lyrvbb6qli3g27byd7";
      type = "gem";
    };
    version = "1.10.1";
  };
  tins = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02qarvy17nbwvslfgqam8y6y7479cwmb1a6di9z18hzka4cf90hz";
      type = "gem";
    };
    version = "1.6.0";
  };
  turbolinks = {
    dependencies = ["coffee-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ddrx25vvvqxlz4h59lrmjhc2bfwxf4bpicvyhgbpjd48ckj81jn";
      type = "gem";
    };
    version = "2.5.3";
  };
  twitter-stream = {
    dependencies = ["eventmachine" "http_parser.rb" "simple_oauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0is81g3xvnjk64sqiaqlh2ziwfryzwvk1yvaniryg0zhppgsyriq";
      type = "gem";
    };
    version = "0.1.16";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
      type = "gem";
    };
    version = "1.2.2";
  };
  uglifier = {
    dependencies = ["execjs" "json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mzs64z3m1b98rh6ssxpqfz9sc87f6ml6906b0m57vydzfgrh1cz";
      type = "gem";
    };
    version = "2.7.2";
  };
  underscore-rails = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iyspb7s49wpi9cc314gvlkyn45iyfivzxhdw0kql1zrgllhlzfk";
      type = "gem";
    };
    version = "1.8.3";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ly2ms6c3irmbr1575ldyh52bz2v0lzzr2gagf0p526k12ld2n5b";
      type = "gem";
    };
    version = "0.0.7.1";
  };
  unicorn = {
    dependencies = ["kgio" "rack" "raindrops"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kpg2vikx2hxdyrl45bqcr89a0w59hfw7yn7xh87bmlczi34xds4";
      type = "gem";
    };
    version = "4.8.3";
  };
  unicorn-worker-killer = {
    dependencies = ["get_process_mem" "unicorn"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rrdxpwdsapx47axjin8ymxb4f685qlpx8a26bql4ay1559c3gva";
      type = "gem";
    };
    version = "0.4.4";
  };
  uniform_notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "009z60qx01am7klmrca8pcladrynljra3a9smifn9f81r4dc7q63";
      type = "gem";
    };
    version = "1.9.0";
  };
  uuid = {
    dependencies = ["macaddr"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gr2mxg27l380wpiy66mgv9wq02myj6m4gmp6c4g1vsbzkh0213v";
      type = "gem";
    };
    version = "2.3.8";
  };
  version_sorter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lad9c43w2xfzmva57ia6glpmhyivyk1m79jli42canshvan5v6y";
      type = "gem";
    };
    version = "2.0.0";
  };
  virtus = {
    dependencies = ["axiom-types" "coercible" "descendants_tracker" "equalizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06iphwi3c4f7y9i2rvhvaizfswqbaflilziz4dxqngrdysgkn1fk";
      type = "gem";
    };
    version = "1.0.5";
  };
  warden = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iyxw1ms3930dh7vcrfyi4ifpdbkfsr8k7fzjryva0r7k3c71gb7";
      type = "gem";
    };
    version = "1.2.4";
  };
  web-console = {
    dependencies = ["activemodel" "binding_of_caller" "railties" "sprockets-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rwps8m76j45iqhggm810j78i8bg4nqzgi8k7amxplik2zm5blf";
      type = "gem";
    };
    version = "2.2.1";
  };
  webmock = {
    dependencies = ["addressable" "crack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p7hqdxk5359xwp59pcx841fhbnqx01ra98rnwhdyz61nrc6piv3";
      type = "gem";
    };
    version = "1.21.0";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v39w1ig6ps8g55xhz6x1w53apl17ii6kpy0jg9249akgpdvb0k9";
      type = "gem";
    };
    version = "0.6.3";
  };
  websocket-extensions = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07qnsafl6203a2zclxl20hy4jq11c471cgvd0bj5r9fx1qqw06br";
      type = "gem";
    };
    version = "0.1.2";
  };
  wikicloth = {
    dependencies = ["builder" "expression_parser" "rinku"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jp6c2yzyqbap8jdiw8yz6l08sradky1llhyhmrg934l1b5akj3s";
      type = "gem";
    };
    version = "0.8.1";
  };
  xml-simple = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
      type = "gem";
    };
    version = "1.1.5";
  };
  xpath = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04kcr127l34p7221z13blyl0dvh0bmxwx326j72idayri36a394w";
      type = "gem";
    };
    version = "2.0.0";
  };
}