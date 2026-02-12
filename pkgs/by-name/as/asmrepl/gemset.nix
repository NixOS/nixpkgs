{
  asmrepl = {
    dependencies = [ "fisk" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qvkqn34ldlip2yz3kdckqmvniyydswcclwdcalcpdwnahg25xjw";
      type = "gem";
    };
    version = "1.2.0";
  };
  fisk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zypl29fpqd5pqkp8j67xnq9b2dwhl8kn01fyw1kxy9l2676dlmh";
      type = "gem";
    };
    version = "2.3.2";
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
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rbs = {
    dependencies = [
      "logger"
      "tsort"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "19nsjb0wkb1zk274q0zy41hfzqraanar3jg6akak8q8134wpyqkh";
      type = "gem";
    };
    version = "3.10.3";
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
