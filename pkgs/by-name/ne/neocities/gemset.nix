{
  equatable = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sjm9zjakyixyvsqziikdrsqfzis6j3fq23crgjkp6fwkfgndj7x";
      type = "gem";
    };
    version = "0.5.0";
  };
  httpclient-fixcerts = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zfszylh51y8ic8sbff3mwf30jb0gj270r5nxkcm1ydxad19w6sl";
      type = "gem";
    };
    version = "2.8.5";
  };
  necromancer = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v9nhdkv6zrp7cn48xv7n2vjhsbslpvs0ha36mfkcd56cp27pavz";
      type = "gem";
    };
    version = "0.4.0";
  };
  neocities = {
    dependencies = ["httpclient-fixcerts" "pastel" "rake" "tty-prompt" "tty-table"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hfvy4gc7rzxkgl2dbrjs2fqzi5mphmr22rjfhk6n0i3bd0wazbw";
      type = "gem";
    };
    version = "0.0.18";
  };
  pastel = {
    dependencies = ["equatable" "tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yf30d9kzpm96gw9kwbv31p0qigwfykn8qdis5950plnzgc1vlp1";
      type = "gem";
    };
    version = "0.7.2";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1cvaqarr1m84mhc006g3l1vw7sa5qpkcw0138lsxlf769zdllsgp";
      type = "gem";
    };
    version = "12.3.3";
  };
  strings = {
    dependencies = ["strings-ansi" "unicode-display_width" "unicode_utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "111876lcqrykh30w7zzkrl06d6rj9lq24y625m28674vgfxkkcz0";
      type = "gem";
    };
    version = "0.1.8";
  };
  strings-ansi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zz5xa6xbrj69h334d8nx7z732fz80s1a0b02b53mim95p80s7bk";
      type = "gem";
    };
    version = "0.4.3";
  };
  tty-cursor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07whfm8mnp7l49s2cm2qy1snhsqq3a90sqwb71gvym4hm2kx822a";
      type = "gem";
    };
    version = "0.4.0";
  };
  tty-prompt = {
    dependencies = ["necromancer" "pastel" "tty-cursor" "wisper"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1026nyqhgmgxi2nmk8xk3hca07gy5rpisjs8y6w00wnw4f01kpv0";
      type = "gem";
    };
    version = "0.12.0";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0azpjgyhdm8ycblnx9crq3dgb2x8yg454a13n60zfpsc0n138sw1";
      type = "gem";
    };
    version = "0.6.5";
  };
  tty-table = {
    dependencies = ["equatable" "necromancer" "pastel" "strings" "tty-screen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05krrj1x5pmfbz74paszrsr1316w9b9jlc4wpd9s9gpzqfzwjzcg";
      type = "gem";
    };
    version = "0.10.0";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1204c1jx2g89pc25qk5150mk7j5k90692i7ihgfzqnad6qni74h2";
      type = "gem";
    };
    version = "1.8.0";
  };
  unicode_utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      type = "gem";
    };
    version = "1.4.0";
  };
  wisper = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19bw0z1qw1dhv7gn9lad25hgbgpb1bkw8d599744xdfam158ms2s";
      type = "gem";
    };
    version = "1.6.1";
  };
}
