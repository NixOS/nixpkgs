{
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s12j8vl8vrxfngkdlz9g8bpz9akq1z42d57mx5r537b2pji8nr7";
      type = "gem";
    };
    version = "4.2.10";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  colorator = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7wvpam948cglrciyqd798gdc6z3cfijciavd0dfixgaypmvy72";
      type = "gem";
    };
    version = "1.1.0";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  em-websocket = {
    dependencies = ["eventmachine" "http_parser.rb"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bsw8vjz0z267j40nhbmrvfz7dvacq4p0pagvyp17jif6mj6v7n3";
      type = "gem";
    };
    version = "0.5.1";
  };
  eventmachine = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "075hdw0fgzldgss3xaqm2dk545736khcvv1fmzbf1sgdlkyh1v8z";
      type = "gem";
    };
    version = "1.2.5";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zw6pbyvmj8wafdc7l5h7w20zkp1vbr2805ql5d941g2b20pk4zr";
      type = "gem";
    };
    version = "1.9.23";
  };
  forwardable-extended = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zcqfxfvsnprwm8agia85x64vjzr2w0xn9vxfnxzgcv8s699v0v";
      type = "gem";
    };
    version = "2.6.0";
  };
  gemoji = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h85qpn2xbmsn8ssf2fqzlqg181j000m5z4l3g26r7vblncg162d";
      type = "gem";
    };
    version = "3.0.0";
  };
  html-pipeline = {
    dependencies = ["activesupport" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hkx70z9ijgnncmrna9qdh9ajn9m7v146k91j257lrzyq2f6jdjd";
      type = "gem";
    };
    version = "2.7.1";
  };
  "http_parser.rb" = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15nidriy0v5yqfjsgsra51wmknxci2n2grliz78sf9pga3n0l7gi";
      type = "gem";
    };
    version = "0.6.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038qvz7kd3cfxk8bvagqhakx68pfbnmghpdkx7573wbf0maqp9a3";
      type = "gem";
    };
    version = "0.9.5";
  };
  jekyll = {
    dependencies = ["addressable" "colorator" "em-websocket" "i18n" "jekyll-sass-converter" "jekyll-watch" "kramdown" "liquid" "mercenary" "pathutil" "rouge" "safe_yaml"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k8pz95yiwxj6h645sxwckl227lah97lshv9xxrddhldxwf0n0ff";
      type = "gem";
    };
    version = "3.7.3";
  };
  jekyll-avatar = {
    dependencies = ["jekyll"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y2w7pnahkm3ddxrq589wv1w53ay7p1pvfs6khcmh6wq85r6wpsf";
      type = "gem";
    };
    version = "0.5.0";
  };
  jekyll-mentions = {
    dependencies = ["activesupport" "html-pipeline" "jekyll"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00nqm1ng4iiibmv4vx0ayzq7fqm2sm1af98r4ykvld6asqj5qkyd";
      type = "gem";
    };
    version = "1.2.0";
  };
  jekyll-sass-converter = {
    dependencies = ["sass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "008ikh5fk0n6ri54mylcl8jn0mq8p2nfyfqif2q3pp0lwilkcxsk";
      type = "gem";
    };
    version = "1.5.2";
  };
  jekyll-seo-tag = {
    dependencies = ["jekyll"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f9b2mvmx57zj49afb3x8cmzdmb1kh4rbpbv3v7w5bh47g2c9big";
      type = "gem";
    };
    version = "2.4.0";
  };
  jekyll-sitemap = {
    dependencies = ["jekyll"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xy93ysl1q8r4xhbnffycvsslja0dskh2z2pl1jnykwsy27dc89n";
      type = "gem";
    };
    version = "1.2.0";
  };
  jekyll-watch = {
    dependencies = ["listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m7scvj3ki8bmyx5v8pzibpg6my10nycnc28lip98dskf8iakprp";
      type = "gem";
    };
    version = "2.0.0";
  };
  jemoji = {
    dependencies = ["activesupport" "gemoji" "html-pipeline" "jekyll"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0acmi7mgr844dmzgfi9flcqkkb0jh5l21h579cidxwf1409w588b";
      type = "gem";
    };
    version = "0.9.0";
  };
  kramdown = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mkrqpp01rrfn3rx6wwsjizyqmafp0vgg8ja1dvbjs185r5zw3za";
      type = "gem";
    };
    version = "1.16.2";
  };
  liquid = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17fa0jgwm9a935fyvzy8bysz7j5n1vf1x2wzqkdfd5k08dbw3x2y";
      type = "gem";
    };
    version = "4.0.0";
  };
  listen = {
    dependencies = ["rb-fsevent" "rb-inotify" "ruby_dep"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v5mrnfqm6sgm8xn2v5swxsn1wlmq7rzh2i48d4jzjsc7qvb6mx";
      type = "gem";
    };
    version = "3.1.5";
  };
  mercenary = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10la0xw82dh5mqab8bl0dk21zld63cqxb1g16fk8cb39ylc4n21a";
      type = "gem";
    };
    version = "0.3.6";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0icglrhghgwdlnzzp4jf76b0mbc71s80njn5afyfjn4wqji8mqbq";
      type = "gem";
    };
    version = "5.11.3";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05fm3xh462glvs0rwnfmc1spmgl4ljg2giifynbmwwqvl42zaaiq";
      type = "gem";
    };
    version = "1.8.2";
  };
  pathutil = {
    dependencies = ["forwardable-extended"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wc18ms1rzi44lpjychyw2a96jcmgxqdvy2949r4vvb5f4p0lgvz";
      type = "gem";
    };
    version = "0.16.1";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x5h1dh1i3gwc01jbg01rly2g6a1qwhynb1s8a30ic507z1nh09s";
      type = "gem";
    };
    version = "3.0.2";
  };
  rb-fsevent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fbpmjypwxkb8r7y1kmhmyp6gawa4byw0yb3jc3dn9ly4ld9lizf";
      type = "gem";
    };
    version = "0.10.2";
  };
  rb-inotify = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yfsgw5n7pkpyky6a9wkf1g9jafxb0ja7gz0qw0y14fd2jnzfh71";
      type = "gem";
    };
    version = "0.9.10";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sfhy0xxqjnzqa7qxmpz1bmy0mzcr55qyvi410gsb6d6i4ialbw3";
      type = "gem";
    };
    version = "3.1.1";
  };
  ruby_dep = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1bkl97i9mkcvkn1jks346ksnvnnp84cs22gwl0vd7radybrgy5";
      type = "gem";
    };
    version = "1.5.0";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  sass = {
    dependencies = ["sass-listen"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10401m2xlv6vaxfwzy4xxmk51ddcnkvwi918cw3jkki0qqdl7d8v";
      type = "gem";
    };
    version = "3.5.5";
  };
  sass-listen = {
    dependencies = ["rb-fsevent" "rb-inotify"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xw3q46cmahkgyldid5hwyiwacp590zj2vmswlll68ryvmvcp7df";
      type = "gem";
    };
    version = "4.0.0";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
}