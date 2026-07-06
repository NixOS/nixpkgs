{
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
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "038cqc1kzxl22m3jfspkdpg0dxskga9jvgwclb4pivcjqxi62d4m";
      type = "gem";
    };
    version = "4.35.0";
  };
  pg_query = {
    dependencies = [ "google-protobuf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0vwvfxz4gp5xqrv4jwyqigfkpldjqp6mbzvskapwiyncc10ijv1i";
      type = "gem";
    };
    version = "6.2.2";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "009p524zl0p0kfa65nii8wdmaigkmawv9pbvlcffky7islmmp0nb";
      type = "gem";
    };
    version = "13.4.2";
  };
  sqlint = {
    dependencies = [ "pg_query" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "06gljzjhbfvxs85699jr1p7y2j8hhi629kfarad7yjqy7ssl541n";
      type = "gem";
    };
    version = "0.3.0";
  };
}
