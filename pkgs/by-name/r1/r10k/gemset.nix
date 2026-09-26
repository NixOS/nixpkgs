{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0drbrv5m3l3qpal7s87gvss81cbzl76gad1hqkpqfqlphf0h7qb3";
      type = "gem";
    };
    version = "4.0.3";
  };
  cri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rank6i9p2drwdcmhan6ifkzrz1v3mwpx47fwjl75rskxwjfkgwa";
      type = "gem";
    };
    version = "2.15.12";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1naaxsqkv5b3vklab5sbb9sdpszrjzlfsbqpy7ncbnw510xi10m0";
      type = "gem";
    };
    version = "1.13.1";
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
      sha256 = "077n5ss3z3ds4vj54w201kd12smai853dp9c9n7ii7g3q7nwwg54";
      type = "gem";
    };
    version = "2.14.1";
  };
  faraday-follow_redirects = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nfmmnmqgbxci7dlca0qnwxn8j29yv7v8wm26m0f4l0kmcc13ynk";
      type = "gem";
    };
    version = "0.4.0";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v4hfmc7d4lrqqj2wl366rm9551gd08zkv2ppwwnjlnkc217aizi";
      type = "gem";
    };
    version = "3.4.2";
  };
  fast_gettext = {
    dependencies = [ "prime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gsz2ywvnms7b4w7bs4dg7cykhgx7z74fa7xy0sbw45a0v2c89px";
      type = "gem";
    };
    version = "2.4.0";
  };
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f78rjpnhm4lgp1qzadnr6kr02b6afh1lvy7w607k4qjk3641kgi";
      type = "gem";
    };
    version = "1.4.0";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0aji3873pxn6gc5qkvnv5y9025mqk0p6h22yrpyz2b3yx9qpzv03";
      type = "gem";
    };
    version = "3.5.1";
  };
  gettext-setup = {
    dependencies = [
      "fast_gettext"
      "gettext"
      "locale"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1v6liz934gmx1wv1z6bvpim6aanbr66xjhb90lc9z1jxayczmm1a";
      type = "gem";
    };
    version = "1.1.0";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11prr7nrxh1y4rfsqa51gy4ixx63r18cz9mdnmk0938va1ajf4gy";
      type = "gem";
    };
    version = "2.18.1";
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
  locale = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "107pm4ccmla23z963kyjldgngfigvchnv85wr6m69viyxxrrjbsj";
      type = "gem";
    };
    version = "2.1.4";
  };
  log4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ri90q0frfmigkirqv5ihyrj59xm8pq5zcmf156cbdv4r4l2jicv";
      type = "gem";
    };
    version = "1.1.10";
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
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gm2ksf678gr5cqr4a3mzx0zvwrc7z2qvkfd8rwh209qdzxhrnrq";
      type = "gem";
    };
    version = "1.1.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1drisvysgvnjlz49a0qcbs294id6mvj3i8iik5rvym68ybwfzvvs";
      type = "gem";
    };
    version = "1.19.1";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15k96fj6qwbaiv6g52l538ass95ds1qwgynqdridz29yqrkhpfi5";
      type = "gem";
    };
    version = "0.9.1";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pi2g9sd9ssyrpvbybh4skrgzqrv0rrd1q7ylgrsd519gjzmwxad";
      type = "gem";
    };
    version = "0.1.4";
  };
  puppet_forge = {
    dependencies = [
      "base64"
      "faraday"
      "faraday-follow_redirects"
      "minitar"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jvncdjxz6337m2mljj6f15l6i9vln023x9q17gnl4zhh8rfigz3";
      type = "gem";
    };
    version = "6.1.0";
  };
  r10k = {
    dependencies = [
      "colored2"
      "cri"
      "gettext-setup"
      "jwt"
      "log4r"
      "minitar"
      "multi_json"
      "puppet_forge"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cz8hf6bsgax7h8rs30p1ys5n9d58w978frh0dmwbka7hhmlxqj8";
      type = "gem";
    };
    version = "5.0.2";
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
  semantic_puppet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15ksbizvakfx0zfdgjbh34hqnrnkjj47m4kbnsg58mpqsx45pzqm";
      type = "gem";
    };
    version = "1.1.1";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y2pc7lr979pab5n5lvk3jhsi99fhskl5f2s6004v8sabz51psl3";
      type = "gem";
    };
    version = "0.3.0";
  };
  text = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ijpbj7mdrq7rhpq2kb51yykhrs2s54wfs6sm9z3icgz4y6sb7rp";
      type = "gem";
    };
    version = "1.1.1";
  };
}
