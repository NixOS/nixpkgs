{
  exifr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-doN0zGtv83Q6y6V8HDUim92Ma5+8EoWVIEf8EhXEuJQ=";
      type = "gem";
    };
    version = "1.4.1";
  };
  fspath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-taybr7l+LI+PnjA82Y69SEvnb+mqWIvE0BxtmeeMnXU=";
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
      hash = "sha256-W//QiRJo6NGJ1G7kuFmZGFgbuhAy0kTmrOR3mkNHdsA=";
      type = "gem";
    };
    version = "0.31.4";
  };
  image_size = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xqWAUT/nSUfiXl0/CuoeM63Wwg99AAfvplUEMXt/Apo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  in_threads = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kafmE40nncYy9ZuKmkCeRxSJSOKXwPackvmiR5oYIUk=";
      type = "gem";
    };
    version = "1.6.0";
  };
  progress = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ng7TBt+kPWF06EfVY8cHNtyiSeIzPP7EsDhzBshs1XM=";
      type = "gem";
    };
    version = "3.6.0";
  };
}
