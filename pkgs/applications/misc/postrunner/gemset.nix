{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bmlqjb5h1ry6wm2d903d6yxibpqzzxwqczvlicsqv0vilaca5ic";
      type = "gem";
    };
    version = "2.4.8";
  };
  fit4ruby = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ljrlq6h0c29crbisx6ych2m9yq19i2z86rwjv03dmzq1yg6gwz";
      type = "gem";
    };
    version = "3.8.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xmf60nj5kg9vaj5bysy308687sgmkasgx06vbbnf94p52ih7si2";
      type = "gem";
    };
    version = "1.10.10";
  };
  perobs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cygqn869fvlsiq27qfg5ak8dr7pagp8yqr34h0hvzg8h8yq9fjq";
      type = "gem";
    };
    version = "4.3.0";
  };
  postrunner = {
    dependencies = ["fit4ruby" "nokogiri" "perobs"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xr00f79pk61p79bmy8vrj91d8d5cz7841r0gv6913mzy4nw6czj";
      type = "gem";
    };
    version = "1.0.4";
  };
}
