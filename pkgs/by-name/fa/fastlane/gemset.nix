{
  abbrev = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hj2qyx7rzpc7awhvqlm597x7qdxwi4kkml4aqnp5jylmsm4w6xd";
      type = "gem";
    };
    version = "0.1.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    version = "2.8.8";
  };
  artifactory = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qzj389l2a3zig040h882mf6cxfa71pm2nk51l4p85n3ck4xa8rh";
      type = "gem";
    };
    version = "3.0.17";
  };
  atomos = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17vq6sjyswr5jfzwdccw748kgph6bdw30bakwnn6p8sl4hpv4hvx";
      type = "gem";
    };
    version = "0.1.3";
  };
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fqqdqg15rgwgz3mn4pj91agd20csk9gbrhi103d20328dfghsqi";
      type = "gem";
    };
    version = "1.4.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04887dhff1nw3pwrfxmqwl0mwd1dzmxfdvjgn6f6n9pl6mbwdinw";
      type = "gem";
    };
    version = "1.1194.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "base64"
      "bigdecimal"
      "jmespath"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fgjki9wja72m5ip1dq5zx8msn1sdw9qid4z7wd0dnqbxr2ii056";
      type = "gem";
    };
    version = "3.239.2";
  };
  aws-sdk-kms = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gbgf7xgg2hrrc51g3mpf0isba801w0r0z45mjnh45agdmcm3iy9";
      type = "gem";
    };
    version = "1.118.0";
  };
  aws-sdk-s3 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sdk-kms"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v9as5bvkxk5nqfbchram8v7rsimnpp0v8wxcp20bwdw3dlf9yc5";
      type = "gem";
    };
    version = "1.206.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "003ch8qzh3mppsxch83ns0jra8d222ahxs96p9cdrl0grfazywv9";
      type = "gem";
    };
    version = "1.12.1";
  };
  babosa = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16dwqn33kmxkqkv51cwiikdkbrdjfsymlnc0rgbjwilmym8a9phq";
      type = "gem";
    };
    version = "1.0.4";
  };
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qml0yilb9basf7is2614skjp8384h2pycfx86cr8023arfj98g";
      type = "gem";
    };
    version = "0.2.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0612spks81fvpv2zrrv3371lbs6mwd7w6g5zafglyk75ici1x87a";
      type = "gem";
    };
    version = "3.3.1";
  };
  CFPropertyList = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qa226xndfs9r6c7qj7zs6yhzrcbmicvvxsjn9x3svakh3cx169c";
      type = "gem";
    };
    version = "3.0.8";
  };
  claide = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bpqhc0kqjp1bh9b7ffc395l9gfls0337rrhmab4v46ykl45qg3d";
      type = "gem";
    };
    version = "1.1.0";
  };
  colored = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
      type = "gem";
    };
    version = "1.2";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jlbqa9q4mvrm73aw9mxh23ygzbjiqwisl32d8szfb5fxvbjng5i";
      type = "gem";
    };
    version = "3.1.2";
  };
  commander = {
    dependencies = [ "highline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n8k547hqq9hvbyqbx2qi08g0bky20bbjca1df8cqq5frhzxq7bx";
      type = "gem";
    };
    version = "4.6.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    version = "3.3.5";
  };
  declarative = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yczgnqrbls7shrg63y88g7wand2yp9h6sf56c9bdcksn5nds8c0";
      type = "gem";
    };
    version = "0.0.20";
  };
  digest-crc = {
    dependencies = [ "rake" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01wcsyhaadss4zzvqh12kvbq3hmkl5y4fck7pr608hd24qxc5bb4";
      type = "gem";
    };
    version = "0.7.0";
  };
  domain_name = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cyr2xm576gqhqicsyqnhanni47408w2pgvrfi8pd13h2li3nsaz";
      type = "gem";
    };
    version = "0.6.20240107";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1n0pi8x8ql5h1mijvm8lgn6bhq4xjb5a500p5r1krq4s6j9lg565";
      type = "gem";
    };
    version = "2.8.1";
  };
  emoji_regex = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jsnrkfy345v66jlm2xrz8znivfnamg3mfzkddn414bndf2vxn7c";
      type = "gem";
    };
    version = "3.2.3";
  };
  excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1w7098hnyby5sn2315qy26as6kxlxivxlcrs714amj9g9hxaryfs";
      type = "gem";
    };
    version = "0.112.0";
  };
  faraday = {
    dependencies = [
      "faraday-em_http"
      "faraday-em_synchrony"
      "faraday-excon"
      "faraday-httpclient"
      "faraday-multipart"
      "faraday-net_http"
      "faraday-net_http_persistent"
      "faraday-patron"
      "faraday-rack"
      "faraday-retry"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "069gmdh5j90v06rbwlqvlhzhq45lxhx74mahz25xd276rm0wb153";
      type = "gem";
    };
    version = "1.10.4";
  };
  faraday-cookie_jar = {
    dependencies = [
      "faraday"
      "http-cookie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fwx5720g33w3zycyq636m4fbn5fd94fxk4g0b3n7k7q4dc60h01";
      type = "gem";
    };
    version = "0.0.8";
  };
  faraday-em_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12cnqpbak4vhikrh2cdn94assh3yxza8rq2p9w2j34bqg5q4qgbs";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l0pz1wk2mk6p6hbfd86jfad59jyk201y1db379qhc2lrxfy8g5z";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h09wkb0k0bhm6dqsd47ac601qiaah8qdzjh8gvxfd376x1chmdh";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fyk0jd3ks7fdn8nv3spnwjpzx2lmxmg2gh4inz3by1zjzqg33sc";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00w9imp55hi81q0wsgwak90ldkk7gbyb8nzmmv8hy0s907s8z8bp";
      type = "gem";
    };
    version = "1.1.1";
  };
  faraday-net_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10n6wikd442mfm15hd6gzm0qb527161w1wwch4h5m4iclkz2x6b3";
      type = "gem";
    };
    version = "1.0.2";
  };
  faraday-net_http_persistent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dc36ih95qw3rlccffcb0vgxjhmipsvxhn6cw71l7ffs0f7vq30b";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19wgsgfq0xkski1g7m96snv39la3zxz6x7nbdgiwhg5v82rxfb6w";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h184g4vqql5jv9s9im6igy00jp6mrah2h14py6mpf9bkabfqq7g";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "153i967yrwnswqgvnnajgwp981k9p50ys1h80yz3q94rygs59ldd";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s990pnapb3vci9c00bklqc7jjix4i2zhxn2zf1lfk46xv47hnyl";
      type = "gem";
    };
    version = "1.2.1";
  };
  fastimage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1s67b9n7ki3iaycypq8sh02377gjkaxadg4dq53bpgfk4xg3gkjz";
      type = "gem";
    };
    version = "2.4.0";
  };
  fastlane = {
    dependencies = [
      "CFPropertyList"
      "abbrev"
      "addressable"
      "artifactory"
      "aws-sdk-s3"
      "babosa"
      "base64"
      "colored"
      "commander"
      "csv"
      "dotenv"
      "emoji_regex"
      "excon"
      "faraday"
      "faraday-cookie_jar"
      "faraday_middleware"
      "fastimage"
      "fastlane-sirp"
      "gh_inspector"
      "google-apis-androidpublisher_v3"
      "google-apis-playcustomapp_v1"
      "google-cloud-env"
      "google-cloud-storage"
      "highline"
      "http-cookie"
      "json"
      "jwt"
      "mini_magick"
      "multipart-post"
      "mutex_m"
      "naturally"
      "nkf"
      "optparse"
      "plist"
      "rubyzip"
      "security"
      "simctl"
      "terminal-notifier"
      "terminal-table"
      "tty-screen"
      "tty-spinner"
      "word_wrap"
      "xcodeproj"
      "xcpretty"
      "xcpretty-travis-formatter"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08q875hq41yvw44n55lsjz41pfawys85c4ws9swg5jwx7hf8rv3z";
      type = "gem";
    };
    version = "2.229.1";
  };
  fastlane-sirp = {
    dependencies = [ "sysrandom" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hg6ql3g25f96fsmwr9xlxpn8afa7wvjampnrh1fqffhphjqyiv6";
      type = "gem";
    };
    version = "1.0.0";
  };
  gh_inspector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f8r9byajj3bi2c7c5sqrc7m0zrv3nblfcd4782lw5l73cbsgk04";
      type = "gem";
    };
    version = "1.1.3";
  };
  google-apis-androidpublisher_v3 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "046j100lrh5dhb8p3gr38fyqrw8vcif97pqb55ysipy874lafw49";
      type = "gem";
    };
    version = "0.54.0";
  };
  google-apis-core = {
    dependencies = [
      "addressable"
      "googleauth"
      "httpclient"
      "mini_mime"
      "representable"
      "retriable"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15ycm7al9dizabbqmri5xmiz8mbcci343ygb64ndbmr9n49p08a3";
      type = "gem";
    };
    version = "0.11.3";
  };
  google-apis-iamcredentials_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ysil0bkh755kmf9xvw5szhk1yyh3gqzwfsrbwsrl77gsv7jarcs";
      type = "gem";
    };
    version = "0.17.0";
  };
  google-apis-playcustomapp_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mlgwiid5lgg41y7qk8ca9lzhwx5njs25hz5fbf1mdal0kwm37lm";
      type = "gem";
    };
    version = "0.13.0";
  };
  google-apis-storage_v1 = {
    dependencies = [ "google-apis-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13yvc9r8bhs16vq3fjc93qlffmq9p6zx97c9g1c3wh0jbrvwrs03";
      type = "gem";
    };
    version = "0.31.0";
  };
  google-cloud-core = {
    dependencies = [
      "google-cloud-env"
      "google-cloud-errors"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kw10897ardky1chwwsb8milygzcdi8qlqlhcnqwmkw9y75yswp5";
      type = "gem";
    };
    version = "1.8.0";
  };
  google-cloud-env = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05gshdqscg4kil6ppfzmikyavsx449bxyj47j33r4n4p8swsqyb1";
      type = "gem";
    };
    version = "1.6.0";
  };
  google-cloud-errors = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvv9w8s4dqc4ncfa6c6qpdypz2wj8dmgpjd44jq2qhhij5y4sxm";
      type = "gem";
    };
    version = "1.5.0";
  };
  google-cloud-storage = {
    dependencies = [
      "addressable"
      "digest-crc"
      "google-apis-iamcredentials_v1"
      "google-apis-storage_v1"
      "google-cloud-core"
      "googleauth"
      "mini_mime"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xpb3s7zr7g647xg66y2mavdargk5ixsfbfdmi4m2jc3khdd0hxm";
      type = "gem";
    };
    version = "1.47.0";
  };
  googleauth = {
    dependencies = [
      "faraday"
      "jwt"
      "multi_json"
      "os"
      "signet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ry9v23kndgx2pxq9v31l68k9lnnrcz1w4v75bkxq88jmbddljl1";
      type = "gem";
    };
    version = "1.8.1";
  };
  highline = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yclf57n2j3cw8144ania99h1zinf8q3f5zrhqa754j6gl95rp9d";
      type = "gem";
    };
    version = "2.0.3";
  };
  http-cookie = {
    dependencies = [ "domain_name" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19hsskzk5zpv14mnf07pq71hfk1fsjwfjcw616pgjjzjbi2f0kxi";
      type = "gem";
    };
    version = "1.0.8";
  };
  httpclient = {
    dependencies = [ "mutex_m" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j4qwj1nv66v3n9s4xqf64x2galvjm630bwa5xngicllwic5jr2b";
      type = "gem";
    };
    version = "2.9.0";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cdw9vw2qly7q7r41s7phnac264rbsdqgj4l0h4nqgbjb157g393";
      type = "gem";
    };
    version = "1.6.2";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01fmiz052cvnxgdnhb3qwcy88xbv7l3liz0fkvs5qgqqwjp0c1di";
      type = "gem";
    };
    version = "2.18.0";
  };
  jwt = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x64l31nkqjwfv51s2vsm0yqq4cwzrlnji12wvaq761myx3fxq9i";
      type = "gem";
    };
    version = "2.10.2";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  mini_magick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nfxjpmka12ihbwd87d5k2hh7d2pv3aq95x0l2lh8gca1s72bmki";
      type = "gem";
    };
    version = "4.13.2";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vycif7pjzkr29mfk4dlqv3disc5dn0va04lkwajlpr1wkibg0c6";
      type = "gem";
    };
    version = "1.1.5";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vsrfm36zlg7jbrd1fjbr8kmdvr8bfayrw0hdlza75987vvhrxr3";
      type = "gem";
    };
    version = "1.18.0";
  };
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a5lrlvmg2kb2dhw3lxcsv6x276bwgsxpnka1752082miqxd0wlq";
      type = "gem";
    };
    version = "2.4.1";
  };
  mutex_m = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l875dw0lk7b2ywa54l0wjcggs94vb7gs8khfw9li75n2sn09jyg";
      type = "gem";
    };
    version = "0.3.0";
  };
  nanaimo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08q73nchv8cpk28h1sdnf5z6a862fcf4mxy1d58z25xb3dankw7s";
      type = "gem";
    };
    version = "0.4.0";
  };
  naturally = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00cy2wg40rsasnbl0cjcj3jcghq068v445rh90q63rn2fv7j76a5";
      type = "gem";
    };
    version = "2.3.0";
  };
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09piyp2pd74klb9wcn0zw4mb5l0k9wzwppxggxi1yi95l2ym3hgv";
      type = "gem";
    };
    version = "0.2.0";
  };
  optparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06mx0g76bqwyrv8hxdikhyziyq8x8j8rk9l0y3scyz4hac6s3gj2";
      type = "gem";
    };
    version = "0.8.1";
  };
  os = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hlaf4b3d8grxm9fqbnam5gwd55wvghl0jyzjd1hc5hirhklaynk";
      type = "gem";
    };
    version = "3.7.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15dhl6k4gbax0xz8frfs4nsb6lg5zgax9vkr1pqzjmhfxddhn2gp";
      type = "gem";
    };
    version = "7.0.0";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "175iisqb211n0qbfyqd8jz2g01q6xj038zjf4q0nm8k6kz88k7lc";
      type = "gem";
    };
    version = "13.3.1";
  };
  representable = {
    dependencies = [
      "declarative"
      "trailblazer-option"
      "uber"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kms3r6w6pnryysnaqqa9fsn0v73zx1ilds9d1c565n3xdzbyafc";
      type = "gem";
    };
    version = "3.2.0";
  };
  retriable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q48hqws2dy1vws9schc0kmina40gy7sn5qsndpsfqdslh65snha";
      type = "gem";
    };
    version = "3.1.2";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "080fswzii68wnbsg7pgq55ba7p289sqjlxwp4vch0h32qy1f8v8d";
      type = "gem";
    };
    version = "3.28.0";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05an0wz87vkmqwcwyh5rjiaavydfn5f4q1lixcsqkphzvj7chxw5";
      type = "gem";
    };
    version = "2.4.1";
  };
  security = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1drkm2wgjazwzj09db1szrllkag036bdvc3dr42fh1kpr877m5rs";
      type = "gem";
    };
    version = "0.1.5";
  };
  signet = {
    dependencies = [
      "addressable"
      "faraday"
      "jwt"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nydm087m5c3j85gvzvz30w1qb9pl2lzpznw746jha29ybxyj5yn";
      type = "gem";
    };
    version = "0.21.0";
  };
  simctl = {
    dependencies = [
      "CFPropertyList"
      "naturally"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sr3z4kmp6ym7synicyilj9vic7i9nxgaszqx6n1xn1ss7s7g45r";
      type = "gem";
    };
    version = "1.6.10";
  };
  sysrandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x8yryf6migjnkfwr8dxgx1qyzhvajgha60hr5mgfkn65qyarhas";
      type = "gem";
    };
    version = "1.0.5";
  };
  terminal-notifier = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1slc0y8pjpw30hy21v8ypafi8r7z9jlj4bjbgz03b65b28i2n3bs";
      type = "gem";
    };
    version = "2.0.0";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14dfmfjppmng5hwj7c5ka6qdapawm3h6k9lhn8zj001ybypvclgr";
      type = "gem";
    };
    version = "3.0.2";
  };
  trailblazer-option = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18s48fndi2kfvrfzmq6rxvjfwad347548yby0341ixz1lhpg3r10";
      type = "gem";
    };
    version = "0.1.2";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j5zw041jgkmn605ya1zc151bxgxl6v192v2i26qhxx7ws2l2lvr";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0l4vh6g333jxm9lakilkva2gn17j6gb052626r1pdbmy2lhnb460";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-spinner = {
    dependencies = [ "tty-cursor" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hh5awmijnzw9flmh5ak610x1d00xiqagxa5mbr63ysggc26y0qf";
      type = "gem";
    };
    version = "0.9.3";
  };
  uber = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p1mm7mngg40x05z52md3mbamkng0zpajbzqjjwmsyw0zw3v9vjv";
      type = "gem";
    };
    version = "0.1.0";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nkz7fadlrdbkf37m0x7sw8bnz8r355q3vwcfb9f9md6pds9h9qj";
      type = "gem";
    };
    version = "2.6.0";
  };
  word_wrap = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1iyc5bc7dbgsd8j3yk1i99ral39f23l6wapi0083fbl19hid8mpm";
      type = "gem";
    };
    version = "1.0.0";
  };
  xcodeproj = {
    dependencies = [
      "CFPropertyList"
      "atomos"
      "claide"
      "colored2"
      "nanaimo"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lslz1kfb8jnd1ilgg02qx0p0y6yiq8wwk84mgg2ghh58lxsgiwc";
      type = "gem";
    };
    version = "1.27.0";
  };
  xcpretty = {
    dependencies = [ "rouge" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14iqgwrdfzc00b3dc5pal4gm9n7w5hn3wdgmsvirwn7n47km0k5i";
      type = "gem";
    };
    version = "0.4.1";
  };
  xcpretty-travis-formatter = {
    dependencies = [ "xcpretty" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14rg4f70klrs910n7rsgfa4dn8s2qyny55194ax2qyyb2wpk7k5a";
      type = "gem";
    };
    version = "1.0.1";
  };
}
