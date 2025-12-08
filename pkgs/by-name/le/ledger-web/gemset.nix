{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1gbg3i823vky26mf63wfr69035bv451nmha8cb8cwcz3p6b28zlb";
      type = "gem";
    };
    version = "8.1.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05rxrcfsp06ljhm149xwhfm9bjgd3g150hgbk0s81zb4wc1klb73";
      type = "gem";
    };
    version = "8.1.1";
  };
  activesupport = {
    dependencies = [
      "base64"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "json"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rzadiafj8llldqry9jjnzbw2rgavdlrqy0nddg8p2qcim7574jy";
      type = "gem";
    };
    version = "8.1.1";
  };
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
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ipbrgvf0pp6zxdk5ascp6i29aybz2bx9wdrlchjmpx6mhvkwfw1";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b8nlxr5z843ii7hfk6igpr5acw3k2ih9yjrgkyz2gbmallgjkz5";
      type = "gem";
    };
    version = "2.5.5";
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
  database_cleaner = {
    dependencies = [ "database_cleaner-active_record" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kc9bp3415p1m94d54y2pjjlsx546q0w3fn65xlxlxhm7dpa5jqx";
      type = "gem";
    };
    version = "2.1.0";
  };
  database_cleaner-active_record = {
    dependencies = [
      "activerecord"
      "database_cleaner-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1203q6zdw14vwmnr2hw0d6b1rdz4d07w3kjg1my1zhw862gnnac8";
      type = "gem";
    };
    version = "2.2.2";
  };
  database_cleaner-core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v44bn386ipjjh4m2kl53dal8g4d41xajn2jggnmjbhn6965fil6";
      type = "gem";
    };
    version = "2.0.1";
  };
  diff-lcs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qlrj2qyysc9avzlr4zs1py3x684hqm61n4czrsk1pyllz5x5q4s";
      type = "gem";
    };
    version = "1.6.2";
  };
  directory_watcher = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fwc2shba7vks262ind74y3g76qp7znjq5q8b2dvza0yidgywhcq";
      type = "gem";
    };
    version = "1.5.1";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wrkl7yiix268s2md1h6wh91311w95ikd8fy8m5gx589npyxc00b";
      type = "gem";
    };
    version = "2.2.3";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03sx3ahz1v5kbqjwxj48msw3maplpp2iyzs22l4jrzrqh4zmgfnf";
      type = "gem";
    };
    version = "1.14.7";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "098m3q2jrx4xbf0knrbmflsynmmb5x9q9b0bzpmj7jmm1cr30mna";
      type = "gem";
    };
    version = "2.16.0";
  };
  ledger_web = {
    dependencies = [
      "database_cleaner"
      "directory_watcher"
      "pg"
      "rack"
      "rspec"
      "sequel"
      "sinatra"
      "sinatra-contrib"
      "sinatra-session"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i4vagaiyayymlr41rsy4lg2cl1r011ib0ql9dgjadfy6imb4kqh";
      type = "gem";
    };
    version = "1.5.2";
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
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qyda32pf9jivaw2m7yymxshqxxd0fhjn7zpbagvmfc5c65128gh";
      type = "gem";
    };
    version = "5.26.2";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06sabsvnw0x1aqdcswc6bqrqz6705548bfd8z22jxgxfjrn1yn3n";
      type = "gem";
    };
    version = "1.17.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08ma2fmxlm6i7lih4mc3har2fzsbj1pl4hhva65kljf6nfvdryl5";
      type = "gem";
    };
    version = "3.0.4";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xf8i58shwvwlka4ld12nxcgqv0d5r1yizsvw74w5jaw83yllqaq";
      type = "gem";
    };
    version = "1.6.2";
  };
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1xmnrk076sqymilydqgyzhkma3hgqhcv8xhy7ks479l2a3vvcx2x";
      type = "gem";
    };
    version = "3.2.4";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1b4bamcbpk29i7jvly3i7ayfj69yc1g03gm4s7jgamccvx12hvng";
      type = "gem";
    };
    version = "4.2.1";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1sg4laz2qmllxh1c5sqlj9n1r7scdn08p3m4b0zmhjvyx9yw0v8b";
      type = "gem";
    };
    version = "2.1.1";
  };
  rspec = {
    dependencies = [
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11q5hagj6vr694innqj4r45jrm8qcwvkxjnphqgyd66piah88qi0";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-core = {
    dependencies = [ "rspec-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bcbh9yv6cs6pv299zs4bvalr8yxa51kcdd1pjl60yv625j3r0m8";
      type = "gem";
    };
    version = "3.13.6";
  };
  rspec-expectations = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dl8npj0jfpy31bxi6syc7jymyd861q277sfr6jawq2hv6hx791k";
      type = "gem";
    };
    version = "3.13.5";
  };
  rspec-mocks = {
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "071bqrk2rblk3zq3jk1xxx0dr92y0szi5pxdm8waimxici706y89";
      type = "gem";
    };
    version = "3.13.7";
  };
  rspec-support = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cmgz34hwj5s3jwxhyl8mszs24nci12ffbrmr5jb1si74iqf739f";
      type = "gem";
    };
    version = "3.13.6";
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
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cd0iriqfsf1z91qg271sm88xjnfd92b832z49p1nd542ka96lfc";
      type = "gem";
    };
    version = "0.4.1";
  };
  sequel = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0irbjils48r7w14jacka3l96jzh534d98vb88yj1qc9nl43r3r2g";
      type = "gem";
    };
    version = "5.98.0";
  };
  sinatra = {
    dependencies = [
      "logger"
      "mustermann"
      "rack"
      "rack-protection"
      "rack-session"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "103h6wjpcqp3i034hi44za2v365yz7qk9s5df8lmasq43nqvkbmp";
      type = "gem";
    };
    version = "4.2.1";
  };
  sinatra-contrib = {
    dependencies = [
      "multi_json"
      "mustermann"
      "rack-protection"
      "sinatra"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jkbsaika8pr9bc90ag3wqrhbgiy7h5a93k11j8sls6j8k4r3l0h";
      type = "gem";
    };
    version = "4.2.1";
  };
  sinatra-session = {
    dependencies = [ "sinatra" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "183xl8i4d2hc03afd1i52gwn2xi3vzrv02g22llhfy5wkmm44gmq";
      type = "gem";
    };
    version = "1.0.0";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w27v04d7rnxjr3f65w1m7xyvr6ch6szjj2v5wv1wz6z5ax9pa9m";
      type = "gem";
    };
    version = "2.6.1";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nqf9rg974k4bjji7aggalg8pfvbkd9hys4hv5y450jb21qgkxph";
      type = "gem";
    };
    version = "0.4.4";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
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
