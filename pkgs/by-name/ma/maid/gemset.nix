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
  deprecated = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AyzDtzZydb69K0bA+iP3BEf2Xn808NaJd7DJJDwHws8=";
      type = "gem";
    };
    version = "3.0.1";
  };
  dimensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q4T68liLkBo8OoBoS7neLG90tzTEU8QXD0mQMLHzk8o=";
      type = "gem";
    };
    version = "1.3.0";
  };
  escape = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5J9EritPR8ajq9VErnf+QVeAJ5TjLxm453PLxNzsQWk=";
      type = "gem";
    };
    version = "0.0.4";
  };
  et-orbi = {
    dependencies = [ "tzinfo" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0m6GjMIduIKAqewaUKo9pdJn65sgN7p7gx1sJzH132Q=";
      type = "gem";
    };
    version = "1.2.11";
  };
  exifr = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jGOPrtDdu8xy+6T+1uVMfkxlCqr0P6E0r567pLiu1SE=";
      type = "gem";
    };
    version = "1.3.10";
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
  fugit = {
    dependencies = [
      "et-orbi"
      "raabro"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6JSF574iIm2OnG2kEWZNBmAoS0scCMrLVA9QWQeGmGg=";
      type = "gem";
    };
    version = "1.11.1";
  };
  geocoder = {
    dependencies = [
      "base64"
      "csv"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yvRPXuWk/Zo0bbYpXdnN8BW3ZWfS9fy2JsGs0Eg59r8=";
      type = "gem";
    };
    version = "1.8.5";
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
      hash = "sha256-lnkECsbnhFrZ8Zz1ns3mCGHHji+uV6XCD+NelJWbL48=";
      type = "gem";
    };
    version = "3.8.0";
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
  maid = {
    dependencies = [
      "deprecated"
      "dimensions"
      "escape"
      "exifr"
      "geocoder"
      "listen"
      "mime-types"
      "rubyzip"
      "rufus-scheduler"
      "thor"
      "xdg"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qTXtdAE/GYZ6pvdAINaQqU8NZxwDGm5jBiFS3x+HNGw=";
      type = "gem";
    };
    version = "0.10.0";
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
  raabro = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1Pqf9Rcjke25KyQu7YvoAtGTSxRkBhrl5w2AlixdqII=";
      type = "gem";
    };
    version = "1.4.0";
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
  rubyzip = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1fjk13CJVxBRIT7+NZztJCdimpXAH7XVN3jk0LSNz8=";
      type = "gem";
    };
    version = "2.3.2";
  };
  rufus-scheduler = {
    dependencies = [ "fugit" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mjPTL7XVinCGH6eSvi1/DebMH97joh1bIpgWj1b2RKs=";
      type = "gem";
    };
    version = "3.8.2";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L5PGUoKMup/PT2X13IwwbxpzF+BarVg1oTdAEiwX8kw=";
      type = "gem";
    };
    version = "1.2.2";
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
  xdg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-86X3mTY4UmleRXu3N5rGxOPoyzpRzmtEmrR/uxUjuRM=";
      type = "gem";
    };
    version = "2.2.5";
  };
}
