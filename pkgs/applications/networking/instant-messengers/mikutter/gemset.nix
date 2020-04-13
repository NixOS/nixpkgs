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
    dependencies = ["native-package-installer" "pkg-config"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yvv2lcbsybzbw1nrmfivmln23da4rndrs3av6ymjh0x3ww5h7p8";
      type = "gem";
    };
    version = "1.16.4";
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
    dependencies = ["safe_yaml"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
      type = "gem";
    };
    version = "0.4.3";
  };
  delayer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09p4rkh3dpdm1mhq721m4d6zvxqqp44kg7069s8l7kmaf7nv2nb3";
      type = "gem";
    };
    version = "1.0.1";
  };
  delayer-deferred = {
    dependencies = ["delayer"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mbdxn1hskjqf3zlj4waxl71ccvbj6lk81c99769paxw4fajwrgx";
      type = "gem";
    };
    version = "2.1.1";
  };
  diva = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182gws1zihhpl7r3m8jsf29maqg9xdhj46s9lidbldar8clpl23h";
      type = "gem";
    };
    version = "1.0.1";
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
      sha256 = "0764vj7gacn0aypm2bf6m46dzjzwzrjlmbyx6qwwwzbmi94r40wr";
      type = "gem";
    };
    version = "3.2.9";
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
      sha256 = "18jqpbvidrlnq3xf0hkdbs00607jgz35lry6gjw4bcxgh52am2mk";
      type = "gem";
    };
    version = "1.0.0";
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
  io-console = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0srn91ly4cc5qvyj3r87sc7v8dnm52qj1hczzxmysib6ffparngd";
      type = "gem";
    };
    version = "0.5.3";
  };
  irb = {
    dependencies = ["reline"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1r1y8i46qd5izdszzzn5jxvwvq00m89rk0hm8cs8f21p7nlwmh5w";
      type = "gem";
    };
    version = "1.2.1";
  };
  locale = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
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
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  mocha = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06i2q5qjr9mvjgjc8w41pdf3qalw340y33wjvzc0rp4a1cbbb7pp";
      type = "gem";
    };
    version = "1.11.1";
  };
  moneta = {
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0q7fskfdc0h5dhl8aamg3ypybd6cyl4x0prh4803gj7hxr17jfm1";
      type = "gem";
    };
    version = "1.2.1";
  };
  native-package-installer = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0piclgf6pw7hr10x57x0hn675djyna4sb3xc97yb9vh66wkx1fl0";
      type = "gem";
    };
    version = "1.0.9";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0r0qpgf80h764k176yr63gqbs2z0xbsp8vlvs2a79d5r9vs83kln";
      type = "gem";
    };
    version = "1.10.7";
  };
  oauth = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zszdg8q1b135z7l7crjj234k4j0m347hywp5kj6zsq7q78pw09y";
      type = "gem";
    };
    version = "0.5.4";
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
      sha256 = "1cxdpr2wlz9b587avlq04a1da5fz1vdw8jvr6lx23mcq7mqh2xcx";
      type = "gem";
    };
    version = "1.4.0";
  };
  pluggaloid = {
    dependencies = ["delayer" "instance_storage"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gv0rjjdic8c41gfr3kyyphvf0fmv5rzcf6qd57zjdfcn6fvi3hh";
      type = "gem";
    };
    version = "1.2.0";
  };
  power_assert = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dii0wkfa0jm8sk9b20zl1z4980dmrjh0zqnii058485pp3ws10s";
      type = "gem";
    };
    version = "1.1.5";
  };
  public_suffix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnfv2j2bqgdpg2yq9i2rxby0w2sc9h5iyjkpaas2xknwrgmhdb0";
      type = "gem";
    };
    version = "4.0.1";
  };
  rake = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0w6qza25bq1s825faaglkx1k6d59aiyjjk3yw3ip5sb463mhhai9";
      type = "gem";
    };
    version = "13.0.1";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0908ijrngc3wkn5iny7d0kxkp74w6ixk2nwzzngplplfla1vkp8x";
      type = "gem";
    };
    version = "0.1.2";
  };
  ruby-prof = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18ga5f4h1fnwn0xh910kpnw4cg3lq3jqljd3h16bdw9pgc5ff7dn";
      type = "gem";
    };
    version = "1.1.0";
  };
  safe_yaml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0j7qv63p0vqcd838i2iy2f76c3dgwzkiz1d1xkg7n0pbnxj2vb56";
      type = "gem";
    };
    version = "1.0.5";
  };
  test-unit = {
    dependencies = ["power_assert"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mrkpb6wz0cs1740kaca240k4ymmkbvb2v5xaxsy6vynqw8n0g6z";
      type = "gem";
    };
    version = "3.3.4";
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
      sha256 = "19xvs7gdf8r75bmyb17w9g367qxzqnlrmbdda1y36cn1vrlnf2l8";
      type = "gem";
    };
    version = "3.7.6";
  };
}