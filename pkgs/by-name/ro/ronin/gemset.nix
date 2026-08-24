{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09v987j1jy4821s06cpm3h50ldybv89k0ll70grn05fxv1yccxrp";
      type = "gem";
    };
    version = "7.2.3.2";
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
      sha256 = "1iw5f93c6rq080xphy4776lamc4iahibjbhjxlj0v0jzgsx28bg6";
      type = "gem";
    };
    version = "7.2.3.2";
  };
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "04ikxwixhpnv2dih9hy3af45qgra7kz0fd70miw6s248vl8hvjfx";
      type = "gem";
    };
    version = "7.2.3.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1by7h2lwziiblizpd5yx87jsq8ppdhzvwf08ga34wzqgcv1nmpvz";
      type = "gem";
    };
    version = "2.9.0";
  };
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1cprvia1j7ggdp6cdl81p2biv6glkadzs461iv2prclz046wx6q7";
      type = "gem";
    };
    version = "2.44.1";
  };
  async-dns = {
    dependencies = [
      "async"
      "io-endpoint"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nyz9fbbl2kmvfmc30h2qqij11rfbwjxps60xqhml94lild0shh2";
      type = "gem";
    };
    version = "1.4.1";
  };
  async-http = {
    dependencies = [
      "async"
      "async-pool"
      "io-endpoint"
      "io-stream"
      "protocol-http"
      "protocol-http1"
      "protocol-http2"
      "protocol-url"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d6mxr6122jkcvfbmqhaddk1hllmpma0d5bz27b35zf0yd5s4p23";
      type = "gem";
    };
    version = "0.101.0";
  };
  async-io = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1isyrpbsnp00kh38jjqzk933zx48xyvpr2mzk3lsybvs885aybl9";
      type = "gem";
    };
    version = "1.43.2";
  };
  async-pool = {
    dependencies = [ "async" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vg3lwb3yhq0rad3dm00vp35vrahkbxgl4kx3d2rqkdh09xs2hqa";
      type = "gem";
    };
    version = "0.11.2";
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
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0v1337j39w1z7x9zs4q7ag0nfv4vs4xlsjx2la0wpv8s6hig2pa6";
      type = "gem";
    };
    version = "0.5.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1g9zi8c4i7g8zz0c3hxrw6mblrjvgn7akys60clb9si7c1k1gljk";
      type = "gem";
    };
    version = "4.1.2";
  };
  chars = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bqcbk4c4vdxfmcr9hrq8ilvb7cl7s65602bgvxyqrdw2k12pl13";
      type = "gem";
    };
    version = "0.3.4";
  };
  combinatorics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bwkk3hw3ll585y4558zy8ahbc1049ylc3321sjvlhm2lvha7717";
      type = "gem";
    };
    version = "0.5.0";
  };
  command_kit = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "147s9bc97k2pkh9pbzidwi4mgy47zw8djh8044f5fkzfbb7jjzz5";
      type = "gem";
    };
    version = "0.6.0";
  };
  command_mapper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08x2c5vfhljcws535mdlqfqxf3qmpgvw69hjgb6bg0k7ybddmyhn";
      type = "gem";
    };
    version = "0.3.2";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qfi2ns3zwkgq616fc127xiqhan7g7m7gqpwriwcr34nds1vxwdj";
      type = "gem";
    };
    version = "1.3.8";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "02ifws3c4x7b54fv17sm4cca18d2pfw1saxpdji2lbd1f6xgbzrk";
      type = "gem";
    };
    version = "3.0.2";
  };
  console = {
    dependencies = [
      "fiber-annotation"
      "fiber-local"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mzgyg46jxdyijmg6dkxjv3yqmaixr7mk66094w0cnjrqa3b54w0";
      type = "gem";
    };
    version = "1.37.0";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mj4kq4wwpc7c8ll52q30hsir1jrcd5kq7yb8lyz0rksa1z1x9mb";
      type = "gem";
    };
    version = "3.3.6";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h0db8r2v5llxdbzkzyllkfniqw9gm092qn7cbaib73v9lw0c3bm";
      type = "gem";
    };
    version = "3.5.1";
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
  dry-configurable = {
    dependencies = [
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kkk3fs22ndslgihxwm6rwr0y03rvccljmhz6vpm65q87iginpg3";
      type = "gem";
    };
    version = "1.4.0";
  };
  dry-core = {
    dependencies = [
      "concurrent-ruby"
      "logger"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18cn9s2p7cbgacy0z41h3sf9jvl75vjfmvj774apyffzi3dagi8c";
      type = "gem";
    };
    version = "1.2.0";
  };
  dry-inflector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k1dd35sqqqg2abd2g2w78m94pa3mcwvmrsjbkr3hxpn0jxw5c3z";
      type = "gem";
    };
    version = "1.3.1";
  };
  dry-initializer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qy4cv0j0ahabprdbp02nc3r1606jd5dp90lzqg0mp0jz6c9gm9p";
      type = "gem";
    };
    version = "3.2.0";
  };
  dry-logic = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18nf8mbnhgvkw34drj7nmvpx2afmyl2nyzncn3wl3z4h1yyfsvys";
      type = "gem";
    };
    version = "1.6.0";
  };
  dry-schema = {
    dependencies = [
      "concurrent-ruby"
      "dry-configurable"
      "dry-core"
      "dry-initializer"
      "dry-logic"
      "dry-types"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09spk1wfpg0v5fi2kblxifjs14pvqka9d452hbn6dbziq2mswfnd";
      type = "gem";
    };
    version = "1.16.0";
  };
  dry-struct = {
    dependencies = [
      "dry-core"
      "dry-types"
      "ice_nine"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wc07v0qm8zbblr74w3iy2s74sxpifyfpw9b2x01a9259icnhf03";
      type = "gem";
    };
    version = "1.8.1";
  };
  dry-types = {
    dependencies = [
      "bigdecimal"
      "concurrent-ruby"
      "dry-core"
      "dry-inflector"
      "dry-logic"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0y7icwaa26ycikz6h97gwd1hji3r280n4yr2kmn5sfgqp76yxsxs";
      type = "gem";
    };
    version = "1.9.1";
  };
  dry-validation = {
    dependencies = [
      "concurrent-ruby"
      "dry-core"
      "dry-initializer"
      "dry-schema"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11c0zx0irrawi028xsljpyw8kwxzqrhf7lv6nnmch4frlashp43h";
      type = "gem";
    };
    version = "1.11.1";
  };
  erb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14pfj6zn0p1hxj6s6s0r7d424wap8zl9zxf89nj79y8fbg16vjn5";
      type = "gem";
    };
    version = "6.0.7";
  };
  fake_io = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10559cnd2cqllql8ibd0zx0rvq8xk0qll5sqa4khb5963596ldmn";
      type = "gem";
    };
    version = "0.1.0";
  };
  ferrum = {
    dependencies = [
      "addressable"
      "base64"
      "concurrent-ruby"
      "websocket-driver"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1inpi750jjbjlhqcf414jfx966zc6i5j3sc7y1sivz2jwcbbxf2c";
      type = "gem";
    };
    version = "0.18.0";
  };
  fiber-annotation = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = [ "fiber-storage" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qa0j9qjwav9xb0n3isx0rbh0942xrfback392n6vs8bidnmp3pl";
      type = "gem";
    };
    version = "1.0.1";
  };
  hexdump = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wvi685igjmi00b7pmjpxnki5gwgzxn71qxhycbivbqy9vj86jvk";
      type = "gem";
    };
    version = "1.0.1";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dfikmmd9dllirsfq0kjiyxpmlq0afkxm5sslsr97r9g85ifpy80";
      type = "gem";
    };
    version = "1.15.2";
  };
  ice_nine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nv35qg1rps9fsis28hz2cq2fx1i96795f91q4nmkm934xynll2x";
      type = "gem";
    };
    version = "0.11.2";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "026v93kja19bfslnwi9xfq2dj4r89kkwdprim4whjg6h3n4lz9zg";
      type = "gem";
    };
    version = "0.9.2";
  };
  io-endpoint = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ajia4kwnma5i41mp2w4xvzwbhrc6fmivjdzj2j8nkjqrmmih3bj";
      type = "gem";
    };
    version = "0.18.0";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lms71bkfbx663lhac44cz8fsn8zhfzz90kz0kr99s50qnvsjs5i";
      type = "gem";
    };
    version = "1.19.5";
  };
  io-stream = {
    dependencies = [ "openssl" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kgim30xjghz4z6047nkc5sy8casmmlqvzqzfsycnv06l8zb3n87";
      type = "gem";
    };
    version = "0.14.0";
  };
  irb = {
    dependencies = [
      "pp"
      "prism"
      "rdoc"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1qs8a9vprg7s8krgq4s0pygr91hclqqyz98ik15p0m1sf2h5956y";
      type = "gem";
    };
    version = "1.18.0";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0shwgjqbj856mb6m9kgkpy08nhym2gdvc2yaprlimfmky9y3n78z";
      type = "gem";
    };
    version = "2.21.2";
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
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mbpz92ml19rcxxfjrj91gmkif9khb1xpzyw38f81rvglgw1ffrd";
      type = "gem";
    };
    version = "5.27.0";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1040lr5y2phn7avdyam6zw6ikprlmk77biw3yhclsfwfh0qnl4p6";
      type = "gem";
    };
    version = "1.21.1";
  };
  mustermann = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "163i29mdcr1h0nximk3d51a1fgp7vz3sfasn8p1rjm2d4g3p0qac";
      type = "gem";
    };
    version = "3.1.1";
  };
  net-ftp = {
    dependencies = [
      "net-protocol"
      "time"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0r9vn7q6c66y4iw048qdbqviv7bankdkcziz12fzfa7lyz61fy1h";
      type = "gem";
    };
    version = "0.3.9";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1px886qvws5zvqphy5cysj8vg01lym0w7vs9wq1h41pk1pjlxaln";
      type = "gem";
    };
    version = "0.6.6";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1wyz41jd4zpjn0v1xsf9j778qx1vfrl24yc20cpmph8k42c4x2w4";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1a32l4x73hz200cm587bc29q8q9az278syw3x6fkc9d1lv5y0wxa";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dh7nzjp0fiaqq1jz90nv4nxhc2w359d7c199gmzq965cfps15pd";
      type = "gem";
    };
    version = "0.5.1";
  };
  nio4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18fwy5yqnvgixq3cn0h63lm8jaxsjjxkmj8rhiv8wpzv9271d43c";
      type = "gem";
    };
    version = "2.7.5";
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
      sha256 = "1d9safb4dly6qmc2g06444l0zifby52yy6j1a5fa1g4j3ihm3jah";
      type = "gem";
    };
    version = "1.19.4";
  };
  nokogiri-diff = {
    dependencies = [
      "nokogiri"
      "tdiff"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1x96g7zbfiqac3h2prhaz0zz8xbryapdbxpsra3019a2q29ac3yj";
      type = "gem";
    };
    version = "0.3.0";
  };
  nokogiri-ext = {
    dependencies = [ "nokogiri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03jgdkdmh5ny9c49l18ls9cr8rwwlff3vfawqg2s7cwzpndn7lk9";
      type = "gem";
    };
    version = "0.1.1";
  };
  open_namespace = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0k7093vbkf4mgppjz2r7pk7w3gcpmmzm4a6l8q2aa1fks4bvqhxl";
      type = "gem";
    };
    version = "0.4.2";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hj7wwp4r3jhvnyd8ik85wbs25cq1w61r28pv6ddyn5fd0lasdqh";
      type = "gem";
    };
    version = "4.0.2";
  };
  pagy = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qsxw0686k0987yybqb2z2blrb6sxpszp8dhanbnynnkgkih91v";
      type = "gem";
    };
    version = "6.5.0";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0w5mha75hs8gdj75g8vl0sxpyp8rzvwq8a4jcmi4ah8cf370zjyz";
      type = "gem";
    };
    version = "0.6.4";
  };
  prettyprint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14zicq3plqi217w6xahv7b8f7aj5kpxv1j1w98344ix9h5ay3j9b";
      type = "gem";
    };
    version = "0.2.0";
  };
  prism = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11ggfikcs1lv17nhmhqyyp6z8nq5pkfcj6a904047hljkxm0qlvv";
      type = "gem";
    };
    version = "1.9.0";
  };
  protocol-hpack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14ddqg5mcs9ysd1hdzkm5pwil0660vrxcxsn576s3387p0wa5v3g";
      type = "gem";
    };
    version = "1.5.1";
  };
  protocol-http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fnr9gql98zfqglxp5zn6r765msbrczv88byxvvw7w0bvzrpnmrq";
      type = "gem";
    };
    version = "0.71.0";
  };
  protocol-http1 = {
    dependencies = [ "protocol-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "18qfic0k6w4bqw3n0w2hxprwi0562dns2ziydj4qm5182958fqwq";
      type = "gem";
    };
    version = "0.41.0";
  };
  protocol-http2 = {
    dependencies = [
      "protocol-hpack"
      "protocol-http"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1piy395lxlbwzy16p5idlq9qj2qpxaa007h5971i4xc766mcymql";
      type = "gem";
    };
    version = "0.26.2";
  };
  protocol-url = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1mhf2nbc79ikirr9c9m3c9cspr30n8rr6w2bw0c6vd4l62c5avxi";
      type = "gem";
    };
    version = "0.18.0";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "08znfv30pxmdkjyihvbjqbvv874dj3nybmmyscl958dy3f7v12qs";
      type = "gem";
    };
    version = "7.0.5";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07pajhv7pqz82kcjc6017y4d0hwz5kp746cydpx1npd79r56xddr";
      type = "gem";
    };
    version = "6.6.1";
  };
  python-pickle = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nk6wylwn5l8cx4m01z41c9ib6fnf7hlki0p9srwqdm1zs0ifsjf";
      type = "gem";
    };
    version = "0.2.0";
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
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pyammr7fpxqa1sdvw0vnk4699j081sqqcsj6isl67471mm545pg";
      type = "gem";
    };
    version = "2.2.24";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zzvivmdb4dkscc58i3gmcyrnypynsjwp6xgc4ylarlhqmzvlx1w";
      type = "gem";
    };
    version = "3.2.0";
  };
  rack-session = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xhxhlsz6shh8nm44jsmd9276zcnyzii364vhcvf0k8b8bjia8d0";
      type = "gem";
    };
    version = "1.0.2";
  };
  rack-user_agent = {
    dependencies = [
      "rack"
      "woothee"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "131a7v696ddzh3aric141gdsz3nshq4s763jb5b8mdl9cbf6gj8w";
      type = "gem";
    };
    version = "0.6.0";
  };
  rbs = {
    dependencies = [
      "logger"
      "prism"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x067q8cdam4kv5dc09iq2nzca8qm2kdl0dr22gc0ny0vj3bixsi";
      type = "gem";
    };
    version = "4.2.0";
  };
  rdoc = {
    dependencies = [
      "erb"
      "prism"
      "rbs"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sf4909q2mr9z0rpygv94z12b0yamg07gz8cba2mi5k3m448rgq3";
      type = "gem";
    };
    version = "8.0.0";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bpsh5dbvybsa8qnv4dg11a6f2zn4sndarf7pk4iaayjgaspbrmm";
      type = "gem";
    };
    version = "5.4.1";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0baj2r8wa6imzfndyz6cj732v8nq02wy7nicfciqdr5zgdfbqlai";
      type = "gem";
    };
    version = "0.30.1";
  };
  redis-namespace = {
    dependencies = [ "redis" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f92i9cwlp6xj6fyn7qn4qsaqvxfw4wqvayll7gbd26qnai1l6p9";
      type = "gem";
    };
    version = "1.11.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gaq2lc463ap1srz7y5kh2p4dxazs7vjrpiby58d9yfvan72s0av";
      type = "gem";
    };
    version = "0.7.0";
  };
  robots = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "141gvihcr2c0dpzl3dqyh8kqc9121prfdql2iamaaw0mf9qs3njs";
      type = "gem";
    };
    version = "0.10.1";
  };
  ronin = {
    dependencies = [
      "async-io"
      "open_namespace"
      "ronin-app"
      "ronin-code-asm"
      "ronin-code-sql"
      "ronin-core"
      "ronin-db"
      "ronin-dns-proxy"
      "ronin-exploits"
      "ronin-fuzzer"
      "ronin-listener"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-payloads"
      "ronin-recon"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "ronin-web"
      "ronin-wordlists"
      "rouge"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1zhlq8xjay0143kl6ix70daxs4cqs00vf3yhn96pifqnn9l7p4ww";
      type = "gem";
    };
    version = "2.1.1";
  };
  ronin-app = {
    dependencies = [
      "dry-schema"
      "dry-struct"
      "dry-validation"
      "pagy"
      "puma"
      "redis"
      "redis-namespace"
      "ronin-core"
      "ronin-db"
      "ronin-db-activerecord"
      "ronin-exploits"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-payloads"
      "ronin-recon"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "ronin-web-spider"
      "sidekiq"
      "sinatra"
      "sinatra-contrib"
      "sinatra-flash"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1d5lrc0wq8vvxcl7gp78h6yk3j3hb1rspn94w5mmk4n79xm2cy3i";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-code-asm = {
    dependencies = [ "ruby-yasm" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01qn97lsln0izrns2bwmh980qzf02ba864y66hxkxf50nm2vcign";
      type = "gem";
    };
    version = "1.0.1";
  };
  ronin-code-sql = {
    dependencies = [ "ronin-support" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19db7ayhhyvzkdyms81brfsilkk9xccikakhwch3zy3kbmdzrr6w";
      type = "gem";
    };
    version = "2.1.1";
  };
  ronin-core = {
    dependencies = [
      "command_kit"
      "csv"
      "irb"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h5zd5b4fh5rx1cn4r9n6abw1y7izr4imx2fcc6rn014w4zq1i2b";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-db = {
    dependencies = [
      "ronin-core"
      "ronin-db-activerecord"
      "ronin-support"
      "sqlite3"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "07rksw32aakr4y7j03ba12cbvvciv6snf4xql2imwa1571x7b5z3";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-db-activerecord = {
    dependencies = [
      "activerecord"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10f4h6vz9axmzcnp7rrmqbkmp38z0sw8i6vvqljcnc0f0r71vzap";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-dns-proxy = {
    dependencies = [
      "async-dns"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lnmbb6cc2j8id1rprjlh2jynarq682mdq42bklcp203wvvifanq";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-exploits = {
    dependencies = [
      "csv"
      "ronin-code-sql"
      "ronin-core"
      "ronin-payloads"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
      "ronin-vulns"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1spirikck7a1adsn0lz8s9qwgjci09yah24qz58b38kqh1f4kvs2";
      type = "gem";
    };
    version = "1.1.1";
  };
  ronin-fuzzer = {
    dependencies = [
      "combinatorics"
      "ronin-core"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ikvyy7xa1z9p4ww7fgxzn0kqv2knz1c5nb9hhk5k47j4rrlxlky";
      type = "gem";
    };
    version = "0.2.0";
  };
  ronin-listener = {
    dependencies = [
      "ronin-core"
      "ronin-listener-dns"
      "ronin-listener-http"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0iashm02jlfk1w0v9y03r595jb1v2mh4raa6mcvdz2gsjvpngd4a";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-listener-dns = {
    dependencies = [ "async-dns" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nh990mykhjrpnzqnypgm6csrhb8xkvd1r2m7skx67jdyyh42b5w";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-listener-http = {
    dependencies = [ "async-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0nqg61n1ladrg9cfwb1w8l9i14020crhpxnjqhc36zwmshi28rz2";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-masscan = {
    dependencies = [
      "csv"
      "ronin-core"
      "ronin-db"
      "ruby-masscan"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0g4vq16qqrrmdr8nsg1kyl7w7v7p61j8kk0lkjwg4i22lyz8w464";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-nmap = {
    dependencies = [
      "csv"
      "ronin-core"
      "ronin-db"
      "ruby-nmap"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xf7hdxd3vl9lkmx4hlq75jgvv4qzk01v34fdwgxny6r684lngd4";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-payloads = {
    dependencies = [
      "ronin-code-asm"
      "ronin-core"
      "ronin-post_ex"
      "ronin-repos"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0bzw3y3m1p743ifandylmfgdlfx8j03iv8ii5wih18gyv6h0q27x";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-post_ex = {
    dependencies = [
      "fake_io"
      "hexdump"
      "ronin-core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dcpnlz8niqjjm5d9z8khg53acl7xn5dgliv70svsncc3h0hx0w7";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-recon = {
    dependencies = [
      "async-dns"
      "async-http"
      "async-io"
      "ronin-core"
      "ronin-db"
      "ronin-masscan"
      "ronin-nmap"
      "ronin-repos"
      "ronin-support"
      "ronin-web-spider"
      "thread-local"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11fqjhl3dckwz9rm9zff2kwf38026799sq6d89cnwajr6pwz6ffh";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-repos = {
    dependencies = [ "ronin-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "15np60qj069235gnmgsv3yy3jlj2w4ypdh5dblhxcrwq8fhawcwy";
      type = "gem";
    };
    version = "0.2.0";
  };
  ronin-support = {
    dependencies = [
      "addressable"
      "base64"
      "chars"
      "combinatorics"
      "hexdump"
      "uri-query_params"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dff85yirfzdskchzhx2vd0l39vndw76iddayii1hgwffqwmbr9f";
      type = "gem";
    };
    version = "1.1.1";
  };
  ronin-support-web = {
    dependencies = [
      "nokogiri"
      "nokogiri-ext"
      "ronin-support"
      "websocket"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09gg2zmapg9qyrsszfn0w2qsdrh7jx50hbbq77b52dqz3jxvy4qc";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-vulns = {
    dependencies = [
      "base64"
      "ronin-core"
      "ronin-db"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11pmxl73g6wdk702g6rz4igy207a8bq8yfm8n8hwaq8v8bw2y1rx";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-web = {
    dependencies = [
      "nokogiri"
      "nokogiri-diff"
      "open_namespace"
      "robots"
      "ronin-core"
      "ronin-support"
      "ronin-support-web"
      "ronin-vulns"
      "ronin-web-browser"
      "ronin-web-server"
      "ronin-web-session_cookie"
      "ronin-web-spider"
      "ronin-web-user_agents"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09xdwiz33v1n6ygkz2bi564gsvrypfsg236aisrlnskwc403dx9i";
      type = "gem";
    };
    version = "2.0.1";
  };
  ronin-web-browser = {
    dependencies = [
      "ferrum"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d0d4mw5gs3a8a0pzvnil4sbhyh84davly0q2z2h7967dxa7rfyg";
      type = "gem";
    };
    version = "0.1.0";
  };
  ronin-web-server = {
    dependencies = [
      "rack"
      "rack-user_agent"
      "ronin-support"
      "sinatra"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pv018w05yx0qmxnygvr42aa7jixyjihnf1n54wh9zwqbwk110qh";
      type = "gem";
    };
    version = "0.1.2";
  };
  ronin-web-session_cookie = {
    dependencies = [
      "base64"
      "python-pickle"
      "rack-session"
      "ronin-support"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vr5wkhls77a1vpy1lnzs3wickn3x6pv42wmdv1jhxz9r9qiwigp";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-web-spider = {
    dependencies = [
      "ronin-support"
      "spidr"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cdv1ypqa6r3hpzmdw52lfp9i32yaxcsdjr6pjys3r8phvglgg3w";
      type = "gem";
    };
    version = "0.2.1";
  };
  ronin-web-user_agents = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06y0l85qn0j6lvfmj9sfvbakbfjn0m3s78aghf03gk0p837r0711";
      type = "gem";
    };
    version = "0.1.1";
  };
  ronin-wordlists = {
    dependencies = [
      "ronin-core"
      "wordlist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09yb1dnaygq86ahhq9hhh5ddl2ylawjg68m3nz2cv43h85ax2xsa";
      type = "gem";
    };
    version = "0.1.0";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dnfkrk8xx2m8r3r9m2p5xcq57viznyc09k7r3i4jbm758i57lx3";
      type = "gem";
    };
    version = "3.30.0";
  };
  ruby-masscan = {
    dependencies = [ "command_mapper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "018jjdah2zyw12wcyk0qmislysb9847wisyv593r4f9m8aq5ppbi";
      type = "gem";
    };
    version = "0.3.0";
  };
  ruby-nmap = {
    dependencies = [
      "command_mapper"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17a0qgj0sk8dyw80pnvih81027f1mnf4a1xh1vj6x48xajzvsdmy";
      type = "gem";
    };
    version = "1.0.3";
  };
  ruby-yasm = {
    dependencies = [ "command_mapper" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06gdp5d5mw7rs4qh6m2nar8yir8di0n8cqrc5ls6zpw18lsbzyfd";
      type = "gem";
    };
    version = "0.3.1";
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
  sidekiq = {
    dependencies = [
      "base64"
      "connection_pool"
      "logger"
      "rack"
      "redis-client"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19xm4s49hq0kpfbmvhnjskzmfjjxw5d5sm7350mh12gg3lp7220i";
      type = "gem";
    };
    version = "7.3.9";
  };
  sinatra = {
    dependencies = [
      "mustermann"
      "rack"
      "rack-protection"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "01wq20aqk5kfggq3wagx5xr1cz0x08lg6dxbk9yhd1sf0d6pywkf";
      type = "gem";
    };
    version = "3.2.0";
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
      sha256 = "1hggy6m87bam8h3hs2d7m9wnfgw0w3fzwi60jysyj8icxghsjchc";
      type = "gem";
    };
    version = "3.2.0";
  };
  sinatra-flash = {
    dependencies = [ "sinatra" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vhpyzv3nvx6rl01pgzg5a9wdarb5iccj73gvk6hv1218gd49w7y";
      type = "gem";
    };
    version = "0.3.0";
  };
  spidr = {
    dependencies = [
      "base64"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bj2ylgc96sl8r5bhxj9zbd0m3mmiz4sj06b8xmvj8li8ws0lpqj";
      type = "gem";
    };
    version = "0.7.2";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "073hd24qwx9j26cqbk0jma0kiajjv9fb8swv9rnz8j4mf0ygcxzs";
      type = "gem";
    };
    version = "1.7.3";
  };
  tdiff = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c4kaj6yqh84rln9iixvcngyf0ghrcr9baysvdr2cjbyh19vwnv8";
      type = "gem";
    };
    version = "0.4.0";
  };
  thread-local = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1ryjgfwcsbkxph1l24x87p1yabnnbqy958s57w37iwhf3z9nid9g";
      type = "gem";
    };
    version = "1.1.0";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19d3k8ym9bj9j98zmc0pbjnwqdg4mqabnh8hm7lrdfhb5383amys";
      type = "gem";
    };
    version = "2.9.0";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1arxpii25xgb3fkgqp5acyc0x6179j3qzld78lflgsdxqfcf897k";
      type = "gem";
    };
    version = "0.4.2";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1jxcji88mh6xsqz0mfzwnxczpg7cyniph7wpavnavfz7lxl77xbq";
      type = "gem";
    };
    version = "0.6.1";
  };
  tsort = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17q8h020dw73wjmql50lqw5ddsngg67jfw8ncjv476l5ys9sfl4n";
      type = "gem";
    };
    version = "0.2.0";
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
  uri-query_params = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0z7w39zz9pfs5zcjkk5ga6q0yadc82kn1wlhmj6f56bj0jpdnlbi";
      type = "gem";
    };
    version = "0.8.2";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ca1hr2rxrfw7s613rp4r4bxb454i3ylzniv9b9gxpklqigs3d5y";
      type = "gem";
    };
    version = "1.9.2";
  };
  websocket = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dr78vh3ag0d1q5gfd8960g1ca9g6arjd2w54mffid8h4i7agrxp";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ij19k6034x0c4hw0ywa7wnk5s912r8aq0hhjss10d5z36q5dicp";
      type = "gem";
    };
    version = "0.8.2";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      type = "gem";
    };
    version = "0.1.5";
  };
  woothee = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xg31qi09swgsf46b9ba38z2jav2516bg3kg7xf1wfbzw8mpd3fc";
      type = "gem";
    };
    version = "1.13.0";
  };
  wordlist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lg0sp95ny4i62n9zw0mc87i5vdrwm4g692f0lv9wc6ad0xd5gmd";
      type = "gem";
    };
    version = "1.1.1";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1rcjpgyzmdxp8rdw466156fmr588k9q1wg8j42g0dkk7hid1519c";
      type = "gem";
    };
    version = "2.8.3";
  };
}
