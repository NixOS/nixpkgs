{
  daemons = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l5gai3vd4g7aqff0k1mp41j9zcsvm2rbwmqn115a325k9r7pf4w";
      type = "gem";
    };
    version = "1.3.1";
  };
  eventmachine = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wh9aqb0skz80fhfn66lbpr4f86ya2z5rx6gm5xlfhd05bj1ch4r";
      type = "gem";
    };
    version = "1.2.7";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lrirj0gw420kw71bjjlqkqhqbrplla61gbv1jzgsz6bv90qr3ci";
      type = "gem";
    };
    version = "2.5.1";
  };
  mustermann = {
    dependencies = ["ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ccm54qgshr1lq3pr1dfh7gphkilc19dp63rw6fcx7460pjwy88a";
      type = "gem";
    };
    version = "1.1.1";
  };
  optimist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vg2chy1cfmdj6c1gryl8zvjhhmb3plwgyh1jfnpq4fnfqv7asrk";
      type = "gem";
    };
    version = "3.0.1";
  };
  pifi = {
    dependencies = ["json" "optimist" "ruby-mpd" "sinatra" "thin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xwjaql852m0p7himc3pak1ibc8lfxi29bbgic153wp713xc2cga";
      type = "gem";
    };
    version = "0.4.11";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i5vs0dph9i5jn8dfc6aqd6njcafmb20rwqngrf759c9cvmyff16";
      type = "gem";
    };
    version = "2.2.3";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "159a4j4kragqh0z0z8vrpilpmaisnlz3n7kgiyf16bxkwlb3qlhz";
      type = "gem";
    };
    version = "2.1.0";
  };
  ruby-mpd = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l80gbnma009pfcqgz4azbngkr5jn9nm46fflx5p7c4vz4kwshpc";
      type = "gem";
    };
    version = "0.3.3";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15wfcqxyfgka05v2a7kpg64x57gl1y4xzvnc9lh60bqx5sf1iqrs";
      type = "gem";
    };
    version = "0.0.4";
  };
  sinatra = {
    dependencies = ["mustermann" "rack" "rack-protection" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dd53rzpkxgs697pycbhhgc9vcnxra4ly4xar8ni6aiydx2f88zk";
      type = "gem";
    };
    version = "2.1.0";
  };
  thin = {
    dependencies = ["daemons" "eventmachine" "rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g5p3r47qxxfmfagdf8wb68pd24938cgzdfn6pmpysrn296pg5m5";
      type = "gem";
    };
    version = "1.8.0";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rn8z8hda4h41a64l0zhkiwz2vxw9b1nb70gl37h1dg2k874yrlv";
      type = "gem";
    };
    version = "2.0.10";
  };
}
