{
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
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "14mbmlwyrxccmf2svhxmvrv0ypcq53xyyqzh4a2r2azmxjb1zxnx";
    };
    dependencies = [
      "actionpack"
      "actionview"
      "mail"
    ];
  };
  "actionpack" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "078iqmjay787xg76zibnvk485y29d57wffiv9nj0nmzb89jfa6y1";
    };
    dependencies = [
      "actionview"
      "activesupport"
      "rack"
      "rack-test"
    ];
  };
  "actionview" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "0wlhsy9hqzpi3xylphx71i9bd5x6dd03qzrh4nnc8mimzjbv14jq";
    };
    dependencies = [
      "activesupport"
      "builder"
      "erubis"
    ];
  };
  "activemodel" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "0cijxp7n0zv1j2bh5jyirlcwi24j9xlwfsmn7icr0zsybgc0in61";
    };
    dependencies = [
      "activesupport"
      "builder"
    ];
  };
  "activerecord" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "180kxb98097nh8dprqrm5d1ab6xaqv8kxqdbm1p84y87w0kj57yz";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "arel"
    ];
  };
  "activesupport" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "11dsdfrdqqfhpgigb960a4xrs1k7ix5brbsw034nijn8d4fq0hkk";
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
    version = "2.4.1";
    source = {
      type = "gem";
      sha256 = "0gbmxx6nk109i6c4686vr5wpf89xiiys7s2lwf7z68dpgi1dsxab";
    };
    dependencies = [
      "rails"
    ];
  };
  "addressable" = {
    version = "2.3.5";
    source = {
      type = "gem";
      sha256 = "11hv69v6h39j7m4v51a4p7my7xwjbhxbsg3y7ja156z7by10wkg7";
    };
  };
  "annotate" = {
    version = "2.6.0";
    source = {
      type = "gem";
      sha256 = "0min6rmiqjnp6irjd9mjlz8k13qzx4g51d8v6vn8zn8hdnfbjanr";
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
  "asciidoctor" = {
    version = "0.1.4";
    source = {
      type = "gem";
      sha256 = "14ngw7c8sq5ydh0xz6b5jgvs5vbk2sx1vf75fjf0q81ixnd6yb9a";
    };
  };
  "awesome_print" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1k85hckprq0s9pakgadf42k1d5s07q23m3y6cs977i6xmwdivyzr";
    };
  };
  "axiom-types" = {
    version = "0.0.5";
    source = {
      type = "gem";
      sha256 = "0k6mf132n2f5z8xwcwfjayrxfqsd8yyzj2cgxv5phvr7szlqfyzn";
    };
    dependencies = [
      "descendants_tracker"
      "ice_nine"
    ];
  };
  "bcrypt" = {
    version = "3.1.7";
    source = {
      type = "gem";
      sha256 = "00jpjl2v0y8dsfhxx3l3sp2pnflkxbbywnda46n1w5f7a8qrac0w";
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
    version = "3.0.3.0";
    source = {
      type = "gem";
      sha256 = "1isljqrlasq9n7cxj4ldf0cjjhkwzsbl8lj6rf5z9farwjx6k4iz";
    };
    dependencies = [
      "sass"
    ];
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "capybara" = {
    version = "2.2.1";
    source = {
      type = "gem";
      sha256 = "1sydb3mnznqn23s2cqb0ysdml0dgl06fzdvx8aqbbx1km9pgz080";
    };
    dependencies = [
      "mime-types"
      "nokogiri"
      "rack"
      "rack-test"
      "xpath"
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
    version = "0.15.2";
    source = {
      type = "gem";
      sha256 = "0lpa97m7f4p5hgzaaa47y1d5c78n8pp4xd8qb0sn5llqd0klkd9b";
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
  "cliver" = {
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "096f4rj7virwvqxhkavy0v55rax10r4jqf8cymbvn4n631948xc7";
    };
  };
  "code_analyzer" = {
    version = "0.4.3";
    source = {
      type = "gem";
      sha256 = "1v8b6sbsyw1612wilfc2bsjbr41gf46apjqmlqbishmkhywi1di7";
    };
    dependencies = [
      "sexp_processor"
    ];
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
    version = "4.0.1";
    source = {
      type = "gem";
      sha256 = "12nqw61xfs43qap4bxp123q4fgj41gvxirdal95ymdd2qzr3cvig";
    };
    dependencies = [
      "coffee-script"
      "railties"
    ];
  };
  "coffee-script" = {
    version = "2.2.0";
    source = {
      type = "gem";
      sha256 = "133cp4znfp44wwnv12myw8s0z6qws74ilqmw88iwzkshg689zpdc";
    };
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
  };
  "coffee-script-source" = {
    version = "1.6.3";
    source = {
      type = "gem";
      sha256 = "0p33h0rdj1n8xhm2d5hzqbb8br6wn4rx0gk4hyhc6rxkaxsy79b4";
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
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "1ffw78r39b3gn121ghi65fsrkzjjv7h0mxag6ilphsas1kzz3h21";
    };
  };
  "coveralls" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0sz30d7b83qqsj3i0fr691w05d62wj7x3afh0ryjkqkis3fq94j4";
    };
    dependencies = [
      "multi_json"
      "rest-client"
      "simplecov"
      "term-ansicolor"
      "thor"
    ];
  };
  "crack" = {
    version = "0.4.1";
    source = {
      type = "gem";
      sha256 = "0wb2s4nidabcgn2k65ydhx0f9758py79p615qph99117csy915jg";
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
    version = "3.1.10";
    source = {
      type = "gem";
      sha256 = "1n94vwn51v1dfqjqmdkb11mgyvq6dfmf5cjwa9w1nj3785yvkii8";
    };
    dependencies = [
      "railties"
    ];
  };
  "daemons" = {
    version = "1.1.9";
    source = {
      type = "gem";
      sha256 = "1j1m64pirsldhic6x6sg4lcrmp1bs1ihpd49xm8m1b2rc1c3irzy";
    };
  };
  "database_cleaner" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "19w25yda684pg29bggq26wy4lpyjvzscwg2hx3hmmmpysiwfnxgn";
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
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "08bhk2dzxpvsk891y415man42vn3f9cvysysywh1iavxbv5qkg8z";
    };
    dependencies = [
      "activerecord"
    ];
  };
  "descendants_tracker" = {
    version = "0.0.3";
    source = {
      type = "gem";
      sha256 = "0819j80k85j62qjg90v8z8s3h4nf3v6afxxz73hl6iqxr2dhgmq1";
    };
  };
  "devise" = {
    version = "3.2.4";
    source = {
      type = "gem";
      sha256 = "1za4082iacq2n0g0v5s1vmn402wj4bwvqqd55phc9da922j4awx3";
    };
    dependencies = [
      "bcrypt"
      "orm_adapter"
      "railties"
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
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "diffy" = {
    version = "3.0.3";
    source = {
      type = "gem";
      sha256 = "0qldyp6m5vlagiaiwdixbj64ynr5ghz58xsrxykas7581qdxk88m";
    };
  };
  "docile" = {
    version = "1.1.5";
    source = {
      type = "gem";
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
    };
  };
  "dotenv" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1gl0m6s8d6m72wcm4p86kzzjdihyryi5mh6v70qkqd0dl1gj73l3";
    };
  };
  "dropzonejs-rails" = {
    version = "0.4.14";
    source = {
      type = "gem";
      sha256 = "0aqjij9dvazz7vq9c8m9fxjc3vnkfagqgnq94whzgrm2ikszb1ny";
    };
    dependencies = [
      "rails"
    ];
  };
  "email_spec" = {
    version = "1.5.0";
    source = {
      type = "gem";
      sha256 = "0gshv8ylfr1nf6mhgriyzlm5rv5c44yxlgmxva8gpdqsyibfa1r6";
    };
    dependencies = [
      "launchy"
      "mail"
    ];
  };
  "emoji" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "01fgzkwfsfcvcgrxb6x58w8rpcv0hq6x761iws0xqv0rzz3a8x1a";
    };
    dependencies = [
      "json"
    ];
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
    version = "0.0.8";
    source = {
      type = "gem";
      sha256 = "1nh9i4khg7z2nsay8i1i43yk6ml2hwsf7cl179z22p4kwvn04vfn";
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
    version = "1.0.3";
    source = {
      type = "gem";
      sha256 = "09sqlsb6x9ddlgfw5gsw7z0yjg5m2qfjiqkz2fx70zsizj3lqhil";
    };
  };
  "excon" = {
    version = "0.32.1";
    source = {
      type = "gem";
      sha256 = "0yazh0228ldyxrbrj5pqw06rs5sk3disp24v5bw4h8mp3ibih45a";
    };
  };
  "execjs" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "167kbkyql7nvvwjsgdw5z8j66ngq7kc59gxfwsxhqi5fl1z0jbjs";
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
    version = "0.8.9";
    source = {
      type = "gem";
      sha256 = "17d79fsgx0xwh0mfxyz5pbr435qlw79phlfvifc546w2axdkp718";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "faraday_middleware" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1kwvi2sdxd6j764a7q5iir73dw2v6816zx3l8cgfv0wr2m47icq2";
    };
    dependencies = [
      "faraday"
    ];
  };
  "ffaker" = {
    version = "1.22.1";
    source = {
      type = "gem";
      sha256 = "17zpqhf1kq831jg9rdrpx58mwnrnrvy5g97rxg3hzgy5j09kxq0q";
    };
  };
  "ffi" = {
    version = "1.9.3";
    source = {
      type = "gem";
      sha256 = "0873h6jp3v65mll7av9bxlzp9m9l1cc66j0krg0llchwbh4pv5sp";
    };
  };
  "fog" = {
    version = "1.21.0";
    source = {
      type = "gem";
      sha256 = "14hbq573gl5x8zrcx5jz9d7m6rnn0vk8ypgn77hrhjh0wyxb0a7f";
    };
    dependencies = [
      "fog-brightbox"
      "fog-core"
      "fog-json"
      "nokogiri"
    ];
  };
  "fog-brightbox" = {
    version = "0.0.1";
    source = {
      type = "gem";
      sha256 = "0j1bpfa8in3h69habl46zmm1540w46348gd246bamrs5gi4zfqkk";
    };
    dependencies = [
      "fog-core"
      "fog-json"
    ];
  };
  "fog-core" = {
    version = "1.21.1";
    source = {
      type = "gem";
      sha256 = "1wcxilb537ibfl06r8h73ilj5xxvd18cc21nzwbh6fp2ip527q34";
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
    version = "1.0.0";
    source = {
      type = "gem";
      sha256 = "1517sm8bl0bmaw2fbaf5ra6midq3wzgkpm55lb9rw6jm5ys23lyw";
    };
    dependencies = [
      "multi_json"
    ];
  };
  "font-awesome-rails" = {
    version = "4.2.0.0";
    source = {
      type = "gem";
      sha256 = "1r6x34lswqcm6s6y5fvx34afsydpdly0123m75m1f5vx30l81jh0";
    };
    dependencies = [
      "railties"
    ];
  };
  "foreman" = {
    version = "0.63.0";
    source = {
      type = "gem";
      sha256 = "0yqyjix9jm4iwyc4f3wc32vxr28rpjcw1c9ni5brs4s2a24inzlk";
    };
    dependencies = [
      "dotenv"
      "thor"
    ];
  };
  "formatador" = {
    version = "0.2.4";
    source = {
      type = "gem";
      sha256 = "0pgmk1h6i6m3cslnfyjqld06a4c2xbbvmngxg2axddf39xwz6f12";
    };
  };
  "gemnasium-gitlab-service" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "0a3jy2z1xkgxaqxhsclsfkn52iccdga5zznfk00s69gn0bpvdfc2";
    };
    dependencies = [
      "rugged"
    ];
  };
  "gherkin-ruby" = {
    version = "0.3.1";
    source = {
      type = "gem";
      sha256 = "10plcj47ky078dvg78abf0asv29g6ba1zs9mgrza1161cxyj0mlq";
    };
    dependencies = [
      "racc"
    ];
  };
  "github-markup" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "06zsljgavpkwafw32zx69xblhrhz1r2mjbhgpvn51c2qa0rmsd7g";
    };
  };
  "gitlab-flowdock-git-hook" = {
    version = "0.4.2.2";
    source = {
      type = "gem";
      sha256 = "0r6hwkzkcdv53ib9ispjs38njxmmca7kz8kj5mjadqvdwiak9nwv";
    };
    dependencies = [
      "gitlab-grit"
      "multi_json"
    ];
  };
  "gitlab-grack" = {
    version = "2.0.0.pre";
    source = {
      type = "gem";
      sha256 = "197qdlymn6cf0qk3698kn0miizv7x9hr1429g9l900rnc85a5rdb";
    };
    dependencies = [
      "rack"
    ];
  };
  "gitlab-grit" = {
    version = "2.6.12";
    source = {
      type = "gem";
      sha256 = "00yghwc3ggg34vdkz7v8mq27fc8h47kydahbqzaby5s0w70nx6c8";
    };
    dependencies = [
      "charlock_holmes"
      "diff-lcs"
      "mime-types"
      "posix-spawn"
    ];
  };
  "gitlab-linguist" = {
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "0g2nv7lb33354nb8clwjrgxk09vr3wjn4rpyllmq6s01vx660lk6";
    };
    dependencies = [
      "charlock_holmes"
      "escape_utils"
      "mime-types"
    ];
  };
  "gitlab_emoji" = {
    version = "0.0.1.1";
    source = {
      type = "gem";
      sha256 = "0cqxhbq5c3mvkxbdcwcl4pa0cwlvnjsphs7hp2dz63h82ggwa3vn";
    };
    dependencies = [
      "emoji"
    ];
  };
  "gitlab_git" = {
    version = "7.0.0.rc10";
    source = {
      type = "gem";
      sha256 = "0kjljz76wh4344z05mv3wiad7qdf6nwaa0yl1jls1j0hk9i4bb4k";
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
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0bpsh8z8fl03fwgz82wn53ibrc7714hmx16s5zxfbq1xk70r3pq7";
    };
    dependencies = [
      "net-ldap"
      "omniauth"
      "pyu-ruby-sasl"
      "rubyntlm"
    ];
  };
  "gollum-lib" = {
    version = "3.0.0";
    source = {
      type = "gem";
      sha256 = "18g74hl0zm285jszsk4414qvd106j0gkydg134my8hylwv59c23s";
    };
    dependencies = [
      "github-markup"
      "gitlab-grit"
      "nokogiri"
      "rouge"
      "sanitize"
      "stringex"
    ];
  };
  "gon" = {
    version = "5.0.1";
    source = {
      type = "gem";
      sha256 = "19ga6y4375iakccg089f7789r9n87gh16cdmhaa0qsk1m1dx34zm";
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
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "15vvpj7hw2n84glrvh5p3il8h3nnqg5gzgk6knavhamc7gj09g4k";
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
    version = "2.2.4";
    source = {
      type = "gem";
      sha256 = "0z427rkcpzy82g21cgq7i5sn1vxn8hm8j4d78kj9vlaqgilcybhq";
    };
    dependencies = [
      "formatador"
      "listen"
      "lumberjack"
      "pry"
      "thor"
    ];
  };
  "guard-rspec" = {
    version = "4.2.0";
    source = {
      type = "gem";
      sha256 = "0n4159cw88y0va5v2yvhjphwlgwhqbc3mplj7p92irbj045xsc8n";
    };
    dependencies = [
      "guard"
      "rspec"
    ];
  };
  "guard-spinach" = {
    version = "0.0.2";
    source = {
      type = "gem";
      sha256 = "1fsh6yifiywvnzrk6wbgssxr5bshp38gbhs96hbfzhvzfiff0xid";
    };
    dependencies = [
      "guard"
      "spinach"
    ];
  };
  "haml" = {
    version = "4.0.5";
    source = {
      type = "gem";
      sha256 = "1xmzb0k5q271090crzmv7dbw8ss4289bzxklrc0fhw6pw3kcvc85";
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
  "hike" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0i6c9hrszzg3gn2j41v3ijnwcm8cc2931fnjiv6mnpl4jcjjykhm";
    };
  };
  "hipchat" = {
    version = "0.14.0";
    source = {
      type = "gem";
      sha256 = "1y3bi5aj21iay138027i8y9b022hpsfw54k7k31argp2gppc8y0n";
    };
    dependencies = [
      "httparty"
      "httparty"
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
  "html-pipeline-gitlab" = {
    version = "0.1.5";
    source = {
      type = "gem";
      sha256 = "1gih8j7sq45244v21z5rc19mi21achiy11l5sc8a4xfkvq5gldng";
    };
    dependencies = [
      "actionpack"
      "gitlab_emoji"
      "html-pipeline"
      "sanitize"
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
    version = "0.13.0";
    source = {
      type = "gem";
      sha256 = "1qda6yhxwh1riddnib8knhqc0ja5h26i75kaxnywfldx9rkd32jw";
    };
    dependencies = [
      "json"
      "multi_xml"
    ];
  };
  "httpauth" = {
    version = "0.2.1";
    source = {
      type = "gem";
      sha256 = "1ydlaf1nvs3g7b4xp9445m01qyjbwnbbh2f7gvialipyipj92j8d";
    };
  };
  "i18n" = {
    version = "0.6.11";
    source = {
      type = "gem";
      sha256 = "0fwjlgmgry2blf8zlxn9c555cf4a16p287l599kz5104ncjxlzdk";
    };
  };
  "ice_nine" = {
    version = "0.10.0";
    source = {
      type = "gem";
      sha256 = "0hjcn06xgrmpz3zyg0yirx6r7xb2m6akhn29p4yn4698ncw7b3qh";
    };
  };
  "jasmine" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "1v0z5a5m4np12m0lmf0vl63qdxbh6zxnxbnzx3xjwky723inqhir";
    };
    dependencies = [
      "jasmine-core"
      "phantomjs"
      "rack"
      "rake"
    ];
  };
  "jasmine-core" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1frr9ndyrawag8c4rhd0yxl3318s5xwb3dqvz3i6z8nc936gwfzj";
    };
  };
  "jquery-atwho-rails" = {
    version = "0.3.3";
    source = {
      type = "gem";
      sha256 = "1f8w1kqy46s4qzfhlh08qb1l1czl6randcccxpknaw9pzf367fvs";
    };
  };
  "jquery-rails" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "130a8gn67b2zn47yyqshf48d46na885v4g3mh2rrchd5ma1jy6cx";
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
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "0d6av6cc0g8ym5zlkc8f00zxmnqchs95h7hqnrs2yrfz9nj856kd";
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
    version = "1.8.1";
    source = {
      type = "gem";
      sha256 = "0002bsycvizvkmk1jyv8px1hskk6wrjfk4f7x5byi8gxm6zzn6wn";
    };
  };
  "jwt" = {
    version = "0.1.13";
    source = {
      type = "gem";
      sha256 = "03c8sy54nhvvb0ksphk15p5yfkd601ncs55k4h32hjqbm9vgnlsn";
    };
    dependencies = [
      "multi_json"
    ];
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
    version = "2.8.1";
    source = {
      type = "gem";
      sha256 = "0vpw3nk35mh8mda4gn0qklq51znxxgv3852g6mxifi6hjwxrmrcj";
    };
  };
  "launchy" = {
    version = "2.4.2";
    source = {
      type = "gem";
      sha256 = "0i1nmlrqpnk2q6f7iq85cqaa7b8fw4bmqm57w60g92lsfmszs8iv";
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
  "libv8" = {
    version = "3.16.14.3";
    source = {
      type = "gem";
      sha256 = "1arjjbmr9zxkyv6pdrihsz1p5cadzmx8308vgfvrhm380ccgridm";
    };
  };
  "listen" = {
    version = "2.3.1";
    source = {
      type = "gem";
      sha256 = "081pv5nw79nl1251prh11v3ywghcmb660xm990rbp5bs6c3vcjam";
    };
    dependencies = [
      "celluloid"
      "rb-fsevent"
      "rb-inotify"
    ];
  };
  "lumberjack" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1mj6m12hnmkvzl4w2yh04ak3z45pwksj6ra7v30za8snw9kg919d";
    };
  };
  "mail" = {
    version = "2.5.4";
    source = {
      type = "gem";
      sha256 = "0z15ksb8blcppchv03g34844f7xgf36ckp484qjj2886ig1qara4";
    };
    dependencies = [
      "mime-types"
      "treetop"
    ];
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
  "mini_portile" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "09kcn4g63xrdirgwxgjikqg976rr723bkc9bxfr29pk22cj3wavn";
    };
  };
  "minitest" = {
    version = "5.3.5";
    source = {
      type = "gem";
      sha256 = "18lkfjr0p26x5qxaficwlnhvjrf5bqwl244qdx4pvr5clrvv17xr";
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
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "1ll21dz01jjiplr846n1c8yzb45kj5hcixgb72rz0zg8fyc9g61c";
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
    version = "0.3.16";
    source = {
      type = "gem";
      sha256 = "0ikg892bvyviqvxsyn0v6vj9ndhgdbc1339488n8y4s9zh35y71f";
    };
  };
  "net-ldap" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1d54cm02w8xi5nylss5b9vmzsscflcrbwg5qv1rp5frak4f397fk";
    };
  };
  "net-scp" = {
    version = "1.1.2";
    source = {
      type = "gem";
      sha256 = "0xsr5gka2y14i5pa6h2lgkdzvmlviqq2qbmgaw76gdzrcf7q9n7k";
    };
    dependencies = [
      "net-ssh"
    ];
  };
  "net-ssh" = {
    version = "2.8.0";
    source = {
      type = "gem";
      sha256 = "0l89a01199ag77vvbm47fdpmx4fp2dk9jsvwvrsqryxqqhzwbxa2";
    };
  };
  "newrelic_rpm" = {
    version = "3.9.4.245";
    source = {
      type = "gem";
      sha256 = "0r1x16wwmiqsf1gj2a1lgc0fq1v0x4yv40k5wgb00gs439vgzyin";
    };
  };
  "nokogiri" = {
    version = "1.6.2.1";
    source = {
      type = "gem";
      sha256 = "0dj8ajm9hlfpa71qz1xn5prqy5qdi32ll74qh8ssjwknp1a35cnz";
    };
    dependencies = [
      "mini_portile"
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
    version = "0.8.1";
    source = {
      type = "gem";
      sha256 = "18gk2m42l4dmhiq394mmj1md2l5va5m236lkwy62pwk526lhi271";
    };
    dependencies = [
      "faraday"
      "httpauth"
      "jwt"
      "multi_json"
      "rack"
    ];
  };
  "omniauth" = {
    version = "1.1.4";
    source = {
      type = "gem";
      sha256 = "1ggg6nrlbpj67q59s5lyrpi6lnwv6wp3y7y5njbqr6y5y7d34wfl";
    };
    dependencies = [
      "hashie"
      "rack"
    ];
  };
  "omniauth-github" = {
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "1hnsindjhy4ihgjl96iwlf26vdv7v2cikagpqpkv25nc97mipd4l";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-google-oauth2" = {
    version = "0.2.5";
    source = {
      type = "gem";
      sha256 = "1pgbc21y5kjna1ac2fwaaimv1a4a6wdpy6y5wmvrl6pr631s248w";
    };
    dependencies = [
      "omniauth"
      "omniauth-oauth2"
    ];
  };
  "omniauth-oauth" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "0ng7zcsfx0hv4yqwj80y1yc6wh5511p07lihaf9j7a3bzqqgn6wz";
    };
    dependencies = [
      "oauth"
      "omniauth"
    ];
  };
  "omniauth-oauth2" = {
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "0s7bhlbz9clg1qxjrrcssyp5kxry1zp0lhsfgw735m7ap5vvmf3j";
    };
    dependencies = [
      "oauth2"
      "omniauth"
    ];
  };
  "omniauth-shibboleth" = {
    version = "1.1.1";
    source = {
      type = "gem";
      sha256 = "0xljj8mpdbr243ddqcd3bmr2jc674lj9iv0v1z3rczg4q45jmadh";
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
  "org-ruby" = {
    version = "0.9.9";
    source = {
      type = "gem";
      sha256 = "1r978d8rsmln1jz44in6ll61ii84r81wb2mmic633h0agm62s9za";
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
  "pg" = {
    version = "0.15.1";
    source = {
      type = "gem";
      sha256 = "1lwyb542avqfav3814n5b3pssyih1ghzchs58vyzh5061r02fs5s";
    };
  };
  "phantomjs" = {
    version = "1.9.2.0";
    source = {
      type = "gem";
      sha256 = "0cvg8c9b85bhl00wg1fbkbr129sdxlh9gm61fqq3hal3c6sxbws2";
    };
  };
  "poltergeist" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "08va59swiyvppb020xy6k9sqpnf5s6rjm1ycsbkv2abp37080ifv";
    };
    dependencies = [
      "capybara"
      "cliver"
      "multi_json"
      "websocket-driver"
    ];
  };
  "polyglot" = {
    version = "0.3.4";
    source = {
      type = "gem";
      sha256 = "0jcnabyh7iirz78db1g713iyhshmw4j0nw7q6nbd67vfffgrsh05";
    };
  };
  "posix-spawn" = {
    version = "0.3.9";
    source = {
      type = "gem";
      sha256 = "042i1afggy1sv2jmdjjjhyffas28xp2r1ylj5xfv3hchy3b4civ3";
    };
  };
  "pry" = {
    version = "0.9.12.4";
    source = {
      type = "gem";
      sha256 = "0ndihrzirbfypf5pkqqcqhml6qpq66wbafkpc5jhjqjc6jc1llis";
    };
    dependencies = [
      "coderay"
      "method_source"
      "slop"
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
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "1a1gdaaglcpl583x9ma8la8cpls0lbc0l6qhv66dahia8ql8gg1z";
    };
    dependencies = [
      "railties"
    ];
  };
  "racc" = {
    version = "1.4.10";
    source = {
      type = "gem";
      sha256 = "10xm27dic2y8d53rw3yqw6jkdhrlgq11kbf5p8wiskiz28gzd0k2";
    };
  };
  "rack" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "19szfw76cscrzjldvw30jp3461zl00w4xvw1x9lsmyp86h1g0jp6";
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
    version = "2.3.0";
    source = {
      type = "gem";
      sha256 = "177l9q3gi5lypcxs7141mw62cmg4l20i84dzhvhcfz2blp8fa47r";
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
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "0js0s422j7qqjbr3zay48hw82m3z7ddf3qvwcp2m8yz1g438fxqw";
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
  "rack-protection" = {
    version = "1.5.1";
    source = {
      type = "gem";
      sha256 = "0qxq5ld15nljxzdcx2wmbc3chw8nb6la1ap838vf263lnjcpx3dd";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack-test" = {
    version = "0.6.2";
    source = {
      type = "gem";
      sha256 = "01mk715ab5qnqf6va8k3hjsvsmplrfqpz6g58qw4m3l8mim0p4ky";
    };
    dependencies = [
      "rack"
    ];
  };
  "rails" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "199agdsvidzk2g3zd50vkwnlr6gjk3s1qhligiik3rqr4ij7a8k0";
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
  "rails_autolink" = {
    version = "1.1.6";
    source = {
      type = "gem";
      sha256 = "0wanqb979j9zf60g6r6mdlsvrdmbj4ppc0clyi2dr98wwyz1fk1q";
    };
    dependencies = [
      "rails"
    ];
  };
  "rails_best_practices" = {
    version = "1.14.4";
    source = {
      type = "gem";
      sha256 = "14f6qwrzvk2dai56h32jg42z1h7hiphy6b01wwrnmzpwcgzp34w5";
    };
    dependencies = [
      "activesupport"
      "awesome_print"
      "code_analyzer"
      "colored"
      "erubis"
      "i18n"
      "require_all"
      "ruby-progressbar"
    ];
  };
  "railties" = {
    version = "4.1.1";
    source = {
      type = "gem";
      sha256 = "1rlfbwrcg1qzyv5972wjx3vj40i0k9vgn2zzqavgcha7smmpivqc";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "rake"
      "thor"
    ];
  };
  "raindrops" = {
    version = "0.12.0";
    source = {
      type = "gem";
      sha256 = "16k8gb6f6y368wqf7s8n0lcm8c2krkrpf3p2qixn7nfs2x0g4xr0";
    };
  };
  "rake" = {
    version = "10.3.2";
    source = {
      type = "gem";
      sha256 = "0nvpkjrpsk8xxnij2wd1cdn6arja9q11sxx4aq4fz18bc6fss15m";
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
    version = "0.9.3";
    source = {
      type = "gem";
      sha256 = "0bdnxwdxj4r1kdxfi5nszbsb126njrr81p912g64xxs2bgxd1bp1";
    };
  };
  "rb-inotify" = {
    version = "0.9.2";
    source = {
      type = "gem";
      sha256 = "0752fhgfrx370b2jnhxzs8sjv2l8yrnwqj337kx9v100igd1c7iv";
    };
    dependencies = [
      "ffi"
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
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "076p52lkns90hqs27rs4kns2bg7maz8qxr87bl34yd6in319flzz";
    };
  };
  "redis" = {
    version = "3.0.6";
    source = {
      type = "gem";
      sha256 = "1ha2h422rvbf0wk96bp7k0ibl0jyg7v101jsj7z0r7pvzcx21j73";
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
    version = "4.0.0";
    source = {
      type = "gem";
      sha256 = "18mlzjchj7sh1jm2icx2idf2hcir3agpd6i01q0gnf36f432v06d";
    };
    dependencies = [
      "activesupport"
      "redis-store"
    ];
  };
  "redis-namespace" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "0fb6i98mhfxn26bqr5vdzhfjyda36cpaxh0dgxynp1y3m301khf7";
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
    version = "1.1.4";
    source = {
      type = "gem";
      sha256 = "0ja2h1rdyjga8bqb02w3sk3a1m78dsfg96b842s6mkkbpifpxd4z";
    };
    dependencies = [
      "redis"
    ];
  };
  "ref" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "19qgpsfszwc2sfh6wixgky5agn831qq8ap854i1jqqhy1zsci3la";
    };
  };
  "request_store" = {
    version = "1.0.5";
    source = {
      type = "gem";
      sha256 = "1ky19wb6mpq6dxb81a0h4hnzx7a4ka99n9ay2syi68djbr4bkbbh";
    };
  };
  "require_all" = {
    version = "1.3.2";
    source = {
      type = "gem";
      sha256 = "16l08r6asr8nif6ah75w57i7y728132n8ns62rlrf78sh4lmfkhx";
    };
  };
  "rest-client" = {
    version = "1.6.7";
    source = {
      type = "gem";
      sha256 = "0nn7zalgidz2yj0iqh3xvzh626krm2al79dfiij19jdhp0rk8853";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "rinku" = {
    version = "1.7.3";
    source = {
      type = "gem";
      sha256 = "1jh6nys332brph55i6x6cil6swm086kxjw34wq131nl6mwryqp7b";
    };
  };
  "rouge" = {
    version = "1.3.3";
    source = {
      type = "gem";
      sha256 = "0l82xyfdpir2hdm94dw8hy01ngghhas1jm8r3lp3kvyw6z7ph4ml";
    };
  };
  "rspec" = {
    version = "2.14.1";
    source = {
      type = "gem";
      sha256 = "134y4wzk1prninb5a0bhxgm30kqfzl8dg06af4js5ylnhv2wd7sg";
    };
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "rspec-core" = {
    version = "2.14.7";
    source = {
      type = "gem";
      sha256 = "0j23ca2hkf0ac708afvi5nxjn75g0mani6m17if52bjrxcgn4577";
    };
  };
  "rspec-expectations" = {
    version = "2.14.4";
    source = {
      type = "gem";
      sha256 = "0figi31xg100yc90p04n16p1n8q9nlnqyncyl0f34mks8bc4zdrw";
    };
    dependencies = [
      "diff-lcs"
    ];
  };
  "rspec-mocks" = {
    version = "2.14.4";
    source = {
      type = "gem";
      sha256 = "12vbv0firjkxlinxgg81j6qnwq8mmz48y4iv3ml9j411vqav4ig7";
    };
  };
  "rspec-rails" = {
    version = "2.14.0";
    source = {
      type = "gem";
      sha256 = "1s9mszadqjmbcahyjgazygvkj8m7pzg7jpgx8m4wl0vxjxg3gr3f";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
  };
  "ruby-progressbar" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "16vxr5n8q87gvdc2px4vzjkasiadzi0c18ynqc8x61352hl5f9ll";
    };
  };
  "rubyntlm" = {
    version = "0.1.1";
    source = {
      type = "gem";
      sha256 = "0w48h3n8jzndqwmxxbj72j4gwma07f0x07ppsiv1qlygq2n9nyx0";
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
    version = "0.21.0";
    source = {
      type = "gem";
      sha256 = "0abmh5l1j7pp7vwq8vrqmgv07pc2wq0m97hm1sb0k0ghsx9yqdp5";
    };
  };
  "safe_yaml" = {
    version = "0.9.7";
    source = {
      type = "gem";
      sha256 = "0y34vpak8gim18rq02rgd144jsvk5is4xni16wm3shbhivzqb4hk";
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
    version = "4.0.3";
    source = {
      type = "gem";
      sha256 = "1j1f7zhn1ywkmgp5m1rdi7n404vd3j53wp9ngq9n7w33bzwnaxmm";
    };
    dependencies = [
      "railties"
      "sass"
      "sprockets"
      "sprockets-rails"
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
    version = "2.3.1";
    source = {
      type = "gem";
      sha256 = "1nw1pic6nxbqfwakykamaxm2rgz699yzwf1y64ms4ijgazmwy2gb";
    };
    dependencies = [
      "activerecord"
      "activesupport"
    ];
  };
  "select2-rails" = {
    version = "3.5.2";
    source = {
      type = "gem";
      sha256 = "0zlzkqr4xjd9k317wkw26m8nficp5cdf5ghl1h47ajgrj9pjvbnw";
    };
    dependencies = [
      "thor"
    ];
  };
  "semantic-ui-sass" = {
    version = "0.16.1.0";
    source = {
      type = "gem";
      sha256 = "18bivcl0a1pzd0sdxlnpwfb6fdai52f94kwzx68ky818mk1zgaal";
    };
    dependencies = [
      "sass"
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
    version = "4.4.0";
    source = {
      type = "gem";
      sha256 = "1rvbxsnjqy82mq0ah6jbmakhr18kfp47gls698pf3dcrvbdisnbi";
    };
  };
  "shoulda-matchers" = {
    version = "2.1.0";
    source = {
      type = "gem";
      sha256 = "1ilz8hsc8n8snd1q6l54mkrcm1zgvc3bxdrhinldz9bh17hyhk6s";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "sidekiq" = {
    version = "2.17.0";
    source = {
      type = "gem";
      sha256 = "0lqcl5b3x1k9m78ry2yl1vq6b4schxwcywqkwzl7cw8w642pxic1";
    };
    dependencies = [
      "celluloid"
      "connection_pool"
      "json"
      "redis"
      "redis-namespace"
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
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1dwyb1q6mn4cy76s9givrakf5x439jmvny46qpa0ywzkli95f82g";
    };
    dependencies = [
      "docile"
      "multi_json"
      "simplecov-html"
    ];
  };
  "simplecov-html" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0jhn3jql73x7hsr00wwv984iyrcg0xhf64s90zaqv2f26blkqfb9";
    };
  };
  "sinatra" = {
    version = "1.4.4";
    source = {
      type = "gem";
      sha256 = "12iy0f92d3zyk4759flgcracrbzc3x6cilpgdkzhzgjrsm9aa5hs";
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
    version = "0.3.2";
    source = {
      type = "gem";
      sha256 = "0126im7nm7qw03xgls5qmbldls94yjgv8fzhrnqy7140a51n65k4";
    };
  };
  "slim" = {
    version = "2.0.2";
    source = {
      type = "gem";
      sha256 = "1sm78ai5xvqqh7zpv6c2c4iy2lakmrqfmmnyr5ha768vjxzzdk87";
    };
    dependencies = [
      "temple"
      "tilt"
    ];
  };
  "slop" = {
    version = "3.4.7";
    source = {
      type = "gem";
      sha256 = "1x3dwljqvkzj314rwn2bxgim9xvgwnfipzg5g0kwwxfn90fpv2sn";
    };
  };
  "spinach" = {
    version = "0.8.7";
    source = {
      type = "gem";
      sha256 = "036zrwf31iq5fh2qgins51nh9756aqyz4almznq2p36yfylihdx4";
    };
    dependencies = [
      "colorize"
      "gherkin-ruby"
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
    version = "1.1.3";
    source = {
      type = "gem";
      sha256 = "1ibj1d1490wys76ng4g7q8q2rglh37yqxkz2c3vv087cizr8ralj";
    };
  };
  "spring-commands-rspec" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "1z6ghbyndpaz9pm6mw97jpgc1zvz79y3ijidji3z4ygx98imxmv1";
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
  "sprockets" = {
    version = "2.11.0";
    source = {
      type = "gem";
      sha256 = "082rrn7nsy18ky095zm6a9b4zfbikf60gaakplyqmkjclxk4lsmh";
    };
    dependencies = [
      "hike"
      "multi_json"
      "rack"
      "tilt"
    ];
  };
  "sprockets-rails" = {
    version = "2.1.3";
    source = {
      type = "gem";
      sha256 = "12kdy9vjn3ygrxhn9jxxx0rvsq601vayrkgbr3rqcpyhqhl4s4wy";
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
    version = "2.5.1";
    source = {
      type = "gem";
      sha256 = "178ppbdm70hzadrgq55q83c3hwv6b7wixacg9kk4v6cxnns5dmfv";
    };
  };
  "temple" = {
    version = "0.6.7";
    source = {
      type = "gem";
      sha256 = "09makksvllkzrm0vfb91xm46pq5qdp2c04cqid9i2immqcwz6x1k";
    };
  };
  "term-ansicolor" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1b41q1q6mqcgzq9fhzhmjvfg5sfs5v7gkb8z57r4hajcp89lflxr";
    };
    dependencies = [
      "tins"
    ];
  };
  "test_after_commit" = {
    version = "0.2.2";
    source = {
      type = "gem";
      sha256 = "13zsag1lbkabwkaxbwhf06d4za5r4nb0fam95rqnx3yxnyshkq4b";
    };
  };
  "therubyracer" = {
    version = "0.12.0";
    source = {
      type = "gem";
      sha256 = "185k2kvn2q9xznrij3swf9xp3d13h3hdc4w4ldhbrjkg7k1139q6";
    };
    dependencies = [
      "libv8"
      "ref"
    ];
  };
  "thin" = {
    version = "1.6.1";
    source = {
      type = "gem";
      sha256 = "065xsmjb7s0gfhx0zhh6wpjxvq26n6d7vq479df9llnk68b0xf50";
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
    version = "0.3.4";
    source = {
      type = "gem";
      sha256 = "1cil2zcdzqkyr8zrwhlg7gywryg36j4mxlxw0h0x0j0wjym5nc8n";
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
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0x3vnkxy3bg9f6v1nhkfqkajr19glrzkmqd5a1wy8hrylx8rdfrv";
    };
  };
  "tinder" = {
    version = "1.9.3";
    source = {
      type = "gem";
      sha256 = "0ixxyrlr1ynj9bki515byqg7j45vkvfm4s49n614whpdf8mgs1hb";
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
    version = "0.13.1";
    source = {
      type = "gem";
      sha256 = "0c7gqgj7z1frab4r9i8dbf111l3jyd44npraz8fdds1b8qvz4fy5";
    };
  };
  "treetop" = {
    version = "1.4.15";
    source = {
      type = "gem";
      sha256 = "1zqj5y0mvfvyz11nhsb4d5ch0i0rfcyj64qx19mw4qhg3hh8z9pz";
    };
    dependencies = [
      "polyglot"
      "polyglot"
    ];
  };
  "turbolinks" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "1zz8ff6v1chsv1clixapcmw1w62pqa1xlxlvlgxasvkscbqxhbyr";
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
    version = "2.3.2";
    source = {
      type = "gem";
      sha256 = "1w5cc90wzs4jdpvfrhqjgf4gwsg517cwz15a31p4z7hxs412z52y";
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
    version = "0.0.6";
    source = {
      type = "gem";
      sha256 = "07zbmkzcid6pzdqgla3456ipfdka7j1v4hsx1iaa8rbnllqbmkdg";
    };
  };
  "unicorn" = {
    version = "4.6.3";
    source = {
      type = "gem";
      sha256 = "0rj9lwqwaklyk5vy0lqj4x7fcqb027j240waya5zvb14i8a142zx";
    };
    dependencies = [
      "kgio"
      "rack"
      "raindrops"
    ];
  };
  "unicorn-worker-killer" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "12y7lsqyfca9dxy387hfx4c3xjd22sj4b9xxrmdzcksighs1ja3d";
    };
    dependencies = [
      "unicorn"
    ];
  };
  "version_sorter" = {
    version = "1.1.0";
    source = {
      type = "gem";
      sha256 = "0wvqjkj0z5yi29f6907f1jzfszq8zgrq74mapmmi9csgvqkybsmf";
    };
  };
  "virtus" = {
    version = "1.0.1";
    source = {
      type = "gem";
      sha256 = "19j4ssjxn4ag8i08v4andlz1rnhd2dwfxh2qn2a3hq3s6xjivn03";
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
    version = "1.16.0";
    source = {
      type = "gem";
      sha256 = "1y2pm64qah6n9c203c90vlw8jkvbjv703y8qr2z6ikwblp8cxs49";
    };
    dependencies = [
      "addressable"
      "crack"
    ];
  };
  "websocket-driver" = {
    version = "0.3.3";
    source = {
      type = "gem";
      sha256 = "0f3nx6yfd7q8xz78zfc3zbkj2rwfm4ri9viqjy1dmnkhwg0h96jf";
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