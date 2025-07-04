{
  bashly = {
    dependencies = [
      "colsole"
      "completely"
      "filewatcher"
      "gtx"
      "logger"
      "lp"
      "mister_bin"
      "ostruct"
      "requires"
      "tty-markdown"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XJ/7Ta5G8qsZ9swsXCUqmUn3X5nz2BYi38ziXWZ++7c=";
      type = "gem";
    };
    version = "1.2.10";
  };
  cgi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o8sZDUaoIMoBo+KL1bZOZwA/+Z14hLcFEkSFZvNTR+Y=";
      type = "gem";
    };
    version = "0.4.2";
  };
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
      hash = "sha256-YSoAwuvmpl3V4zQFXxm8kLrsqRwM4i/qKULvzeq7c8g=";
      type = "gem";
    };
    version = "0.7.0";
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
  erb = {
    dependencies = [ "cgi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3hFuEGIFxGvAGRh4m2EaqtEyjcxunxLPjNLMYO9hlxc=";
      type = "gem";
    };
    version = "4.0.4";
  };
  filewatcher = {
    dependencies = [ "module_methods" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-54CZB4F8QphkXJ/bzAsXewN/eoPSgxBrAk/9wk7ZyQ0=";
      type = "gem";
    };
    version = "2.1.0";
  };
  gtx = {
    dependencies = [ "erb" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5IiT0q6taR5/EFya4kNRfErlxLtxhLWuTvZKE1NeEPA=";
      type = "gem";
    };
    version = "0.1.1";
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
  lp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2fsHLK8ssjKs13pnGeaJjmLziNUtvKoPTyJZMdRXQVs=";
      type = "gem";
    };
    version = "0.2.1";
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
  module_methods = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ccq9jluFNzFqLkpUOneHJvNPqwSNbV/pfzdmx7TkBqE=";
      type = "gem";
    };
    version = "0.1.0";
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
  requires = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-V1pQamt3NhqKdj/GxkSGkCB+RdXvCrmVI7Q5aW5fkTY=";
      type = "gem";
    };
    version = "1.1.0";
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
}
