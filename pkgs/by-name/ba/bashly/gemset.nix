{
  bashly = {
    dependencies = ["colsole" "completely" "filewatcher" "gtx" "lp" "mister_bin" "psych" "tty-markdown"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rhzbpv8j5qcm5a84m4vzrryb0j8z90q6djbpid4ay2fr492kvkq";
      type = "gem";
    };
    version = "1.1.1";
  };
  colsole = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvf6dz2wsvjk7q24z0dm8lajq3p2l6i5ywf3mxj683rmhwq49bg";
      type = "gem";
    };
    version = "1.0.0";
  };
  completely = {
    dependencies = ["colsole" "mister_bin"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01nk1cigb09z6rjy41qrhqf58cgpqm43xwjdkz33mfmwrnz04cw1";
      type = "gem";
    };
    version = "0.6.1";
  };
  docopt_ng = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rsnl5s7k2s1gl4n4dg68ssg577kf11sl4a4l2lb2fpswj718950";
      type = "gem";
    };
    version = "0.7.1";
  };
  filewatcher = {
    dependencies = ["module_methods"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03f9v57c5zag09mi10yjhdx7y0vv2w5wrnwzbij9hhkwh43rk077";
      type = "gem";
    };
    version = "2.1.0";
  };
  gtx = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "10hfhicvv371gy1i16x6vry1xglvxl0zh7qr6f14pqsx32qih6ff";
      type = "gem";
    };
    version = "0.1.0";
  };
  kramdown = {
    dependencies = ["rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ic14hdcqxn821dvzki99zhmcy130yhv5fqfffkcf87asv5mnbmn";
      type = "gem";
    };
    version = "2.4.0";
  };
  lp = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ns1aza32n929w7smg1dsn4g6qlfi7k1jrvssyn35cicmwn0gyyr";
      type = "gem";
    };
    version = "0.2.1";
  };
  mister_bin = {
    dependencies = ["colsole" "docopt_ng"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xx8cxvzcn47zsnshcllf477x4rbssrchvp76929qnsg5k9q7fas";
      type = "gem";
    };
    version = "0.7.6";
  };
  module_methods = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1886wjscfripgzlmyvcd0jmlzwr6hxvklm2a5rm32dw5bf7bvjki";
      type = "gem";
    };
    version = "0.1.0";
  };
  pastel = {
    dependencies = ["tty-color"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xash2gj08dfjvq4hy6l1z22s5v30fhizwgs10d6nviggpxsj7a8";
      type = "gem";
    };
    version = "0.8.0";
  };
  psych = {
    dependencies = ["stringio"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wjzrkssjfjpynij5dpycyflhqbjvi1gc2j73xgq3b196s1d3c24";
      type = "gem";
    };
    version = "5.1.1.1";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05i8518ay14kjbma550mv0jm8a6di8yp5phzrd8rj44z9qnrlrp0";
      type = "gem";
    };
    version = "3.2.6";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19drl3x8fw65v3mpy7fk3cf3dfrywz5alv98n2rm4pp04vdn71lw";
      type = "gem";
    };
    version = "4.1.3";
  };
  stringio = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ix96dxbjqlpymdigb4diwrifr0bq7qhsrng95fkkp18av326nqk";
      type = "gem";
    };
    version = "3.0.8";
  };
  strings = {
    dependencies = ["strings-ansi" "unicode-display_width" "unicode_utils"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yynb0qhhhplmpzavfrrlwdnd1rh7rkwzcs4xf0mpy2wr6rr6clk";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "120wa6yjc63b84lprglc52f40hx3fx920n4dmv14rad41rv2s9lh";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-color = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aik4kmhwwrmkysha7qibi2nyzb4c8kp42bd5vxnf8sf7b53g73g";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-markdown = {
    dependencies = ["kramdown" "pastel" "rouge" "strings" "tty-color" "tty-screen"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04f599zn5rfndq4d9l0acllfpc041bzdkkz2h6x0dl18f2wivn0y";
      type = "gem";
    };
    version = "0.7.2";
  };
  tty-screen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18jr6s1cg8yb26wzkqa6874q0z93rq0y5aw092kdqazk71y6a235";
      type = "gem";
    };
    version = "0.8.1";
  };
  unicode-display_width = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d0azx233nags5jx3fqyr23qa2rhgzbhv8pxp46dgbg1mpf82xky";
      type = "gem";
    };
    version = "2.5.0";
  };
  unicode_utils = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h1a5yvrxzlf0lxxa1ya31jcizslf774arnsd89vgdhk4g7x08mr";
      type = "gem";
    };
    version = "1.4.0";
  };
}
