{
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
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
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
      sha256 = "0dikardh14c72gd9ypwh8dim41wvqmzfzf35mincaj5yals9m7ff";
      type = "gem";
    };
    version = "0.6.0";
  };
  irb = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "158ca10kj3qqnql5g8f1g2arsnhgdl79mg74manpf8ldkwjjn3n8";
      type = "gem";
    };
    version = "1.7.4";
  };
  iruby = {
    dependencies = [
      "data_uri"
      "ffi-rzmq"
      "irb"
      "mime-types"
      "multi_json"
      "native-package-installer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0856ncjk7akm55gxcnhfmv426xsl4ryywdxrqbwgphwpqwm9w8fc";
      type = "gem";
    };
    version = "0.7.4";
  };
  mime-types = {
    dependencies = [ "mime-types-data" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0q8d881k1b3rbsfcdi3fx0b5vpdr5wcrhn88r2d9j7zjdkxp5mw5";
      type = "gem";
    };
    version = "3.5.1";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17zdim7kzrh5j8c97vjqp4xp78wbyz7smdp4hi5iyzk0s9imdn5a";
      type = "gem";
    };
    version = "3.2023.0808";
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
  native-package-installer = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "004wx9xhcam92g1d4ybvrl1yqablm2svalyck9sq4igy9nwkz9nb";
      type = "gem";
    };
    version = "1.1.8";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0lv1nv7z63n4qmsm3h5h273m7daxngkcq8ynkk9j8lmn7jji98lb";
      type = "gem";
    };
    version = "0.3.8";
  };
}
