{
  colsole = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-byWCOax5ICN7HY77Eg0Vd2CpKKoNfCLwmXJrLn4zbrs=";
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
      hash = "sha256-yNGSJ9s3E1koBEe+T2jeq2mliTElptD28VtAUj5VSQQ=";
      type = "gem";
    };
    version = "0.7.1";
  };
  docopt_ng = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oCQUjuT6OrGooEQRqkNw85zytEbmNWIJfUGLeXShVmc=";
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
      hash = "sha256-3gXuVU1CIvcTw5ADQ70G/98VcLbs9duEpf/lbvzd4/8=";
      type = "gem";
    };
    version = "0.8.1";
  };
}
