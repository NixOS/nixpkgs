{
  comp_tree = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dj9lkfxcczn67l1j12dcxswrfxxd1zgxa344zk6vqs2gwwhy9m9";
      type = "gem";
    };
    version = "1.1.3";
  };
  drake = {
    dependencies = [ "comp_tree" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "09gkmdshwdmdnkdxi03dv4rk1dip0wdv6dx14wscrmi0jyk86yag";
      type = "gem";
    };
    version = "0.9.2.0.3.1";
  };
}
