{
  cmdparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-98XKzhC+xqv4UzcK4JXkuXqE7Z2Eez+zj0HMT7yVBzk=";
      type = "gem";
    };
    version = "3.0.7";
  };
  geom2d = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6gmY6pDE8nUuJP4T2FpPib7midFRMWFA68xjab9jTtk=";
      type = "gem";
    };
    version = "0.4.1";
  };
  hexapdf = {
    dependencies = [
      "cmdparse"
      "geom2d"
      "openssl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jERBhjXCvLI9rPiUaoS+or8PzwqAvknho3Kw4yzTq40=";
      type = "gem";
    };
    version = "1.0.2";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PEu4dgl3tL7NKBnGwlabz1xvSLMrn3pM4f03+ZY3jRQ=";
      type = "gem";
    };
    version = "3.2.0";
  };
}
