{
  exifr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "155qqhai5z2742aqa4mwkxmqrpcv48siqz55rcx79wvgdg6790vn";
      type = "gem";
    };
    version = "1.4.1";
  };
  fspath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xcxikkrjv8ws328nn5ax5pyfjs8pn7djg1hks7qyb3yp6prpb5m";
      type = "gem";
    };
    version = "3.1.2";
  };
  image_optim = {
    dependencies = [
      "exifr"
      "fspath"
      "image_size"
      "in_threads"
      "progress"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h3n8x1rlxz4mkk49lij22x1nn0qk5cvir3fsj4x3s382a4x1zsv";
      type = "gem";
    };
    version = "0.31.4";
  };
  image_size = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "16h2gxxk212mlvphf03x1z1ddb9k3vm0lgsxbvi4fjg77x8q19f6";
      type = "gem";
    };
    version = "3.4.0";
  };
  in_threads = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0j9132d4g8prjafgdh4pw948j527kr09m2lvylrcd797il9yd9wi";
      type = "gem";
    };
    version = "1.6.0";
  };
  progress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0wymdk40cwrqn32gwg1kw94s5p1n0z3n7ma7x1s62gd4vw3d63in";
      type = "gem";
    };
    version = "3.6.0";
  };
}
