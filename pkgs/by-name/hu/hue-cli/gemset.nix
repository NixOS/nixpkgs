{
  hue-cli = {
    dependencies = [
      "hue-lib"
      "json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10gjf59pamfy2m17fs271d9ffrg1194b1m6vxzn6p7smzry52h9z";
      type = "gem";
    };
    version = "0.1.4";
  };
  hue-lib = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1pyl8g8gisdhl79gbzvnddqrsbq0lmflzg7n6yi6xrp5b5290shz";
      type = "gem";
    };
    version = "0.7.4";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "098m3q2jrx4xbf0knrbmflsynmmb5x9q9b0bzpmj7jmm1cr30mna";
      type = "gem";
    };
    version = "2.16.0";
  };
}
