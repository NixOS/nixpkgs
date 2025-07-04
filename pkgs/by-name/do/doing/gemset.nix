{
  base64 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  chronic = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dm8vzOasPMFSJJ7Q8rgndw0+UX4uh8X7p+109IidLcM=";
      type = "gem";
    };
    version = "0.10.2";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b/DBNeZeSF0YZN3mwXA7YNNMyeGb7YRSg0oLKKUZvU4=";
      type = "gem";
    };
    version = "3.3.2";
  };
  deep_merge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g87To9f5X2felY0s5BsYdOg8jZT+Ldv/UMi0uCMjVjo=";
      type = "gem";
    };
    version = "1.2.2";
  };
  doing = {
    dependencies = [
      "base64"
      "chronic"
      "csv"
      "deep_merge"
      "gli"
      "haml"
      "logger"
      "ostruct"
      "parslet"
      "plist"
      "reline"
      "safe_yaml"
      "tty-link"
      "tty-markdown"
      "tty-progressbar"
      "tty-reader"
      "tty-screen"
      "tty-which"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V3oAAYuSUslxsDSA8E2SBFLJ9Fl51rOGYV9DzzfXVus=";
      type = "gem";
    };
    version = "2.1.88";
  };
  gli = {
    dependencies = [ "ostruct" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WA6NbIiw8PDLjossoYw0he0PdCzs6FXeRr+ONiAvXbA=";
      type = "gem";
    };
    version = "2.22.2";
  };
  haml = {
    dependencies = [
      "temple"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TEE6yT31oI04IqcvtBcApMn1sdGTuZMqN3YiiLdLCuA=";
      type = "gem";
    };
    version = "5.0.4";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  kramdown = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-h7u2q9nTzr5PwfM+Nnw5K0UA5vj6Gd1hwJcs9K/nNow=";
      type = "gem";
    };
    version = "2.5.1";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3WGNJOY3cVRycy5+7QLjPPvfVt6q0iXt0PH4nTgCQBc=";
      type = "gem";
    };
    version = "1.6.6";
  };
  ostruct = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CaP7fswfpAOfJUGMwFrpyCvVIEcsXGpvUV8D5JiMuBc=";
      type = "gem";
    };
    version = "0.6.1";
  };
  parslet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1FEwaV05tD1+apH00uxms4io2CK6443ptN6aX73h9gY=";
      type = "gem";
    };
    version = "2.0.0";
  };
  pastel = {
    dependencies = [ "tty-color" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SB2p+30vbmsaCPrxH6EDYxctxA/UeEjwlq4hIJ+AWnU=";
      type = "gem";
    };
    version = "0.8.0";
  };
  plist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03pFJ8wRFgZDk99LQOHbvJTGX6nKLuxS7fmhNhZxikI=";
      type = "gem";
    };
    version = "3.7.2";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V2IDddy+VuwJuscZK/t0YMcWu/AFTclDReyqVDjlOdI=";
      type = "gem";
    };
    version = "0.6.0";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ksgcbe5wGbvGYA1MLWQdcw1lwWWUFADr2SQlkGfmkN0=";
      type = "gem";
    };
    version = "4.5.1";
  };
  safe_yaml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pqwtZLfrAnve7KGFH+fnrw1mjhM+iogGagxvcIfZ+Eg=";
      type = "gem";
    };
    version = "1.0.5";
  };
  strings = {
    dependencies = [
      "strings-ansi"
      "unicode-display_width"
      "unicode_utils"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kzKTs8lc+FuB60Szz2c+MIdmG6c5u63+rfRCCDFY1vs=";
      type = "gem";
    };
    version = "0.2.1";
  };
  strings-ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kCYtdg6kqUzCro1YIFJ3o0NAnCiMvnwpQWsYJr1RHIg=";
      type = "gem";
    };
    version = "0.2.0";
  };
  temple = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3zFF/mV3rx4lOH639xItMu1Rvbby57sPT78HtmFRkTs=";
      type = "gem";
    };
    version = "0.10.3";
  };
  tilt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Jj10hGbg2D5RCqGi4ige/1R5N/DvBr4z02MnIeJV92s=";
      type = "gem";
    };
    version = "2.6.0";
  };
  tty-color = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b5w3yjpOI2f7Lm0JcidiZH1vRVwRHwW1nzVzDuskMyo=";
      type = "gem";
    };
    version = "0.6.0";
  };
  tty-cursor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eVNBheand4iNiGKLFLah/fUVSmA/KF+AsXU+GQjgv0g=";
      type = "gem";
    };
    version = "0.7.1";
  };
  tty-link = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gvoyhJEMJQw+EP7vDy1JFxdGfAKcPrOsS0p8Y/3cv+U=";
      type = "gem";
    };
    version = "0.2.0";
  };
  tty-markdown = {
    dependencies = [
      "kramdown"
      "pastel"
      "rouge"
      "strings"
      "tty-color"
      "tty-screen"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HtgduXAo0Aa6geLP2f4KBLDrKGUK0NQIbtblYn9KxRE=";
      type = "gem";
    };
    version = "0.7.2";
  };
  tty-progressbar = {
    dependencies = [
      "strings-ansi"
      "tty-cursor"
      "tty-screen"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bLtCYOVedKkYDVAhQ+tqRn0sjlG/XzyVCftcrMPUpfY=";
      type = "gem";
    };
    version = "0.18.3";
  };
  tty-reader = {
    dependencies = [
      "tty-cursor"
      "tty-screen"
      "wisper"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xilyyYXAsVZvDlZ0O2p4gvl509wy/0ke1JCgdviZwrE=";
      type = "gem";
    };
    version = "0.9.0";
  };
  tty-screen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wJBlIRW+rnZDNsKIAtYz8gT7hNqTxqloql2OMZ6Bm1A=";
      type = "gem";
    };
    version = "0.8.2";
  };
  tty-which = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WCQFXw1nRMl+fEQmVE8B1RnEDRgG7y70fZhUR3mT9GY=";
      type = "gem";
    };
    version = "0.5.0";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EieYdLum1eTScozvgUsZGX27ENeng3qGm6tl2pQ7f1o=";
      type = "gem";
    };
    version = "2.6.0";
  };
  unicode_utils = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uSLQzyMTtrcTatpmRc5xVP/IZBjKB9U7BY7+nrcvKkA=";
      type = "gem";
    };
    version = "1.4.0";
  };
  wisper = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zhe8XDoWbyQaLmYThIsCXIFG/OLe+6UFkgwdHz+I+uY=";
      type = "gem";
    };
    version = "2.0.1";
  };
}
