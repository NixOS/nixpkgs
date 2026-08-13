{
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fzqwshg1xzbdm97havskfp6wifsgbjii00dzba0y6bih4lk1jk1";
      type = "gem";
    };
    version = "0.5.2";
  };
  data_uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0fzkxgdxrlbfl4537y3n9mjxbm28kir639gcw3x47ffchwsgdcky";
      type = "gem";
    };
    version = "0.1.0";
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
  erb = {
    dependencies = [ "cgi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "097f4xvjq5k0m0i9mjwpl8vmqrl1wpbllc624f6fqk5s484sgqj7";
      type = "gem";
    };
    version = "4.0.4.1";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kqasqvy8d7r09ri4n6bkdwbk63j7afd9ilsw34nzlgh0qp69ldw";
      type = "gem";
    };
    version = "1.17.4";
  };
  ffi-rzmq = {
    dependencies = [ "ffi-rzmq-core" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14a5kxfnf8l3ngyk8hgmk30z07aj1324ll8i48z67ps6pz2kpsrg";
      type = "gem";
    };
    version = "2.0.7";
  };
  ffi-rzmq-core = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0amkbvljpjfnv0jpdmz71p1i3mqbhyrnhamjn566w0c01xd64hb5";
      type = "gem";
    };
    version = "1.0.7";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k0lk3pwadm2myvpg893n8jshmrf2sigrd4ki15lymy7gixaxqyn";
      type = "gem";
    };
    version = "0.8.2";
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
  iruby = {
    dependencies = [
      "data_uri"
      "ffi-rzmq"
      "irb"
      "logger"
      "mime-types"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "13qdw2ykzn6yjs4biiyvy1dr5j5v3kb1q7r98ds0kvg22rbs1s56";
      type = "gem";
    };
    version = "0.8.3";
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
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mjyxl7c0xzyqdqa8r45hqg7jcw2prp3hkp39mdf223g4hfgdsyw";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1k28j6ww8rf43r5i8278jvm2cq3pnzsvqm7yqpb4p93kadjlq726";
      type = "gem";
    };
    version = "3.2026.0414";
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
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1dx5bc3s1mb1i53np4cdkypg7ccygnvagr3hglyndbqilrljvxql";
      type = "gem";
    };
    version = "5.4.0";
  };
  rdoc = {
    dependencies = [
      "erb"
      "psych"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14iiyb4yi1chdzrynrk74xbhmikml3ixgdayjma3p700singfl46";
      type = "gem";
    };
    version = "7.2.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0d8q5c4nh2g9pp758kizh8sfrvngynrjlm0i1zn3cnsnfd4v160i";
      type = "gem";
    };
    version = "0.6.3";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1q92y9627yisykyscv0bdsrrgyaajc2qr56dwlzx7ysgigjv4z63";
      type = "gem";
    };
    version = "3.2.0";
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
}
