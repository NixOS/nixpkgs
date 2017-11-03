{
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  atk = {
    dependencies = ["glib2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18l99gv6828rn59q8k6blxg146b025fj44klrcisffw6h9s9qqxm";
      type = "gem";
    };
    version = "3.1.9";
  };
  cairo = {
    dependencies = ["native-package-installer" "pkg-config"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1f0n057cj6cjz7f38pwnflrkbwkl8pm3g9ssa51flyxr7lcpcw7c";
      type = "gem";
    };
    version = "1.15.10";
  };
  cairo-gobject = {
    dependencies = ["cairo" "glib2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qnsd9203qc6hl2i4hfzngr8v06rfk4vxfn6sbr8b4c1q4n0lq26";
      type = "gem";
    };
    version = "3.1.9";
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
  delayer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "156vy4x1d2jgafkjaafzfz7g8ghl4p5zgbl859b8slp4wdxy3v1r";
      type = "gem";
    };
    version = "0.0.2";
  };
  delayer-deferred = {
    dependencies = ["delayer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rp2hpik8gs1kzwwq831jwj1iv5bhfwd3dmm9nvizy3nqpz1gvvb";
      type = "gem";
    };
    version = "1.0.4";
  };
  gdk_pixbuf2 = {
    dependencies = ["gio2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x7vna77qw26479dydzfs1sq7xmq31xfly2pn5fvh35wg0q4y07d";
      type = "gem";
    };
    version = "3.1.9";
  };
  gettext = {
    dependencies = ["locale" "text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14vw306p46w2kyad3kp9vq56zw3ch6px30wkhl5x0qkx8d3ya3ir";
      type = "gem";
    };
    version = "3.0.9";
  };
  gio2 = {
    dependencies = ["glib2" "gobject-introspection"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1dxyaxp32m19mynw20x39vkb50wa4jcxczwmbkq7pcg55j76wwhm";
      type = "gem";
    };
    version = "3.1.9";
  };
  glib2 = {
    dependencies = ["native-package-installer" "pkg-config"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y1ws895345a88wikqil1x87cpd7plmwfi635piam7il6vsb4h73";
      type = "gem";
    };
    version = "3.1.9";
  };
  gobject-introspection = {
    dependencies = ["glib2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04gla6z9y8g0d69wlwl0wr7pwyzqg132pfs1n9fq6fgkjb6l7sm3";
      type = "gem";
    };
    version = "3.1.9";
  };
  gtk2 = {
    dependencies = ["atk" "gdk_pixbuf2" "pango"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mshgsw2x0w5wfcp17qnsja50aafbjxy2g42kvk5sr19l0chkkkq";
      type = "gem";
    };
    version = "3.1.9";
  };
  hashdiff = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yj5l2rw8i8jc725hbcpc4wks0qlaaimr3dpaqamfjkjkxl0hjp9";
      type = "gem";
    };
    version = "0.3.7";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  instance_storage = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08nf5fhq9dckq9lmaklxydq0hrlfi7phk66gr3bggxg45zd687pl";
      type = "gem";
    };
    version = "1.0.0";
  };
  json_pure = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vllrpm2hpsy5w1r7000mna2mhd7yfrmd8hi713lk0n9mv27bmam";
      type = "gem";
    };
    version = "1.8.6";
  };
  locale = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sls9bq4krx0fmnzmlbn64dw23c4d6pz46ynjzrn9k8zyassdd0x";
      type = "gem";
    };
    version = "2.1.2";
  };
  memoist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pq8fhqh8w25qcw9v3vzfb0i6jp0k3949ahxc3wrwz2791dpbgbh";
      type = "gem";
    };
    version = "0.16.0";
  };
  metaclass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";
      type = "gem";
    };
    version = "0.0.4";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  mocha = {
    dependencies = ["metaclass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0id1x7g46fzy8f4jna20ys329ydaj3sad75qs9db2a6nd7f0zc2b";
      type = "gem";
    };
    version = "0.14.0";
  };
  moneta = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pgwn6xnlh7vviy511mfgkv2j3sfihn5ic2zabmyrs2nh6kfa912";
      type = "gem";
    };
    version = "1.0.0";
  };
  native-package-installer = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0svj2sg7y7izl90qrvzd2fcb1rkq8bv3bd6lr9sh1ml18v3w882a";
      type = "gem";
    };
    version = "1.0.4";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105xh2zkr8nsyfaj2izaisarpnkrrl9000y3nyflg9cbzrfxv021";
      type = "gem";
    };
    version = "1.8.1";
  };
  oauth = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a5cfg9pm3mxsmlk1slj652vza8nha2lpbpbmf3rrk0lh6zi4d0b";
      type = "gem";
    };
    version = "0.5.3";
  };
  pango = {
    dependencies = ["cairo" "cairo-gobject" "gobject-introspection"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0swld0s01djjlqrari0ib75703mb7qr4ydn00cqfhdr7xim66hjk";
      type = "gem";
    };
    version = "3.1.9";
  };
  pkg-config = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056qb6cwbw2l9riq376wazx4kwd67cdilyclpa6j38mfsswpmzws";
      type = "gem";
    };
    version = "1.2.8";
  };
  pluggaloid = {
    dependencies = ["delayer" "instance_storage"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0p9s1bzw02jzjlpjpxsbfsy1cyfbqs10iqvhxqh4xgyh72nry9zr";
      type = "gem";
    };
    version = "1.1.1";
  };
  power_assert = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h0s1clasynlbk3782801c61yx24pdv959fpw53g5yl8gxqj34iz";
      type = "gem";
    };
    version = "1.1.1";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0snaj1gxfib4ja1mvy3dzmi7am73i0mkqr0zkz045qv6509dhj5f";
      type = "gem";
    };
    version = "3.0.0";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jcabbgnjc788chx31sihc5pgbqnlc1c75wakmqlbjdm8jns2m9b";
      type = "gem";
    };
    version = "10.5.0";
  };
  ruby-hmac = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01zym41f8fqbmxfz8zv19627swi62ka3gp33bfbkc87v5k7mw954";
      type = "gem";
    };
    version = "0.4.0";
  };
  ruby-prof = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0y13gdcdajfgrkx5rc9pvb7bwkyximwl5yrhq05gkmhflzdr7kag";
      type = "gem";
    };
    version = "0.16.2";
  };
  safe_yaml = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
      type = "gem";
    };
    version = "1.0.4";
  };
  test-unit = {
    dependencies = ["power_assert"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gl5b2d6bysnm0a1zx54qn6iwd67f6gsjy0c7zb68ag0453rqcnv";
      type = "gem";
    };
    version = "3.2.6";
  };
  text = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x6kkmsr49y3rnrin91rv8mpc3dhrf3ql08kbccw8yffq61brfrg";
      type = "gem";
    };
    version = "1.3.1";
  };
  totoridipjp = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03ci9hbwc6xf4x0lkm6px4jgbmi37n8plsjhbf2ir5vka9f29lck";
      type = "gem";
    };
    version = "0.1.0";
  };
  twitter-text = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1732h7hy1k152w8wfvjsx7b79alk45i5imwd37ia4qcx8hfm3gvg";
      type = "gem";
    };
    version = "1.14.7";
  };
  typed-array = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qlv2rnkin9rwkgjx3k5qvc17m0m7jf5cdirw3wxbjnw5kga27w9";
      type = "gem";
    };
    version = "0.1.2";
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
      sha256 = "14hr2dzqh33kqc0xchs8l05pf3kjcayvad4z1ip5rdjxrkfk8glb";
      type = "gem";
    };
    version = "0.0.7.4";
  };
  watch = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02g4g6ynnldyjjzrh19r584gj4z6ksff7h0ajz5jdwhpp5y7cghx";
      type = "gem";
    };
    version = "0.1.0";
  };
  webmock = {
    dependencies = ["addressable" "crack" "hashdiff"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03vlr6axajz6c7xmlk0w1kvkxc92f8y2zp27wq1z6yk916ry25n5";
      type = "gem";
    };
    version = "1.24.6";
  };
}