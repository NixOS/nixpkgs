{
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  byebug = {
    groups = [ "debug" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KFQ0pHMpAtm7JyjH3VOk/7YqiZqFzNfcbsK+n/KGh4=";
      type = "gem";
    };
    version = "12.0.0";
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
  charlock_holmes = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tJ6KEc4ZIeLFtlURu4ZK5RcgzpvRwzbM8OiebIrmLbA=";
      type = "gem";
    };
    version = "0.7.9";
  };
  coderay = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FMAGKRoRRL484FDzSoJbJ8CofwkWe3P5TR4en/HfUs=";
      type = "gem";
    };
    version = "1.1.3";
  };
  dotenv = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nhF2BgztWB+ObOQ4TpE2GBd2OnbjxiXIvdwYs1vTksM=";
      type = "gem";
    };
    version = "3.1.8";
  };
  faraday = {
    dependencies = [
      "faraday-net_http"
      "json"
      "logger"
    ];
    groups = [
      "default"
      "development"
    ];
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ofHkzWos8hWZyCIVleJ1gtmTaBmXe71AiaYB8kxk5Uo=";
      type = "gem";
    };
    version = "3.4.0";
  };
  github-linguist = {
    dependencies = [
      "cgi"
      "charlock_holmes"
      "mini_mime"
      "rugged"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      path = ./.;
      type = "path";
    };
    version = "9.1.0";
  };
  json = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mhD2WKLeZ8Drg363ld1IEyznl8QD5Stevvh9zcf5zME=";
      type = "gem";
    };
    version = "2.11.3";
  };
  licensed = {
    dependencies = [
      "json"
      "licensee"
      "parallel"
      "pathname-common_prefix"
      "reverse_markdown"
      "ruby-xxHash"
      "thor"
      "tomlrb"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-c/oWEWDvpEFzlDTjlpjwxrQOuaGeCc/JX1dGz1GF18M=";
      type = "gem";
    };
    version = "4.5.0";
  };
  licensee = {
    dependencies = [
      "dotenv"
      "octokit"
      "reverse_markdown"
      "rugged"
      "thor"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PoPbmE+35OUcmP6g5DQTjcthEvjCbcdpNzSk+N+Z33c=";
      type = "gem";
    };
    version = "9.18.0";
  };
  logger = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  method_source = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GBMBycRbcxtHabyB6IYOcvkWGtfWbdmRA8mrhPVg9cU=";
      type = "gem";
    };
    version = "1.1.0";
  };
  mini_mime = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hoG34uQhXyoVn5QAtYFthenYxsa0kelqEnl+eY+LzO8=";
      type = "gem";
    };
    version = "1.1.5";
  };
  mini_portile2 = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
  };
  minitest = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ORtsbLQ6SAK/t8k68evirGaiECk/Sj+32zby/H3Cx1Y=";
      type = "gem";
    };
    version = "5.25.5";
  };
  mocha = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j31TjV0+vHX8eIs9kvurkTqTp4Ri0qPOmdG93nr3+FE=";
      type = "gem";
    };
    version = "2.7.1";
  };
  net-http = {
    dependencies = [ "uri" ];
    groups = [
      "default"
      "development"
    ];
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
    groups = [
      "default"
      "development"
    ];
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T6R/81zmVBJ+3yyDarkmm8yIKfVULcHoaHH2l85/QxY=";
      type = "gem";
    };
    version = "9.2.0";
  };
  parallel = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SsFR4YBrdV+04twjMsvw5U8uJLqCH/LT3Phr9txK4TA=";
      type = "gem";
    };
    version = "1.27.0";
  };
  pathname-common_prefix = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-08mF5CaTJwskTvRARTVxnDeiF3YTiZlSACS5jNmSjww=";
      type = "gem";
    };
    version = "0.0.2";
  };
  plist = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-03pFJ8wRFgZDk99LQOHbvJTGX6nKLuxS7fmhNhZxikI=";
      type = "gem";
    };
    version = "3.7.2";
  };
  pry = {
    dependencies = [
      "coderay"
      "method_source"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EtVLhkDT+inJIR3U/7CPP9i/ek/Ztac85bWchwk4W2s=";
      type = "gem";
    };
    version = "0.15.2";
  };
  public_suffix = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  racc = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rake = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rss42uZdfXS2AgpKydSK/tjrgUnAQOzPBSO+yRkHBZ0=";
      type = "gem";
    };
    version = "13.2.1";
  };
  rake-compiler = {
    dependencies = [ "rake" ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SieP7PdNjy8SxiCxgnKeNXP+lWouEYu54iGR4uM2Jsg=";
      type = "gem";
    };
    version = "0.9.9";
  };
  reverse_markdown = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-siBkZraCrBF3trjsMh0AqE/KAtCWxdZ2p6DMWDjcBwE=";
      type = "gem";
    };
    version = "2.1.1";
  };
  ruby-xxHash = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IB2DBewb0Lwyq+rs97QjdV3R9F9PTQLveTtrtxvyBoQ=";
      type = "gem";
    };
    version = "0.4.0.2";
  };
  ruby2_keywords = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rugged = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-f6qpEsWIjW40jSD6MSCbZAnxV0NGsbgOMJ28fo1j76w=";
      type = "gem";
    };
    version = "1.9.0";
  };
  sawyer = {
    dependencies = [
      "addressable"
      "faraday"
    ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+jpy1ipFJVF7GIV923iSaqs0JN4BKb5ncqjiuiQOeso=";
      type = "gem";
    };
    version = "0.9.2";
  };
  thor = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  tomlrb = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-wnNqzySRn3kzNAI6T/OWwGR9k/znAqc8nTSN6qgV1Pc=";
      type = "gem";
    };
    version = "2.0.3";
  };
  uri = {
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6fIkRgjuove8NX2VTGXJEM4DmcpeGKeikgesIth2cBE=";
      type = "gem";
    };
    version = "1.0.3";
  };
  yajl-ruby = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jJdNnBGuB7CjttJu/qhAcmmwLkE4EY++PvDS7Jck0dI=";
      type = "gem";
    };
    version = "1.4.3";
  };
}
