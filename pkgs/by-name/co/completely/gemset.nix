{
  colsole = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1fvf6dz2wsvjk7q24z0dm8lajq3p2l6i5ywf3mxj683rmhwq49bg";
      type = "gem";
    };
    version = "1.0.0";
  };
  completely = {
    dependencies = [
      "colsole"
      "mister_bin"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ci8iza647hvc4f1cmf9mpsm3i78ysf6g6213wkyrr5jk296hjjb";
      type = "gem";
    };
    version = "0.6.3";
  };
  docopt_ng = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0rsnl5s7k2s1gl4n4dg68ssg577kf11sl4a4l2lb2fpswj718950";
      type = "gem";
    };
    version = "0.7.1";
  };
  mister_bin = {
    dependencies = [
      "colsole"
      "docopt_ng"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0xx8cxvzcn47zsnshcllf477x4rbssrchvp76929qnsg5k9q7fas";
      type = "gem";
    };
    version = "0.7.6";
  };
}
