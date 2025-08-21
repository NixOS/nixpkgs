{
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1bzxvccj8349slymls7navb5y14anglkkasphcd6gi72kqgqd643";
      type = "gem";
    };
    version = "7.2.2.1";
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
      sha256 = "1fgscw775wj4l7f5pj274a984paz23zy0111giqkhl9dqdqiz8vr";
      type = "gem";
    };
    version = "7.2.2.1";
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
      sha256 = "1xa7hr4gp2p86ly6n1j2skyx8pfg6yi621kmnh7zhxr9m7wcnaw4";
      type = "gem";
    };
    version = "7.2.2.1";
  };
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
  async = {
    dependencies = [
      "console"
      "fiber-annotation"
      "io-event"
      "metrics"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0p29xccd3y96m7yb15yr96j362cz855ramn2x83g5z2642ag68w3";
      type = "gem";
    };
    version = "2.23.0";
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
      "metrics"
      "protocol-http"
      "protocol-http1"
      "protocol-http2"
      "traces"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "100s02s6cxzccsr5fdvi4yx7fzscps429mnaabiiwyxpggdz0pzv";
      type = "gem";
    };
    version = "0.87.0";
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
      sha256 = "12h0cmbw8sjlbfkng94wmb9d5mkrpc468ms40mnkvz9lrkggjhmm";
      type = "gem";
    };
    version = "0.10.3";
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
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0jl71qcgamm96dzyqk695j24qszhcc7liw74qc83fpjljp2gh4hg";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k6qzammv9r6b2cw3siasaik18i6wjc5m0gw5nfdc6jj64h79z1g";
      type = "gem";
    };
    version = "3.1.9";
  };
  chars = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vmpki1q4glglfp25flb2i6qy6jj80438z5x4rdqrcvvm869w8sd";
      type = "gem";
    };
    version = "0.3.3";
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
      sha256 = "1z7bag6zb2vwi7wp2bkdkmk7swkj6zfnbsnc949qq0wfsgw94fr3";
      type = "gem";
    };
    version = "2.5.0";
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
      sha256 = "00bd8bcra7sh9cnr9xm83gqv7npj15ksjpq2hkm0g36m3634v5dd";
      type = "gem";
    };
    version = "1.29.3";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kmx36jjh2sahd989vcvw74lrlv07dqc3rnxchc5sj2ywqsw3w3g";
      type = "gem";
    };
    version = "3.3.2";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kz6mc4b9m49iaans6cbx031j9y7ldghpi5fzsdh0n3ixwa8w9mz";
      type = "gem";
    };
    version = "3.4.1";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0h5kbj9hvg5hb3c7l425zpds0vb42phvln2knab8nmazg2zp5m79";
      type = "gem";
    };
    version = "2.2.1";
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
      sha256 = "1a5g30p7kzp37n9w3idp3gy70hzkj30d8j951lhw2zsnb0l8cbc8";
      type = "gem";
    };
    version = "1.3.0";
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
      sha256 = "15di39ssfkwigyyqla65n4x6cfhgwa4cv8j5lmyrlr07jwd840q9";
      type = "gem";
    };
    version = "1.1.0";
  };
  dry-inflector = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0blgyg9l4gpzhb7rs9hqq9j7br80ngiigjp2ayp78w6m1ysx1x92";
      type = "gem";
    };
    version = "1.2.0";
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
      sha256 = "1aa2ywjw2lwag18141z0b3sz3a2rgwinna1gpdy5jh1029g62h7c";
      type = "gem";
    };
    version = "1.14.0";
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
      sha256 = "1bjkxrmsi8wbymkx44fm0fyv89zpcw0a09np67ak4sd34hx92022";
      type = "gem";
    };
    version = "1.7.1";
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
      sha256 = "03zcngwfpq0nx9wmxma0s1c6sb3xxph93q8j7dy75721d7d9lkn8";
      type = "gem";
    };
    version = "1.8.2";
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
      "webrick"
      "websocket-driver"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1lwdra73yxinx9c2gffq5b7778b4dpfpwnw46ds7wshk4j2z7rnf";
      type = "gem";
    };
    version = "0.16";
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
      sha256 = "0zxblmxwdpj3587wji5325y53gjdcmzxzm6126dyg58b3qzk42mq";
      type = "gem";
    };
    version = "1.0.0";
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
      sha256 = "03sx3ahz1v5kbqjwxj48msw3maplpp2iyzs22l4jrzrqh4zmgfnf";
      type = "gem";
    };
    version = "1.14.7";
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
      sha256 = "18pgvl7lfjpichdfh1g50rpz0zpaqrpr52ybn9liv1v9pjn9ysnd";
      type = "gem";
    };
    version = "0.8.0";
  };
  io-endpoint = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09cghz7i1hpvz2skc0k0h6i60551mc2wafmlfn02hi9rd2xr0zhy";
      type = "gem";
    };
    version = "0.15.2";
  };
  io-event = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hag7zbmsvkbmv0486bxqvnngym4mhsj32aywwmklr5d21k2n9jc";
      type = "gem";
    };
    version = "1.9.0";
  };
  io-stream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vz9sad4kmgby53hn8jh31a462m9mkln7lxhk972dz9d870z0825";
      type = "gem";
    };
    version = "0.6.1";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1478m97wiy6nwg6lnl0szy39p46acsvrhax552vsh1s2mi2sgg6r";
      type = "gem";
    };
    version = "1.15.1";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1p4l5ycdxfsr8b51gnvlvhq6s21vmx9z4x617003zbqv3bcqmj6x";
      type = "gem";
    };
    version = "2.10.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "05s008w9vy7is3njblmavrbdzyrwwc1fsziffdr58w9pwqj8sqfx";
      type = "gem";
    };
    version = "1.6.6";
  };
  metrics = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1762zjanzjzr7jwig2arpj4h09ylhspipp9blx4pb9cjvgm8xv22";
      type = "gem";
    };
    version = "0.12.1";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0x8asxl83msn815lwmb2d7q5p29p7drhjv5va0byhk60v9n16iwf";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0izrg03wn2yj3gd76ck7ifbm9h2kgy8kpg4fk06ckpy4bbicmwlw";
      type = "gem";
    };
    version = "5.25.4";
  };
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "123ycmq6pkivv29bqbv79jv2cs04xakzd0fz1lalgvfs5nxfky6i";
      type = "gem";
    };
    version = "3.0.3";
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
      sha256 = "0kw7g0j35fla8438s90m72b3xr0mqnpgm910qcwrgnvyg903xmi8";
      type = "gem";
    };
    version = "0.3.8";
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
      sha256 = "1rgva7p9gvns2ndnqpw503mbd36i2skkggv0c0h192k8xr481phy";
      type = "gem";
    };
    version = "0.5.6";
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
      sha256 = "1a9www524fl1ykspznz54i0phfqya4x45hqaz67in9dvw1lfwpfr";
      type = "gem";
    };
    version = "2.7.4";
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
      sha256 = "0npx535cs8qc33n0lpbbwl0p9fi3a5bczn6ayqhxvknh9yqw77vb";
      type = "gem";
    };
    version = "1.18.3";
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
      sha256 = "1zxnfxjni0r9l2x42fyq0sqpnaf5nakjbap8irgik4kg1h9c6zll";
      type = "gem";
    };
    version = "0.6.2";
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
      sha256 = "1dvpyl26q3zm2ca1sys9r8lp5qryy8i6glaq4vdi4jd71sk9lhdm";
      type = "gem";
    };
    version = "0.49.0";
  };
  protocol-http1 = {
    dependencies = [ "protocol-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0sn3r9rzkwxwix1c8af1njwzxf1nmhn0xmi39pz0jsfa9hd9d4ll";
      type = "gem";
    };
    version = "0.30.0";
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
      sha256 = "0s575j0xp1xkb37640fgw7ldyy4hln8ji9nm9ysyk4p7hdq6x5li";
      type = "gem";
    };
    version = "0.22.1";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1vjrx3yd596zzi42dcaq5xw7hil1921r769dlbz08iniaawlp9c4";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vqcw3iwby3yc6avs1vb3gfd0vcp2v7q310665dvxfswmcf4xm31";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11xd3207k5rl6bz0qxhcb3zcr941rhx7ig2f19gxxmdk7s3hcp7j";
      type = "gem";
    };
    version = "6.6.0";
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
      sha256 = "12mv97fz3jp6nl4bc36wiqwdiivv5lgqcpfnan91w20rzapljk22";
      type = "gem";
    };
    version = "2.2.11";
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
      sha256 = "1l1gw8xx1g04kdxc89hsy4aawdz8r2an4b78yzk9cc3y8qmw16v7";
      type = "gem";
    };
    version = "0.5.3";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q2nkyk6r3m15a2an7lwm4ilkcxzdh3j93s4ib8sbzqb0xp70vvx";
      type = "gem";
    };
    version = "6.12.0";
  };
  redis = {
    dependencies = [ "redis-client" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0syhyw1bp9nbb0fvcmm58y1c6iav6xw6b4bzjz1rz2j1d7c012br";
      type = "gem";
    };
    version = "5.4.0";
  };
  redis-client = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1yin53x7d817rs55gyw93acc5fbbjfbd4vayz7z5q5f8h9kanfz3";
      type = "gem";
    };
    version = "0.23.2";
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
      sha256 = "1lirwlw59apc8m1wjk85y2xidiv0fkxjn6f7p84yqmmyvish6qjp";
      type = "gem";
    };
    version = "0.6.0";
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
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1j1mgvrgkxhadi6nb6pz1kcff7gsb5aivj1vfhsia4ssa5hj9adw";
      type = "gem";
    };
    version = "3.1.5";
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
      sha256 = "0szpapi229v3scrvw1pgy0vpjm7z3qlf58m1198kxn70cs278g96";
      type = "gem";
    };
    version = "2.6.0";
  };
  time = {
    dependencies = [ "date" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qgarmdyqypzsaanf4w9vqrd9axrcrjqilxwrfmxp954102kcpq3";
      type = "gem";
    };
    version = "0.4.1";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03p31w5ghqfsbz5mcjzvwgkw3h9lbvbknqvrdliy8pxmn9wz02cm";
      type = "gem";
    };
    version = "0.4.3";
  };
  traces = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "109dh1xmsmvkg1pf3306svigh3m8kdmjqlznyk4bi2r4nws7hm6j";
      type = "gem";
    };
    version = "0.15.2";
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
      sha256 = "12d9n8hll67j737ym2zw4v23cn4vxyfkb6vyv1rzpwv6y6a3qbdl";
      type = "gem";
    };
    version = "1.9.1";
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
      sha256 = "1d26l4qn55ivzahbc7fwc4k4z3j7wzym05i9n77i4mslrpr9jv85";
      type = "gem";
    };
    version = "0.7.7";
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
      sha256 = "0ws6rpyj0y9iadjg1890dwnnbjfdbzxsv6r48zbj7f8yn5y0cbl4";
      type = "gem";
    };
    version = "2.7.2";
  };
}
