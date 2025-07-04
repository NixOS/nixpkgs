{
  activesupport = {
    dependencies = [
      "base64"
      "benchmark"
      "bigdecimal"
      "concurrent-ruby"
      "connection_pool"
      "drb"
      "i18n"
      "logger"
      "minitest"
      "securerandom"
      "tzinfo"
      "uri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hWXN26MbkAzcF2gv1m7NAgRB4+7zIKmTAoU5TowHpF4=";
      type = "gem";
    };
    version = "8.0.2";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
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
  benchmark = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
  };
  classifier-reborn = {
    dependencies = [
      "fast-stemmer"
      "matrix"
    ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4iNjIt5CucjUXYipUcsNduIQr6O7hli3tYAuLfQe9hw=";
      type = "gem";
    };
    version = "2.3.0";
  };
  coderay = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  coffee-script = {
    dependencies = [
      "coffee-script-source"
      "execjs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gv4oHhG5PIEXuYxeqAY+cXQYcPHE+7Jxd9fWMz3Th2U=";
      type = "gem";
    };
    version = "2.4.1";
  };
  coffee-script-source = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4SsW/Ykn+7+Lh8sumoWmz0V8aIHMf/ixrxWzH3DaB6Q=";
      type = "gem";
    };
    version = "1.12.2";
  };
  colorator = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4vhdr1evR9dA2yoyGR0b37D2UDoN+8gyfQyRVNXd/Dg=";
      type = "gem";
    };
    version = "1.1.0";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z9dKgrmwlNHOMMTxo0baI+4Z3IoGKhaoX1jqsc7UMFs=";
      type = "gem";
    };
    version = "2.5.3";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6W7NWow0lKpbWWKCJJ2rpcYDMgPBmSSOYUbjbSp42M0=";
      type = "gem";
    };
    version = "3.3.4";
  };
  date = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  drb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CwDW/bUJlf5KRd6hNmNJPIQREuQGhlaFRkb0GP2hM3M=";
      type = "gem";
    };
    version = "2.2.3";
  };
  em-websocket = {
    dependencies = [
      "eventmachine"
      "http_parser.rb"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9WqSveTmy4eSVtWO4x8SQYH2j4iHvRTVPV2aKSdYxqg=";
      type = "gem";
    };
    version = "0.5.3";
  };
  erb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dgQ5gDs2zJPsqKJmqrYUYU5YgCSom8MKYueNmP9FLCM=";
      type = "gem";
    };
    version = "5.0.1";
  };
  eventmachine = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mUAW5CqgQUd7qc/0XL5Q3iBH8l3UGOugA+hPDRZWCXI=";
      type = "gem";
    };
    version = "1.2.7";
  };
  execjs = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-a8uL6PAFL/nTcLZdHAgPJAZlbhUEUqCr2xhaEzBIRQ0=";
      type = "gem";
    };
    version = "2.10.0";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFMetUZ+fXTUUXYw+pbxpwA2R8vyCpo+Bn0JiUEhe3U=";
      type = "gem";
    };
    version = "2.13.1";
  };
  faraday-net_http = {
    dependencies = [ "net-http" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  fast-stemmer = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0Kqf2c+8qDagnYq7EiVSrII0EwJxo7DaHLB3Mj1lCBk=";
      type = "gem";
    };
    version = "1.0.2";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KXI1hC5ZR8wwNuvmQHdYS/9YPNek6U6aAv3sOZ70baY=";
      type = "gem";
    };
    version = "1.17.2";
  };
  forwardable-extended = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-G+yUjEabvd+t6zvZDrjIX25iekEqPoUqz9fq7brD7Jc=";
      type = "gem";
    };
    version = "2.6.0";
  };
  gemoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c0Q0Agy+lk6p0ZCGeYeXpH0joXCJLeDOVbdKpl0t3Bo=";
      type = "gem";
    };
    version = "4.1.0";
  };
  google-protobuf = {
    dependencies = [
      "bigdecimal"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tbb+bJLdaDqpZxQyw4l2aFqvm6L5JFDuvWPXa82+SJE=";
      type = "gem";
    };
    version = "4.31.0";
  };
  html-pipeline = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ih1NcSiyFBkTOHysD4uomLtoElVwAazAwrRpEPWUE6A=";
      type = "gem";
    };
    version = "2.14.3";
  };
  "http_parser.rb" = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wgky8fqCzgioUWomhdWoYDHAAFYPiZRpE8VVoGl1RL4=";
      type = "gem";
    };
    version = "0.8.0";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  jekyll = {
    dependencies = [
      "addressable"
      "base64"
      "colorator"
      "csv"
      "em-websocket"
      "i18n"
      "jekyll-sass-converter"
      "jekyll-watch"
      "json"
      "kramdown"
      "kramdown-parser-gfm"
      "liquid"
      "mercenary"
      "pathutil"
      "rouge"
      "safe_yaml"
      "terminal-table"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TBFE2FelsrgNRbjPUTgolXmp+BNqrfpt1oSzH+K8GME=";
      type = "gem";
    };
    version = "4.4.1";
  };
  jekyll-avatar = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6nNid8LeVKITABIglnAFF5cqci1caMqD+HI7SZmr/Us=";
      type = "gem";
    };
    version = "0.8.0";
  };
  jekyll-coffeescript = {
    dependencies = [
      "coffee-script"
      "coffee-script-source"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Mpxy+2KEMFal1nEVFNT/fxenmRaeiBZ9HTqD6haY0p0=";
      type = "gem";
    };
    version = "2.0.0";
  };
  jekyll-compose = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BHhjipIcV5Wx5bH/3HafPEBWguI5sd4BF73mCvTtyNs=";
      type = "gem";
    };
    version = "0.12.0";
  };
  jekyll-favicon = {
    dependencies = [
      "jekyll"
      "mini_magick"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IULTHsD9RaN7EzmK0Ro4zIGG5m4G8tOgxsCGEEnV0zc=";
      type = "gem";
    };
    version = "1.1.0";
  };
  jekyll-feed = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-aJqrFsh3lJu556XENt5ieDGKUey5dHkiMv2U2LOs/MM=";
      type = "gem";
    };
    version = "0.17.0";
  };
  jekyll-gist = {
    dependencies = [ "octokit" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SVtkg1UqPil1onUpZOp6zd1UW8bhPOK+FaUM7I1Mnw8=";
      type = "gem";
    };
    version = "1.5.0";
  };
  jekyll-mentions = {
    dependencies = [
      "html-pipeline"
      "jekyll"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OegBAky28jGbP3iimZnQBo719ovFICuHV9U1T+8xHtk=";
      type = "gem";
    };
    version = "1.6.0";
  };
  jekyll-paginate = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iAqt9LAlKak1QdUIxcu3RPAUy/wHHQJjox8l7JBm62Q=";
      type = "gem";
    };
    version = "1.1.0";
  };
  jekyll-polyglot = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2WdgPZqxACBWdYmqwEOQMvGlPMVXi2/wpOyKE/Ut/zw=";
      type = "gem";
    };
    version = "1.9.0";
  };
  jekyll-redirect-from = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ZjXK5Wnvmw+Q/7cewBS6l3F3+vtE0yorBSYojU2b5ts=";
      type = "gem";
    };
    version = "0.16.0";
  };
  jekyll-sass-converter = {
    dependencies = [ "sass-embedded" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5JdhPHRNEEMEdDGZDsAk+guOjzxJ+kHV6hSlKOGJEM=";
      type = "gem";
    };
    version = "3.1.0";
  };
  jekyll-seo-tag = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Py7RkW1W8U6/o44krN6bfJRt9wyxg68stfBZjyGuaBg=";
      type = "gem";
    };
    version = "2.8.0";
  };
  jekyll-sitemap = {
    dependencies = [ "jekyll" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DeCMXevBhepaj5gOECXHzT+ODDXItu9ZLxXEYjXPQhg=";
      type = "gem";
    };
    version = "1.4.0";
  };
  jekyll-watch = {
    dependencies = [ "listen" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vETtQ/XgpVKDYkWlTb/z6nQh7MKFZwfooe4gOoOHp+E=";
      type = "gem";
    };
    version = "2.2.1";
  };
  jemoji = {
    dependencies = [
      "gemoji"
      "html-pipeline"
      "jekyll"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XUw+jiy7src5l8MSlPb3DJTk1PreA5Nz6Gg1vPVSnnw=";
      type = "gem";
    };
    version = "0.13.0";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/I/jBcF8CcjOa8gl+aphvPIy2DVmmxBHLf+oYnlvIDs=";
      type = "gem";
    };
    version = "2.12.1";
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
  kramdown-parser-gfm = {
    dependencies = [ "kramdown" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+zl0VRZCfSmIVDvwH8TPCrEUlHY4I5Pg6cSFkvZYFyk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  kramdown-syntax-coderay = {
    dependencies = [
      "coderay"
      "kramdown"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-quXaiivXiQHLh1Nsx4DEfD+cVC9O5j4N9Hg11ut1dw8=";
      type = "gem";
    };
    version = "1.0.1";
  };
  liquid = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T8/rsaBF5HkYOI27egkl58OJPljSvWw7PHPsF6LY/bM=";
      type = "gem";
    };
    version = "4.0.4";
  };
  liquid-c = {
    dependencies = [ "liquid" ];
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8mBnBUA0+AKIotZcR+MF3yrb3j0J0Ie36GiclD6x+h4=";
      type = "gem";
    };
    version = "4.0.1";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-255EJODlg0SAOFGXwTnLawrg7yjMEzEM/Ryng3fVnGc=";
      type = "gem";
    };
    version = "3.9.0";
  };
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  matrix = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  mercenary = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sloeSlmtyohmXgjiSs8K8w2ltdhZ99jzj7pSwo9AUTg=";
      type = "gem";
    };
    version = "0.4.0";
  };
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3Ov2HCRvCOFaTeNOOG6+gjN5HoaFZKRww/53wA7tXlY=";
      type = "gem";
    };
    version = "3.7.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kfV4yJ5DIRrvmi6SgGrZWgxtebYYXHmsjDbVjnLuXxA=";
      type = "gem";
    };
    version = "3.2025.0520";
  };
  mini_magick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cdYljg6KPQSpoKCXhNXYV7QDoZilHdT4glEENeuV3dk=";
      type = "gem";
    };
    version = "4.13.2";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DNfH+CTgEMBy4z9ovALYWgCutvzgW7SBnAPf08FAwok=";
      type = "gem";
    };
    version = "2.8.9";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-liGyDBN4mK+diQVWhIyTYDcWyrUW3CyJsBo4uJTiWfs=";
      type = "gem";
    };
    version = "0.6.0";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  octokit = {
    dependencies = [
      "faraday"
      "sawyer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wCCS7oLc3+hNsODqYwpw0yvsxUJFpPC6z9IcAQ3wm5Y=";
      type = "gem";
    };
    version = "4.25.1";
  };
  pathutil = {
    dependencies = [ "forwardable-extended" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5Dt0NlYxyrT21eQij4EpJ+/Jyyxx5il27cslLulI1Yk=";
      type = "gem";
    };
    version = "0.16.2";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gUMoql3LbWBNMhJqILwcvPBVIaW0nbsaizCgflgPMW4=";
      type = "gem";
    };
    version = "5.2.6";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-v6fNUQgGb4yWAuDW1BFJmaXfWDmmMUnT6LD5wdNVg5Q=";
      type = "gem";
    };
    version = "6.0.2";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rb-fsevent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q5ALly5zAdZXD2S4UKWqZ4M+59h7RY7pKAXVa3MYrv4=";
      type = "gem";
    };
    version = "0.11.2";
  };
  rb-inotify = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  rdoc = {
    dependencies = [
      "erb"
      "psych"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-LEbeWNcSm4dD/PbXbj25cb3JFBUOFawGs4ZUm9gu19s=";
      type = "gem";
    };
    version = "6.14.0";
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
      hash = "sha256-A0Iz+4pp0K0OBHaUMYTgTLlxto48IjlyTgL0KIeLaKM=";
      type = "gem";
    };
    version = "4.5.2";
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
  sass-embedded = {
    dependencies = [
      "google-protobuf"
      "rake"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lOB25JZ5wst8/FS/Ll5E+yhRv+wFYeWtYlfHgcDk+kA=";
      type = "gem";
    };
    version = "1.89.0";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+jpy1ipFJVF7GIV923iSaqs0JN4BKb5ncqjiuiQOeso=";
      type = "gem";
    };
    version = "0.9.2";
  };
  securerandom = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3i3yyQqMV+0/KYaglXWLsQ49Y2iuQvmYEhUat5FB/o=";
      type = "gem";
    };
    version = "3.1.7";
  };
  terminal-table = {
    dependencies = [ "unicode-display_width" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+VG2r18+ACA/spCmaeCoXF3VsFGzsCM5LM/We6WrrpE=";
      type = "gem";
    };
    version = "3.0.2";
  };
  tomlrb = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wnNqzySRn3kzNAI6T/OWwGR9k/znAqc8nTSN6qgV1Pc=";
      type = "gem";
    };
    version = "2.0.3";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
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
  uri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  webrick = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tC08lPFm8/tz2H6bNZ3vm1g2xCb8i+rPOPIYSiGyqYk=";
      type = "gem";
    };
    version = "1.9.1";
  };
  yajl-ruby = {
    groups = [ "default" ];
    platforms = [
      {
        engine = "maglev";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mingw";
      }
      {
        engine = "mswin";
      }
      {
        engine = "rbx";
      }
      {
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJdNnBGuB7CjttJu/qhAcmmwLkE4EY++PvDS7Jck0dI=";
      type = "gem";
    };
    version = "1.4.3";
  };
}
