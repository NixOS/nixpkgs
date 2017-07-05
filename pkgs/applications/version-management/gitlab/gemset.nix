{
  "RedCloth" = {
    version = "4.3.2";
    source = {
      type = "gem";
      sha256 = "0m9dv7ya9q93r8x1pg2gi15rxlbck8m178j1fz7r5v6wr1avrrqy";
    };
  };
  "ace-rails-ap" = {
    version = "4.1.2";
    source = {
      type = "gem";
      sha256 = "14wj9gsiy7rm0lvs27ffsrh92wndjksj6rlfj3n7jhv1v77w9v2h";
    };
  };
  "actionmailer" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "0pr3cmr0bpgg5d0f6wy1z6r45n14r9yin8jnr4hi3ssf402xpc0q";
    };
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "mail"
      "rails-dom-testing"
    ];
  };
  "actionpack" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "09fbazl0ja80na2wadfp3fzmdmdy1lsb4wd2yg7anbj0zk0ap7a9";
    };
    dependencies = [
      "actionview"
      "activesupport"
      "rack"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
  };
  "actionview" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "1mg4a8143q2wjhjq4mngl69jkv249z5jvg0jkdribdv4zkg586rp";
    };
    dependencies = [
      "activesupport"
      "builder"
      "erubis"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
  };
  "activejob" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "0kazbpfgzz6cdmwjnlb9m671ps4qgggwv2hy8y9xi4h96djyyfqz";
    };
    dependencies = [
      "activesupport"
      "globalid"
    ];
  };
  "activemodel" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "11vhh7zmp92880s5sx8r32v2p0b7xg039mfr92pjynpkz4q901ld";
    };
    dependencies = [
      "activesupport"
      "builder"
    ];
  };
  "activerecord" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "1kk4dhn8jfhqfsf1dmb3a183gix6k46xr6cjkxj0rp51w2za1ns0";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "arel"
    ];
  };
  "activerecord-nulldb-adapter" = {
    version = "0.3.7";
    source = {
      type = "gem";
      sha256 = "1dxk26drn3s0mpyk8ir30k1pg5fqndrnsdjkkncn0acylq4ja27z";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "activerecord_sane_schema_dumper" = {
    version = "0.2";
    source = {
      type = "gem";
      sha256 = "122c7v7lvs0gwckvx2rar07waxnx1vv0lryz322nybb69d8vbhl6";
    };
    dependencies = [
      "rails"
    ];
  };
  "activesupport" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "0wibdzd2f5l5rlsw1a1y3j3fhw2imrrbkxggdraa6q9qbdnc66hi";
    };
    dependencies = [
      "i18n"
      "minitest"
      "thread_safe"
      "tzinfo"
    ];
  };
  "acts-as-taggable-on" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "1h2y2zh4vrjf6bzdgvyq5a53a4gpr8xvq4a5rvq7fy1w43z4753s";
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
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1jrhvj4335dsrj0xndbf7a7m2inbwbx1knc0bwgvmkk1w47l43s0";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "akismet" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0hqpn25iyypkwkrqaibjm5nss5jmlkrddhia7frmz94prvyjr02w";
    };
  };
  "allocations" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "1y7z66lpzabyvviphk1fnzvrj5vhv7v9vppcnkrf0n5wh8qwx2zi";
    };
  };
  "arel" = {
    version = "6.0.4";
    source = {
      type = "gem";
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
    };
  };
  "asana" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "0bn7f3sc2f02g871jd0y6qdhixn464mflkjchp56x6kcnyqy24z6";
    };
    dependencies = [
      "faraday"
      "faraday_middleware"
      "faraday_middleware-multi_json"
      "oauth2"
    ];
  };
  "asciidoctor" = {
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0q9yhan2mkk1lh15zcfd9g2fn6faix9yrf5skg23dp1y77jv7vm0";
    };
  };
  "asciidoctor-plantuml" = {
    version = "0.0.7";
    source = {
      type = "gem";
      sha256 = "00ax9r822n4ykl6jizaxp03wqzknr7nn20mmqjpiwajy9j0zvr88";
    };
    dependencies = [
      "asciidoctor"
    ];
  };
  "ast" = {
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
    };
  };
  "atomic" = {
    version = "1.1.99";
    source = {
      type = "gem";
      sha256 = "1kh9rvhjn4dndbfsk3yjq7alds6s2j70rc4k8wdwdyibab8a8gq9";
    };
  };
  "attr_encrypted" = {
    version = "3.0.3";
    source = {
      type = "gem";
      sha256 = "1dikbf55wjqyzfb9p4xjkkkajwan569pmzljdf9c1fy4a94cd13d";
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
  "autoparse" = {
    version = "0.3.3";
    source = {
      type = "gem";
      sha256 = "1q5wkd8gc2ckmgry9fba4b8vxb5kr8k8gqq2wycbirgq06mbllb6";
    };
    dependencies = [
      "addressable"
      "extlib"
      "multi_json"
    ];
  };
  "autoprefixer-rails" = {
    version = "6.2.3";
    source = {
      type = "gem";
      sha256 = "0m1w42ncz0p48r5hbyglayxkzrnplw18r99dc1ia2cb3nizkwllx";
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
  "babosa" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "05rgxg4pz4bc4xk34w5grv0yp1j94wf571w84lf3xgqcbs42ip2f";
    };
  };
  "base32" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "0b7y8sy6j9v1lvfzd4va88k5vg9yh0xcjzzn3llcw7yxqlcrnbjk";
    };
  };
  "bcrypt" = {
    version = "3.1.11";
    source = {
      type = "gem";
      sha256 = "1d254sdhdj6mzak3fb5x3jam8b94pvl1srladvs53j05a89j5z50";
    };
  };
  "benchmark-ips" = {
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "0bh681m54qdsdyvpvflj1wpnj3ybspbpjkr4cnlrl4nk4yikli0j";
    };
  };
  "better_errors" = {
    version = "2.1.1";
    source = {
      type = "gem";
      sha256 = "11csk41yhijqvp0dkky0cjl8kn6blw4jhr8b6v4islfvvayddcxc";
    };
    dependencies = [
      "coderay"
      "erubis"
      "rack"
    ];
  };
  "bindata" = {
    version = "2.3.5";
    source = {
      type = "gem";
      sha256 = "07i51jzq9iamw40xmmcgkrdq4m8f0vb5gp53p6q1vggj7z53q3v7";
    };
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
    version = "3.3.6";
    source = {
      type = "gem";
      sha256 = "12hhw42hk9clwfj6yz5v0c5p35wrn5yjnji7bnzsfs99vi2q00ld";
    };
    dependencies = [
      "autoprefixer-rails"
      "sass"
    ];
  };
  "brakeman" = {
    version = "3.6.1";
    source = {
      type = "gem";
      sha256 = "0fxv3cgmjh6rimz2jcslj3qnh1vqqz1grrjnp6m3nywbznlv441w";
    };
  };
  "browser" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "055r4wyc3z61r7mg2bgqpzabpkg8db2q5rciwfx9lwfyhjx19pbv";
    };
  };
  "builder" = {
    version = "3.2.3";
    source = {
      type = "gem";
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
    };
  };
  "bullet" = {
    version = "5.5.1";
    source = {
      type = "gem";
      sha256 = "1pdq3ckmwxnwrdm2x89zfj68h0yhiln35y8wps2nkvam4kpivyr5";
    };
    dependencies = [
      "activesupport"
      "uniform_notifier"
    ];
  };
  "bundler-audit" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "1gr7k6m9fda7m66irxzydm8v9xbmlryjj65cagwm1zyi5f317srb";
    };
    dependencies = [
      "thor"
    ];
  };
  "byebug" = {
    version = "9.0.6";
    source = {
      type = "gem";
      sha256 = "1kbfcn65rgdhi72n8x9l393b89rvi5z542459k7d1ggchpb0idb0";
    };
  };
  "capybara" = {
    version = "2.6.2";
    source = {
      type = "gem";
      sha256 = "0ln77a5wwhd5sbxsh3v26xrwjnza0rgx2hn23yjggdlha03b00yw";
    };
    dependencies = [
      "addressable"
      "mime-types"
      "nokogiri"
      "rack"
      "rack-test"
      "xpath"
    ];
  };
  "capybara-screenshot" = {
    version = "1.0.14";
    source = {
      type = "gem";
      sha256 = "1xy79lf3rwn3602r4hqm9s8a03bhlf6hzwdi6345dzrkmhwwj2ij";
    };
    dependencies = [
      "capybara"
      "launchy"
    ];
  };
  "carrierwave" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1c0bclx9nnysw3pdsdnypdja48cyf4mbwf1qxcmgb35z0l7kc3fc";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "mime-types"
    ];
  };
  "cause" = {
    version = "0.1";
    source = {
      type = "gem";
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
    };
  };
  "charlock_holmes" = {
    version = "0.7.3";
    source = {
      type = "gem";
      sha256 = "0jsl6k27wjmssxbwv9wpf7hgp9r0nvizcf6qpjnr7qs2nia53lf7";
    };
  };
  "chronic" = {
    version = "0.10.2";
    source = {
      type = "gem";
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
    };
  };
  "chronic_duration" = {
    version = "0.10.6";
    source = {
      type = "gem";
      sha256 = "1k7sx3xqbrn6s4pishh2pgr4kw6fmw63h00lh503l66k8x0qvigs";
    };
    dependencies = [
      "numerizer"
    ];
  };
  "chunky_png" = {
    version = "1.3.5";
    source = {
      type = "gem";
      sha256 = "0vf0axgrm95bs3y0x5gdb76xawfh210yxplj7jbwr6z7n88i1axn";
    };
  };
  "citrus" = {
    version = "3.0.2";
    source = {
      type = "gem";
      sha256 = "0l7nhk3gkm1hdchkzzhg2f70m47pc0afxfpl6mkiibc9qcpl3hjf";
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
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "1x6z923iwr1hi04k6kz5a6llrixflz8h5sskl9mhaaxy9jx2x93r";
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
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "1mv1kaw3z4ry6cm51w8pfrbby40gqwxanrqyqr0nvs8j1bscc1gw";
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
    version = "1.10.0";
    source = {
      type = "gem";
      sha256 = "1k4fg39rrkl3bpgchfj94fbl9s4ysaz16w8dkqncf2vyf79l3qz0";
    };
  };
  "colorize" = {
    version = "0.7.7";
    source = {
      type = "gem";
      sha256 = "16bsjcqb6pg3k94dh1l5g3hhx5g2g4g8rlr76dnc78yyzjjrbayn";
    };
  };
  "concurrent-ruby" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
    };
  };
  "concurrent-ruby-ext" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "119l554zi3720d3rk670ldcqhsgmfii28a9z307v4mwdjckdm4gp";
    };
    dependencies = [
      "concurrent-ruby"
    ];
  };
  "connection_pool" = {
    version = "2.2.1";
    source = {
      type = "gem";
      sha256 = "17vpaj6kyf2i8bimaxz7rg1kyadf4d10642ja67qiqlhwgczl2w7";
    };
  };
  "crack" = {
    version = "0.4.3";
    source = {
      type = "gem";
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
    };
    dependencies = [
      "safe_yaml"
    ];
  };
  "creole" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "00rcscz16idp6dx0dk5yi5i0fz593i3r6anbn5bg2q07v3i025wm";
    };
  };
  "css_parser" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0jlr17cn044yaq4l3d9p42g3bghnamwsprq9c39xn6pxjrn5k1hy";
    };
    dependencies = [
      "addressable"
    ];
  };
  "d3_rails" = {
    version = "3.5.11";
    source = {
      type = "gem";
      sha256 = "12vxiiflnnkcxak2wmbajyf5wzmcv9wkl4drsp0am72azl8a6g9x";
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
    version = "1.5.3";
    source = {
      type = "gem";
      sha256 = "0fx6zmqznklmkbjl6f713jyl11d4g9q220rcl86m2jp82r8kfwjj";
    };
  };
  "debug_inspector" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "109761g00dbrw5q0dfnbqg8blfm699z4jj70l4zrgf9mzn7ii50m";
    };
  };
  "debugger-ruby_core_source" = {
    version = "1.3.8";
    source = {
      type = "gem";
      sha256 = "1lp5dmm8a8dpwymv6r1y6yr24wxsj0gvgb2b8i7qq9rcv414snwd";
    };
  };
  "deckar01-task_list" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "0w6qsk712ic6vx9ydmix2ys95zwpkvdx3a9xxi8bdqlpgh1ipm9j";
    };
    dependencies = [
      "html-pipeline"
    ];
  };
  "default_value_for" = {
    version = "3.0.2";
    source = {
      type = "gem";
      sha256 = "014482mxjrc227fxv6vff6ccjr9dr0ydz52flxslsa7biq542k73";
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
    version = "4.2.0";
    source = {
      type = "gem";
      sha256 = "045qw3186gkcm38wjbjhb7w2zycbqj85wfb1cdwvkqk8hf1a7dp0";
    };
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
      "responders"
      "warden"
    ];
  };
  "devise-two-factor" = {
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "1pkldws5lga4mlv4xmcrfb0yivl6qad0l8qyb2hdb50adv6ny4gs";
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
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "1azibizfv91sjbzhjqj1pg2xcv8z9b8a7z6kb3wpl4hpj5hil5kj";
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
    version = "0.5.20161021";
    source = {
      type = "gem";
      sha256 = "1y5c96gzyh6z4nrnkisljqngfvljdba36dww657ka0x7khzvx7jl";
    };
    dependencies = [
      "unf"
    ];
  };
  "doorkeeper" = {
    version = "4.2.0";
    source = {
      type = "gem";
      sha256 = "0hs8r280k7a1kibzxrhifjps880n43jfrybf4mqpffw669jrwk3v";
    };
    dependencies = [
      "railties"
    ];
  };
  "doorkeeper-openid_connect" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "1pla85j5wxra0k9rhj04g2ai5d5jg97fiavi0s9v2hjba2l54cni";
    };
    dependencies = [
      "doorkeeper"
      "json-jwt"
    ];
  };
  "dropzonejs-rails" = {
    version = "0.7.2";
    source = {
      type = "gem";
      sha256 = "1vqqxzv6qdqy47m2q28adnmccfvc17p2bmkkaqjvrczrhvkkha64";
    };
    dependencies = [
      "rails"
    ];
  };
  "email_reply_trimmer" = {
    version = "0.1.6";
    source = {
      type = "gem";
      sha256 = "0vijywhy1acsq4187ss6w8a7ksswaf1d5np3wbj962b6rqif5vcz";
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
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "0s8rvfl0vn8w7k1sgkc234060jh468s3zd45xa64p1jdmfa3zwmb";
    };
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
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "088r5c2mz2vy2jbbx1xjbi8msnzg631ggli29nhik2spbcp1z6vh";
    };
  };
  "et-orbi" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "1apn9gzgbgs7z6p6l3rv66vrfwyfh68p2rxkybh10vx82fp6g0wi";
    };
    dependencies = [
      "tzinfo"
    ];
  };
  "eventmachine" = {
    version = "1.0.8";
    source = {
      type = "gem";
      sha256 = "1frvpk3p73xc64qkn0ymll3flvn4xcycq5yx8a43zd3gyzc1ifjp";
    };
  };
  "excon" = {
    version = "0.55.0";
    source = {
      type = "gem";
      sha256 = "149grwcry52hi3f1xkbbx74jw5m3qcmiib13wxrk3rw5rz200kmx";
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
  "extlib" = {
    version = "0.9.16";
    source = {
      type = "gem";
      sha256 = "1cbw3vgb189z3vfc1arijmsd604m3w5y5xvdfkrblc9qh7sbk2rh";
    };
  };
  "factory_girl" = {
    version = "4.7.0";
    source = {
      type = "gem";
      sha256 = "1xzl4z9z390fsnyxp10c9if2n46zan3n6zwwpfnwc33crv4s410i";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "factory_girl_rails" = {
    version = "4.7.0";
    source = {
      type = "gem";
      sha256 = "0hzpirb33xdqaz44i1mbcfv0icjrghhgaz747llcfsflljd4pa4r";
    };
    dependencies = [
      "factory_girl"
      "railties"
    ];
  };
  "faraday" = {
    version = "0.11.0";
    source = {
      type = "gem";
      sha256 = "18p1csdivgwmshfw3mb698a3bn0yrykg30khk5qxjf6n168g91jr";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "faraday_middleware" = {
    version = "0.11.0.1";
    source = {
      type = "gem";
      sha256 = "0bcarc90brm1y68bl957w483bddsy9idj2gghqnysk6bbxpsvm00";
    };
    dependencies = [
      "faraday"
    ];
  };
  "faraday_middleware-multi_json" = {
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "0651sxhzbq9xfq3hbpmrp0nbybxnm9ja3m97k386m4bqgamlvz1q";
    };
    dependencies = [
      "faraday_middleware"
      "multi_json"
    ];
  };
  "fast_gettext" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "1l8snpgxrri8jc0c35s6h3n92j8bfahh1knj94mw6i4zqhnpv40z";
    };
  };
  "ffaker" = {
    version = "2.4.0";
    source = {
      type = "gem";
      sha256 = "1rlfvf2iakphs3krxy1hiywr2jzmrhvhig8n8fw6rcivpz9v52ry";
    };
  };
  "ffi" = {
    version = "1.9.10";
    source = {
      type = "gem";
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
    };
  };
  "flay" = {
    version = "2.8.1";
    source = {
      type = "gem";
      sha256 = "1x563gyx292ka3awps6h6hmswqf71zdxnzw0pfv6p2mhd2zwxaba";
    };
    dependencies = [
      "erubis"
      "path_expander"
      "ruby_parser"
      "sexp_processor"
    ];
  };
  "flipper" = {
    version = "0.10.2";
    source = {
      type = "gem";
      sha256 = "1gbvd4j0rkr7qc3mnjdw4r9p6lffnwv7rvm1cyr8a0avjky34n8p";
    };
  };
  "flipper-active_record" = {
    version = "0.10.2";
    source = {
      type = "gem";
      sha256 = "053lq791z8bf3xv6kb14nq3yrzjpmlyhzq3kvys978dc8yw78ld7";
    };
    dependencies = [
      "activerecord"
      "flipper"
    ];
  };
  "flowdock" = {
    version = "0.7.1";
    source = {
      type = "gem";
      sha256 = "04nrvg4gzgabf5mnnhccl8bwrkvn3y4pm7a1dqzqhpvfr4m5pafg";
    };
    dependencies = [
      "httparty"
      "multi_json"
    ];
  };
  "fog-aliyun" = {
    version = "0.1.0";
    source = {
      type = "gem";
      sha256 = "1i76g8sdskyfc0gcnd6n9i757s7dmwg3wf6spcr2xh8wzyxkm1pj";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "ipaddress"
      "xml-simple"
    ];
  };
  "fog-aws" = {
    version = "0.13.0";
    source = {
      type = "gem";
      sha256 = "1am8fi0z19y398zg7g629rzxzkks9rxyl7j8m5vsgzs80mbsl06s";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
      "ipaddress"
    ];
  };
  "fog-core" = {
    version = "1.44.1";
    source = {
      type = "gem";
      sha256 = "0l78l9jlkxnv1snib80p92r5cwk6jqgyni6758j6kphzcplkkbdm";
    };
    dependencies = [
      "builder"
      "excon"
      "formatador"
    ];
  };
  "fog-google" = {
    version = "0.5.0";
    source = {
      type = "gem";
      sha256 = "06irf9gcg5v8iwaa5qilhwir6gl82rrp7jyyw87ad15v8p3xa59f";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
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
  "fog-local" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "0256l3q2f03q8fk49035h5jij388rcz9fqlwri7y788492b4vs3c";
    };
    dependencies = [
      "fog-core"
    ];
  };
  "fog-openstack" = {
    version = "0.1.6";
    source = {
      type = "gem";
      sha256 = "1pw2ypxbbmfscmhcz05ry5kc7c5rjr61lv9zj6zpr98fg1wad3a6";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "ipaddress"
    ];
  };
  "fog-rackspace" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "0y2bli061g37l9p4w0ljqbmg830rp2qz6sf8b0ck4cnx68j7m32a";
    };
    dependencies = [
      "fog-core"
      "fog-json"
      "fog-xml"
      "ipaddress"
    ];
  };
  "fog-xml" = {
    version = "0.1.3";
    source = {
      type = "gem";
      sha256 = "043lwdw2wsi6d55ifk0w3izi5l1d1h0alwyr3fixic7b94kc812n";
    };
    dependencies = [
      "fog-core"
      "nokogiri"
    ];
  };
  "font-awesome-rails" = {
    version = "4.7.0.1";
    source = {
      type = "gem";
      sha256 = "0qc07vj7qyllrj7lr7wl89l5ir0gj104rc7sds2jynzmrqsamnlw";
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
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "17yy3cp7b75ngc2v4f0cacvq3f1bk3il5a0ykvnypl6fcj6r6b3w";
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
  "gettext" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "1d2i1zfqvaxqi01g9vvkfkf5r85c5nfj2zwpd2ib9vvkjavhn9cx";
    };
    dependencies = [
      "locale"
      "text"
    ];
  };
  "gettext_i18n_rails" = {
    version = "1.8.0";
    source = {
      type = "gem";
      sha256 = "0vs918a03mqvx9aczaqdg9d2q9s3c6swqavzn82qgq5i822czrcm";
    };
    dependencies = [
      "fast_gettext"
    ];
  };
  "gettext_i18n_rails_js" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "04lkmy6mgxdnpl4icddg00nj0ay0ylacfxrm723npzaqviml7c2x";
    };
    dependencies = [
      "gettext"
      "gettext_i18n_rails"
      "po_to_json"
      "rails"
    ];
  };
  "gherkin-ruby" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "18ay7yiibf4sl9n94k7mbi4k5zj2igl4j71qcmkswv69znyx0sn1";
    };
  };
  "gitaly" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "141s3ac4xvjaar6dl7xwg6qc4hdz2vc3vwkc3gc14hwpllhmjaji";
    };
    dependencies = [
      "google-protobuf"
      "grpc"
    ];
  };
  "github-linguist" = {
    version = "4.7.6";
    source = {
      type = "gem";
      sha256 = "0c8w92yzjfs7pjnm8bdjsgyd1jpisn10fb6dy43381k1k8pxsifd";
    };
    dependencies = [
      "charlock_holmes"
      "escape_utils"
      "mime-types"
      "rugged"
    ];
  };
  "github-markup" = {
    version = "1.4.0";
    source = {
      type = "gem";
      sha256 = "046bvnbhk3bw021sd88808n71dya0b0dmx8hm64rj0fvs2jzg54z";
    };
    meta.priority = 10; # lower priority, exectuable conflicts with gitlab-markdown
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
    version = "2.8.1";
    source = {
      type = "gem";
      sha256 = "0lf1cr6pzqrbnxiiwym6q74b1a2ihdi91dynajk8hi1p093hl66n";
    };
    dependencies = [
      "charlock_holmes"
      "diff-lcs"
      "mime-types"
      "posix-spawn"
    ];
  };
  "gitlab-markup" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "1aam7zvvbai5nv7vf0c0640pvik6s71f276lip4yb4slbg0pfpn2";
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
  "globalid" = {
    version = "0.3.7";
    source = {
      type = "gem";
      sha256 = "11plkgyl3w9k4y2scc1igvpgwyz4fnmsr63h2q4j8wkb48nlnhak";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "gollum-grit_adapter" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0fcibm63v1afc0fj5rki0mm51m7nndil4cjcjjvkh3yigfn4nr4b";
    };
    dependencies = [
      "gitlab-grit"
    ];
  };
  "gollum-lib" = {
    version = "4.2.1";
    source = {
      type = "gem";
      sha256 = "1q668c76gnyyyl8217gnblbj50plm7giacs5lgf7ix2rj8rdxzj7";
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
  "gollum-rugged_adapter" = {
    version = "0.4.4";
    source = {
      type = "gem";
      sha256 = "0khfmakp65frlaj7ajs6ihqg4xi7yc9z96kpsf1b7giqi3fqhhv4";
    };
    dependencies = [
      "mime-types"
      "rugged"
    ];
  };
  "gon" = {
    version = "6.1.0";
    source = {
      type = "gem";
      sha256 = "1jmf6ly9wfrg52xkk9qb4hlfn3zdmz62ivclhp4f424m39rd9ngz";
    };
    dependencies = [
      "actionpack"
      "json"
      "multi_json"
      "request_store"
    ];
  };
  "google-api-client" = {
    version = "0.8.7";
    source = {
      type = "gem";
      sha256 = "11wr57j9fp6x6fym4k1a7jqp72qgc8l24mfwb4y55bbvdmkv1b2d";
    };
    dependencies = [
      "activesupport"
      "addressable"
      "autoparse"
      "extlib"
      "faraday"
      "googleauth"
      "launchy"
      "multi_json"
      "retriable"
      "signet"
    ];
  };
  "google-protobuf" = {
    version = "3.2.0.2";
    source = {
      type = "gem";
      sha256 = "1kd3k09p6i7jg7bbgr5bda00l7y1n5clxwg5nzn3gpd0hcjdfhsl";
    };
  };
  "googleauth" = {
    version = "0.5.1";
    source = {
      type = "gem";
      sha256 = "1nzkg63s161c6jsia92c1jfwpayzbpwn588smd286idn07y0az2m";
    };
    dependencies = [
      "faraday"
      "jwt"
      "logging"
      "memoist"
      "multi_json"
      "os"
      "signet"
    ];
  };
  "grape" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "1z52875d5v3slpnyfndxilf9nz0phb2jwxiir0hz8fp0ni13m9yy";
    };
    dependencies = [
      "activesupport"
      "builder"
      "hashie"
      "multi_json"
      "multi_xml"
      "mustermann-grape"
      "rack"
      "rack-accept"
      "virtus"
    ];
  };
  "grape-entity" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "18jhjn1164z68xrjz23wf3qha3x9az086dr7p6405jv6rszyxihq";
    };
    dependencies = [
      "activesupport"
      "multi_json"
    ];
  };
  "grpc" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "0dim67bny2pwvanqzxdvkbhcvmnfwd96mcl4jdkr9fvr0bbhbzw1";
    };
    dependencies = [
      "google-protobuf"
      "googleauth"
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
  "haml_lint" = {
    version = "0.21.0";
    source = {
      type = "gem";
      sha256 = "1vy8dkgkisikh3aigkhw7rl7wr83gb5xnaxafba654r2nyyvz63d";
    };
    dependencies = [
      "haml"
      "rake"
      "rubocop"
      "sysexits"
    ];
  };
  "hamlit" = {
    version = "2.6.1";
    source = {
      type = "gem";
      sha256 = "0ph4kv2ddr538f9ni2fmk7aq38djv5am29r3m6y64adg52n6jma9";
    };
    dependencies = [
      "temple"
      "thor"
      "tilt"
    ];
  };
  "hashdiff" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "1q1rp4ncyykjrlh4kvg5vpxfzh1xbp8q0pc85k2d697j23jwd0jn";
    };
  };
  "hashie" = {
    version = "3.5.5";
    source = {
      type = "gem";
      sha256 = "0lfmbh98ng141m7yc8s4v56v49ppam416pzvd2d7pg85wmm44ljw";
    };
  };
  "hashie-forbidden_attributes" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "1chgg5d2iddja6ww02x34g8avg11fzmzcb8yvnqlykii79zx6vis";
    };
    dependencies = [
      "hashie"
    ];
  };
  "health_check" = {
    version = "2.6.0";
    source = {
      type = "gem";
      sha256 = "1mfa180nyzz1j0abfihm5nm3lmzq99362ibcphky6rh5vwhckvm8";
    };
    dependencies = [
      "rails"
    ];
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
  "html2text" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "0kxdj8pf9pss9xgs8aac0alj5g1fi225yzdhh33lzampkazg1hii";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "htmlentities" = {
    version = "4.3.4";
    source = {
      type = "gem";
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
    };
  };
  "http" = {
    version = "0.9.8";
    source = {
      type = "gem";
      sha256 = "1ll9x8qjp97l8gj0jx23nj7xvm0rsxj5pb3d19f7bhmdb70r0xsi";
    };
    dependencies = [
      "addressable"
      "http-cookie"
      "http-form_data"
      "http_parser.rb"
    ];
  };
  "http-cookie" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
    };
    dependencies = [
      "domain_name"
    ];
  };
  "http-form_data" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "10r6hy8wcf8n4nbdmdz9hrm8mg45lncfc7anaycpzrhfp3949xh9";
    };
  };
  "http_parser.rb" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
    };
  };
  "httparty" = {
    version = "0.13.7";
    source = {
      type = "gem";
      sha256 = "0c9gvg6dqw2h3qyaxhrq1pzm6r69zfcmfh038wyhisqsd39g9hr2";
    };
    dependencies = [
      "json"
      "multi_xml"
    ];
  };
  "httpclient" = {
    version = "2.8.2";
    source = {
      type = "gem";
      sha256 = "1pg15svk9lv5r7w1hxd87di6apsr9y009af3mm01xcaccvqj4j2d";
    };
  };
  "i18n" = {
    version = "0.8.1";
    source = {
      type = "gem";
      sha256 = "1s6971zmjxszdrp59vybns9gzxpdxzdklakc5lp8nl4fx5kpxkbp";
    };
  };
  "ice_nine" = {
    version = "0.11.2";
    source = {
      type = "gem";
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
    };
  };
  "influxdb" = {
    version = "0.2.3";
    source = {
      type = "gem";
      sha256 = "1vhg5nd88nwvfa76lqcczld916nljswwq6clsixrzi3js8ym9y1w";
    };
    dependencies = [
      "cause"
      "json"
    ];
  };
  "ipaddress" = {
    version = "0.8.3";
    source = {
      type = "gem";
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
    };
  };
  "jira-ruby" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "03n76a8m2d352q29j3yna1f9g3xg9dc9p3fvvx77w67h19ks7zrf";
    };
    dependencies = [
      "activesupport"
      "oauth"
    ];
  };
  "jquery-atwho-rails" = {
    version = "1.3.2";
    source = {
      type = "gem";
      sha256 = "0g8239cddyi48i5n0hq2acg9k7n7jilhby9g36zd19mwqyia16w9";
    };
  };
  "jquery-rails" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "1asbrr9hqf43q9qbjf87f5lm7fp12pndh76z89ks6jwxf1350fj1";
    };
    dependencies = [
      "rails-dom-testing"
      "railties"
      "thor"
    ];
  };
  "json" = {
    version = "1.8.6";
    source = {
      type = "gem";
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
    };
  };
  "json-jwt" = {
    version = "1.7.1";
    source = {
      type = "gem";
      sha256 = "1ylvlnb6assan9qkhz1vq1gbfwxg35q9a8f8qhlyx0fak5fyks23";
    };
    dependencies = [
      "activesupport"
      "bindata"
      "multi_json"
      "securecompare"
      "url_safe_base64"
    ];
  };
  "json-schema" = {
    version = "2.6.2";
    source = {
      type = "gem";
      sha256 = "15bva4w940ckan3q89in5f98s8zz77nxglylgm98697wa4fbfqp9";
    };
    dependencies = [
      "addressable"
    ];
  };
  "jwt" = {
    version = "1.5.6";
    source = {
      type = "gem";
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
    };
  };
  "kaminari" = {
    version = "0.17.0";
    source = {
      type = "gem";
      sha256 = "1n063jha143mw4fklpq5f4qs7saakx4s4ps1zixj0s5y8l9pam54";
    };
    dependencies = [
      "actionpack"
      "activesupport"
    ];
  };
  "kgio" = {
    version = "2.10.0";
    source = {
      type = "gem";
      sha256 = "1y6wl3vpp82rdv5g340zjgkmy6fny61wib7xylyg0d09k5f26118";
    };
  };
  "knapsack" = {
    version = "1.11.0";
    source = {
      type = "gem";
      sha256 = "0z0bp5al0b8wyzw8ff99jwr6qsh5n52xqryvzvy2nbrma9qr7dam";
    };
    dependencies = [
      "rake"
      "timecop"
    ];
  };
  "kubeclient" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "09hr5cb6rzf9876wa0c8pv3kxjj4s8hcjpf7jjdg2n9prb7hhmgi";
    };
    dependencies = [
      "http"
      "recursive-open-struct"
      "rest-client"
    ];
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
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "1pcrdbxvp2x5six8fqn8gf09bn9rd3jga76ds205yph5m8fsda21";
    };
    dependencies = [
      "launchy"
    ];
  };
  "letter_opener_web" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "050x5cwqbxj2cydd2pzy9vfhmpgn1w6lfbwjaax1m1vpkn3xg9bv";
    };
    dependencies = [
      "actionmailer"
      "letter_opener"
      "railties"
    ];
  };
  "license_finder" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "092rwf1yjq1l63zbqanmbnbky8g5pj7c3g30mcqbyppbqrsflx80";
    };
    dependencies = [
      "httparty"
      "rubyzip"
      "thor"
      "xml-simple"
    ];
  };
  "licensee" = {
    version = "8.7.0";
    source = {
      type = "gem";
      sha256 = "1nhj0vx30llqyb7q52bwmrgy9xpjk3q48k98h0dvq83ym4v216a2";
    };
    dependencies = [
      "rugged"
    ];
  };
  "little-plugger" = {
    version = "1.1.4";
    source = {
      type = "gem";
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
    };
  };
  "locale" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
    };
  };
  "logging" = {
    version = "2.2.2";
    source = {
      type = "gem";
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
    };
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
  };
  "loofah" = {
    version = "2.0.3";
    source = {
      type = "gem";
      sha256 = "109ps521p0sr3kgc460d58b4pr1z4mqggan2jbsf0aajy9s6xis8";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "mail" = {
    version = "2.6.5";
    source = {
      type = "gem";
      sha256 = "07k8swmv7vgk86clzpjhdlmgahlvg6yzjwy7wcsv0xx400fh4x61";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "mail_room" = {
    version = "0.9.1";
    source = {
      type = "gem";
      sha256 = "16b8yjd1if665mwaindwys06nkkcs0jw3dcsqvn6qbp6alfigqaa";
    };
  };
  "memoist" = {
    version = "0.15.0";
    source = {
      type = "gem";
      sha256 = "0yd3rd7bnbhn9n47qlhcii5z89liabdjhy3is3h6gq77gyfk4f5q";
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
    version = "2.99.3";
    source = {
      type = "gem";
      sha256 = "03j98xr0qw2p2jkclpmk7pm29yvmmh0073d8d43ajmr0h3w7i5l9";
    };
  };
  "mimemagic" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "101lq4bnjs7ywdcicpw3vbz9amg5gbb4va1626fybd2hawgdx8d9";
    };
  };
  "mini_portile2" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "1y25adxb1hgg1wb2rn20g3vl07qziq6fz364jc5694611zz863hb";
    };
  };
  "minitest" = {
    version = "5.7.0";
    source = {
      type = "gem";
      sha256 = "0rxqfakp629mp3vwda7zpgb57lcns5znkskikbfd0kriwv8i1vq8";
    };
  };
  "mmap2" = {
    version = "2.2.7";
    source = {
      type = "gem";
      sha256 = "1rgf4zhqa6632nbqj585hc0x69iz21s5c91mpijcr9i5wpj9p1s6";
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
    version = "1.12.1";
    source = {
      type = "gem";
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
    };
  };
  "multi_xml" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
    };
  };
  "multipart-post" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
    };
  };
  "mustermann" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "0km27zp3mnlmh157nmj3pyd2g7n2da4dh4mr0psq53a9r0d4gli8";
    };
    dependencies = [
      "tool"
    ];
  };
  "mustermann-grape" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "1g6kf753v0kf8zfz0z46kyb7cbpinpc3qqh02qm4s9n49s1v2fva";
    };
    dependencies = [
      "mustermann"
    ];
  };
  "mysql2" = {
    version = "0.3.20";
    source = {
      type = "gem";
      sha256 = "0n075x14n9kziv0qdxqlzhf3j1abi1w6smpakfpsg4jbr8hnn5ip";
    };
  };
  "net-ldap" = {
    version = "0.12.1";
    source = {
      type = "gem";
      sha256 = "0z1j0zklbbx3vi91zcd2v0fnkfgkvq3plisa6hxaid8sqndyak46";
    };
  };
  "net-ssh" = {
    version = "3.0.1";
    source = {
      type = "gem";
      sha256 = "1dzqkgwi9xm6mbfk1rkk17rzmz8m5xakqi21w1b97ybng6kkw0hf";
    };
  };
  "netrc" = {
    version = "0.11.0";
    source = {
      type = "gem";
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
    };
  };
  "nokogiri" = {
    version = "1.6.8.1";
    source = {
      type = "gem";
      sha256 = "045xdg0w7nnsr2f2gb7v7bgx53xbc9dxf0jwzmh2pr3jyrzlm0cj";
    };
    dependencies = [
      "mini_portile2"
    ];
  };
  "numerizer" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "0vrk9jbv4p4dcz0wzr72wrf5kajblhc5l9qf7adbcwi4qvz9xv0h";
    };
  };
  "oauth" = {
    version = "0.5.1";
    source = {
      type = "gem";
      sha256 = "1awhy8ddhixch44y68lail3h1d214rnl3y1yzk0msq5g4z2l62ky";
    };
  };
  "oauth2" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "0qgalbqnmffvkw32zb4m5jfy2vvhcxk0m8rli5lcy3h1g5hl8fhn";
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
    version = "4.6.2";
    source = {
      type = "gem";
      sha256 = "1bppfc0q8mflbcdsb66dly3skx42vad30q0fkzwx4za908qwvjpd";
    };
    dependencies = [
      "sawyer"
    ];
  };
  "oj" = {
    version = "2.17.5";
    source = {
      type = "gem";
      sha256 = "17c50q2ygi8jlw8dq3ghzha774ln1swbvmvai2ar7qb3bwcfgc8b";
    };
  };
  "omniauth" = {
    version = "1.4.2";
    source = {
      type = "gem";
      sha256 = "0kvr0g12fawf491jmdaxzzr6qyd1r8ixzkcdr0zscs42fqsxv79i";
    };
    dependencies = [
      "hashie"
      "rack"
    ];
  };
  "omniauth-auth0" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "0dhfl01519q1cp4w0ml481j1cg05g7qvam0x4ia9jhdz8yx6npfs";
    };
    dependencies = [
      "omniauth-oauth2"
    ];
  };
  "omniauth-authentiq" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "0drbrrxk0wlmq4y6nmsxa77b815ji1jsdjr6fcqxb3sqiscq2p0a";
    };
    dependencies = [
      "omniauth-oauth2"
    ];
  };
  "omniauth-azure-oauth2" = {
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "0qay454zvyas8xfnfkycqpjkafaq5pw4gaji176cdfw0blhviz0s";
    };
    dependencies = [
      "jwt"
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-cas3" = {
    version = "1.1.3";
    source = {
      type = "gem";
      sha256 = "13swm2hi2z63nvb2bps6g41kki8kr9b5c7014rk8259bxlpflrk7";
    };
    dependencies = [
      "addressable"
      "nokogiri"
      "omniauth"
    ];
  };
  "omniauth-facebook" = {
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "03zjla9i446fk1jkw7arh67c39jfhp5bhkmhvbw8vczxr1jkbbh5";
    };
    dependencies = [
      "omniauth-oauth2"
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
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0hv672p372jq7p9p6dw8i7qyisbny3lq0si077yys1fy4bjw127x";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-google-oauth2" = {
    version = "0.4.1";
    source = {
      type = "gem";
      sha256 = "1m6v2vm3h21ychd10wzkdhyhnrk9zhc1bgi4ahp5gwy00pggrppw";
    };
    dependencies = [
      "jwt"
      "multi_json"
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-kerberos" = {
    version = "0.3.0";
    source = {
      type = "gem";
      sha256 = "05xsv76qjxcxzrvabaar2bchv7435y8l2j0wk4zgchh3yv85kiq7";
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
  "omniauth-oauth2-generic" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "1m6vpip3rm1spx1x9y1kjczzailsph1xqgaakqylzq3jqkv18273";
    };
    dependencies = [
      "omniauth-oauth2"
    ];
  };
  "omniauth-saml" = {
    version = "1.7.0";
    source = {
      type = "gem";
      sha256 = "1garppa83v53yr9bwfx51v4hqwfr5h4aq3d39gn2fmysnfav7c1x";
    };
    dependencies = [
      "omniauth"
      "ruby-saml"
    ];
  };
  "omniauth-shibboleth" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0a8pwy23aybxhn545357zdjy0hnpfgldwqk5snmz9kxingpq12jl";
    };
    dependencies = [
      "omniauth"
    ];
  };
  "omniauth-twitter" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "1hqjpb1zx0pp3s12c83pkpk4kkx41f001jc5n8qz0h3wll0ld833";
    };
    dependencies = [
      "json"
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
  "os" = {
    version = "0.9.6";
    source = {
      type = "gem";
      sha256 = "1llv8w3g2jwggdxr5a5cjkrnbbfnvai3vxacxxc0fy84xmz3hymz";
    };
  };
  "paranoia" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "1kfznq6lba1xb3nskvn8kdb08ljh4a0lvbm3lv91xvj6n9hm15k0";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "parser" = {
    version = "2.4.0.0";
    source = {
      type = "gem";
      sha256 = "130rfk8a2ws2fyq52hmi1n0xakylw39wv4x1qhai4z17x2b0k9cq";
    };
    dependencies = [
      "ast"
    ];
  };
  "path_expander" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0hklnfb0br6mx6l25zknz2zj6r152i0jiy6fn6ki220x0l5m2h59";
    };
  };
  "peek" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1998vcsli215d6qrn9821gr2qip60xki2p7n2dpn8i1n68hyshcn";
    };
    dependencies = [
      "concurrent-ruby"
      "concurrent-ruby-ext"
      "railties"
    ];
  };
  "peek-gc" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "094h3mr9q8wzbqsj0girpyjvj4bcxax8m438igp42n75xv0bhwi9";
    };
    dependencies = [
      "peek"
    ];
  };
  "peek-host" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "11ra0hzdkdywp3cmaizcisliy26jwz7k0r9nkgm87y7amqk1wh8b";
    };
    dependencies = [
      "peek"
    ];
  };
  "peek-mysql2" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0bb2fzx3dwj7k6sc87jwhjk8vzp8dskv49j141xx15vvkg603j8k";
    };
    dependencies = [
      "atomic"
      "mysql2"
      "peek"
    ];
  };
  "peek-performance_bar" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "0wrzhv6d0ixxba9ckis6mmvb9vdsxl9mdl4zh4arv6w40wqv0k8d";
    };
    dependencies = [
      "peek"
    ];
  };
  "peek-pg" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "17yk8xrh7yh57wg6vi3s8km9qd9f910n94r511mdyqd7aizlfb7c";
    };
    dependencies = [
      "concurrent-ruby"
      "concurrent-ruby-ext"
      "peek"
      "pg"
    ];
  };
  "peek-rblineprof" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "0ywk1gvsnhrkhqq2ibwsg7099kg5m2vs4nmzy0wf65kb0ywl0m9c";
    };
    dependencies = [
      "peek"
      "rblineprof"
    ];
  };
  "peek-redis" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0v91cni591d9wdrmvgam20gr3504x84mh1l95da4rz5a9436jm33";
    };
    dependencies = [
      "atomic"
      "peek"
      "redis"
    ];
  };
  "peek-sidekiq" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "0y7s32p6cp66z1hpd1wcv4crmvvvcag5i39aazclckjsfpdfn24x";
    };
    dependencies = [
      "atomic"
      "peek"
      "sidekiq"
    ];
  };
  "pg" = {
    version = "0.18.4";
    source = {
      type = "gem";
      sha256 = "07dv4ma9xd75xpsnnwwg1yrpwpji7ydy0q1d9dl0yfqbzpidrw32";
    };
  };
  "po_to_json" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1xvanl437305mry1gd57yvcg7xrfhri91czr32bjr8j2djm8hwba";
    };
    dependencies = [
      "json"
    ];
  };
  "poltergeist" = {
    version = "1.9.0";
    source = {
      type = "gem";
      sha256 = "1fnkly1ks31nf5cdks9jd5c5vynbanrr8pwp801qq2i8bg78rwc0";
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
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
    };
  };
  "premailer" = {
    version = "1.10.4";
    source = {
      type = "gem";
      sha256 = "10w6f7r6snpkcnv3byxma9b08lyqzcfxkm083scb2dr2ly4xkzyf";
    };
    dependencies = [
      "addressable"
      "css_parser"
      "htmlentities"
    ];
  };
  "premailer-rails" = {
    version = "1.9.7";
    source = {
      type = "gem";
      sha256 = "05czxmx6hnykg6g23hy2ww2bf86a69njbi02sv7lrds4w776jhim";
    };
    dependencies = [
      "actionmailer"
      "premailer"
    ];
  };
  "prometheus-client-mmap" = {
    version = "0.7.0.beta5";
    source = {
      type = "gem";
      sha256 = "11c4g8sa45xyf0dpwwszpz7xbfvlmmmn6cfg038xkixp13q1waqz";
    };
    dependencies = [
      "mmap2"
    ];
  };
  "pry" = {
    version = "0.10.4";
    source = {
      type = "gem";
      sha256 = "05xbzyin63aj2prrv8fbq2d5df2mid93m81hz5bvf2v4hnzs42ar";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
    ];
  };
  "pry-byebug" = {
    version = "3.4.2";
    source = {
      type = "gem";
      sha256 = "0lwqc8vjq7b177xfknmigxvahp6dc8i1fy09d3n8ld1ndd909xjq";
    };
    dependencies = [
      "byebug"
      "pry"
    ];
  };
  "pry-rails" = {
    version = "0.3.5";
    source = {
      type = "gem";
      sha256 = "0v8xlzzb535k7wcl0vrpday237xwc04rr9v3gviqzasl7ydw32x6";
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
  "rack" = {
    version = "1.6.5";
    source = {
      type = "gem";
      sha256 = "1374xyh8nnqb8sy6g9gcvchw8gifckn5v3bhl6dzbwwsx34qz7gz";
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
    version = "4.4.1";
    source = {
      type = "gem";
      sha256 = "1czx68p70x98y21dkdndsb64lrxf9qrv09wl1dbcxrypcjnpsdl1";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-cors" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "1sz9d9gjmv2vjl3hddzk269hb1k215k8sp37gicphx82h3chk1kw";
    };
  };
  "rack-oauth2" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0j7fh3fyajpfwg47gyfd8spavn7lmd6dcm468w7lhnhcviy5vmyf";
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
  "rack-proxy" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "1bpbcb9ch94ha2q7gdri88ry7ch0z6ian289kah9ayxyqg19j6f4";
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
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "0dpbf3ybzbhqqkwg5vi60121860cr8fybvchrxk5wy3f2jcj0mch";
    };
    dependencies = [
      "actionmailer"
      "actionpack"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activesupport"
      "railties"
      "sprockets-rails"
    ];
  };
  "rails-deprecated_sanitizer" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "rails-dom-testing" = {
    version = "1.0.8";
    source = {
      type = "gem";
      sha256 = "1ny7mbjxhq20rzg4pivvyvk14irmc7cn20kxfk3vc0z2r2c49p8r";
    };
    dependencies = [
      "activesupport"
      "nokogiri"
      "rails-deprecated_sanitizer"
    ];
  };
  "rails-html-sanitizer" = {
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "138fd86kv073zqfx0xifm646w6bgw2lr8snk16lknrrfrss8xnm7";
    };
    dependencies = [
      "loofah"
    ];
  };
  "railties" = {
    version = "4.2.8";
    source = {
      type = "gem";
      sha256 = "0bavl4hj7bnl3ryqi9rvykm410kflplgingkcxasfv1gdilddh4g";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "rake"
      "thor"
    ];
  };
  "rainbow" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "11licivacvfqbjx2rwppi8z89qff2cgs67d4wyx42pc5fg7g9f00";
    };
  };
  "raindrops" = {
    version = "0.17.0";
    source = {
      type = "gem";
      sha256 = "1syj5gdrgwzdqzc3p1bqg1wv6gn16s2iq8304mrglzhi7cyja73q";
    };
  };
  "rake" = {
    version = "10.5.0";
    source = {
      type = "gem";
      sha256 = "0jcabbgnjc788chx31sihc5pgbqnlc1c75wakmqlbjdm8jns2m9b";
    };
  };
  "rblineprof" = {
    version = "0.3.6";
    source = {
      type = "gem";
      sha256 = "0m58kdjgncwf0h1qry3qk5h4bg8sj0idykqqijqcrr09mxfd9yc6";
    };
    dependencies = [
      "debugger-ruby_core_source"
    ];
  };
  "rdoc" = {
    version = "4.2.2";
    source = {
      type = "gem";
      sha256 = "027dvwz1g1h4bm40v3kxqbim4p7ww4fcmxa2l1mvwiqm5cjiqd7k";
    };
    dependencies = [
      "json"
    ];
  };
  "recaptcha" = {
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "1pppfgica4629i8gbji6pnh681wjf03m6m1ix2ficpnqg2z7gl9n";
    };
    dependencies = [
      "json"
    ];
  };
  "recursive-open-struct" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "102bgpfkjsaghpb1qs1ah5s89100dchpimzah2wxdy9rv9318rqw";
    };
  };
  "redcarpet" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
    };
  };
  "redis" = {
    version = "3.3.3";
    source = {
      type = "gem";
      sha256 = "0kdj7511l6kqvqmaiw7kw604c83pk6f4b540gdsq1bf7yxm6qx6g";
    };
  };
  "redis-actionpack" = {
    version = "5.0.1";
    source = {
      type = "gem";
      sha256 = "0gnkqi7cji2q5yfwm8b752k71pqrb3dqksv983yrf23virqnjfjr";
    };
    dependencies = [
      "actionpack"
      "redis-rack"
      "redis-store"
    ];
  };
  "redis-activesupport" = {
    version = "5.0.1";
    source = {
      type = "gem";
      sha256 = "0i0r23rv32k25jqwbr4cb73alyaxwvz9crdaw3gv26h1zjrdjisd";
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
    version = "1.6.0";
    source = {
      type = "gem";
      sha256 = "0fbxl5gv8krjf6n88gvn44xbzhfnsysnzawz7zili298ak98lsb3";
    };
    dependencies = [
      "rack"
      "redis-store"
    ];
  };
  "redis-rails" = {
    version = "5.0.1";
    source = {
      type = "gem";
      sha256 = "04l2y26k4v30p3dx0pqf9gz257q73qzgrfqf3qv6bxwyv8z9f5hm";
    };
    dependencies = [
      "redis-actionpack"
      "redis-activesupport"
      "redis-store"
    ];
  };
  "redis-store" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1da15wr3wc1d4hqy7h7smdc2k2jpfac3waa9d65si6f4dmqymkkq";
    };
    dependencies = [
      "redis"
    ];
  };
  "request_store" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "1va9x0b3ww4chcfqlmi8b14db39di1mwa7qrjbh7ma0lhndvs2zv";
    };
  };
  "responders" = {
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "16h343srb6msivc2mpm1dbihsmniwvyc9jk3g4ip08g9fpmxfc2i";
    };
    dependencies = [
      "railties"
    ];
  };
  "rest-client" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1v2jp2ilpb2rm97yknxcnay9lfagcm4k82pfsmmcm9v290xm1ib7";
    };
    dependencies = [
      "http-cookie"
      "mime-types"
      "netrc"
    ];
  };
  "retriable" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "1cmhwgv5r4vn7iqy4bfbnbb73pzl8ik69zrwq9vdim45v8b13gsj";
    };
  };
  "rinku" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "11cakxzp7qi04d41hbqkh92n52mm4z2ba8sqyhxbmfi4kypmls9y";
    };
  };
  "rotp" = {
    version = "2.1.2";
    source = {
      type = "gem";
      sha256 = "1w8d6svhq3y9y952r8cqirxvdx12zlkb7zxjb44bcbidb2sisy4d";
    };
  };
  "rouge" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "1932gvvzfdky2z01sjri354ak7wq3nk9jmh7fiydfgjchfwk7sr4";
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
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "16g3mmih999f0b6vcz2c3qsc7ks5zy4lj1rzjh8hf6wk531nvc6s";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "rspec-core" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "03m0pn5lwlix094khfwlv50n963p75vjsg6w2g0b3hqcvvlch1mx";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-mocks" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-rails" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "0zzd75v8vpa1r30j3hsrprza272rcx54hb0klwpzchr9ch6c9z2a";
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
  "rspec-retry" = {
    version = "0.4.5";
    source = {
      type = "gem";
      sha256 = "0izvxab7jvk25kaprk0i72asjyh1ip3cm70bgxlm8lpid35qjar6";
    };
    dependencies = [
      "rspec-core"
    ];
  };
  "rspec-set" = {
    version = "0.1.3";
    source = {
      type = "gem";
      sha256 = "06vw8b5w1a58838cw9ssmy3r6f8vrjh54h7dp97rwv831gn5zlyk";
    };
  };
  "rspec-support" = {
    version = "3.5.0";
    source = {
      type = "gem";
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
    };
  };
  "rspec_profiling" = {
    version = "0.0.5";
    source = {
      type = "gem";
      sha256 = "1g7q7gav26bpiprx4dhlvdh4zdrhwiky9jbmsp14gyfiabqdz4sz";
    };
    dependencies = [
      "activerecord"
      "pg"
      "rails"
      "sqlite3"
    ];
  };
  "rubocop" = {
    version = "0.47.1";
    source = {
      type = "gem";
      sha256 = "05kr3a4jlyq6vaf9rjqiryk51l05bzpxwql024gssfryal66l1m7";
    };
    dependencies = [
      "parser"
      "powerpack"
      "rainbow"
      "ruby-progressbar"
      "unicode-display_width"
    ];
  };
  "rubocop-rspec" = {
    version = "1.15.0";
    source = {
      type = "gem";
      sha256 = "1svaibl7qw4k5vxi7729ddgy6582b8lzhc01ybikb4ahnxj1x1cd";
    };
    dependencies = [
      "rubocop"
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
  "ruby-prof" = {
    version = "0.16.2";
    source = {
      type = "gem";
      sha256 = "0y13gdcdajfgrkx5rc9pvb7bwkyximwl5yrhq05gkmhflzdr7kag";
    };
  };
  "ruby-progressbar" = {
    version = "1.8.1";
    source = {
      type = "gem";
      sha256 = "1qzc7s7r21bd7ah06kskajc2bjzkr9y0v5q48y0xwh2l55axgplm";
    };
  };
  "ruby-saml" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "1abhf16vbyzck4pv06qd5c59780glaf682ssjzpjwd9h9d7nqvl5";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "ruby_parser" = {
    version = "3.8.4";
    source = {
      type = "gem";
      sha256 = "1rl95zp2csygrc6dansxkg8y356rlx8cwgk9ky6834l68bxwhrgy";
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
  "rubyzip" = {
    version = "1.2.1";
    source = {
      type = "gem";
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
    };
  };
  "rufus-scheduler" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "0343xrx4gbld5w2ydh9d2a7pw7lllvrsa691bgjq7p9g44ry1vq8";
    };
    dependencies = [
      "et-orbi"
    ];
  };
  "rugged" = {
    version = "0.25.1.1";
    source = {
      type = "gem";
      sha256 = "1sj833k4g09sgx37k3f46dxyjfppmmcj1s6w6bqan0f2vc047bi0";
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
    version = "3.4.22";
    source = {
      type = "gem";
      sha256 = "0dkj6v26fkg1g0majqswwmhxva7cd6p3psrhdlx93qal72dssywy";
    };
  };
  "sass-rails" = {
    version = "5.0.6";
    source = {
      type = "gem";
      sha256 = "0iji20hb8crncz14piss1b29bfb6l89sz3ai5fny3iw39vnxkdcb";
    };
    dependencies = [
      "railties"
      "sass"
      "sprockets"
      "sprockets-rails"
      "tilt"
    ];
  };
  "sawyer" = {
    version = "0.8.1";
    source = {
      type = "gem";
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
    };
    dependencies = [
      "addressable"
      "faraday"
    ];
  };
  "scss_lint" = {
    version = "0.47.1";
    source = {
      type = "gem";
      sha256 = "0q6yankh4ay4fqz7s19p2r2nqhzv93gihc5c6xnqka3ch1z6v9fv";
    };
    dependencies = [
      "rake"
      "sass"
    ];
  };
  "securecompare" = {
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "0ay65wba4i7bvfqyvf5i4r48q6g70s5m724diz9gdvdavscna36b";
    };
  };
  "seed-fu" = {
    version = "2.3.6";
    source = {
      type = "gem";
      sha256 = "1nkp1pvkdydclbl2v4qf9cixmiycvlqnrgxd61sv9r85spb01z3p";
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
  "sentry-raven" = {
    version = "2.4.0";
    source = {
      type = "gem";
      sha256 = "01r5xdls813qdz5p9r83kk29hyvcxp8kbzi4ilm9kibazf7v9373";
    };
    dependencies = [
      "faraday"
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
    version = "4.8.0";
    source = {
      type = "gem";
      sha256 = "1npss89qnd1skpldx0c1zq296z6n1bv60xivsjl0ps2vigr2b4sv";
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
    version = "5.0.0";
    source = {
      type = "gem";
      sha256 = "1h19c0vk7h5swbpi91qx4ln6nwas4ycj7y6bsm86ilhpiqcb7746";
    };
    dependencies = [
      "concurrent-ruby"
      "connection_pool"
      "rack-protection"
      "redis"
    ];
  };
  "sidekiq-cron" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "04mq83rzvq4wbc4h0rn00sawgv039j8s2p0wnlqb4sgf55gc0dzj";
    };
    dependencies = [
      "rufus-scheduler"
      "sidekiq"
    ];
  };
  "sidekiq-limit_fetch" = {
    version = "3.4.0";
    source = {
      type = "gem";
      sha256 = "0ykpqw2nc9fs4v0slk5n4m42n3ihwwkk5mcyw3rz51blrdzj92kr";
    };
    dependencies = [
      "sidekiq"
    ];
  };
  "signet" = {
    version = "0.7.3";
    source = {
      type = "gem";
      sha256 = "149668991xqibvm8kvl10kzy891yd6f994b4gwlx6c3vl24v5jq6";
    };
    dependencies = [
      "addressable"
      "faraday"
      "jwt"
      "multi_json"
    ];
  };
  "simplecov" = {
    version = "0.14.1";
    source = {
      type = "gem";
      sha256 = "1r9fnsnsqj432cmrpafryn8nif3x0qg9mdnvrcf0wr01prkdlnww";
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
  "slack-notifier" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "0xavibxh00gy62mm79l6id9l2fldjmdqifk8alqfqy5z38ffwah6";
    };
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
  "spinach-rerun-reporter" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "0fkmp99cpxrdzkjrxw9y9qp8qxk5d1arpmmlg5njx40rlcvx002k";
    };
    dependencies = [
      "spinach"
    ];
  };
  "spring" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "1wwbyg2nab2k4hdpd1i65qmnfixry29b4yqynrqfnmjghn0xvc7x";
    };
    dependencies = [
      "activesupport"
    ];
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
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "12qa60sclhnclwi6lskhdgr1l007bca831vhp35f06hq1zmimi2x";
    };
    dependencies = [
      "spring"
    ];
  };
  "sprockets" = {
    version = "3.7.1";
    source = {
      type = "gem";
      sha256 = "0sv3zk5hwxyjvg7iy9sggjc7k3mfxxif7w8p260rharfyib939ar";
    };
    dependencies = [
      "concurrent-ruby"
      "rack"
    ];
  };
  "sprockets-rails" = {
    version = "3.2.0";
    source = {
      type = "gem";
      sha256 = "1zr9vk2vn44wcn4265hhnnnsciwlmqzqc6bnx78if1xcssxj6x44";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
  };
  "sqlite3" = {
    version = "1.3.13";
    source = {
      type = "gem";
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
    };
  };
  "stackprof" = {
    version = "0.2.10";
    source = {
      type = "gem";
      sha256 = "1c88j2d6ipjw5s3hgdgfww37gysgrkicawagj33hv3knijjc9ski";
    };
  };
  "state_machines" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "1xg84kdglz0k1pshf2q604zybjpribzcz2b651sc1j27kd86w787";
    };
  };
  "state_machines-activemodel" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "0p6560jsb4flapd1vbc50bqjk6dzykkwbmyivchyjh5ncynsdb8v";
    };
    dependencies = [
      "activemodel"
      "state_machines"
    ];
  };
  "state_machines-activerecord" = {
    version = "0.4.0";
    source = {
      type = "gem";
      sha256 = "0x5wx1s2i3qc4p2knkf2n9h8b49pla9rjidkwxqzi781qm40wdxx";
    };
    dependencies = [
      "activerecord"
      "state_machines-activemodel"
    ];
  };
  "stringex" = {
    version = "2.5.2";
    source = {
      type = "gem";
      sha256 = "150adm7rfh6r9b5ra6vk75mswf9m3wwyslcf8f235a08m29fxa17";
    };
  };
  "sys-filesystem" = {
    version = "1.1.6";
    source = {
      type = "gem";
      sha256 = "092wj7936i5inzafi09wqh5c8dbak588q21k652dsrdjf5qi10zq";
    };
    dependencies = [
      "ffi"
    ];
  };
  "sysexits" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "0qjng6pllznmprzx8vb0zg0c86hdrkyjs615q41s9fjpmv2430jr";
    };
  };
  "temple" = {
    version = "0.7.7";
    source = {
      type = "gem";
      sha256 = "0xlf1if32xj14mkfwh8nxy3zzjzd9lipni0v2bghknp2kfc1hcz6";
    };
  };
  "test_after_commit" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0s8pz00xq28lsa1rfczm83yqwk8wcb5dqw2imlj8gldnsdapcyc2";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "text" = {
    version = "1.3.1";
    source = {
      type = "gem";
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
    };
  };
  "thin" = {
    version = "1.7.0";
    source = {
      type = "gem";
      sha256 = "1dq9q7qyjyg4444bmn12r2s0mir8dqnvc037y0zidhbyaavrv95q";
    };
    dependencies = [
      "daemons"
      "eventmachine"
      "rack"
    ];
  };
  "thor" = {
    version = "0.19.4";
    source = {
      type = "gem";
      sha256 = "01n5dv9kql60m6a00zc0r66jvaxx98qhdny3klyj0p3w34pad2ns";
    };
  };
  "thread_safe" = {
    version = "0.3.6";
    source = {
      type = "gem";
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
    };
  };
  "tilt" = {
    version = "2.0.6";
    source = {
      type = "gem";
      sha256 = "0qsyzq2k7blyp1rph56xczwfqi8gplns2whswyr67mdfzdi60vvm";
    };
  };
  "timecop" = {
    version = "0.8.1";
    source = {
      type = "gem";
      sha256 = "0vwbkwqyxhavzvr1820hqwz43ylnfcf6w4x6sag0nghi44sr9kmx";
    };
  };
  "timfel-krb5-auth" = {
    version = "0.8.3";
    source = {
      type = "gem";
      sha256 = "105vajc0jkqgcx1wbp0ad262sdry4l1irk7jpaawv8vzfjfqqf5b";
    };
  };
  "toml-rb" = {
    version = "0.3.15";
    source = {
      type = "gem";
      sha256 = "03sr3k193i1r5bh9g4zc7iq9jklapmwj0rndcvhr9q7v5xm7x4rf";
    };
    dependencies = [
      "citrus"
    ];
  };
  "tool" = {
    version = "0.2.3";
    source = {
      type = "gem";
      sha256 = "1iymkxi4lv2b2k905s9pl4d9k9k4455ksk3a98ssfn7y94h34np0";
    };
  };
  "truncato" = {
    version = "0.7.8";
    source = {
      type = "gem";
      sha256 = "09ngwz2mpfsi1ms94j7nmms4kbd5sgcqv5dshrbwaqf585ja7cm5";
    };
    dependencies = [
      "htmlentities"
      "nokogiri"
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
  "u2f" = {
    version = "0.2.1";
    source = {
      type = "gem";
      sha256 = "0lsm1hvwcaa9sq13ab1l1zjk0fgcy951ay11v2acx0h6q1iv21vr";
    };
  };
  "uglifier" = {
    version = "2.7.2";
    source = {
      type = "gem";
      sha256 = "0mzs64z3m1b98rh6ssxpqfz9sc87f6ml6906b0m57vydzfgrh1cz";
    };
    dependencies = [
      "execjs"
      "json"
    ];
  };
  "underscore-rails" = {
    version = "1.8.3";
    source = {
      type = "gem";
      sha256 = "0iyspb7s49wpi9cc314gvlkyn45iyfivzxhdw0kql1zrgllhlzfk";
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
    version = "0.0.7.2";
    source = {
      type = "gem";
      sha256 = "04d13bp6lyg695x94whjwsmzc2ms72d94vx861nx1y40k3817yp8";
    };
  };
  "unicode-display_width" = {
    version = "1.1.3";
    source = {
      type = "gem";
      sha256 = "1r28mxyi0zwby24wyn1szj5hcnv67066wkv14wyzsc94bf04fqhx";
    };
  };
  "unicorn" = {
    version = "5.1.0";
    source = {
      type = "gem";
      sha256 = "1rcvg9381yw3wrnpny5c01mvm35caycshvfbg96wagjhscw6l72v";
    };
    dependencies = [
      "kgio"
      "raindrops"
    ];
  };
  "unicorn-worker-killer" = {
    version = "0.4.4";
    source = {
      type = "gem";
      sha256 = "0rrdxpwdsapx47axjin8ymxb4f685qlpx8a26bql4ay1559c3gva";
    };
    dependencies = [
      "get_process_mem"
      "unicorn"
    ];
  };
  "uniform_notifier" = {
    version = "1.10.0";
    source = {
      type = "gem";
      sha256 = "1jha0l7x602g5rvah960xl9r0f3q25gslj39i0x1vai8i5z6zr1l";
    };
  };
  "url_safe_base64" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "1wgslyapmw4m6l5f6xvcvrvdz3hbkqczkhmjp96s6pzwcgxvcazz";
    };
  };
  "validates_hostname" = {
    version = "1.0.6";
    source = {
      type = "gem";
      sha256 = "04p1l0v98j4ffvaks1ig9mygx5grpbpdgz7haq3mygva9iy8ykja";
    };
    dependencies = [
      "activerecord"
      "activesupport"
    ];
  };
  "version_sorter" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "1smi0bf8pgx23014nkpfg29qnmlpgvwmn30q0ca7qrfbha2mjwdr";
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
  "vmstat" = {
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "0vb5mwc71p8rlm30hnll3lb4z70ipl5rmilskpdrq2mxwfilcm5b";
    };
  };
  "warden" = {
    version = "1.2.6";
    source = {
      type = "gem";
      sha256 = "04gpmnvkp312wxmsvvbq834iyab58vjmh6w4x4qpgh4p1lzkiq1l";
    };
    dependencies = [
      "rack"
    ];
  };
  "webmock" = {
    version = "1.24.6";
    source = {
      type = "gem";
      sha256 = "03vlr6axajz6c7xmlk0w1kvkxc92f8y2zp27wq1z6yk916ry25n5";
    };
    dependencies = [
      "addressable"
      "crack"
      "hashdiff"
    ];
  };
  "webpack-rails" = {
    version = "0.9.10";
    source = {
      type = "gem";
      sha256 = "0l0jzw05yk1c19q874nhkanrn2ik7hjbr2vjcdnk1fqp2f3ypzvv";
    };
    dependencies = [
      "railties"
    ];
  };
  "websocket-driver" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "1v39w1ig6ps8g55xhz6x1w53apl17ii6kpy0jg9249akgpdvb0k9";
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
  "xml-simple" = {
    version = "1.1.5";
    source = {
      type = "gem";
      sha256 = "0xlqplda3fix5pcykzsyzwgnbamb3qrqkgbrhhfz2a2fxhrkvhw8";
    };
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
