{
  cmdparse = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0f87jny4zk21iyrkyyw4kpnq8ymrwjay02ipagwapimy237cmigp";
      type = "gem";
    };
    version = "3.0.7";
  };
  geom2d = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1nafcfznjqycxd062cais64ydgl99xddh4zy4hp7bwn4j3m9h2ga";
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
      sha256 = "182bjblyncngdyx3376lzqxabl9klgdv9pqmrpayvw0x46kk1phj";
      type = "gem";
    };
    version = "0.45.0";
  };
  openssl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "054d6ybgjdzxw567m7rbnd46yp6gkdbc5ihr536vxd3p15vbhjrw";
      type = "gem";
    };
    version = "3.2.0";
  };
}
