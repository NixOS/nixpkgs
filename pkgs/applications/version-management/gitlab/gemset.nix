{
  "CFPropertyList" = {
    version = "2.3.1";
    source = {
      type = "gem";
      sha256 = "1wnk3gxnhfafbhgp0ic7qhzlx3lhv04v8nws2s31ii5s8135hs6k";
    };
  };
  "RedCloth" = {
    version = "4.2.9";
    source = {
      type = "gem";
      sha256 = "06pahxyrckhgb7alsxwhhlx1ib2xsx33793finj01jk8i054bkxl";
    };
  };
  "ace-rails-ap" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "082n12rkd9j7d89030nhmi4fx1gqaf13knps6cknsyvwix7fryvv";
    };
  };
  "actionmailer" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "0p1hydjf5vb4na4fs29v7cdknfq3d6qvmld2vbafbh78kkclxi2m";
    };
    dependencies = [
      "actionpack"
      "actionview"
      "mail"
    ];
  };
  "actionpack" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "19bryymqlapsvn9df6q2ba4hvw9dwpp4fjc7i6lwffkadc4snkjy";
    };
    dependencies = [
      "actionview"
      "activesupport"
      "rack"
      "rack-test"
    ];
  };
  "actionview" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "1bv8qifaqa514z64zgfw3r4i120h2swwgpfk79xlrac21q6ps70n";
    };
    dependencies = [
      "activesupport"
      "builder"
      "erubis"
    ];
  };
  "activemodel" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "16429dg04s64g834svi7ghq486adr32gxr5p9kac2z6mjp8ggjr3";
    };
    dependencies = [
      "activesupport"
      "builder"
    ];
  };
  "activerecord" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "1w3dbmbdk4whm5p1l6d2ky3xpl59lfcr9p3hwd41dz77ynpi5dr5";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "arel"
    ];
  };
  "activerecord-deprecated_finders" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "03xplckz7v3nm6inqkwdd44h6gpbpql0v02jc1rz46a38rd6cj6m";
    };
  };
  "activerecord-session_store" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "15dgx7jjp8iqqzjq2q3a6fsmnhvjwspbsz1s1gd6zp744k6xbrjh";
    };
    dependencies = [
      "actionpack"
      "activerecord"
      "railties"
    ];
  };
  "activeresource" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "0fc5igjijyjzsl9q5kybkdzhc92zv8wsv0ifb0y90i632jx6d4jq";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "rails-observers"
    ];
  };
  "activesupport" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "166jvrmdwayacnrd4z3rs2d6y0av3xnc18k6120ah13c2ipw69hn";
    };
    dependencies = [
      "i18n"
      "json"
      "minitest"
      "thread_safe"
      "tzinfo"
    ];
  };
  "acts-as-taggable-on" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "0bz0z8dlp3fjzah9y9b6rr9mkidsav9l4hdm51fnq1gd05yv3pr7";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "addressable" = {
    version = "2.3.8";
    source = {
      type = "gem";
      sha256 = "1533axm85gpz267km9gnfarf9c78g2scrysd6b8yw33vmhkz2km6";
    };
  };
  "after_commit_queue" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0m7qwbzvxb2xqramf38pzg8ld91s4cy2v0fs26dnmnqr1jf11z4y";
    };
    dependencies = [
      "rails"
    ];
  };
  "annotate" = {
    version = "2.6.10";
    source = {
      type = "gem";
      sha256 = "1wdw9phsv2dndgid3pd8h0hl4zycwy11jc9iz6prwza0xax0i7hg";
    };
    dependencies = [
      "activerecord"
      "rake"
    ];
  };
  "arel" = {
    version = "5.0.1.20140414130214";
    source = {
      type = "gem";
      sha256 = "0dhnc20h1v8ml3nmkxq92rr7qxxpk6ixhwvwhgl2dbw9mmxz0hf9";
    };
  };
  "asana" = {
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "1x325pywh3d91qrg916gh8i5g13h4qzgi03zc93x6v4m4rj79dcp";
    };
    dependencies = [
      "activeresource"
    ];
  };
  "asciidoctor" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "0hs99bjvnf1nw49nwq62mi5x65x2jlvwqa0xllsi3zfikafsm1y9";
    };
  };
  "ast" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "102bywfxrv0w3n4s6lg25d7xxshd344sc7ijslqmganj5bany1pk";
    };
  };
  "astrolabe" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "0ybbmjxaf529vvhrj4y8d4jpf87f3hgczydzywyg1d04gggjx7l7";
    };
    dependencies = [
      "parser"
    ];
  };
  "attr_encrypted" = {
    version = "1.3.4";
    source = {
      type = "gem";
      sha256 = "1hm2844qm37kflqq5v0x2irwasbhcblhp40qk10m3wlkj4m9wp8p";
    };
    dependencies = [
      "encryptor"
    ];
  };
  "attr_required" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0pawa2i7gw9ppj6fq6y288da1ncjpzsmc6kx7z63mjjvypa5q3dc";
    };
  };
  "autoprefixer-rails" = {
    version = "5.2.1.2";
    source = {
      type = "gem";
      sha256 = "129kr8hiyzcnj4x3n14nnp7f7scps9v3d690i7fjzpq8i4n9gz8g";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
  "awesome_print" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1k85hckprq0s9pakgadf42k1d5s07q23m3y6cs977i6xmwdivyzr";
    };
  };
  "axiom-types" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "10q3k04pll041mkgy0m5fn2b1lazm6ly1drdbcczl5p57lzi3zy1";
    };
    dependencies = [
      "descendants_tracker"
      "ice_nine"
      "thread_safe"
    ];
  };
  "bcrypt" = {
    version = "3.1.10";
    source = {
      type = "gem";
      sha256 = "15cf7zzlj9b0xcx12jf8fmnpc8g1b0yhxal1yr5p7ny3mrz5pll6";
    };
  };
  "better_errors" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0v0q8bdkqqlcsfqbk4wvc3qnz8an44mgz720v5f11a4nr413mjgf";
    };
    dependencies = [
      "coderay"
      "erubis"
    ];
  };
  "binding_of_caller" = {
    version = "0.7.2";
    source = {
      type = "gem";
      sha256 = "15jg6dkaq2nzcd602d7ppqbdxw3aji961942w93crs6qw4n6h9yk";
    };
    dependencies = [
      "debug_inspector"
    ];
  };
  "bootstrap-sass" = {
    version = "3.3.5";
    source = {
      type = "gem";
      sha256 = "0gnbl3jfi7x491kb5b2brhqr981wzg6r9sc907anhq9y727d96iv";
    };
    dependencies = [
      "autoprefixer-rails"
      "sass"
    ];
  };
  "brakeman" = {
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "0c3pwqhan5qpkmymmp4zpr6j1v3xrvvla9adsd0z9nx1dbc7llry";
    };
    dependencies = [
      "erubis"
      "fastercsv"
      "haml"
      "highline"
      "multi_json"
      "ruby2ruby"
      "ruby_parser"
      "sass"
      "terminal-table"
    ];
  };
  "browser" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "03pmj759wngl03lacn8mdhjn6mc5f8zn08mz6k5hq8czgwcwhjxi";
    };
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "byebug" = {
    version = "6.0.2";
    source = {
      type = "gem";
      sha256 = "0537h9qbhr6csahmzyn4lk1g5b2lcligbzd21gfy93nx9lbfdnzc";
    };
  };
  "cal-heatmap-rails" = {
    version = "0.0.1";
    source = {
      type = "gem";
      sha256 = "07qp74hi1612xgmkfvk1dmc4n79lc7dfkcgqjprnlwb6nkqa940m";
    };
  };
  "capybara" = {
    version = "2.4.4";
    source = {
      type = "gem";
      sha256 = "114k4xi4nfbp3jfbxgwa3fksbwsyibx74gbdqpcgg3dxpmzkaa4f";
    };
    dependencies = [
      "mime-types"
      "nokogiri"
      "rack"
      "rack-test"
      "xpath"
    ];
  };
  "capybara-screenshot" = {
    version = "1.0.11";
    source = {
      type = "gem";
      sha256 = "17v1wihr3aqrxhrwswkdpdklj1xsfcaksblh1y8hixvm9bqfyz3y";
    };
    dependencies = [
      "capybara"
      "launchy"
    ];
  };
  "carrierwave" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1b1av1ancby6brhmypl5k8xwrasd8bd3kqp9ri8kbq7z8nj6k445";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "json"
    ];
  };
  "celluloid" = {
    version = "0.16.0";
    source = {
      type = "gem";
      sha256 = "044xk0y7i1xjafzv7blzj5r56s7zr8nzb619arkrl390mf19jxv3";
    };
    dependencies = [
      "timers"
    ];
  };
  "charlock_holmes" = {
    version = "0.6.9.4";
    source = {
      type = "gem";
      sha256 = "1vyzsr3r2bwig9knyhay1m7i828w9x5zhma44iajyrbs1ypvfbg5";
    };
  };
  "chronic" = {
    version = "0.10.2";
    source = {
      type = "gem";
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
    };
  };
  "chunky_png" = {
    version = "1.3.4";
    source = {
      type = "gem";
      sha256 = "0n5xhkj3vffihl3h9s8yjzazqaqcm4p1nyxa1w2dk3fkpzvb0wfw";
    };
  };
  "cliver" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "096f4rj7virwvqxhkavy0v55rax10r4jqf8cymbvn4n631948xc7";
    };
  };
  "coderay" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "059wkzlap2jlkhg460pkwc1ay4v4clsmg1bp4vfzjzkgwdckr52s";
    };
  };
  "coercible" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1p5azydlsz0nkxmcq0i1gzmcfq02lgxc4as7wmf47j1c6ljav0ah";
    };
    dependencies = [
      "descendants_tracker"
    ];
  };
  "coffee-rails" = {
    version = "4.1.0";
    source = {
      type = "gem";
      sha256 = "0p3zhs44gsy1p90nmghihzfyl7bsk8kv6j3q7rj3bn74wg8w7nqs";
    };
    dependencies = [
      "coffee-script"
      "railties"
    ];
  };
  "coffee-script" = {
    version = "2.4.1";
    source = {
      type = "gem";
      sha256 = "0rc7scyk7mnpfxqv5yy4y5q1hx3i7q3ahplcp4bq2g5r24g2izl2";
    };
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
  };
  "coffee-script-source" = {
    version = "1.9.1.1";
    source = {
      type = "gem";
      sha256 = "1arfrwyzw4sn7nnaq8jji5sv855rp4c5pvmzkabbdgca0w1cxfq5";
    };
  };
  "colored" = {
    version = "1.2";
    source = {
      type = "gem";
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
    };
  };
  "colorize" = {
    version = "0.5.8";
    source = {
      type = "gem";
      sha256 = "1rfzvscnk2js87zzwjgg2lk6h6mrv9448z5vx3b8vnm9yrb2qg8g";
    };
  };
  "connection_pool" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "1b2bb3k39ni5mzcnqlv9y4yjkbin20s7dkwzp0jw2jf1rmzcgrmy";
    };
  };
  "coveralls" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "0ds63q3g8zp23813hsvjjqpjglwr76ld4zqbbdhc9ads9l988axz";
    };
    dependencies = [
      "json"
      "rest-client"
      "simplecov"
      "term-ansicolor"
      "thor"
    ];
  };
  "crack" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "1il94m92sz32nw5i6hdq14f1a2c3s9hza9zn6l95fvqhabq38k7a";
    };
    dependencies = [
      "safe_yaml"
    ];
  };
  "creole" = {
    version = "0.3.8";
    source = {
      type = "gem";
      sha256 = "1wwqk5ij4r5rhzbzhnpqwbn9ck56qgyjs02pjmi2wh46gs8dmkl8";
    };
  };
  "d3_rails" = {
    version = "3.5.6";
    source = {
      type = "gem";
      sha256 = "0faz49chi08zxqwwdzzcb468gmcfmpv1s58y4c431kpa6kyh8qsm";
    };
    dependencies = [
      "railties"
    ];
  };
  "daemons" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0b839hryy9sg7x3knsa1d6vfiyvn0mlsnhsb6an8zsalyrz1zgqg";
    };
  };
  "database_cleaner" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "0n5r7kvsmknk876v3scdphfnvllr9157fa5q7j5fczg8j5qm6kf0";
    };
  };
  "debug_inspector" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "109761g00dbrw5q0dfnbqg8blfm699z4jj70l4zrgf9mzn7ii50m";
    };
  };
  "default_value_for" = {
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "1z4lrba4y1c3y0rxw8321qbwsb3nr6c2igrpksfvz93yhc9m6xm0";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "descendants_tracker" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "15q8g3fcqyb41qixn6cky0k3p86291y7xsh1jfd851dvrza1vi79";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "devise" = {
    version = "3.5.2";
    source = {
      type = "gem";
      sha256 = "1wj88i2hyhcnifj606vzgf2q68yhcpyrsx7bc11h93cma51z59c3";
    };
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "thread_safe"
      "warden"
    ];
  };
  "devise-async" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "11llg7ggzpmg4lb9gh4sx55spvp98sal5r803gjzamps9crfq6mm";
    };
    dependencies = [
      "devise"
    ];
  };
  "devise-two-factor" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1xzaagz6fr9cbq7cj8g7sahx6sxxsc1jyja462caa0gjang9yrhr";
    };
    dependencies = [
      "activesupport"
      "attr_encrypted"
      "devise"
      "railties"
      "rotp"
    ];
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "diffy" = {
    version = "3.0.7";
    source = {
      type = "gem";
      sha256 = "0il0ri511g9rm88qbvncbzgwc6wk6265hmnf7grcczmrs1z49vl0";
    };
  };
  "docile" = {
    version = "1.1.5";
    source = {
      type = "gem";
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
    };
  };
  "domain_name" = {
    version = "0.5.24";
    source = {
      type = "gem";
      sha256 = "1xjm5arwc35wryn0hbfldx2pfhwx5qilkv7yms4kz0jri3m6mgcc";
    };
    dependencies = [
      "unf"
    ];
  };
  "doorkeeper" = {
    version = "2.1.4";
    source = {
      type = "gem";
      sha256 = "00akgshmz85kxvf35qsag80qbxzjvmkmksjy96zx44ckianxwahl";
    };
    dependencies = [
      "railties"
    ];
  };
  "dropzonejs-rails" = {
    version = "0.7.1";
    source = {
      type = "gem";
      sha256 = "0spfjkji6v98996bc320sx3ar3sflkpbjpzwg6cvbycwfn29fjfy";
    };
    dependencies = [
      "rails"
    ];
  };
  "email_reply_parser" = {
    version = "0.5.8";
    source = {
      type = "gem";
      sha256 = "0k2p229mv7xn7q627zwmvhrcvba4b9m70pw2jfjm6iimg2vmf22r";
    };
  };
  "email_spec" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "00p1cc69ncrgg7m45va43pszip8anx5735w1lsb7p5ygkyw8nnpv";
    };
    dependencies = [
      "launchy"
      "mail"
    ];
  };
  "encryptor" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "04wqqda081h7hmhwjjx1yqxprxjk8s5jgv837xqv1bpxiv7f4v1y";
    };
  };
  "enumerize" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0rg6bm3xv7p4i5gs4796v8gc49mzakphwv4kdbhn0wjm690h6226";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "equalizer" = {
    version = "0.0.11";
    source = {
      type = "gem";
      sha256 = "1kjmx3fygx8njxfrwcmn7clfhjhb6bvv3scy2lyyi0wqyi3brra4";
    };
  };
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "escape_utils" = {
    version = "0.2.4";
    source = {
      type = "gem";
      sha256 = "0mg5pgaa02w1bxh0166d367f2ll6fizyrs5dsirrcnw4g17ba54g";
    };
  };
  "eventmachine" = {
    version = "1.0.8";
    source = {
      type = "gem";
      sha256 = "1frvpk3p73xc64qkn0ymll3flvn4xcycq5yx8a43zd3gyzc1ifjp";
    };
  };
  "excon" = {
    version = "0.45.4";
    source = {
      type = "gem";
      sha256 = "1shb4g3dhsfkywgjv6123yrvp2c8bvi8hqmq47iqa5lp72sn4b4w";
    };
  };
  "execjs" = {
    version = "2.6.0";
    source = {
      type = "gem";
      sha256 = "0grlxwiccbnflxs30r3h7g23xnps5knav1jyqkk3anvm8363ifjw";
    };
  };
  "expression_parser" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1938z3wmmdabqxlh5d5c56xfg1jc6z15p7zjyhvk7364zwydnmib";
    };
  };
  "factory_girl" = {
    version = "4.3.0";
    source = {
      type = "gem";
      sha256 = "13z20a4b7z1c8vbz0qz5ranssdprldwvwlgjmn38x311sfjmp9dz";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "factory_girl_rails" = {
    version = "4.3.0";
    source = {
      type = "gem";
      sha256 = "1jj0yl6mfildb4g79dwgc1q5pv2pa65k9b1ml43mi8mg62j8mrhz";
    };
    dependencies = [
      "factory_girl"
      "railties"
    ];
  };
  "faraday" = {
    version = "0.8.10";
    source = {
      type = "gem";
      sha256 = "093hrmrx3jn9969q6c9cjms2k73aqwhs03kij378kg1d5izr4r6f";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "faraday_middleware" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "0nxia26xzy8i56qfyz1bg8dg9yb26swpgci8n5jry8mh4bnx5r5h";
    };
    dependencies = [
      "faraday"
    ];
  };
  "fastercsv" = {
    version = "1.5.5";
    source = {
      type = "gem";
      sha256 = "1df3vfgw5wg0s405z0pj0rfcvnl9q6wak7ka8gn0xqg4cag1k66h";
    };
  };
  "ffaker" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "19fnbbsw87asyb1hvkr870l2yldah2jcjb8074pgyrma5lynwmn0";
    };
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "fission" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "09pmp1j1rr8r3pcmbn2na2ls7s1j9ijbxj99xi3a8r6v5xhjdjzh";
    };
    dependencies = [
      "CFPropertyList"
    ];
  };
  "flowdock" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0wzqj35mn2x2gcy88y00h3jz57ldkkidkwy63jxvmqdlz759pds5";
    };
    dependencies = [
      "httparty"
      "multi_json"
    ];
  };
  "fog" = {
    version = "1.25.0";
    source = {
      type = "gem";
      sha256 = "0zncds3qj5n3i780y6y6sy5h1gg0kwiyiirxyisbd8p0ywwr8bc3";
    };
    dependencies = [
      "fog-brightbox"
      "fog-core"
      "fog-json"
      "fog-profitbricks"
      "fog-radosgw"
      "fog-sakuracloud"
      "fog-softlayer"
      "fog-terremark"
      "fog-vmfusion"
      "fog-voxel"
      "fog-xml"
      "ipaddress"
      "nokogiri"
      "opennebula"
    ];
  };
  "fog-brightbox" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "01a6ydv7y02zbid8s9mqcxpc0k0hig39ap7mrwj9vp6z7mm9dydv";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "inflecto"
    ];
  };
  "fog-core" = {
    version = "1.32.1";
    source = {
      type = "gem";
      sha256 = "0pnm3glgha2hxmhjvgp7f088vzdgv08q8c6w8y9c2cys3b4fx83m";
    };
    dependencies = [
      "builder"
      "excon"
      "formatador"
      "mime-types"
      "net-scp"
      "net-ssh"
    ];
  };
  "fog-json" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0advkkdjajkym77r3c0bg2rlahl2akj0vl4p5r273k2qmi16n00r";
    };
    dependencies = [
      "fog-core"
      "multi_json"
    ];
  };
  "fog-profitbricks" = {
    version = "0.0.5";
    source = {
      type = "gem";
      sha256 = "154sqs2dcmvg21v4m3fj8f09z5i70sq8a485v6rdygsffs8xrycn";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
      "nokogiri"
    ];
  };
  "fog-radosgw" = {
    version = "0.0.4";
    source = {
      type = "gem";
      sha256 = "1pxbvmr4dsqx4x2klwnciyhki4r5ryr9y0hi6xmm3n6fdv4ii7k3";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
    ];
  };
  "fog-sakuracloud" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1s16b48kh7y03hjv74ccmlfwhqqq7j7m4k6cywrgbyip8n3258n8";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-softlayer" = {
    version = "0.4.7";
    source = {
      type = "gem";
      sha256 = "0fgfbhqnyp8ywymvflflhvbns54d1432x57pgpnfy8k1cxvhv9b8";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-terremark" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "01lfkh9jppj0iknlklmwyb7ym3bfhkq58m3absb6rf5a5mcwi3lf";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-vmfusion" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "0g0l0k9ylxk1h9pzqr6h2ba98fl47lpp3j19lqv4jxw0iw1rqxn4";
    };
    dependencies = [
      "fission"
      "fog-core"
    ];
  };
  "fog-voxel" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "10skdnj59yf4jpvq769njjrvh2l0wzaa7liva8n78qq003mvmfgx";
    };
    dependencies = [
      "fog-core"
      "fog-xml"
    ];
  };
  "fog-xml" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "1576sbzza47z48p0k9h1wg3rhgcvcvdd1dfz3xx1cgahwr564fqa";
    };
    dependencies = [
      "fog-core"
      "nokogiri"
    ];
  };
  "font-awesome-rails" = {
    version = "4.4.0.0";
    source = {
      type = "gem";
      sha256 = "0igrwlkgpggpfdy3f4kzsz22m14rxx5xnvz3if16czqjlkq4kbbx";
    };
    dependencies = [
      "railties"
    ];
  };
  "foreman" = {
    version = "0.78.0";
    source = {
      type = "gem";
      sha256 = "1caz8mi7gq1hs4l1flcyyw1iw1bdvdbhppsvy12akr01k3s17xaq";
    };
    dependencies = [
      "thor"
    ];
  };
  "formatador" = {
    version = "0.2.5";
    source = {
      type = "gem";
      sha256 = "1gc26phrwlmlqrmz4bagq1wd5b7g64avpx0ghxr9xdxcvmlii0l0";
    };
  };
  "fuubar" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0xwqs24y8s73aayh39si17kccsmr0bjgmi6jrjyfp7gkjb6iyhpv";
    };
    dependencies = [
      "rspec"
      "ruby-progressbar"
    ];
  };
  "gemnasium-gitlab-service" = {
    version = "0.2.6";
    source = {
      type = "gem";
      sha256 = "1qv7fkahmqkah3770ycrxd0x2ais4z41hb43a0r8q8wcdklns3m3";
    };
    dependencies = [
      "rugged"
    ];
  };
  "gemojione" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "0655l0vgs0hbz11s2nlpwwj7df66cxlvv94iz7mhf04qrr5mi26q";
    };
    dependencies = [
      "json"
    ];
  };
  "get_process_mem" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "025f7v6bpbgsa2nr0hzv2riggj8qmzbwcyxfgjidpmwh5grh7j29";
    };
  };
  "gherkin-ruby" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "18ay7yiibf4sl9n94k7mbi4k5zj2igl4j71qcmkswv69znyx0sn1";
    };
  };
  "github-markup" = {
    version = "1.3.3";
    source = {
      type = "gem";
      sha256 = "01r901wcgn0gs0n9h684gs5n90y1vaj9lxnx4z5ig611jwa43ivq";
    };
  };
  "gitlab-flowdock-git-hook" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1s3a10cdbh4xy732b92zcsm5zyc1lhi5v29d76j8mwbqmj11a2p8";
    };
    dependencies = [
      "flowdock"
      "gitlab-grit"
      "multi_json"
    ];
  };
  "gitlab-grit" = {
    version = "2.7.3";
    source = {
      type = "gem";
      sha256 = "0nv8shx7w7fww8lf5a2rbvf7bq173rllm381m6x7g1i0qqc68q1b";
    };
    dependencies = [
      "charlock_holmes"
      "diff-lcs"
      "mime-types"
      "posix-spawn"
    ];
  };
  "gitlab-linguist" = {
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "14ydmxmdm7j56nwlcf4ai08mpc7d3mbfhida52p1zljshbvda5ib";
    };
    dependencies = [
      "charlock_holmes"
      "escape_utils"
      "mime-types"
    ];
  };
  "gitlab_emoji" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "13jj6ah88x8y6cr5c82j78a4mi5g88a7vpqf617zpcdiabmr0gl6";
    };
    dependencies = [
      "gemojione"
    ];
  };
  "gitlab_git" = {
    version = "7.2.15";
    source = {
      type = "gem";
      sha256 = "1afa645sj322sfy4h6hksi78m87qgvslmf8rgzlqsa4b6zf4w4x2";
    };
    dependencies = [
      "activesupport"
      "charlock_holmes"
      "gitlab-linguist"
      "rugged"
    ];
  };
  "gitlab_meta" = {
    version = "7.0";
    source = {
      type = "gem";
      sha256 = "14vahv7gblcypbvip845sg3lvawf3kij61mkxz5vyfcv23niqvp9";
    };
  };
  "gitlab_omniauth-ldap" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "1vbdyi57vvlrigyfhmqrnkw801x57fwa3gxvj1rj2bn9ig5186ri";
    };
    dependencies = [
      "net-ldap"
      "omniauth"
      "pyu-ruby-sasl"
      "rubyntlm"
    ];
  };
  "gollum-grit_adapter" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "02c5qfq0s0kx2ifnpbnbgz6258fl7rchzzzc7vpx72shi8gbpac7";
    };
    dependencies = [
      "gitlab-grit"
    ];
  };
  "gollum-lib" = {
    version = "4.0.3";
    source = {
      type = "gem";
      sha256 = "1f8jzxza1ckpyzyk137rqd212vfk2ac2mn1pp1wi880s4ynahyky";
    };
    dependencies = [
      "github-markup"
      "gollum-grit_adapter"
      "nokogiri"
      "rouge"
      "sanitize"
      "stringex"
    ];
  };
  "gon" = {
    version = "5.0.4";
    source = {
      type = "gem";
      sha256 = "0gdl6zhj5k8ma3mwm00kjfa12w0l6br9kyyxvfj90cw9irfi049r";
    };
    dependencies = [
      "actionpack"
      "json"
    ];
  };
  "grape" = {
    version = "0.6.1";
    source = {
      type = "gem";
      sha256 = "1sjlk0pmgqbb3piz8yb0xjcm7liimrr17y5xflm40amv36pg2gz8";
    };
    dependencies = [
      "activesupport"
      "builder"
      "hashie"
      "multi_json"
      "multi_xml"
      "rack"
      "rack-accept"
      "rack-mount"
      "virtus"
    ];
  };
  "grape-entity" = {
    version = "0.4.8";
    source = {
      type = "gem";
      sha256 = "0hxghs2p9ncvdwhp6dwr1a74g552c49dd0jzy0szp4pg2xjbgjk8";
    };
    dependencies = [
      "activesupport"
      "multi_json"
    ];
  };
  "growl" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "0s0y7maljnalpbv2q1j5j5hvb4wcc31y9af0n7x1q2l0fzxgc9n9";
    };
  };
  "guard" = {
    version = "2.13.0";
    source = {
      type = "gem";
      sha256 = "0p3ndfmi6sdw55c7j19pyb2ymlby1vyxlp0k47366im1vi70b7gf";
    };
    dependencies = [
      "formatador"
      "listen"
      "lumberjack"
      "nenv"
      "notiffany"
      "pry"
      "shellany"
      "thor"
    ];
  };
  "guard-rspec" = {
    version = "4.2.10";
    source = {
      type = "gem";
      sha256 = "1mm03i1knmhmdqs4ni03nda7jy3s34c2nxf5sjq1cmywk9c0bn0r";
    };
    dependencies = [
      "guard"
      "rspec"
    ];
  };
  "haml" = {
    version = "4.0.7";
    source = {
      type = "gem";
      sha256 = "0mrzjgkygvfii66bbylj2j93na8i89998yi01fin3whwqbvx0m1p";
    };
    dependencies = [
      "tilt"
    ];
  };
  "haml-rails" = {
    version = "0.5.3";
    source = {
      type = "gem";
      sha256 = "0fg4dh1gb7f4h2571wm5qxli02mgg3r8ikp5vwkww12a431vk625";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "haml"
      "railties"
    ];
  };
  "hashie" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "08w9ask37zh5w989b6igair3zf8gwllyzix97rlabxglif9f9qd9";
    };
  };
  "highline" = {
    version = "1.6.21";
    source = {
      type = "gem";
      sha256 = "06bml1fjsnrhd956wqq5k3w8cyd09rv1vixdpa3zzkl6xs72jdn1";
    };
  };
  "hike" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0i6c9hrszzg3gn2j41v3ijnwcm8cc2931fnjiv6mnpl4jcjjykhm";
    };
  };
  "hipchat" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "0hgy5jav479vbzzk53lazhpjj094dcsqw6w1d6zjn52p72bwq60k";
    };
    dependencies = [
      "httparty"
      "mimemagic"
    ];
  };
  "hitimes" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "1fr9raz7652bnnx09dllyjdlnwdxsnl0ig5hq9s4s8vackvmckv4";
    };
  };
  "html-pipeline" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "1yckdlrn4v5d7bgl8mbffax16640pgg9ny693kqi4j7g17vx2q9l";
    };
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
  };
  "http-cookie" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
    };
    dependencies = [
      "domain_name"
    ];
  };
  "http_parser.rb" = {
    version = "0.5.3";
    source = {
      type = "gem";
      sha256 = "0fwf5d573j1sw52kz057dw0nx2wlivczmx6ybf6mk065n5g54kyn";
    };
  };
  "httparty" = {
    version = "0.13.5";
    source = {
      type = "gem";
      sha256 = "1m93fbpwydzzwhc2zf2qkj6lrbcabpy7xhx7wb2mnbmgh0fs7ff9";
    };
    dependencies = [
      "json"
      "multi_xml"
    ];
  };
  "httpclient" = {
    version = "2.6.0.1";
    source = {
      type = "gem";
      sha256 = "0haz4s9xnzr73mkfpgabspj43bhfm9znmpmgdk74n6gih1xlrx1l";
    };
  };
  "i18n" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
    };
  };
  "ice_cube" = {
    version = "0.11.1";
    source = {
      type = "gem";
      sha256 = "12y23nczfrgslpfqam90076x603xhlpv3fyh8mv49gks4qn2wk20";
    };
  };
  "ice_nine" = {
    version = "0.11.1";
    source = {
      type = "gem";
      sha256 = "0i674zq0hl6rd0wcd12ni38linfja4k0y3mk5barjb4a6f7rcmkd";
    };
  };
  "inflecto" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "085l5axmvqw59mw5jg454a3m3gr67ckq9405a075isdsn7bm3sp4";
    };
  };
  "ipaddress" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0cwy4pyd9nl2y2apazp3hvi12gccj5a3ify8mi8k3knvxi5wk2ir";
    };
  };
  "jquery-atwho-rails" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0fdy4dxfvnzrjbfm45yrnwfczszvnd7psqhnkby0j3qjg8k9xhzw";
    };
  };
  "jquery-rails" = {
    version = "3.1.3";
    source = {
      type = "gem";
      sha256 = "1n07rj1x7l61wygbjdpknv5nxhbg2iybfgkpdgca2kj6c1nb1d87";
    };
    dependencies = [
      "railties"
      "thor"
    ];
  };
  "jquery-scrollto-rails" = {
    version = "1.4.3";
    source = {
      type = "gem";
      sha256 = "12ic0zxw60ryglm1qjq5ralqd6k4jawmjj7kqnp1nkqds2nvinvp";
    };
    dependencies = [
      "railties"
    ];
  };
  "jquery-turbolinks" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "1plip56znrkq3na5bjys5q2zvlbyj8p8i29kaayzfpi2c4ixxaq3";
    };
    dependencies = [
      "railties"
      "turbolinks"
    ];
  };
  "jquery-ui-rails" = {
    version = "4.2.1";
    source = {
      type = "gem";
      sha256 = "1garrnqwh35acj2pp4sp6fpm2g881h23y644lzbic2qmcrq9wd2v";
    };
    dependencies = [
      "railties"
    ];
  };
  "json" = {
    version = "1.8.3";
    source = {
      type = "gem";
      sha256 = "1nsby6ry8l9xg3yw4adlhk2pnc7i0h0rznvcss4vk3v74qg0k8lc";
    };
  };
  "jwt" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "13b5ccknrmxnb6dk7vlmnb05za1xxyqd8dzb6lpqq503wpfrmlyk";
    };
  };
  "kaminari" = {
    version = "0.15.1";
    source = {
      type = "gem";
      sha256 = "1m67ghp55hr16k1njhd00f225qys67n60qa3jz69kzqvrp6qg33d";
    };
    dependencies = [
      "actionpack"
      "activesupport"
    ];
  };
  "kgio" = {
    version = "2.9.3";
    source = {
      type = "gem";
      sha256 = "07gl0drxwckj7kbq5nla2lf81lrrrvirvvdcrykjgivysfg6yp5v";
    };
  };
  "launchy" = {
    version = "2.4.3";
    source = {
      type = "gem";
      sha256 = "190lfbiy1vwxhbgn4nl4dcbzxvm049jwc158r2x7kq3g5khjrxa2";
    };
    dependencies = [
      "addressable"
    ];
  };
  "letter_opener" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "1kzbmc686hfh4jznyckq6g40kn14nhb71znsjjm0rc13nb3n0c5l";
    };
    dependencies = [
      "launchy"
    ];
  };
  "listen" = {
    version = "2.10.1";
    source = {
      type = "gem";
      sha256 = "1ipainbx21ni7xakdbksxjim6nixvzfjkifb2d3v45a50dp3diqg";
    };
    dependencies = [
      "celluloid"
      "rb-fsevent"
      "rb-inotify"
    ];
  };
  "lumberjack" = {
    version = "1.0.9";
    source = {
      type = "gem";
      sha256 = "162frm2bwy58pj8ccsdqa4a6i0csrhb9h5l3inhkl1ivgfc8814l";
    };
  };
  "macaddr" = {
    version = "1.7.1";
    source = {
      type = "gem";
      sha256 = "1clii8mvhmh5lmnm95ljnjygyiyhdpja85c5vy487rhxn52scn0b";
    };
    dependencies = [
      "systemu"
    ];
  };
  "mail" = {
    version = "2.6.3";
    source = {
      type = "gem";
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "mail_room" = {
    version = "0.5.2";
    source = {
      type = "gem";
      sha256 = "1l8ncfwqiiv3nd7i0237xd5ymshgyfxfv4w2bj0lj67ys3l4qwh3";
    };
  };
  "method_source" = {
    version = "0.8.2";
    source = {
      type = "gem";
      sha256 = "1g5i4w0dmlhzd18dijlqw5gk27bv6dj2kziqzrzb7mpgxgsd1sf2";
    };
  };
  "mime-types" = {
    version = "1.25.1";
    source = {
      type = "gem";
      sha256 = "0mhzsanmnzdshaba7gmsjwnv168r1yj8y0flzw88frw1cickrvw8";
    };
  };
  "mimemagic" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "101lq4bnjs7ywdcicpw3vbz9amg5gbb4va1626fybd2hawgdx8d9";
    };
  };
  "mini_portile" = {
    version = "0.6.2";
    source = {
      type = "gem";
      sha256 = "0h3xinmacscrnkczq44s6pnhrp4nqma7k056x5wv5xixvf2wsq2w";
    };
  };
  "minitest" = {
    version = "5.7.0";
    source = {
      type = "gem";
      sha256 = "0rxqfakp629mp3vwda7zpgb57lcns5znkskikbfd0kriwv8i1vq8";
    };
  };
  "mousetrap-rails" = {
    version = "1.4.6";
    source = {
      type = "gem";
      sha256 = "00n13r5pwrk4vq018128vcfh021dw0fa2bk4pzsv0fslfm8ayp2m";
    };
  };
  "multi_json" = {
    version = "1.11.2";
    source = {
      type = "gem";
      sha256 = "1rf3l4j3i11lybqzgq2jhszq7fh7gpmafjzd14ymp9cjfxqg596r";
    };
  };
  "multi_xml" = {
    version = "0.5.5";
    source = {
      type = "gem";
      sha256 = "0i8r7dsz4z79z3j023l8swan7qpbgxbwwz11g38y2vjqjk16v4q8";
    };
  };
  "multipart-post" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "12p7lnmc52di1r4h73h6xrpppplzyyhani9p7wm8l4kgf1hnmwnc";
    };
  };
  "mysql2" = {
    version = "0.3.20";
    source = {
      type = "gem";
      sha256 = "0n075x14n9kziv0qdxqlzhf3j1abi1w6smpakfpsg4jbr8hnn5ip";
    };
  };
  "nenv" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "152wxwri0afwgnxdf93gi6wjl9rr5z7vwp8ln0gpa3rddbfc27s6";
    };
  };
  "nested_form" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "0f053j4zfagxyym28msxj56hrpvmyv4lzxy2c5c270f7xbbnii5i";
    };
  };
  "net-ldap" = {
    version = "0.11";
    source = {
      type = "gem";
      sha256 = "1xfq94lmc5mcc5giipxn9bmrsm9ny1xc1rp0xpm2pgqwr2q8fm7w";
    };
  };
  "net-scp" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0b0jqrcsp4bbi4n4mzyf70cp2ysyp6x07j8k8cqgxnvb4i3a134j";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh" = {
    version = "2.9.2";
    source = {
      type = "gem";
      sha256 = "1p0bj41zrmw5lhnxlm1pqb55zfz9y4p9fkrr9a79nrdmzrk1ph8r";
    };
  };
  "netrc" = {
    version = "0.10.3";
    source = {
      type = "gem";
      sha256 = "1r6cmg1nvxspl24yrqn77vx7xjqigpypialblpcv5qj6xmc4b8lg";
    };
  };
  "newrelic-grape" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1j8cdlc8lvbh2c2drdq0kfrjbw9bkgqx3qiiizzaxv6yj70vq58a";
    };
    dependencies = [
      "grape"
      "newrelic_rpm"
    ];
  };
  "newrelic_rpm" = {
    version = "3.9.4.245";
    source = {
      type = "gem";
      sha256 = "0r1x16wwmiqsf1gj2a1lgc0fq1v0x4yv40k5wgb00gs439vgzyin";
    };
  };
  "nokogiri" = {
    version = "1.6.6.2";
    source = {
      type = "gem";
      sha256 = "1j4qv32qjh67dcrc1yy1h8sqjnny8siyy4s44awla8d6jk361h30";
    };
    dependencies = [
      "mini_portile"
    ];
  };
  "notiffany" = {
    version = "0.0.7";
    source = {
      type = "gem";
      sha256 = "1v5x1w59qq85r6dpv3y9ga34dfd7hka1qxyiykaw7gm0i6kggbhi";
    };
    dependencies = [
      "nenv"
      "shellany"
    ];
  };
  "nprogress-rails" = {
    version = "0.1.2.3";
    source = {
      type = "gem";
      sha256 = "16gqajynqzfvzcyc8b9bjn8xf6j7y80li00ajicxwvb6my2ag304";
    };
  };
  "oauth" = {
    version = "0.4.7";
    source = {
      type = "gem";
      sha256 = "1k5j09p3al3clpjl6lax62qmhy43f3j3g7i6f9l4dbs6r5vpv95w";
    };
  };
  "oauth2" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0zaa7qnvizv363apmxx9vxa8f6c6xy70z0jm0ydx38xvhxr8898r";
    };
    dependencies = [
      "faraday"
      "jwt"
      "multi_json"
      "multi_xml"
      "rack"
    ];
  };
  "octokit" = {
    version = "3.7.1";
    source = {
      type = "gem";
      sha256 = "1sd6cammv5m96640vdb8yp3kfpzn52s8y7d77dgsfb25bc1jg4xl";
    };
    dependencies = [
      "sawyer"
    ];
  };
  "omniauth" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1f0hd9ngfb6f8wz8h2r5n8lr99jqjaghn0h2mljdc6fw031ap7lk";
    };
    dependencies = [
      "hashie"
      "rack"
    ];
  };
  "omniauth-bitbucket" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "1lals2z1yixffrc97zh7zn1jpz9l6vpb3alcp13im42dq9q0g845";
    };
    dependencies = [
      "multi_json"
      "omniauth"
      "omniauth-oauth"
    ];
  };
  "omniauth-github" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "1mbx3c8m1llhdxrqdciq8jh428bxj1nvf4yhziv2xqmqpjcqz617";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-gitlab" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1amg3y0ivfakamfwiljgla1vff59b116nd0i6khmaj4jsa4s81hw";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-google-oauth2" = {
    version = "0.2.6";
    source = {
      type = "gem";
      sha256 = "1nba1iy6w2wj79pvnp9r5bw7jhks0287lw748vkxl9xmwccldnhj";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-kerberos" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1s626nxzq8i6gy67pkh04h8hlmmx4vwpc36sbdsgm1xwyj3hrn1b";
    };
    dependencies = [
      "omniauth-multipassword"
      "timfel-krb5-auth"
    ];
  };
  "omniauth-multipassword" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "0qykp76hw80lkgb39hyzrv68hkbivc8cv0vbvrnycjh9fwfp1lv8";
    };
    dependencies = [
      "omniauth"
    ];
  };
  "omniauth-oauth" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "1n5vk4by7hkyc09d9blrw2argry5awpw4gbw1l4n2s9b3j4qz037";
    };
    dependencies = [
      "oauth"
      "omniauth"
    ];
  };
  "omniauth-oauth2" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "0mskwlw5ibx9mz7ywqji6mm56ikf7mglbnfc02qhg6ry527jsxdm";
    };
    dependencies = [
      "oauth2"
      "omniauth"
    ];
  };
  "omniauth-saml" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "12jkjdrkc3k2k1y53vfxyicdq2j0djhln6apwzmc10h9jhq23nrq";
    };
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
  };
  "omniauth-shibboleth" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "0wy24hwsipjx8iswdbrncgv15qxv7ibg07rv2n6byi037mrnhnhw";
    };
    dependencies = [
      "omniauth"
    ];
  };
  "omniauth-twitter" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "060gnfc9im786llgi7vlrfhar1b7jlk19bjjc5d50lwrah0hh4fd";
    };
    dependencies = [
      "multi_json"
      "omniauth-oauth"
    ];
  };
  "omniauth_crowd" = {
    version = "2.2.3";
    source = {
      type = "gem";
      sha256 = "12g5ck05h6kr9mnp870x8pkxsadg81ca70hg8n3k8xx007lfw2q7";
    };
    dependencies = [
      "activesupport"
      "nokogiri"
      "omniauth"
    ];
  };
  "opennebula" = {
    version = "4.12.1";
    source = {
      type = "gem";
      sha256 = "1y2k706mcxf69cviy415icnhdz7ll5nld9iksqdg4asp60gybq3k";
    };
    dependencies = [
      "json"
      "nokogiri"
      "rbvmomi"
    ];
  };
  "org-ruby" = {
    version = "0.9.12";
    source = {
      type = "gem";
      sha256 = "0x69s7aysfiwlcpd9hkvksfyld34d8kxr62adb59vjvh8hxfrjwk";
    };
    dependencies = [
      "rubypants"
    ];
  };
  "orm_adapter" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "1fg9jpjlzf5y49qs9mlpdrgs5rpcyihq1s4k79nv9js0spjhnpda";
    };
  };
  "paranoia" = {
    version = "2.1.3";
    source = {
      type = "gem";
      sha256 = "1v6izkdf8npwcblzn9zl9ysagih75584d8hpjzhiv0ijz6cw3l92";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "parser" = {
    version = "2.2.2.6";
    source = {
      type = "gem";
      sha256 = "0rmh4yr5qh87wqgwzbs6vy8wyf248k09m2vfjf9br6jdb5zgj5hh";
    };
    dependencies = [
      "ast"
    ];
  };
  "pg" = {
    version = "0.18.2";
    source = {
      type = "gem";
      sha256 = "1axxbf6ij1iqi3i1r3asvjc80b0py5bz0m2wy5kdi5xkrpr82kpf";
    };
  };
  "poltergeist" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "0mpy2yhn0bhm2s78h8wy22j6378vvsdkj5pcvhr2zfhdjf46g41d";
    };
    dependencies = [
      "capybara"
      "cliver"
      "multi_json"
      "websocket-driver"
    ];
  };
  "posix-spawn" = {
    version = "0.3.11";
    source = {
      type = "gem";
      sha256 = "052lnxbkvlnwfjw4qd7vn2xrlaaqiav6f5x5bcjin97bsrfq6cmr";
    };
  };
  "powerpack" = {
    version = "0.0.9";
    source = {
      type = "gem";
      sha256 = "0gflp6d2dc4jz3kgg8v4pdzm3qr2bbdygr83dbsi69pxm2gy5536";
    };
  };
  "pry" = {
    version = "0.10.1";
    source = {
      type = "gem";
      sha256 = "1j0r5fm0wvdwzbh6d6apnp7c0n150hpm9zxpm5xvcgfqr36jaj8z";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
    ];
  };
  "pry-rails" = {
    version = "0.3.4";
    source = {
      type = "gem";
      sha256 = "0a2iinvabis2xmv0z7z7jmh7bbkkngxj2qixfdg5m6qj9x8k1kx6";
    };
    dependencies = [
      "pry"
    ];
  };
  "pyu-ruby-sasl" = {
    version = "0.0.3.3";
    source = {
      type = "gem";
      sha256 = "1rcpjiz9lrvyb3rd8k8qni0v4ps08psympffyldmmnrqayyad0sn";
    };
  };
  "quiet_assets" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "1q4azw4j1xsgd7qwcig110mfdn1fm0y34y87zw9j9v187xr401b1";
    };
    dependencies = [
      "railties"
    ];
  };
  "rack" = {
    version = "1.5.5";
    source = {
      type = "gem";
      sha256 = "1ds3gh8m5gy0d2k4g12k67qid7magg1ia186872yq22ham7sgr2a";
    };
  };
  "rack-accept" = {
    version = "0.4.5";
    source = {
      type = "gem";
      sha256 = "18jdipx17b4ki33cfqvliapd31sbfvs4mv727awynr6v95a7n936";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-attack" = {
    version = "4.3.0";
    source = {
      type = "gem";
      sha256 = "06v5xvp33aysf8hkl9lwl1yjkc82jdlvcm2361y7ckjgykf8ixfr";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-cors" = {
    version = "0.2.9";
    source = {
      type = "gem";
      sha256 = "0z88pbbasr86z6h0965cny0gvrnj7zwv31s506xbpivk4vd6n9as";
    };
  };
  "rack-mini-profiler" = {
    version = "0.9.7";
    source = {
      type = "gem";
      sha256 = "03lz6x1s8rbrccfsxl2rq677zqkmkvzv7whbmwzdp71zzyvvm14j";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-mount" = {
    version = "0.8.3";
    source = {
      type = "gem";
      sha256 = "09a1qfaxxsll1kbgz7z0q0nr48sfmfm7akzaviis5bjpa5r00ld2";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-oauth2" = {
    version = "1.0.10";
    source = {
      type = "gem";
      sha256 = "1srg4hdnyn6bwx225snyq7flb0cn96ppdvicwls6qvp6i4n91k36";
    };
    dependencies = [
      "activesupport"
      "attr_required"
      "httpclient"
      "multi_json"
      "rack"
    ];
  };
  "rack-protection" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-test" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
    };
    dependencies = [
      "rack"
    ];
  };
  "rails" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "0k2n6y92gmysk8y6j1hy6av53f07hhzkhw41qfqwr2hgqc6q8idv";
    };
    dependencies = [
      "actionmailer"
      "actionpack"
      "actionview"
      "activemodel"
      "activerecord"
      "activesupport"
      "railties"
      "sprockets-rails"
    ];
  };
  "rails-observers" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "1lsw19jzmvipvrfy2z04hi7r29dvkfc43h43vs67x6lsj9rxwwcy";
    };
    dependencies = [
      "activemodel"
    ];
  };
  "railties" = {
    version = "4.1.12";
    source = {
      type = "gem";
      sha256 = "0v16grd6ip3ijiz1v36myiirqx9fx004lfvnsmh28b2ddjxcci4q";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "rake"
      "thor"
    ];
  };
  "rainbow" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0dsnzfjiih2w8npsjab3yx1ssmmvmgjkbxny0i9yzrdy7whfw7b4";
    };
  };
  "raindrops" = {
    version = "0.15.0";
    source = {
      type = "gem";
      sha256 = "1hv0xhr762axywr937czi92fs0x3zk7k22vg6f4i7rr8d05sp560";
    };
  };
  "rake" = {
    version = "10.4.2";
    source = {
      type = "gem";
      sha256 = "1rn03rqlf1iv6n87a78hkda2yqparhhaivfjpizblmxvlw2hk5r8";
    };
  };
  "raphael-rails" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "0sjiaymvfn4al5dr1pza5i142byan0fxnj4rymziyql2bzvdm2bc";
    };
  };
  "rb-fsevent" = {
    version = "0.9.5";
    source = {
      type = "gem";
      sha256 = "1p4rz4qqarl7xg2aldpra54h81yal93cbxdy02lmb9kf6f7y2fz4";
    };
  };
  "rb-inotify" = {
    version = "0.9.5";
    source = {
      type = "gem";
      sha256 = "0kddx2ia0qylw3r52nhg83irkaclvrncgy2m1ywpbhlhsz1rymb9";
    };
    dependencies = [
      "ffi"
    ];
  };
  "rbvmomi" = {
    version = "1.8.2";
    source = {
      type = "gem";
      sha256 = "0gjbfazl2q42m1m51nvv14q7y5lbya272flmvhpqvg5z10nbxanj";
    };
    dependencies = [
      "builder"
      "nokogiri"
      "trollop"
    ];
  };
  "rdoc" = {
    version = "3.12.2";
    source = {
      type = "gem";
      sha256 = "1v9k4sp5yzj2bshngckdvivj6bszciskk1nd2r3wri2ygs7vgqm8";
    };
    dependencies = [
      "json"
    ];
  };
  "redcarpet" = {
    version = "3.3.2";
    source = {
      type = "gem";
      sha256 = "1xf95nrc8jgv9hjzjnbf3ljwmp29rqxdamyj9crza2czl4k63rnm";
    };
  };
  "redis" = {
    version = "3.2.1";
    source = {
      type = "gem";
      sha256 = "16jzlqp80qiqg5cdc9l144n6k3c5qj9if4pgij87sscn8ahi993k";
    };
  };
  "redis-actionpack" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "0mad0v3qanw3xi9zs03f4w8sn1qb3x501k3235ck8m5i8vgjk474";
    };
    dependencies = [
      "actionpack"
      "redis-rack"
      "redis-store"
    ];
  };
  "redis-activesupport" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "1xciffiqbhksy534sysdd8pgn2hlvyrs1qb4x1kbcx9f3f83y551";
    };
    dependencies = [
      "activesupport"
      "redis-store"
    ];
  };
  "redis-namespace" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "0rp8gfkznfxqzxk9s976k71jnljkh0clkrhnp6vgx46s5yhj9g25";
    };
    dependencies = [
      "redis"
    ];
  };
  "redis-rack" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "1y1mxx8gn0krdrpwllv7fqsbvki1qjnb2dz8b4q9gwc326829gk8";
    };
    dependencies = [
      "rack"
      "redis-store"
    ];
  };
  "redis-rails" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "0igww7hb58aq74mh50dli3zjg78b54y8nhd0h1h9vz4vgjd4q8m7";
    };
    dependencies = [
      "redis-actionpack"
      "redis-activesupport"
      "redis-store"
    ];
  };
  "redis-store" = {
    version = "1.1.6";
    source = {
      type = "gem";
      sha256 = "1x8pfpd6c3xxb3l9nyggi9qpgxcp9k9rkdwwl80m95lhynwaxcds";
    };
    dependencies = [
      "redis"
    ];
  };
  "request_store" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1s7lk5klbg2qfh8hgqymjrlwgpmjmfx03x1hniq16shd1cjwch45";
    };
  };
  "rerun" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "0hsw0q0wriz4h55hkm9yd313hqixgsgnp4wrl8v4k4zwz41j76xk";
    };
    dependencies = [
      "listen"
    ];
  };
  "responders" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "178279kf1kaah917r6zwzw5kk9swj28yxmg6aqffna7789kjhy3f";
    };
    dependencies = [
      "railties"
    ];
  };
  "rest-client" = {
    version = "1.8.0";
    source = {
      type = "gem";
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
    };
    dependencies = [
      "http-cookie"
      "mime-types"
      "netrc"
    ];
  };
  "rinku" = {
    version = "1.7.3";
    source = {
      type = "gem";
      sha256 = "1jh6nys332brph55i6x6cil6swm086kxjw34wq131nl6mwryqp7b";
    };
  };
  "rotp" = {
    version = "2.1.1";
    source = {
      type = "gem";
      sha256 = "1nzsc9hfxijnyzjbv728ln9dm80bc608chaihjdk63i2wi4m529g";
    };
  };
  "rouge" = {
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "0wp8as9ypdy18kdj9h70kny1rdfq71mr8cj2bpahr9vxjjvjasqz";
    };
  };
  "rqrcode" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "188n1mvc7klrlw30bai16sdg4yannmy7cz0sg0nvm6f1kjx5qflb";
    };
    dependencies = [
      "chunky_png"
    ];
  };
  "rqrcode-rails3" = {
    version = "0.1.7";
    source = {
      type = "gem";
      sha256 = "1i28rwmj24ssk91chn0g7qsnvn003y3s5a7jsrg3w4l5ckr841bg";
    };
    dependencies = [
      "rqrcode"
    ];
  };
  "rspec" = {
    version = "3.3.0";
    source = {
      type = "gem";
      sha256 = "1bn5zs71agc0zyns2r3c8myi5bxw3q7xnzp7f3v5b7hbil1qym4r";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "rspec-core" = {
    version = "3.3.2";
    source = {
      type = "gem";
      sha256 = "0xw5qi936j6nz9fixi2mwy03f406761cd72bzyvd61pr854d7hy1";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.3.1";
    source = {
      type = "gem";
      sha256 = "1d0b5hpkxlr9f3xpsbhvl3irnk4smmycx2xnmc8qv3pqaa7mb7ah";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-mocks" = {
    version = "3.3.2";
    source = {
      type = "gem";
      sha256 = "1lfbzscmpyixlbapxmhy2s69596vs1z00lv590l51hgdw70z92vg";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-rails" = {
    version = "3.3.3";
    source = {
      type = "gem";
      sha256 = "0m66n9p3a7d3fmrzkbh8312prb6dhrgmp53g1amck308ranasv2a";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
  };
  "rspec-support" = {
    version = "3.3.0";
    source = {
      type = "gem";
      sha256 = "1cyagig8slxjas8mbg5f8bl240b8zgr8mnjsvrznag1fwpkh4h27";
    };
  };
  "rubocop" = {
    version = "0.28.0";
    source = {
      type = "gem";
      sha256 = "07n4gha1dp1n15np5v8p58980lsiys3wa9h39lrvnzxgq18m3c4d";
    };
    dependencies = [
      "astrolabe"
      "parser"
      "powerpack"
      "rainbow"
      "ruby-progressbar"
    ];
  };
  "ruby-fogbugz" = {
    version = "0.2.1";
    source = {
      type = "gem";
      sha256 = "1jj0gpkycbrivkh2q3429vj6mbgx6axxisg69slj3c4mgvzfgchm";
    };
    dependencies = [
      "crack"
    ];
  };
  "ruby-progressbar" = {
    version = "1.7.5";
    source = {
      type = "gem";
      sha256 = "0hynaavnqzld17qdx9r7hfw00y16ybldwq730zrqfszjwgi59ivi";
    };
  };
  "ruby-saml" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0hqn49ca2ln5ybc77vpm1vs0szk3pyrz3hnbkbqrkp864mniisi4";
    };
    dependencies = [
      "nokogiri"
      "uuid"
    ];
  };
  "ruby2ruby" = {
    version = "2.1.4";
    source = {
      type = "gem";
      sha256 = "1h0bwjivcsazfd9j9phs640xxqwgvggj9kmafin88ahf7j77spim";
    };
    dependencies = [
      "ruby_parser"
      "sexp_processor"
    ];
  };
  "ruby_parser" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "1l1lzbn5ywfsg8m8cvxwb415p1816ikvjqnsh5as9h4g1vcknw3y";
    };
    dependencies = [
      "sexp_processor"
    ];
  };
  "rubyntlm" = {
    version = "0.5.2";
    source = {
      type = "gem";
      sha256 = "04l8686hl0829x4acsnbz0licf8n6794p7shz8iyahin1jnqg3d7";
    };
  };
  "rubypants" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1vpdkrc4c8qhrxph41wqwswl28q5h5h994gy4c1mlrckqzm3hzph";
    };
  };
  "rugged" = {
    version = "0.22.2";
    source = {
      type = "gem";
      sha256 = "179pnnvlsrwd96csmhwhy45y4f5p7qh3xcbg6v3hdv5m9qqcirpp";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sanitize" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "0xsv6xqrlz91rd8wifjknadbl3z5h6qphmxy0hjb189qbdghggn3";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "sass" = {
    version = "3.2.19";
    source = {
      type = "gem";
      sha256 = "1b5z55pmban9ry7k572ghmpcz9h04nbrdhdfpcz8zaldv5v7vkfx";
    };
  };
  "sass-rails" = {
    version = "4.0.5";
    source = {
      type = "gem";
      sha256 = "1nw78ijbxpaf0pdr6c0jx63nna1l9m8s1mmb4m3g2clx0i0xm4wb";
    };
    dependencies = [
      "railties"
      "sass"
      "sprockets"
      "sprockets-rails"
    ];
  };
  "sawyer" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "0fk43bzwn816qj1ksiicm2i1kmzv5675cmnvk57kmfmi4rfsyjpy";
    };
    dependencies = [
      "addressable"
      "faraday"
    ];
  };
  "sdoc" = {
    version = "0.3.20";
    source = {
      type = "gem";
      sha256 = "17l8qk0ld47z4h5avcnylvds8nc6dp25zc64w23z8li2hs341xf2";
    };
    dependencies = [
      "json"
      "rdoc"
    ];
  };
  "seed-fu" = {
    version = "2.3.5";
    source = {
      type = "gem";
      sha256 = "11xja82yxir1kwccrzng29h7w911i9j0xj2y7y949yqnw91v12vw";
    };
    dependencies = [
      "activerecord"
      "activesupport"
    ];
  };
  "select2-rails" = {
    version = "3.5.9.3";
    source = {
      type = "gem";
      sha256 = "0ni2k74n73y3gv56gs37gkjlh912szjf6k9j483wz41m3xvlz7fj";
    };
    dependencies = [
      "thor"
    ];
  };
  "settingslogic" = {
    version = "2.0.9";
    source = {
      type = "gem";
      sha256 = "1ria5zcrk1nf0b9yia15mdpzw0dqr6wjpbj8dsdbbps81lfsj9ar";
    };
  };
  "sexp_processor" = {
    version = "4.6.0";
    source = {
      type = "gem";
      sha256 = "0gxlcpg81wfjf5gpggf8h6l2dbq3ikgavbrr2yfw3m2vqy88yjg2";
    };
  };
  "sham_rack" = {
    version = "1.3.6";
    source = {
      type = "gem";
      sha256 = "0zs6hpgg87x5jrykjxgfp2i7m5aja53s5kamdhxam16wki1hid3i";
    };
    dependencies = [
      "rack"
    ];
  };
  "shellany" = {
    version = "0.0.1";
    source = {
      type = "gem";
      sha256 = "1ryyzrj1kxmnpdzhlv4ys3dnl2r5r3d2rs2jwzbnd1v96a8pl4hf";
    };
  };
  "shoulda-matchers" = {
    version = "2.8.0";
    source = {
      type = "gem";
      sha256 = "0d3ryqcsk1n9y35bx5wxnqbgw4m8b3c79isazdjnnbg8crdp72d0";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "sidekiq" = {
    version = "3.3.0";
    source = {
      type = "gem";
      sha256 = "0xwy2n4jaja82gw11q1qsqc2jp7hp2asxhfr0gkfb58wj7k5y32l";
    };
    dependencies = [
      "celluloid"
      "connection_pool"
      "json"
      "redis"
      "redis-namespace"
    ];
  };
  "sidetiq" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "1sylv1nyrn7w3782fh0f5svjqricr53vacf4kkvx3l2azzymc2am";
    };
    dependencies = [
      "celluloid"
      "ice_cube"
      "sidekiq"
    ];
  };
  "simple_oauth" = {
    version = "0.1.9";
    source = {
      type = "gem";
      sha256 = "0bb06p88xsdw4fxll1ikv5i5k58sl6y323ss0wp1hqjm3xw1jgvj";
    };
  };
  "simplecov" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "1q2iq2vgrdvvla5y907gkmqx6ry2qvnvc7a90hlcbwgp1w0sv6z4";
    };
    dependencies = [
      "docile"
      "json"
      "simplecov-html"
    ];
  };
  "simplecov-html" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "1qni8g0xxglkx25w54qcfbi4wjkpvmb28cb7rj5zk3iqynjcdrqf";
    };
  };
  "sinatra" = {
    version = "1.4.6";
    source = {
      type = "gem";
      sha256 = "1hhmwqc81ram7lfwwziv0z70jh92sj1m7h7s9fr0cn2xq8mmn8l7";
    };
    dependencies = [
      "rack"
      "rack-protection"
      "tilt"
    ];
  };
  "six" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "1bhapiyjh5r5qjpclfw8i65plvy6k2q4azr5xir63xqglr53viw3";
    };
  };
  "slack-notifier" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0v4kd0l83shmk17qb35lighxjq9j7g3slnkrsyiy36kaqcfrjm97";
    };
  };
  "slim" = {
    version = "2.0.3";
    source = {
      type = "gem";
      sha256 = "1z279vis4z2xsjzf568pxcl2gd1az760ij13d6qzx400mgn7nqxs";
    };
    dependencies = [
      "temple"
      "tilt"
    ];
  };
  "slop" = {
    version = "3.6.0";
    source = {
      type = "gem";
      sha256 = "00w8g3j7k7kl8ri2cf1m58ckxk8rn350gp4chfscmgv6pq1spk3n";
    };
  };
  "spinach" = {
    version = "0.8.10";
    source = {
      type = "gem";
      sha256 = "0phfjs4iw2iqxdaljzwk6qxmi2x86pl3hirmpgw2pgfx76wfx688";
    };
    dependencies = [
      "colorize"
      "gherkin-ruby"
      "json"
    ];
  };
  "spinach-rails" = {
    version = "0.2.1";
    source = {
      type = "gem";
      sha256 = "1nfacfylkncfgi59g2wga6m4nzdcjqb8s50cax4nbx362ap4bl70";
    };
    dependencies = [
      "capybara"
      "railties"
      "spinach"
    ];
  };
  "spring" = {
    version = "1.3.6";
    source = {
      type = "gem";
      sha256 = "0xvz2x6nvza5i53p7mddnf11j2wshqmbaphi6ngd6nar8v35y0k1";
    };
  };
  "spring-commands-rspec" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "0b0svpq3md1pjz5drpa5pxwg8nk48wrshq8lckim4x3nli7ya0k2";
    };
    dependencies = [
      "spring"
    ];
  };
  "spring-commands-spinach" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "138jardqyj96wz68njdgy55qjbpl2d0g8bxbkz97ndaz3c2bykv9";
    };
    dependencies = [
      "spring"
    ];
  };
  "spring-commands-teaspoon" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "1g7n4m2s9d0frh7y1xibzpphqajfnx4fvgfc66nh545dd91w2nqz";
    };
    dependencies = [
      "spring"
    ];
  };
  "sprockets" = {
    version = "2.12.4";
    source = {
      type = "gem";
      sha256 = "15818683yz27w4hgywccf27n91azy9a4nmb5qkklzb08k8jw9gp3";
    };
    dependencies = [
      "hike"
      "multi_json"
      "rack"
      "tilt"
    ];
  };
  "sprockets-rails" = {
    version = "2.3.2";
    source = {
      type = "gem";
      sha256 = "1pk2a69cxirg2dkkpl5cr3fvrj1qgifw1fmpz1ggkcziwxajyg6d";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
  };
  "stamp" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "1w54kxm4sd4za9rhrkl5lqjbsalhziq95sr3nnwr1lqc00nn5mhs";
    };
  };
  "state_machine" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1vf25h443b1s98d2lhd1w3rgam86pjsjhz632f3yrfkn374xvz40";
    };
  };
  "stringex" = {
    version = "2.5.2";
    source = {
      type = "gem";
      sha256 = "150adm7rfh6r9b5ra6vk75mswf9m3wwyslcf8f235a08m29fxa17";
    };
  };
  "systemu" = {
    version = "2.6.5";
    source = {
      type = "gem";
      sha256 = "0gmkbakhfci5wnmbfx5i54f25j9zsvbw858yg3jjhfs5n4ad1xq1";
    };
  };
  "task_list" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "1iv1fizb04463c4mp4gxd8v0414fhvmiwvwvjby5b9qq79d8zwab";
    };
    dependencies = [
      "html-pipeline"
    ];
  };
  "teaspoon" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0cprz18vgf0jgcggcxf4pwx8jcwbiyj1p0dnck5aavlvaxaic58s";
    };
    dependencies = [
      "railties"
    ];
  };
  "teaspoon-jasmine" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "00wygrv1jm4aj15p1ab9d5fdrj6y83kv26xgp52mx4lp78h2ms9q";
    };
    dependencies = [
      "teaspoon"
    ];
  };
  "temple" = {
    version = "0.6.10";
    source = {
      type = "gem";
      sha256 = "1lzz4bisg97725m1q62jhmcxklfhky7g326d0b7p2q0kjx262q81";
    };
  };
  "term-ansicolor" = {
    version = "1.3.2";
    source = {
      type = "gem";
      sha256 = "0ydbbyjmk5p7fsi55ffnkq79jnfqx65c3nj8d9rpgl6sw85ahyys";
    };
    dependencies = [
      "tins"
    ];
  };
  "terminal-table" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "1s6qyj9ir1agbbi32li9c0c34dcl0klyxqif6mxy0dbvq7kqfp8f";
    };
  };
  "test_after_commit" = {
    version = "0.2.7";
    source = {
      type = "gem";
      sha256 = "179dgdpsmn9lcxxkyrxxvmyj4x3xi9sdq80l3zfqcgprnbxavbp7";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "thin" = {
    version = "1.6.3";
    source = {
      type = "gem";
      sha256 = "1m56aygh5rh8ncp3s2gnn8ghn5ibkk0bg6s3clmh1vzaasw2lj4i";
    };
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "thread_safe" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "1hq46wqsyylx5afkp6jmcihdpv4ynzzq9ygb6z2pb1cbz5js0gcr";
    };
  };
  "tilt" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
    };
  };
  "timers" = {
    version = "4.0.4";
    source = {
      type = "gem";
      sha256 = "1jx4wb0x182gmbcs90vz0wzfyp8afi1mpl9w5ippfncyk4kffvrz";
    };
    dependencies = [
      "hitimes"
    ];
  };
  "timfel-krb5-auth" = {
    version = "0.8.3";
    source = {
      type = "gem";
      sha256 = "105vajc0jkqgcx1wbp0ad262sdry4l1irk7jpaawv8vzfjfqqf5b";
    };
  };
  "tinder" = {
    version = "1.9.4";
    source = {
      type = "gem";
      sha256 = "0gl5kln3dgybgarksk2ly4y0wy2lljsh59idfllwzynap8hx9jar";
    };
    dependencies = [
      "eventmachine"
      "faraday"
      "faraday_middleware"
      "hashie"
      "json"
      "mime-types"
      "multi_json"
      "twitter-stream"
    ];
  };
  "tins" = {
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "02qarvy17nbwvslfgqam8y6y7479cwmb1a6di9z18hzka4cf90hz";
    };
  };
  "trollop" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "0415y63df86sqj43c0l82and65ia5h64if7n0znkbrmi6y0jwhl8";
    };
  };
  "turbolinks" = {
    version = "2.5.3";
    source = {
      type = "gem";
      sha256 = "1ddrx25vvvqxlz4h59lrmjhc2bfwxf4bpicvyhgbpjd48ckj81jn";
    };
    dependencies = [
      "coffee-rails"
    ];
  };
  "twitter-stream" = {
    version = "0.1.16";
    source = {
      type = "gem";
      sha256 = "0is81g3xvnjk64sqiaqlh2ziwfryzwvk1yvaniryg0zhppgsyriq";
    };
    dependencies = [
      "eventmachine"
      "http_parser.rb"
      "simple_oauth"
    ];
  };
  "tzinfo" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "uglifier" = {
    version = "2.3.3";
    source = {
      type = "gem";
      sha256 = "0v45v2hccmadxpqrlk8gj9sgyak4d6838014wizdvzkh8sy23nvr";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
  "underscore-rails" = {
    version = "1.4.4";
    source = {
      type = "gem";
      sha256 = "1xg3dfym38gj5zsjxpf1v5cz4j6gysirv9bgc5ls37krixkajag2";
    };
  };
  "unf" = {
    version = "0.1.4";
    source = {
      type = "gem";
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
    };
    dependencies = [
      "unf_ext"
    ];
  };
  "unf_ext" = {
    version = "0.0.7.1";
    source = {
      type = "gem";
      sha256 = "0ly2ms6c3irmbr1575ldyh52bz2v0lzzr2gagf0p526k12ld2n5b";
    };
  };
  "unicorn" = {
    version = "4.8.3";
    source = {
      type = "gem";
      sha256 = "1kpg2vikx2hxdyrl45bqcr89a0w59hfw7yn7xh87bmlczi34xds4";
    };
    dependencies = [
      "kgio"
      "rack"
      "raindrops"
    ];
  };
  "unicorn-worker-killer" = {
    version = "0.4.3";
    source = {
      type = "gem";
      sha256 = "0hhss1bwammh7nhplcj90455h79yq10c30npz4lpcsgw7vcpls00";
    };
    dependencies = [
      "get_process_mem"
      "unicorn"
    ];
  };
  "uuid" = {
    version = "2.3.8";
    source = {
      type = "gem";
      sha256 = "0gr2mxg27l380wpiy66mgv9wq02myj6m4gmp6c4g1vsbzkh0213v";
    };
    dependencies = [
      "macaddr"
    ];
  };
  "version_sorter" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1lad9c43w2xfzmva57ia6glpmhyivyk1m79jli42canshvan5v6y";
    };
  };
  "virtus" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "06iphwi3c4f7y9i2rvhvaizfswqbaflilziz4dxqngrdysgkn1fk";
    };
    dependencies = [
      "axiom-types"
      "coercible"
      "descendants_tracker"
      "equalizer"
    ];
  };
  "warden" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0ykzsgwml0pdqn6vdjjaix12gpcgn8b126z9fx7yq3r3bmdrwxlp";
    };
    dependencies = [
      "rack"
    ];
  };
  "webmock" = {
    version = "1.21.0";
    source = {
      type = "gem";
      sha256 = "1p7hqdxk5359xwp59pcx841fhbnqx01ra98rnwhdyz61nrc6piv3";
    };
    dependencies = [
      "addressable"
      "crack"
    ];
  };
  "websocket-driver" = {
    version = "0.6.2";
    source = {
      type = "gem";
      sha256 = "0y4kc2q2g69i4xdcn85bn7v7g6ia3znr687aivakmlzcanyiz7in";
    };
    dependencies = [
      "websocket-extensions"
    ];
  };
  "websocket-extensions" = {
    version = "0.1.2";
    source = {
      type = "gem";
      sha256 = "07qnsafl6203a2zclxl20hy4jq11c471cgvd0bj5r9fx1qqw06br";
    };
  };
  "whenever" = {
    version = "0.8.4";
    source = {
      type = "gem";
      sha256 = "1bs602cf5rmmj03chn8vwidx0z1psyfyabq6gs3mqna524pnj9h2";
    };
    dependencies = [
      "activesupport"
      "chronic"
    ];
  };
  "wikicloth" = {
    version = "0.8.1";
    source = {
      type = "gem";
      sha256 = "1jp6c2yzyqbap8jdiw8yz6l08sradky1llhyhmrg934l1b5akj3s";
    };
    dependencies = [
      "builder"
      "expression_parser"
      "rinku"
    ];
  };
  "xpath" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "04kcr127l34p7221z13blyl0dvh0bmxwx326j72idayri36a394w";
    };
    dependencies = [
      "nokogiri"
    ];
  };
}