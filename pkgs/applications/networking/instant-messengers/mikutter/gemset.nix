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
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12cnzkkx504b79pxq6jgsma714mlsr42fd6z59xpxv89vv36vpfh";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "12x6c1568maxbr3xwizdp6fypvx190fd6m3pdcszvv7549dpsgjs";
      type = "gem";
    };
    version = "3.3.0";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zvqphyzngj5wghgbb2nd1qj2qvj2plsz9vx8hz24c7bfq55n4xz";
      type = "gem";
    };
    version = "2.0.0";
  };
  diva = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rp125gdlq7jqq7x8la52pdpimhx5wr66frcgf6z4jm927rjw84d";
      type = "gem";
    };
    version = "0.3.2";
  };
  gdk_pixbuf2 = {
    dependencies = ["gio2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "11g7vi054ygzvsfjp5caba624p42hrr1grixkl59p4fdrzqjli9f";
      type = "gem";
    };
    version = "3.3.0";
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
    dependencies = ["glib2" "gobject-introspection"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mik06651hqikczmx8b6q6bk5gmhm7q09m7phyx7qsrh537ci8s1";
      type = "gem";
    };
    version = "3.3.0";
  };
  glib2 = {
    dependencies = ["native-package-installer" "pkg-config"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s1bxyg1k42fm8qjcg4s08ma1zx363bwvhhxqfshlzdxhzs69zss";
      type = "gem";
    };
    version = "3.3.0";
  };
  gobject-introspection = {
    dependencies = ["glib2"];
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fbcwjfk9xm4fk8km0s5km6kcxzmi5gnkj2f0gam8yqfm4ji3d2b";
      type = "gem";
    };
    version = "3.3.0";
  };
  gtk2 = {
    dependencies = ["atk" "gdk_pixbuf2" "pango"];
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0k738xsmbsdn2mz307c36zkk4pjbjp32g5r15fbhszv945j494i1";
      type = "gem";
    };
    version = "3.3.0";
  };
  hashdiff = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19ykg5pax8798nh1yv71adkx0zzs7gn2rxjj86v7nsw0jba5lask";
      type = "gem";
    };
    version = "0.3.8";
  };
  httpclient = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19mxmvghp7ki3klsxwrlwr431li7hm1lczhhj8z4qihl2acy8l99";
      type = "gem";
    };
    version = "2.8.3";
  };
  idn-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07vblcyk3g72sbq12xz7xj28snpxnh3sbcnxy8bglqbfqqhvmawr";
      type = "gem";
    };
    version = "0.1.0";
  };
  instance_storage = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08nf5fhq9dckq9lmaklxydq0hrlfi7phk66gr3bggxg45zd687pl";
      type = "gem";
    };
    version = "1.0.0";
  };
  irb = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "181d88hns00fpw8szg8hbchflwq69wp3y5zvd3dyqjzbq91v1dcr";
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
    dependencies = ["metaclass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0id1x7g46fzy8f4jna20ys329ydaj3sad75qs9db2a6nd7f0zc2b";
      type = "gem";
    };
    version = "0.14.0";
  };
  moneta = {
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pv38ly26fhilw27bsyi3x9fvnhybqf2r9w5p693ifhrcf6w7vik";
      type = "gem";
    };
    version = "1.1.0";
  };
  native-package-installer = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03qrzhk807f98bdwy6c37acksyb5fnairdz4jpl7y3fifh7k7yfn";
      type = "gem";
    };
    version = "1.0.7";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sy96cc8i5y4p67fhf4d9c6sg8ymrrva21zyvzw55l0pa1582wx2";
      type = "gem";
    };
    version = "1.10.2";
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
      sha256 = "0gck302nfvz4pd6n4xyzncmmr86810dz072r7gkql44lbjwf0ifv";
      type = "gem";
    };
    version = "3.3.0";
  };
  pkg-config = {
    groups = ["default" "plugin"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s56ym0chq3fycl29vqabcalqdcf7y2f25pmihjwqgbmrmzdyvr1";
      type = "gem";
    };
    version = "1.3.7";
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
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "072y5ixw59ad47hkfj6nl2i4zcyad8snfxfsyyrgjkiqnvqwvbvq";
      type = "gem";
    };
    version = "1.1.4";
  };
  public_suffix = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08q64b5br692dd3v0a9wq9q5dvycc6kmiqmjbdxkxbfizggsvx6l";
      type = "gem";
    };
    version = "3.0.3";
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
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02z4lh1iv1d8751a1l6r4hfc9mp61gf80g4qc4l6gbync3j3hf2c";
      type = "gem";
    };
    version = "0.17.0";
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
      sha256 = "0psb4pkn09ni15clvv12ymxh7zylbpqmwi0vjh3rkgg42y50hv6v";
      type = "gem";
    };
    version = "3.3.1";
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
    dependencies = ["idn-ruby" "unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ibk4bl9hrq0phlg7zplkilsqgniji6yvid1a7k09rs0ai422jax";
      type = "gem";
    };
    version = "3.0.0";
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
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
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