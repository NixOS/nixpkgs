{
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DNfH+CTgEMBy4z9ovALYWgCutvzgW7SBnAPf08FAwok=";
      type = "gem";
    };
    version = "2.8.9";
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
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
}
