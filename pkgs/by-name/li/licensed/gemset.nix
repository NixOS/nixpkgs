{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cl2qpvwiffym62z991ynks7imsm87qmgxf0yfsmlwzkgi9qcaa6";
      type = "gem";
    };
    version = "2.8.7";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kfqg0m6vqs6c67296f10cr07im5mffj90k2b5dsm51liidcsvp9";
      type = "gem";
    };
    version = "3.3.4";
  };
  dotenv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hwjsddv666wpp42bip3fqx7c5qq6s8lwf74dj71yn7d1h37c4cy";
      type = "gem";
    };
    version = "3.1.8";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xbv450qj2bx0qz9l2pjrd3kc057y6bglc3na7a78zby8ssiwlyc";
      type = "gem";
    };
    version = "2.13.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jp5ci6g40d6i50bsywp35l97nc2fpi9a592r2cibwicdb6y9wd1";
      type = "gem";
    };
    version = "3.4.0";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x5b8ipv6g0z44wgc45039k04smsyf95h2m5m67mqq35sa5a955s";
      type = "gem";
    };
    version = "2.12.2";
  };
  licensed = {
    dependencies = [
      "csv"
      "json"
      "licensee"
      "parallel"
      "pathname-common_prefix"
      "reverse_markdown"
      "ruby-xxHash"
      "thor"
      "tomlrb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hf1c8mn1l3qw28jrmkw7vzm3n0f03f5y2kmmrriiki3j12bb8f0";
      type = "gem";
    };
    version = "5.0.4";
  };
  licensee = {
    dependencies = [
      "dotenv"
      "octokit"
      "reverse_markdown"
      "rugged"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xyzk7gzi91l6xlwfvf2z0963jwd2csf987yk0ffbr5p9ycdp0ry";
      type = "gem";
    };
    version = "9.18.0";
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
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ysrwaabhf0sn24jrp0nnp51cdv0jf688mh5i6fsz63q2c6b48cn";
      type = "gem";
    };
    version = "0.6.0";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rb306hbky6cxfyc8vrwpvl40fdapjvhsk62h08gg9wwbn3n8x4c";
      type = "gem";
    };
    version = "1.18.8";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05j3gz79gxkid3lc2balyllqik4v4swnm0rcvxz14m76bkrpz92g";
      type = "gem";
    };
    version = "9.2.0";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  pathname-common_prefix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "034gjbcqrf940199k28kfqbs4dwwf4slah7l9qj0n9wk4vj8bjfk";
      type = "gem";
    };
    version = "0.0.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1543ap9w3ydhx39ljcd675cdz9cr948x9mp00ab8qvq6118wv9xz";
      type = "gem";
    };
    version = "6.0.2";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "195c7yra7amggqj7rir0yr09r4v29c2hgkbkb21mj0jsfs3868mb";
      type = "gem";
    };
    version = "3.0.0";
  };
  ruby-xxHash = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1106y8dvfsrvg7ph4kagbzsd2pbm4fsggv7amcrbrl0vxh2q6790";
      type = "gem";
    };
    version = "0.4.0.2";
  };
  rugged = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b7gcf6pxg4x607bica68dbz22b4kch33yi0ils6x3c8ql9akakz";
      type = "gem";
    };
    version = "1.9.0";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jks1qjbmqm8f9kvwa81vqj39avaj9wdnzc531xm29a55bb74fps";
      type = "gem";
    };
    version = "0.9.2";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nmymd86a0vb39pzj2cwv57avdrl6pl3lf5bsz58q594kqxjkw7f";
      type = "gem";
    };
    version = "1.3.2";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xyl2nlfm39lklyaf0p7zj9psr60jvrlyfh26hrpk7wi4k7nlwy2";
      type = "gem";
    };
    version = "2.0.3";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04bhfvc25b07jaiaf62yrach7khhr5jlr5bx6nygg8pf11329wp9";
      type = "gem";
    };
    version = "1.0.3";
  };
}
