{
  ace-rails-ap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14wj9gsiy7rm0lvs27ffsrh92wndjksj6rlfj3n7jhv1v77w9v2h";
      type = "gem";
    };
    version = "4.1.2";
  };
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pr3cmr0bpgg5d0f6wy1z6r45n14r9yin8jnr4hi3ssf402xpc0q";
      type = "gem";
    };
    version = "4.2.8";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09fbazl0ja80na2wadfp3fzmdmdy1lsb4wd2yg7anbj0zk0ap7a9";
      type = "gem";
    };
    version = "4.2.8";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mg4a8143q2wjhjq4mngl69jkv249z5jvg0jkdribdv4zkg586rp";
      type = "gem";
    };
    version = "4.2.8";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kazbpfgzz6cdmwjnlb9m671ps4qgggwv2hy8y9xi4h96djyyfqz";
      type = "gem";
    };
    version = "4.2.8";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11vhh7zmp92880s5sx8r32v2p0b7xg039mfr92pjynpkz4q901ld";
      type = "gem";
    };
    version = "4.2.8";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kk4dhn8jfhqfsf1dmb3a183gix6k46xr6cjkxj0rp51w2za1ns0";
      type = "gem";
    };
    version = "4.2.8";
  };
  activerecord-nulldb-adapter = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxk26drn3s0mpyk8ir30k1pg5fqndrnsdjkkncn0acylq4ja27z";
      type = "gem";
    };
    version = "0.3.7";
  };
  activerecord_sane_schema_dumper = {
    dependencies = ["rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "122c7v7lvs0gwckvx2rar07waxnx1vv0lryz322nybb69d8vbhl6";
      type = "gem";
    };
    version = "0.2";
  };
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wibdzd2f5l5rlsw1a1y3j3fhw2imrrbkxggdraa6q9qbdnc66hi";
      type = "gem";
    };
    version = "4.2.8";
  };
  acts-as-taggable-on = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2y2zh4vrjf6bzdgvyq5a53a4gpr8xvq4a5rvq7fy1w43z4753s";
      type = "gem";
    };
    version = "4.0.0";
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
      sha256 = "1y7z66lpzabyvviphk1fnzvrj5vhv7v9vppcnkrf0n5wh8qwx2zi";
      type = "gem";
    };
    version = "1.0.5";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
      type = "gem";
    };
    version = "6.0.4";
  };
  asana = {
    dependencies = ["faraday" "faraday_middleware" "faraday_middleware-multi_json" "oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bn7f3sc2f02g871jd0y6qdhixn464mflkjchp56x6kcnyqy24z6";
      type = "gem";
    };
    version = "0.6.0";
  };
  asciidoctor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q9yhan2mkk1lh15zcfd9g2fn6faix9yrf5skg23dp1y77jv7vm0";
      type = "gem";
    };
    version = "1.5.3";
  };
  asciidoctor-plantuml = {
    dependencies = ["asciidoctor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00ax9r822n4ykl6jizaxp03wqzknr7nn20mmqjpiwajy9j0zvr88";
      type = "gem";
    };
    version = "0.0.7";
  };
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
      type = "gem";
    };
    version = "2.3.0";
  };
  atomic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kh9rvhjn4dndbfsk3yjq7alds6s2j70rc4k8wdwdyibab8a8gq9";
      type = "gem";
    };
    version = "1.1.99";
  };
  attr_encrypted = {
    dependencies = ["encryptor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dikbf55wjqyzfb9p4xjkkkajwan569pmzljdf9c1fy4a94cd13d";
      type = "gem";
    };
    version = "3.0.3";
  };
  attr_required = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pawa2i7gw9ppj6fq6y288da1ncjpzsmc6kx7z63mjjvypa5q3dc";
      type = "gem";
    };
    version = "1.0.0";
  };
  autoparse = {
    dependencies = ["addressable" "extlib" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q5wkd8gc2ckmgry9fba4b8vxb5kr8k8gqq2wycbirgq06mbllb6";
      type = "gem";
    };
    version = "0.3.3";
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
  base32 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b7y8sy6j9v1lvfzd4va88k5vg9yh0xcjzzn3llcw7yxqlcrnbjk";
      type = "gem";
    };
    version = "0.3.2";
  };
  bcrypt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d254sdhdj6mzak3fb5x3jam8b94pvl1srladvs53j05a89j5z50";
      type = "gem";
    };
    version = "3.1.11";
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
    dependencies = ["coderay" "erubis" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11csk41yhijqvp0dkky0cjl8kn6blw4jhr8b6v4islfvvayddcxc";
      type = "gem";
    };
    version = "2.1.1";
  };
  bindata = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07i51jzq9iamw40xmmcgkrdq4m8f0vb5gp53p6q1vggj7z53q3v7";
      type = "gem";
    };
    version = "2.3.5";
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
  bootstrap_form = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sw88vi5sb48xzgwclic38jdgmcbvah2qfi3rijrlmi1wai4j1fw";
      type = "gem";
    };
    version = "2.7.0";
  };
  brakeman = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fxv3cgmjh6rimz2jcslj3qnh1vqqz1grrjnp6m3nywbznlv441w";
      type = "gem";
    };
    version = "3.6.1";
  };
  browser = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "055r4wyc3z61r7mg2bgqpzabpkg8db2q5rciwfx9lwfyhjx19pbv";
      type = "gem";
    };
    version = "2.2.0";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  bullet = {
    dependencies = ["activesupport" "uniform_notifier"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pdq3ckmwxnwrdm2x89zfj68h0yhiln35y8wps2nkvam4kpivyr5";
      type = "gem";
    };
    version = "5.5.1";
  };
  bundler-audit = {
    dependencies = ["thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gr7k6m9fda7m66irxzydm8v9xbmlryjj65cagwm1zyi5f317srb";
      type = "gem";
    };
    version = "0.5.0";
  };
  byebug = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kbfcn65rgdhi72n8x9l393b89rvi5z542459k7d1ggchpb0idb0";
      type = "gem";
    };
    version = "9.0.6";
  };
  capybara = {
    dependencies = ["addressable" "mime-types" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ln77a5wwhd5sbxsh3v26xrwjnza0rgx2hn23yjggdlha03b00yw";
      type = "gem";
    };
    version = "2.6.2";
  };
  capybara-screenshot = {
    dependencies = ["capybara" "launchy"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xy79lf3rwn3602r4hqm9s8a03bhlf6hzwdi6345dzrkmhwwj2ij";
      type = "gem";
    };
    version = "1.0.14";
  };
  carrierwave = {
    dependencies = ["activemodel" "activesupport" "mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nms4w6vkm7djghdxwi9qzykhc2ynjwblgqwk87w61fhispqlq2c";
      type = "gem";
    };
    version = "1.1.0";
  };
  cause = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0digirxqlwdg79mkbn70yc7i9i1qnclm2wjbrc47kqv6236bpj00";
      type = "gem";
    };
    version = "0.1";
  };
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jsl6k27wjmssxbwv9wpf7hgp9r0nvizcf6qpjnr7qs2nia53lf7";
      type = "gem";
    };
    version = "0.7.3";
  };
  chronic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hrdkn4g8x7dlzxwb1rfgr8kw3bp4ywg5l4y4i9c2g5cwv62yvvn";
      type = "gem";
    };
    version = "0.10.2";
  };
  chronic_duration = {
    dependencies = ["numerizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k7sx3xqbrn6s4pishh2pgr4kw6fmw63h00lh503l66k8x0qvigs";
      type = "gem";
    };
    version = "0.10.6";
  };
  chunky_png = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vf0axgrm95bs3y0x5gdb76xawfh210yxplj7jbwr6z7n88i1axn";
      type = "gem";
    };
    version = "1.3.5";
  };
  citrus = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l7nhk3gkm1hdchkzzhg2f70m47pc0afxfpl6mkiibc9qcpl3hjf";
      type = "gem";
    };
    version = "3.0.2";
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
      sha256 = "1x6z923iwr1hi04k6kz5a6llrixflz8h5sskl9mhaaxy9jx2x93r";
      type = "gem";
    };
    version = "1.1.1";
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
      sha256 = "1mv1kaw3z4ry6cm51w8pfrbby40gqwxanrqyqr0nvs8j1bscc1gw";
      type = "gem";
    };
    version = "4.1.1";
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
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  concurrent-ruby-ext = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "119l554zi3720d3rk670ldcqhsgmfii28a9z307v4mwdjckdm4gp";
      type = "gem";
    };
    version = "1.0.5";
  };
  connection_pool = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17vpaj6kyf2i8bimaxz7rg1kyadf4d10642ja67qiqlhwgczl2w7";
      type = "gem";
    };
    version = "2.2.1";
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
  css_parser = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jlr17cn044yaq4l3d9p42g3bghnamwsprq9c39xn6pxjrn5k1hy";
      type = "gem";
    };
    version = "1.5.0";
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
      sha256 = "0fx6zmqznklmkbjl6f713jyl11d4g9q220rcl86m2jp82r8kfwjj";
      type = "gem";
    };
    version = "1.5.3";
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
  deckar01-task_list = {
    dependencies = ["html-pipeline"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6qsk712ic6vx9ydmix2ys95zwpkvdx3a9xxi8bdqlpgh1ipm9j";
      type = "gem";
    };
    version = "2.0.0";
  };
  default_value_for = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "014482mxjrc227fxv6vff6ccjr9dr0ydz52flxslsa7biq542k73";
      type = "gem";
    };
    version = "3.0.2";
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
    dependencies = ["bcrypt" "orm_adapter" "railties" "responders" "warden"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045qw3186gkcm38wjbjhb7w2zycbqj85wfb1cdwvkqk8hf1a7dp0";
      type = "gem";
    };
    version = "4.2.0";
  };
  devise-two-factor = {
    dependencies = ["activesupport" "attr_encrypted" "devise" "railties" "rotp"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pkldws5lga4mlv4xmcrfb0yivl6qad0l8qyb2hdb50adv6ny4gs";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "1azibizfv91sjbzhjqj1pg2xcv8z9b8a7z6kb3wpl4hpj5hil5kj";
      type = "gem";
    };
    version = "3.1.0";
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
      sha256 = "1y5c96gzyh6z4nrnkisljqngfvljdba36dww657ka0x7khzvx7jl";
      type = "gem";
    };
    version = "0.5.20161021";
  };
  doorkeeper = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hs8r280k7a1kibzxrhifjps880n43jfrybf4mqpffw669jrwk3v";
      type = "gem";
    };
    version = "4.2.0";
  };
  doorkeeper-openid_connect = {
    dependencies = ["doorkeeper" "json-jwt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pla85j5wxra0k9rhj04g2ai5d5jg97fiavi0s9v2hjba2l54cni";
      type = "gem";
    };
    version = "1.1.2";
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
  email_reply_trimmer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vijywhy1acsq4187ss6w8a7ksswaf1d5np3wbj962b6rqif5vcz";
      type = "gem";
    };
    version = "0.1.6";
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
      sha256 = "0s8rvfl0vn8w7k1sgkc234060jh468s3zd45xa64p1jdmfa3zwmb";
      type = "gem";
    };
    version = "3.0.0";
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
      sha256 = "088r5c2mz2vy2jbbx1xjbi8msnzg631ggli29nhik2spbcp1z6vh";
      type = "gem";
    };
    version = "1.1.1";
  };
  et-orbi = {
    dependencies = ["tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1apn9gzgbgs7z6p6l3rv66vrfwyfh68p2rxkybh10vx82fp6g0wi";
      type = "gem";
    };
    version = "1.0.3";
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
      sha256 = "149grwcry52hi3f1xkbbx74jw5m3qcmiib13wxrk3rw5rz200kmx";
      type = "gem";
    };
    version = "0.55.0";
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
  extlib = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cbw3vgb189z3vfc1arijmsd604m3w5y5xvdfkrblc9qh7sbk2rh";
      type = "gem";
    };
    version = "0.9.16";
  };
  factory_girl = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xzl4z9z390fsnyxp10c9if2n46zan3n6zwwpfnwc33crv4s410i";
      type = "gem";
    };
    version = "4.7.0";
  };
  factory_girl_rails = {
    dependencies = ["factory_girl" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hzpirb33xdqaz44i1mbcfv0icjrghhgaz747llcfsflljd4pa4r";
      type = "gem";
    };
    version = "4.7.0";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wkx9844vacsk2229xbc27djf6zw15kqd60ifr78whf9mp9v6l03";
      type = "gem";
    };
    version = "0.12.1";
  };
  faraday_middleware = {
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bcarc90brm1y68bl957w483bddsy9idj2gghqnysk6bbxpsvm00";
      type = "gem";
    };
    version = "0.11.0.1";
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
  fast_gettext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l8snpgxrri8jc0c35s6h3n92j8bfahh1knj94mw6i4zqhnpv40z";
      type = "gem";
    };
    version = "1.4.0";
  };
  ffaker = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rlfvf2iakphs3krxy1hiywr2jzmrhvhig8n8fw6rcivpz9v52ry";
      type = "gem";
    };
    version = "2.4.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m5mprppw0xcrv2mkim5zsk70v089ajzqiq5hpyb0xg96fcyzyxj";
      type = "gem";
    };
    version = "1.9.10";
  };
  flay = {
    dependencies = ["erubis" "path_expander" "ruby_parser" "sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x563gyx292ka3awps6h6hmswqf71zdxnzw0pfv6p2mhd2zwxaba";
      type = "gem";
    };
    version = "2.8.1";
  };
  flipper = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gbvd4j0rkr7qc3mnjdw4r9p6lffnwv7rvm1cyr8a0avjky34n8p";
      type = "gem";
    };
    version = "0.10.2";
  };
  flipper-active_record = {
    dependencies = ["activerecord" "flipper"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "053lq791z8bf3xv6kb14nq3yrzjpmlyhzq3kvys978dc8yw78ld7";
      type = "gem";
    };
    version = "0.10.2";
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
  fog-aliyun = {
    dependencies = ["fog-core" "fog-json" "ipaddress" "xml-simple"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i76g8sdskyfc0gcnd6n9i757s7dmwg3wf6spcr2xh8wzyxkm1pj";
      type = "gem";
    };
    version = "0.1.0";
  };
  fog-aws = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "ipaddress"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1am8fi0z19y398zg7g629rzxzkks9rxyl7j8m5vsgzs80mbsl06s";
      type = "gem";
    };
    version = "0.13.0";
  };
  fog-core = {
    dependencies = ["builder" "excon" "formatador"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l78l9jlkxnv1snib80p92r5cwk6jqgyni6758j6kphzcplkkbdm";
      type = "gem";
    };
    version = "1.44.1";
  };
  fog-google = {
    dependencies = ["fog-core" "fog-json" "fog-xml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06irf9gcg5v8iwaa5qilhwir6gl82rrp7jyyw87ad15v8p3xa59f";
      type = "gem";
    };
    version = "0.5.0";
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
      sha256 = "0256l3q2f03q8fk49035h5jij388rcz9fqlwri7y788492b4vs3c";
      type = "gem";
    };
    version = "0.3.0";
  };
  fog-openstack = {
    dependencies = ["fog-core" "fog-json" "ipaddress"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pw2ypxbbmfscmhcz05ry5kc7c5rjr61lv9zj6zpr98fg1wad3a6";
      type = "gem";
    };
    version = "0.1.6";
  };
  fog-rackspace = {
    dependencies = ["fog-core" "fog-json" "fog-xml" "ipaddress"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y2bli061g37l9p4w0ljqbmg830rp2qz6sf8b0ck4cnx68j7m32a";
      type = "gem";
    };
    version = "0.1.1";
  };
  fog-xml = {
    dependencies = ["fog-core" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "043lwdw2wsi6d55ifk0w3izi5l1d1h0alwyr3fixic7b94kc812n";
      type = "gem";
    };
    version = "0.1.3";
  };
  font-awesome-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qc07vj7qyllrj7lr7wl89l5ir0gj104rc7sds2jynzmrqsamnlw";
      type = "gem";
    };
    version = "4.7.0.1";
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
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17yy3cp7b75ngc2v4f0cacvq3f1bk3il5a0ykvnypl6fcj6r6b3w";
      type = "gem";
    };
    version = "3.0.1";
  };
  get_process_mem = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "025f7v6bpbgsa2nr0hzv2riggj8qmzbwcyxfgjidpmwh5grh7j29";
      type = "gem";
    };
    version = "0.2.0";
  };
  gettext = {
    dependencies = ["locale" "text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d2i1zfqvaxqi01g9vvkfkf5r85c5nfj2zwpd2ib9vvkjavhn9cx";
      type = "gem";
    };
    version = "3.2.2";
  };
  gettext_i18n_rails = {
    dependencies = ["fast_gettext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vs918a03mqvx9aczaqdg9d2q9s3c6swqavzn82qgq5i822czrcm";
      type = "gem";
    };
    version = "1.8.0";
  };
  gettext_i18n_rails_js = {
    dependencies = ["gettext" "gettext_i18n_rails" "po_to_json" "rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04lkmy6mgxdnpl4icddg00nj0ay0ylacfxrm723npzaqviml7c2x";
      type = "gem";
    };
    version = "1.2.0";
  };
  gherkin-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ay7yiibf4sl9n94k7mbi4k5zj2igl4j71qcmkswv69znyx0sn1";
      type = "gem";
    };
    version = "0.3.2";
  };
  gitaly = {
    dependencies = ["google-protobuf" "grpc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kmv2nmygaz5w1qsp48zb9xpq2i1nfc5zrilmy56sh3ybnxz99z4";
      type = "gem";
    };
    version = "0.14.0";
  };
  github-linguist = {
    dependencies = ["charlock_holmes" "escape_utils" "mime-types" "rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c8w92yzjfs7pjnm8bdjsgyd1jpisn10fb6dy43381k1k8pxsifd";
      type = "gem";
    };
    version = "4.7.6";
  };
  github-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "046bvnbhk3bw021sd88808n71dya0b0dmx8hm64rj0fvs2jzg54z";
      type = "gem";
    };
    version = "1.4.0";
    meta.priority = 10; # lower priority, exectuable conflicts with gitlab-markdown
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
      sha256 = "0lf1cr6pzqrbnxiiwym6q74b1a2ihdi91dynajk8hi1p093hl66n";
      type = "gem";
    };
    version = "2.8.1";
  };
  gitlab-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aam7zvvbai5nv7vf0c0640pvik6s71f276lip4yb4slbg0pfpn2";
      type = "gem";
    };
    version = "1.5.1";
  };
  gitlab_omniauth-ldap = {
    dependencies = ["net-ldap" "omniauth" "pyu-ruby-sasl" "rubyntlm"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0226z52aqykl64f1ws20qbr8jn9y0zgrvsv3ks3f1sfrbmnh34z3";
      type = "gem";
    };
    version = "2.0.2";
  };
  globalid = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11plkgyl3w9k4y2scc1igvpgwyz4fnmsr63h2q4j8wkb48nlnhak";
      type = "gem";
    };
    version = "0.3.7";
  };
  gollum-grit_adapter = {
    dependencies = ["gitlab-grit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fcibm63v1afc0fj5rki0mm51m7nndil4cjcjjvkh3yigfn4nr4b";
      type = "gem";
    };
    version = "1.0.1";
  };
  gollum-lib = {
    dependencies = ["github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q668c76gnyyyl8217gnblbj50plm7giacs5lgf7ix2rj8rdxzj7";
      type = "gem";
    };
    version = "4.2.1";
  };
  gollum-rugged_adapter = {
    dependencies = ["mime-types" "rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0khfmakp65frlaj7ajs6ihqg4xi7yc9z96kpsf1b7giqi3fqhhv4";
      type = "gem";
    };
    version = "0.4.4";
  };
  gon = {
    dependencies = ["actionpack" "json" "multi_json" "request_store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jmf6ly9wfrg52xkk9qb4hlfn3zdmz62ivclhp4f424m39rd9ngz";
      type = "gem";
    };
    version = "6.1.0";
  };
  google-api-client = {
    dependencies = ["activesupport" "addressable" "autoparse" "extlib" "faraday" "googleauth" "launchy" "multi_json" "retriable" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11wr57j9fp6x6fym4k1a7jqp72qgc8l24mfwb4y55bbvdmkv1b2d";
      type = "gem";
    };
    version = "0.8.7";
  };
  google-protobuf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kd3k09p6i7jg7bbgr5bda00l7y1n5clxwg5nzn3gpd0hcjdfhsl";
      type = "gem";
    };
    version = "3.2.0.2";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "logging" "memoist" "multi_json" "os" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nzkg63s161c6jsia92c1jfwpayzbpwn588smd286idn07y0az2m";
      type = "gem";
    };
    version = "0.5.1";
  };
  grape = {
    dependencies = ["activesupport" "builder" "hashie" "multi_json" "multi_xml" "mustermann-grape" "rack" "rack-accept" "virtus"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1z52875d5v3slpnyfndxilf9nz0phb2jwxiir0hz8fp0ni13m9yy";
      type = "gem";
    };
    version = "0.19.1";
  };
  grape-entity = {
    dependencies = ["activesupport" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jhjn1164z68xrjz23wf3qha3x9az086dr7p6405jv6rszyxihq";
      type = "gem";
    };
    version = "0.6.0";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1siq5v4bmqlsb6122394dpk35fd2lxvjp4xnrabsb3vd90xqszcj";
      type = "gem";
    };
    version = "1.4.0";
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
  haml_lint = {
    dependencies = ["haml" "rake" "rubocop" "sysexits"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vy8dkgkisikh3aigkhw7rl7wr83gb5xnaxafba654r2nyyvz63d";
      type = "gem";
    };
    version = "0.21.0";
  };
  hamlit = {
    dependencies = ["temple" "thor" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ph4kv2ddr538f9ni2fmk7aq38djv5am29r3m6y64adg52n6jma9";
      type = "gem";
    };
    version = "2.6.1";
  };
  hashdiff = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n6hj7k7b9hazac0j48ypbak2nqi5wy4nh5cjra6xl3a92r8db0a";
      type = "gem";
    };
    version = "0.3.4";
  };
  hashie = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lfmbh98ng141m7yc8s4v56v49ppam416pzvd2d7pg85wmm44ljw";
      type = "gem";
    };
    version = "3.5.5";
  };
  hashie-forbidden_attributes = {
    dependencies = ["hashie"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1chgg5d2iddja6ww02x34g8avg11fzmzcb8yvnqlykii79zx6vis";
      type = "gem";
    };
    version = "0.1.1";
  };
  health_check = {
    dependencies = ["rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mfa180nyzz1j0abfihm5nm3lmzq99362ibcphky6rh5vwhckvm8";
      type = "gem";
    };
    version = "2.6.0";
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
  html2text = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kxdj8pf9pss9xgs8aac0alj5g1fi225yzdhh33lzampkazg1hii";
      type = "gem";
    };
    version = "0.2.0";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  http = {
    dependencies = ["addressable" "http-cookie" "http-form_data" "http_parser.rb"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll9x8qjp97l8gj0jx23nj7xvm0rsxj5pb3d19f7bhmdb70r0xsi";
      type = "gem";
    };
    version = "0.9.8";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "004cgs4xg5n6byjs7qld0xhsjq3n6ydfh897myr2mibvh6fjc49g";
      type = "gem";
    };
    version = "1.0.3";
  };
  http-form_data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10r6hy8wcf8n4nbdmdz9hrm8mg45lncfc7anaycpzrhfp3949xh9";
      type = "gem";
    };
    version = "1.0.1";
  };
  "http_parser.rb" = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
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
      sha256 = "1pg15svk9lv5r7w1hxd87di6apsr9y009af3mm01xcaccvqj4j2d";
      type = "gem";
    };
    version = "2.8.2";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6971zmjxszdrp59vybns9gzxpdxzdklakc5lp8nl4fx5kpxkbp";
      type = "gem";
    };
    version = "0.8.1";
  };
  ice_nine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
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
      sha256 = "1x86s0s11w202j6ka40jbmywkrx8fhq8xiy8mwvnkhllj57hqr45";
      type = "gem";
    };
    version = "0.8.3";
  };
  jira-ruby = {
    dependencies = ["activesupport" "oauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03n76a8m2d352q29j3yna1f9g3xg9dc9p3fvvx77w67h19ks7zrf";
      type = "gem";
    };
    version = "1.1.2";
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
      sha256 = "1asbrr9hqf43q9qbjf87f5lm7fp12pndh76z89ks6jwxf1350fj1";
      type = "gem";
    };
    version = "4.1.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qmj7fypgb9vag723w1a49qihxrcf5shzars106ynw2zk352gbv5";
      type = "gem";
    };
    version = "1.8.6";
  };
  json-jwt = {
    dependencies = ["activesupport" "bindata" "multi_json" "securecompare" "url_safe_base64"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ylvlnb6assan9qkhz1vq1gbfwxg35q9a8f8qhlyx0fak5fyks23";
      type = "gem";
    };
    version = "1.7.1";
  };
  json-schema = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15bva4w940ckan3q89in5f98s8zz77nxglylgm98697wa4fbfqp9";
      type = "gem";
    };
    version = "2.6.2";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
      type = "gem";
    };
    version = "1.5.6";
  };
  kaminari = {
    dependencies = ["actionpack" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1n063jha143mw4fklpq5f4qs7saakx4s4ps1zixj0s5y8l9pam54";
      type = "gem";
    };
    version = "0.17.0";
  };
  kgio = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y6wl3vpp82rdv5g340zjgkmy6fny61wib7xylyg0d09k5f26118";
      type = "gem";
    };
    version = "2.10.0";
  };
  knapsack = {
    dependencies = ["rake" "timecop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z0bp5al0b8wyzw8ff99jwr6qsh5n52xqryvzvy2nbrma9qr7dam";
      type = "gem";
    };
    version = "1.11.0";
  };
  kubeclient = {
    dependencies = ["http" "recursive-open-struct" "rest-client"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09hr5cb6rzf9876wa0c8pv3kxjj4s8hcjpf7jjdg2n9prb7hhmgi";
      type = "gem";
    };
    version = "2.2.0";
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
      sha256 = "1pcrdbxvp2x5six8fqn8gf09bn9rd3jga76ds205yph5m8fsda21";
      type = "gem";
    };
    version = "1.4.1";
  };
  letter_opener_web = {
    dependencies = ["actionmailer" "letter_opener" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "050x5cwqbxj2cydd2pzy9vfhmpgn1w6lfbwjaax1m1vpkn3xg9bv";
      type = "gem";
    };
    version = "1.3.0";
  };
  license_finder = {
    dependencies = ["httparty" "rubyzip" "thor" "xml-simple"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "092rwf1yjq1l63zbqanmbnbky8g5pj7c3g30mcqbyppbqrsflx80";
      type = "gem";
    };
    version = "2.1.0";
  };
  licensee = {
    dependencies = ["rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nhj0vx30llqyb7q52bwmrgy9xpjk3q48k98h0dvq83ym4v216a2";
      type = "gem";
    };
    version = "8.7.0";
  };
  little-plugger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  locale = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
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
  mail = {
    dependencies = ["mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07k8swmv7vgk86clzpjhdlmgahlvg6yzjwy7wcsv0xx400fh4x61";
      type = "gem";
    };
    version = "2.6.5";
  };
  mail_room = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16b8yjd1if665mwaindwys06nkkcs0jw3dcsqvn6qbp6alfigqaa";
      type = "gem";
    };
    version = "0.9.1";
  };
  memoist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yd3rd7bnbhn9n47qlhcii5z89liabdjhy3is3h6gq77gyfk4f5q";
      type = "gem";
    };
    version = "0.15.0";
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
      sha256 = "03j98xr0qw2p2jkclpmk7pm29yvmmh0073d8d43ajmr0h3w7i5l9";
      type = "gem";
    };
    version = "2.99.3";
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
      sha256 = "1y25adxb1hgg1wb2rn20g3vl07qziq6fz364jc5694611zz863hb";
      type = "gem";
    };
    version = "2.1.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rxqfakp629mp3vwda7zpgb57lcns5znkskikbfd0kriwv8i1vq8";
      type = "gem";
    };
    version = "5.7.0";
  };
  mmap2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rgf4zhqa6632nbqj585hc0x69iz21s5c91mpijcr9i5wpj9p1s6";
      type = "gem";
    };
    version = "2.2.7";
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
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
      type = "gem";
    };
    version = "1.12.1";
  };
  multi_xml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lmd4f401mvravi1i1yq7b2qjjli0yq7dfc4p1nj5nwajp7r6hyj";
      type = "gem";
    };
    version = "0.6.0";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  mustermann = {
    dependencies = ["tool"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0km27zp3mnlmh157nmj3pyd2g7n2da4dh4mr0psq53a9r0d4gli8";
      type = "gem";
    };
    version = "0.4.0";
  };
  mustermann-grape = {
    dependencies = ["mustermann"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g6kf753v0kf8zfz0z46kyb7cbpinpc3qqh02qm4s9n49s1v2fva";
      type = "gem";
    };
    version = "0.4.0";
  };
  mysql2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n075x14n9kziv0qdxqlzhf3j1abi1w6smpakfpsg4jbr8hnn5ip";
      type = "gem";
    };
    version = "0.3.20";
  };
  net-ldap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fh4l8zfsrvghanpnjxk944k7yl093qpw4759xs6f1v9kb73ihfq";
      type = "gem";
    };
    version = "0.16.0";
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
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "045xdg0w7nnsr2f2gb7v7bgx53xbc9dxf0jwzmh2pr3jyrzlm0cj";
      type = "gem";
    };
    version = "1.6.8.1";
  };
  numerizer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vrk9jbv4p4dcz0wzr72wrf5kajblhc5l9qf7adbcwi4qvz9xv0h";
      type = "gem";
    };
    version = "0.1.1";
  };
  oauth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1awhy8ddhixch44y68lail3h1d214rnl3y1yzk0msq5g4z2l62ky";
      type = "gem";
    };
    version = "0.5.1";
  };
  oauth2 = {
    dependencies = ["faraday" "jwt" "multi_json" "multi_xml" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094hmmfms8vpm6nwglpl7jmlv85nlfzl0kik4fizgx1rg70a6mr5";
      type = "gem";
    };
    version = "1.4.0";
  };
  octokit = {
    dependencies = ["sawyer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bppfc0q8mflbcdsb66dly3skx42vad30q0fkzwx4za908qwvjpd";
      type = "gem";
    };
    version = "4.6.2";
  };
  oj = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17c50q2ygi8jlw8dq3ghzha774ln1swbvmvai2ar7qb3bwcfgc8b";
      type = "gem";
    };
    version = "2.17.5";
  };
  omniauth = {
    dependencies = ["hashie" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kvr0g12fawf491jmdaxzzr6qyd1r8ixzkcdr0zscs42fqsxv79i";
      type = "gem";
    };
    version = "1.4.2";
  };
  omniauth-auth0 = {
    dependencies = ["omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dhfl01519q1cp4w0ml481j1cg05g7qvam0x4ia9jhdz8yx6npfs";
      type = "gem";
    };
    version = "1.4.1";
  };
  omniauth-authentiq = {
    dependencies = ["omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0drbrrxk0wlmq4y6nmsxa77b815ji1jsdjr6fcqxb3sqiscq2p0a";
      type = "gem";
    };
    version = "0.3.0";
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
      sha256 = "03zjla9i446fk1jkw7arh67c39jfhp5bhkmhvbw8vczxr1jkbbh5";
      type = "gem";
    };
    version = "4.0.0";
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
      sha256 = "0hv672p372jq7p9p6dw8i7qyisbny3lq0si077yys1fy4bjw127x";
      type = "gem";
    };
    version = "1.0.2";
  };
  omniauth-google-oauth2 = {
    dependencies = ["jwt" "multi_json" "omniauth" "omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m6v2vm3h21ychd10wzkdhyhnrk9zhc1bgi4ahp5gwy00pggrppw";
      type = "gem";
    };
    version = "0.4.1";
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
  omniauth-oauth2-generic = {
    dependencies = ["omniauth-oauth2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m6vpip3rm1spx1x9y1kjczzailsph1xqgaakqylzq3jqkv18273";
      type = "gem";
    };
    version = "0.2.2";
  };
  omniauth-saml = {
    dependencies = ["omniauth" "ruby-saml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1garppa83v53yr9bwfx51v4hqwfr5h4aq3d39gn2fmysnfav7c1x";
      type = "gem";
    };
    version = "1.7.0";
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
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llv8w3g2jwggdxr5a5cjkrnbbfnvai3vxacxxc0fy84xmz3hymz";
      type = "gem";
    };
    version = "0.9.6";
  };
  paranoia = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ibdga0a0px8rf82qnmgm59z3z4s27r11i2i24087f0yh8z8bd7z";
      type = "gem";
    };
    version = "2.3.1";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "130rfk8a2ws2fyq52hmi1n0xakylw39wv4x1qhai4z17x2b0k9cq";
      type = "gem";
    };
    version = "2.4.0.0";
  };
  path_expander = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hklnfb0br6mx6l25zknz2zj6r152i0jiy6fn6ki220x0l5m2h59";
      type = "gem";
    };
    version = "1.0.1";
  };
  peek = {
    dependencies = ["concurrent-ruby" "concurrent-ruby-ext" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1998vcsli215d6qrn9821gr2qip60xki2p7n2dpn8i1n68hyshcn";
      type = "gem";
    };
    version = "1.0.1";
  };
  peek-gc = {
    dependencies = ["peek"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "094h3mr9q8wzbqsj0girpyjvj4bcxax8m438igp42n75xv0bhwi9";
      type = "gem";
    };
    version = "0.0.2";
  };
  peek-host = {
    dependencies = ["peek"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11ra0hzdkdywp3cmaizcisliy26jwz7k0r9nkgm87y7amqk1wh8b";
      type = "gem";
    };
    version = "1.0.0";
  };
  peek-mysql2 = {
    dependencies = ["atomic" "mysql2" "peek"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bb2fzx3dwj7k6sc87jwhjk8vzp8dskv49j141xx15vvkg603j8k";
      type = "gem";
    };
    version = "1.1.0";
  };
  peek-performance_bar = {
    dependencies = ["peek"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wrzhv6d0ixxba9ckis6mmvb9vdsxl9mdl4zh4arv6w40wqv0k8d";
      type = "gem";
    };
    version = "1.2.1";
  };
  peek-pg = {
    dependencies = ["concurrent-ruby" "concurrent-ruby-ext" "peek" "pg"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17yk8xrh7yh57wg6vi3s8km9qd9f910n94r511mdyqd7aizlfb7c";
      type = "gem";
    };
    version = "1.3.0";
  };
  peek-rblineprof = {
    dependencies = ["peek" "rblineprof"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ywk1gvsnhrkhqq2ibwsg7099kg5m2vs4nmzy0wf65kb0ywl0m9c";
      type = "gem";
    };
    version = "0.2.0";
  };
  peek-redis = {
    dependencies = ["atomic" "peek" "redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v91cni591d9wdrmvgam20gr3504x84mh1l95da4rz5a9436jm33";
      type = "gem";
    };
    version = "1.2.0";
  };
  peek-sidekiq = {
    dependencies = ["atomic" "peek" "sidekiq"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y7s32p6cp66z1hpd1wcv4crmvvvcag5i39aazclckjsfpdfn24x";
      type = "gem";
    };
    version = "1.0.3";
  };
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dv4ma9xd75xpsnnwwg1yrpwpji7ydy0q1d9dl0yfqbzpidrw32";
      type = "gem";
    };
    version = "0.18.4";
  };
  po_to_json = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xvanl437305mry1gd57yvcg7xrfhri91czr32bjr8j2djm8hwba";
      type = "gem";
    };
    version = "1.0.1";
  };
  poltergeist = {
    dependencies = ["capybara" "cliver" "multi_json" "websocket-driver"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnkly1ks31nf5cdks9jd5c5vynbanrr8pwp801qq2i8bg78rwc0";
      type = "gem";
    };
    version = "1.9.0";
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
  premailer = {
    dependencies = ["addressable" "css_parser" "htmlentities"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10w6f7r6snpkcnv3byxma9b08lyqzcfxkm083scb2dr2ly4xkzyf";
      type = "gem";
    };
    version = "1.10.4";
  };
  premailer-rails = {
    dependencies = ["actionmailer" "premailer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05czxmx6hnykg6g23hy2ww2bf86a69njbi02sv7lrds4w776jhim";
      type = "gem";
    };
    version = "1.9.7";
  };
  prometheus-client-mmap = {
    dependencies = ["mmap2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13y2rg2bzbpdx33d72j4dwgwcnml4y7gv0pg401642kmv3ypab77";
      type = "gem";
    };
    version = "0.7.0.beta11";
  };
  pry = {
    dependencies = ["coderay" "method_source" "slop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05xbzyin63aj2prrv8fbq2d5df2mid93m81hz5bvf2v4hnzs42ar";
      type = "gem";
    };
    version = "0.10.4";
  };
  pry-byebug = {
    dependencies = ["byebug" "pry"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lwqc8vjq7b177xfknmigxvahp6dc8i1fy09d3n8ld1ndd909xjq";
      type = "gem";
    };
    version = "3.4.2";
  };
  pry-rails = {
    dependencies = ["pry"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v8xlzzb535k7wcl0vrpday237xwc04rr9v3gviqzasl7ydw32x6";
      type = "gem";
    };
    version = "0.3.5";
  };
  pyu-ruby-sasl = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcpjiz9lrvyb3rd8k8qni0v4ps08psympffyldmmnrqayyad0sn";
      type = "gem";
    };
    version = "0.0.3.3";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1374xyh8nnqb8sy6g9gcvchw8gifckn5v3bhl6dzbwwsx34qz7gz";
      type = "gem";
    };
    version = "1.6.5";
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
      sha256 = "1czx68p70x98y21dkdndsb64lrxf9qrv09wl1dbcxrypcjnpsdl1";
      type = "gem";
    };
    version = "4.4.1";
  };
  rack-cors = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sz9d9gjmv2vjl3hddzk269hb1k215k8sp37gicphx82h3chk1kw";
      type = "gem";
    };
    version = "0.4.0";
  };
  rack-oauth2 = {
    dependencies = ["activesupport" "attr_required" "httpclient" "multi_json" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7fh3fyajpfwg47gyfd8spavn7lmd6dcm468w7lhnhcviy5vmyf";
      type = "gem";
    };
    version = "1.2.3";
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
  rack-proxy = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bpbcb9ch94ha2q7gdri88ry7ch0z6ian289kah9ayxyqg19j6f4";
      type = "gem";
    };
    version = "0.6.0";
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
      sha256 = "0dpbf3ybzbhqqkwg5vi60121860cr8fybvchrxk5wy3f2jcj0mch";
      type = "gem";
    };
    version = "4.2.8";
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
      sha256 = "1ny7mbjxhq20rzg4pivvyvk14irmc7cn20kxfk3vc0z2r2c49p8r";
      type = "gem";
    };
    version = "1.0.8";
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
  rails-i18n = {
    dependencies = ["i18n" "railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17a02f2671pw5r2hl2n3isiz6w9wy2dxq8g52srciyl1xcmvsw01";
      type = "gem";
    };
    version = "4.0.9";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bavl4hj7bnl3ryqi9rvykm410kflplgingkcxasfv1gdilddh4g";
      type = "gem";
    };
    version = "4.2.8";
  };
  rainbow = {
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08w2ghc5nv0kcq5b257h7dwjzjz1pqcavajfdx2xjyxqsvh2y34w";
      type = "gem";
    };
    version = "2.2.2";
  };
  raindrops = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0854mial50yhvdv0d2r41xxl47v7z2f4nx49js42hygv7rf1mscz";
      type = "gem";
    };
    version = "0.18.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jcabbgnjc788chx31sihc5pgbqnlc1c75wakmqlbjdm8jns2m9b";
      type = "gem";
    };
    version = "10.5.0";
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
      sha256 = "027dvwz1g1h4bm40v3kxqbim4p7ww4fcmxa2l1mvwiqm5cjiqd7k";
      type = "gem";
    };
    version = "4.2.2";
  };
  re2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mjpvm9v81cvcr6yrv71kpvpxwjhxj086hsy3zr9rgzmnl2dfj23";
      type = "gem";
    };
    version = "1.0.0";
  };
  recaptcha = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pppfgica4629i8gbji6pnh681wjf03m6m1ix2ficpnqg2z7gl9n";
      type = "gem";
    };
    version = "3.0.0";
  };
  recursive-open-struct = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "102bgpfkjsaghpb1qs1ah5s89100dchpimzah2wxdy9rv9318rqw";
      type = "gem";
    };
    version = "1.0.0";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
      type = "gem";
    };
    version = "3.4.0";
  };
  RedCloth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m9dv7ya9q93r8x1pg2gi15rxlbck8m178j1fz7r5v6wr1avrrqy";
      type = "gem";
    };
    version = "4.3.2";
  };
  redis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kdj7511l6kqvqmaiw7kw604c83pk6f4b540gdsq1bf7yxm6qx6g";
      type = "gem";
    };
    version = "3.3.3";
  };
  redis-actionpack = {
    dependencies = ["actionpack" "redis-rack" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gnkqi7cji2q5yfwm8b752k71pqrb3dqksv983yrf23virqnjfjr";
      type = "gem";
    };
    version = "5.0.1";
  };
  redis-activesupport = {
    dependencies = ["activesupport" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i0r23rv32k25jqwbr4cb73alyaxwvz9crdaw3gv26h1zjrdjisd";
      type = "gem";
    };
    version = "5.0.1";
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
      sha256 = "0fbxl5gv8krjf6n88gvn44xbzhfnsysnzawz7zili298ak98lsb3";
      type = "gem";
    };
    version = "1.6.0";
  };
  redis-rails = {
    dependencies = ["redis-actionpack" "redis-activesupport" "redis-store"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04l2y26k4v30p3dx0pqf9gz257q73qzgrfqf3qv6bxwyv8z9f5hm";
      type = "gem";
    };
    version = "5.0.1";
  };
  redis-store = {
    dependencies = ["redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1da15wr3wc1d4hqy7h7smdc2k2jpfac3waa9d65si6f4dmqymkkq";
      type = "gem";
    };
    version = "1.2.0";
  };
  request_store = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1va9x0b3ww4chcfqlmi8b14db39di1mwa7qrjbh7ma0lhndvs2zv";
      type = "gem";
    };
    version = "1.3.1";
  };
  responders = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16h343srb6msivc2mpm1dbihsmniwvyc9jk3g4ip08g9fpmxfc2i";
      type = "gem";
    };
    version = "2.3.0";
  };
  rest-client = {
    dependencies = ["http-cookie" "mime-types" "netrc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v2jp2ilpb2rm97yknxcnay9lfagcm4k82pfsmmcm9v290xm1ib7";
      type = "gem";
    };
    version = "2.0.0";
  };
  retriable = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cmhwgv5r4vn7iqy4bfbnbb73pzl8ik69zrwq9vdim45v8b13gsj";
      type = "gem";
    };
    version = "1.4.1";
  };
  rinku = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11cakxzp7qi04d41hbqkh92n52mm4z2ba8sqyhxbmfi4kypmls9y";
      type = "gem";
    };
    version = "2.0.0";
  };
  rotp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w8d6svhq3y9y952r8cqirxvdx12zlkb7zxjb44bcbidb2sisy4d";
      type = "gem";
    };
    version = "2.1.2";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1932gvvzfdky2z01sjri354ak7wq3nk9jmh7fiydfgjchfwk7sr4";
      type = "gem";
    };
    version = "2.1.0";
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
      sha256 = "16g3mmih999f0b6vcz2c3qsc7ks5zy4lj1rzjh8hf6wk531nvc6s";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03m0pn5lwlix094khfwlv50n963p75vjsg6w2g0b3hqcvvlch1mx";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bbqfrb1x8gmwf8x2xhhwvvlhwbbafq4isbvlibxi6jk602f09gs";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nl3ksivh9wwrjjd47z5dggrwx40v6gpb3a0gzbp1gs06a5dmk24";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-rails = {
    dependencies = ["actionpack" "activesupport" "railties" "rspec-core" "rspec-expectations" "rspec-mocks" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zzd75v8vpa1r30j3hsrprza272rcx54hb0klwpzchr9ch6c9z2a";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec-retry = {
    dependencies = ["rspec-core"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0izvxab7jvk25kaprk0i72asjyh1ip3cm70bgxlm8lpid35qjar6";
      type = "gem";
    };
    version = "0.4.5";
  };
  rspec-set = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06vw8b5w1a58838cw9ssmy3r6f8vrjh54h7dp97rwv831gn5zlyk";
      type = "gem";
    };
    version = "0.1.3";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10vf3k3d472y573mag2kzfsfrf6rv355s13kadnpryk8d36yq5r0";
      type = "gem";
    };
    version = "3.5.0";
  };
  rspec_profiling = {
    dependencies = ["activerecord" "pg" "rails" "sqlite3"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g7q7gav26bpiprx4dhlvdh4zdrhwiky9jbmsp14gyfiabqdz4sz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubocop = {
    dependencies = ["parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05kr3a4jlyq6vaf9rjqiryk51l05bzpxwql024gssfryal66l1m7";
      type = "gem";
    };
    version = "0.47.1";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1svaibl7qw4k5vxi7729ddgy6582b8lzhc01ybikb4ahnxj1x1cd";
      type = "gem";
    };
    version = "1.15.0";
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
  ruby-prof = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y13gdcdajfgrkx5rc9pvb7bwkyximwl5yrhq05gkmhflzdr7kag";
      type = "gem";
    };
    version = "0.16.2";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qzc7s7r21bd7ah06kskajc2bjzkr9y0v5q48y0xwh2l55axgplm";
      type = "gem";
    };
    version = "1.8.1";
  };
  ruby-saml = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1abhf16vbyzck4pv06qd5c59780glaf682ssjzpjwd9h9d7nqvl5";
      type = "gem";
    };
    version = "1.4.1";
  };
  ruby_parser = {
    dependencies = ["sexp_processor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18apbsmmivgc1schfxmkp429aijrwy8psm30dwx5cpmpjf48ir3n";
      type = "gem";
    };
    version = "3.9.0";
  };
  rubyntlm = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1p6bxsklkbcqni4bcq6jajc2n57g0w5rzn4r49c3lb04wz5xg0dy";
      type = "gem";
    };
    version = "0.6.2";
  };
  rubypants = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vpdkrc4c8qhrxph41wqwswl28q5h5h994gy4c1mlrckqzm3hzph";
      type = "gem";
    };
    version = "0.2.0";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06js4gznzgh8ac2ldvmjcmg9v1vg9llm357yckkpylaj6z456zqz";
      type = "gem";
    };
    version = "1.2.1";
  };
  rufus-scheduler = {
    dependencies = ["et-orbi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0343xrx4gbld5w2ydh9d2a7pw7lllvrsa691bgjq7p9g44ry1vq8";
      type = "gem";
    };
    version = "3.4.0";
  };
  rugged = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sj833k4g09sgx37k3f46dxyjfppmmcj1s6w6bqan0f2vc047bi0";
      type = "gem";
    };
    version = "0.25.1.1";
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
      sha256 = "0dkj6v26fkg1g0majqswwmhxva7cd6p3psrhdlx93qal72dssywy";
      type = "gem";
    };
    version = "3.4.22";
  };
  sass-rails = {
    dependencies = ["railties" "sass" "sprockets" "sprockets-rails" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iji20hb8crncz14piss1b29bfb6l89sz3ai5fny3iw39vnxkdcb";
      type = "gem";
    };
    version = "5.0.6";
  };
  sawyer = {
    dependencies = ["addressable" "faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv1463r7bqzvx4drqdmd36m7rrv6sf1v3c6vswpnq3k6vdw2dvd";
      type = "gem";
    };
    version = "0.8.1";
  };
  scss_lint = {
    dependencies = ["rake" "sass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q6yankh4ay4fqz7s19p2r2nqhzv93gihc5c6xnqka3ch1z6v9fv";
      type = "gem";
    };
    version = "0.47.1";
  };
  securecompare = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ay65wba4i7bvfqyvf5i4r48q6g70s5m724diz9gdvdavscna36b";
      type = "gem";
    };
    version = "1.0.0";
  };
  seed-fu = {
    dependencies = ["activerecord" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkp1pvkdydclbl2v4qf9cixmiycvlqnrgxd61sv9r85spb01z3p";
      type = "gem";
    };
    version = "2.3.6";
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
    dependencies = ["faraday"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19qqb7whayd170y45asc3cr3mbxfd46fv6s4jbs5xx1wphy4q80i";
      type = "gem";
    };
    version = "2.5.3";
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
      sha256 = "1c6kp2qxq550hz7gsxqi37irxn3vynkz7ibgy9hfwqymf6y1jdik";
      type = "gem";
    };
    version = "4.9.0";
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
    dependencies = ["concurrent-ruby" "connection_pool" "rack-protection" "redis"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h19c0vk7h5swbpi91qx4ln6nwas4ycj7y6bsm86ilhpiqcb7746";
      type = "gem";
    };
    version = "5.0.0";
  };
  sidekiq-cron = {
    dependencies = ["rufus-scheduler" "sidekiq"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04mq83rzvq4wbc4h0rn00sawgv039j8s2p0wnlqb4sgf55gc0dzj";
      type = "gem";
    };
    version = "0.6.0";
  };
  sidekiq-limit_fetch = {
    dependencies = ["sidekiq"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ykpqw2nc9fs4v0slk5n4m42n3ihwwkk5mcyw3rz51blrdzj92kr";
      type = "gem";
    };
    version = "3.4.0";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "149668991xqibvm8kvl10kzy891yd6f994b4gwlx6c3vl24v5jq6";
      type = "gem";
    };
    version = "0.7.3";
  };
  simplecov = {
    dependencies = ["docile" "json" "simplecov-html"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r9fnsnsqj432cmrpafryn8nif3x0qg9mdnvrcf0wr01prkdlnww";
      type = "gem";
    };
    version = "0.14.1";
  };
  simplecov-html = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qni8g0xxglkx25w54qcfbi4wjkpvmb28cb7rj5zk3iqynjcdrqf";
      type = "gem";
    };
    version = "0.10.0";
  };
  slack-notifier = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xavibxh00gy62mm79l6id9l2fldjmdqifk8alqfqy5z38ffwah6";
      type = "gem";
    };
    version = "1.5.1";
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
  spinach-rerun-reporter = {
    dependencies = ["spinach"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fkmp99cpxrdzkjrxw9y9qp8qxk5d1arpmmlg5njx40rlcvx002k";
      type = "gem";
    };
    version = "0.0.2";
  };
  spring = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wwbyg2nab2k4hdpd1i65qmnfixry29b4yqynrqfnmjghn0xvc7x";
      type = "gem";
    };
    version = "2.0.1";
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
      sha256 = "12qa60sclhnclwi6lskhdgr1l007bca831vhp35f06hq1zmimi2x";
      type = "gem";
    };
    version = "1.1.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sv3zk5hwxyjvg7iy9sggjc7k3mfxxif7w8p260rharfyib939ar";
      type = "gem";
    };
    version = "3.7.1";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zr9vk2vn44wcn4265hhnnnsciwlmqzqc6bnx78if1xcssxj6x44";
      type = "gem";
    };
    version = "3.2.0";
  };
  sqlite3 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01ifzp8nwzqppda419c9wcvr8n82ysmisrs0hph9pdmv1lpa4f5i";
      type = "gem";
    };
    version = "1.3.13";
  };
  stackprof = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c88j2d6ipjw5s3hgdgfww37gysgrkicawagj33hv3knijjc9ski";
      type = "gem";
    };
    version = "0.2.10";
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
      sha256 = "0p6560jsb4flapd1vbc50bqjk6dzykkwbmyivchyjh5ncynsdb8v";
      type = "gem";
    };
    version = "0.4.0";
  };
  state_machines-activerecord = {
    dependencies = ["activerecord" "state_machines-activemodel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x5wx1s2i3qc4p2knkf2n9h8b49pla9rjidkwxqzi781qm40wdxx";
      type = "gem";
    };
    version = "0.4.0";
  };
  stringex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "150adm7rfh6r9b5ra6vk75mswf9m3wwyslcf8f235a08m29fxa17";
      type = "gem";
    };
    version = "2.5.2";
  };
  sys-filesystem = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "092wj7936i5inzafi09wqh5c8dbak588q21k652dsrdjf5qi10zq";
      type = "gem";
    };
    version = "1.1.6";
  };
  sysexits = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qjng6pllznmprzx8vb0zg0c86hdrkyjs615q41s9fjpmv2430jr";
      type = "gem";
    };
    version = "1.2.0";
  };
  temple = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xlf1if32xj14mkfwh8nxy3zzjzd9lipni0v2bghknp2kfc1hcz6";
      type = "gem";
    };
    version = "0.7.7";
  };
  test_after_commit = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8pz00xq28lsa1rfczm83yqwk8wcb5dqw2imlj8gldnsdapcyc2";
      type = "gem";
    };
    version = "1.1.0";
  };
  text = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dq9q7qyjyg4444bmn12r2s0mir8dqnvc037y0zidhbyaavrv95q";
      type = "gem";
    };
    version = "1.7.0";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01n5dv9kql60m6a00zc0r66jvaxx98qhdny3klyj0p3w34pad2ns";
      type = "gem";
    };
    version = "0.19.4";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qsyzq2k7blyp1rph56xczwfqi8gplns2whswyr67mdfzdi60vvm";
      type = "gem";
    };
    version = "2.0.6";
  };
  timecop = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vwbkwqyxhavzvr1820hqwz43ylnfcf6w4x6sag0nghi44sr9kmx";
      type = "gem";
    };
    version = "0.8.1";
  };
  timfel-krb5-auth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105vajc0jkqgcx1wbp0ad262sdry4l1irk7jpaawv8vzfjfqqf5b";
      type = "gem";
    };
    version = "0.8.3";
  };
  toml-rb = {
    dependencies = ["citrus"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03sr3k193i1r5bh9g4zc7iq9jklapmwj0rndcvhr9q7v5xm7x4rf";
      type = "gem";
    };
    version = "0.3.15";
  };
  tool = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iymkxi4lv2b2k905s9pl4d9k9k4455ksk3a98ssfn7y94h34np0";
      type = "gem";
    };
    version = "0.2.3";
  };
  truncato = {
    dependencies = ["htmlentities" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09ngwz2mpfsi1ms94j7nmms4kbd5sgcqv5dshrbwaqf585ja7cm5";
      type = "gem";
    };
    version = "0.7.8";
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
  u2f = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lsm1hvwcaa9sq13ab1l1zjk0fgcy951ay11v2acx0h6q1iv21vr";
      type = "gem";
    };
    version = "0.2.1";
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
      sha256 = "04d13bp6lyg695x94whjwsmzc2ms72d94vx861nx1y40k3817yp8";
      type = "gem";
    };
    version = "0.0.7.2";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r28mxyi0zwby24wyn1szj5hcnv67066wkv14wyzsc94bf04fqhx";
      type = "gem";
    };
    version = "1.1.3";
  };
  unicorn = {
    dependencies = ["kgio" "raindrops"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rcvg9381yw3wrnpny5c01mvm35caycshvfbg96wagjhscw6l72v";
      type = "gem";
    };
    version = "5.1.0";
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
      sha256 = "1jha0l7x602g5rvah960xl9r0f3q25gslj39i0x1vai8i5z6zr1l";
      type = "gem";
    };
    version = "1.10.0";
  };
  url_safe_base64 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wgslyapmw4m6l5f6xvcvrvdz3hbkqczkhmjp96s6pzwcgxvcazz";
      type = "gem";
    };
    version = "0.2.2";
  };
  validates_hostname = {
    dependencies = ["activerecord" "activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04p1l0v98j4ffvaks1ig9mygx5grpbpdgz7haq3mygva9iy8ykja";
      type = "gem";
    };
    version = "1.0.6";
  };
  version_sorter = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1smi0bf8pgx23014nkpfg29qnmlpgvwmn30q0ca7qrfbha2mjwdr";
      type = "gem";
    };
    version = "2.1.0";
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
  vmstat = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vb5mwc71p8rlm30hnll3lb4z70ipl5rmilskpdrq2mxwfilcm5b";
      type = "gem";
    };
    version = "2.3.0";
  };
  warden = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04gpmnvkp312wxmsvvbq834iyab58vjmh6w4x4qpgh4p1lzkiq1l";
      type = "gem";
    };
    version = "1.2.6";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04hkcqsmbfnp8g237pisnc834vpgildklicbjbyikqg0bg1rwcy5";
      type = "gem";
    };
    version = "2.3.2";
  };
  webpack-rails = {
    dependencies = ["railties"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l0jzw05yk1c19q874nhkanrn2ik7hjbr2vjcdnk1fqp2f3ypzvv";
      type = "gem";
    };
    version = "0.9.10";
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
