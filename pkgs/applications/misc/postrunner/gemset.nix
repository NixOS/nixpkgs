{
  bindata = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06lqi4svq5qls9f7nnvd2zmjdqmi2sf82sq78ci5d78fq0z5x2vr";
      type = "gem";
    };
    version = "2.4.10";
  };
  fit4ruby = {
    dependencies = ["bindata"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s30g027v0pvk53fgkszm1qj7mmljgam4gwd9wbljap7i4c32w7d";
      type = "gem";
    };
    version = "3.9.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d3ga166pahsxavzwj19yjj4lr13rw1vsb36s2qs8blcxigrdp6z";
      type = "gem";
    };
    version = "2.7.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2" "racc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zqzawia52cdcmi55lp7v8jmiqyw7pcpwsksqlnirwfm3f7bnf11";
      type = "gem";
    };
    version = "1.13.1";
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
      sha256 = "116xs2zn1178906ybpfll3f1k0jai2ccr3bxq1c175faiskdalxg";
      type = "gem";
    };
    version = "1.0.5";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0la56m0z26j3mfn1a9lf2l03qx1xifanndf9p3vx1azf6sqy7v9d";
      type = "gem";
    };
    version = "1.6.0";
  };
}
