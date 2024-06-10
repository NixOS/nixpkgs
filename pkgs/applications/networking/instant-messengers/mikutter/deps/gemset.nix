{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  atk = {
    dependencies = ["glib2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a8q9a1f6x4gy55p8cf52a22bnpjgn18ad9n959x0f4gybbhs948";
      type = "gem";
    };
    version = "3.4.1";
  };
  cairo = {
    dependencies = ["native-package-installer" "pkg-config" "red-colors"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0vbj9szp2xbnxqan8hppip8vm9fxpcmpx745y5fvg2scdh9f0p7s";
      type = "gem";
    };
    version = "1.17.5";
  };
  cairo-gobject = {
    dependencies = ["cairo" "glib2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gkxdfslcvrwrs48giilji3bgxd5bwijwq33p9h00r10jzfg2028";
      type = "gem";
    };
    version = "3.4.1";
  };
  crack = {
    dependencies = ["rexml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cr1kfpw3vkhysvkk3wg7c54m75kd68mbm9rs5azdjdq57xid13r";
      type = "gem";
    };
    version = "0.4.5";
  };
  delayer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0iqf4i18i8rk3x7qgvkhbiqskf0xzdf733fjimrq6xkag2mq60bl";
      type = "gem";
    };
    version = "1.2.0";
  };
  delayer-deferred = {
    dependencies = ["delayer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i2das3ncssacpqdgaf4as77vrxm7jfiizaja884fqv4rzv6s2sv";
      type = "gem";
    };
    version = "2.2.0";
  };
  diva = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05wl4wg57vvng4nrp4lzjq148v908xzq092kq93phwvyxs7jnw2g";
      type = "gem";
    };
    version = "1.0.2";
  };
  gdk_pixbuf2 = {
    dependencies = ["gio2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0194gzn0kialfh0j7crllvp808r64sg6dh297x69b0av21ar5pam";
      type = "gem";
    };
    version = "3.4.1";
  };
  gettext = {
    dependencies = ["locale" "text"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fqlwq7i8ck1fjyhn19q3skvgrbz44q7gq51mlr0qym5rkj5f6rn";
      type = "gem";
    };
    version = "3.3.7";
  };
  gio2 = {
    dependencies = ["gobject-introspection"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l3jpgbdvb55xhcmpkcqgwx5068dfyi8kijfvzhbqh96ng0p1m7g";
      type = "gem";
    };
    version = "3.4.1";
  };
  glib2 = {
    dependencies = ["native-package-installer" "pkg-config"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18clyn0fp0h5alnkf9i2bqd6wvl78h468pdbzs1csqnba8vw4q1c";
      type = "gem";
    };
    version = "3.4.1";
  };
  gobject-introspection = {
    dependencies = ["glib2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3x8qiisbax3x0izj8l5w66r53ba5ma53ax2jhdbhbvaxx3d02n";
      type = "gem";
    };
    version = "3.4.1";
  };
  gtk2 = {
    dependencies = ["atk" "gdk_pixbuf2" "pango"];
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17az8g0n1yzz90kdbjg2hpabi04qccda7v6lin76bs637ivfg2md";
      type = "gem";
    };
    version = "3.4.1";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nynpl0xbj0nphqx1qlmyggq58ms1phf5i03hk64wcc0a17x1m1c";
      type = "gem";
    };
    version = "1.0.1";
  };
  httpclient = {
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  instance_storage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08nf5fhq9dckq9lmaklxydq0hrlfi7phk66gr3bggxg45zd687pl";
      type = "gem";
    };
    version = "1.0.0";
  };
  locale = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0997465kxvpxm92fiwc2b16l49mngk7b68g5k35ify0m3q0yxpdn";
      type = "gem";
    };
    version = "2.1.3";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
  };
  mini_portile2 = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hdbpmamx8js53yk3h8cqy12kgv6ca06k0c9n3pxh6b6cjfs19x7";
      type = "gem";
    };
    version = "2.5.0";
  };
  mocha = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05yw6rwgjppq116jgqfg4pv4bql3ci4r2fmmg0m2c3sqib1bq41a";
      type = "gem";
    };
    version = "1.12.0";
  };
  moneta = {
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z25b4yysvnf2hi9jxnsiv3fvnicnzr2m70ci231av5093jfknc6";
      type = "gem";
    };
    version = "1.4.1";
  };
  native-package-installer = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ww1mq41q7rda975byjmq5dk8k13v8dawvm33370pbkrymd8syp8";
      type = "gem";
    };
    version = "1.1.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19d78mdg2lbz9jb4ph6nk783c9jbsdm8rnllwhga6pd53xffp6x0";
      type = "gem";
    };
    version = "1.11.3";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zwd6v39yqfdrpg1p3d9jvzs9ljg55ana2p06m0l7qn5w0lgx1a0";
      type = "gem";
    };
    version = "0.5.6";
  };
  pango = {
    dependencies = ["cairo-gobject" "gobject-introspection"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d0cn50qgpifrcv8qx72wi6l9xalw3ryngbfmm9xpg9vx5rl1qbp";
      type = "gem";
    };
    version = "3.4.1";
  };
  pkg-config = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mjjy1grxr64znkffxsvprcckbrrnm40b6gbllnbm7jxslbr3gjl";
      type = "gem";
    };
    version = "1.4.6";
  };
  pluggaloid = {
    dependencies = ["delayer" "instance_storage"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m3f940lf1bg01jin22by7hg9hs43y995isgcyqb6vbvlv51zj11";
      type = "gem";
    };
    version = "1.5.0";
  };
  power_assert = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "172qfmzwxdf82bmwgcb13hnz9i3p6i2s2nijxnx6r63kn3drjppr";
      type = "gem";
    };
    version = "2.0.0";
  };
  public_suffix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xqcgkl7bwws1qrlnmxgh8g4g9m10vg60bhlw40fplninb3ng6d9";
      type = "gem";
    };
    version = "4.0.6";
  };
  racc = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "178k7r0xn689spviqzhvazzvxfq6fyjldxb3ywjbgipbfi4s8j1g";
      type = "gem";
    };
    version = "1.5.2";
  };
  rake = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1iik52mf9ky4cgs38fp2m8r6skdkq1yz23vh18lk95fhbcxb6a67";
      type = "gem";
    };
    version = "13.0.3";
  };
  red-colors = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ar2k7zvhr1215jx5di29hkg5h1798f1gypmq6v0sy9v35w6ijca";
      type = "gem";
    };
    version = "0.1.1";
  };
  rexml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08ximcyfjy94pm1rhcx04ny1vx2sk0x4y185gzn86yfsbzwkng53";
      type = "gem";
    };
    version = "3.2.5";
  };
  ruby-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r3xalp91l07m0cwllcxjzg6nkviiqnxkcbgg5qnzsdji6rgy65m";
      type = "gem";
    };
    version = "1.4.3";
  };
  test-unit = {
    dependencies = ["power_assert"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h0c323zfn4hdida4g58h8wnlh4kax438gyxlw20dd78kcp01i8m";
      type = "gem";
    };
    version = "3.4.0";
  };
  text = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  typed-array = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlv2rnkin9rwkgjx3k5qvc17m0m7jf5cdirw3wxbjnw5kga27w9";
      type = "gem";
    };
    version = "0.1.2";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "038igpmkpmn0nw0k7s4db8x88af1nwcy7wzh9m9c9q4p74h7rii0";
      type = "gem";
    };
    version = "3.12.2";
  };
}
