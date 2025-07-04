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
      hash = "sha256-8iDDTgfZiwTgLrIxk77kNvq5r81VH0Pc6IN6G0qoB2I=";
      type = "gem";
    };
    version = "3.2.0";
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
  gitlab-triage = {
    dependencies = [
      "activesupport"
      "globalid"
      "graphql"
      "graphql-client"
      "httparty"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fKIeHjZ6kp5q+N3wcrkiUYXhZEsdccM/Jr8AJqn1Rnk=";
      type = "gem";
    };
    version = "1.44.5";
  };
  globalid = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cL92cRhx+EPbunK+uGEyKaSUKdGGaChHb5ydbMwyfOk=";
      type = "gem";
    };
    version = "1.2.1";
  };
  graphql = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DuocM/5ffJSUz0Eb2NskqLCzm/8XaQtjwTAE7tCgQdQ=";
      type = "gem";
    };
    version = "2.0.32";
  };
  graphql-client = {
    dependencies = [
      "activesupport"
      "graphql"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nmbEVkm7fTYPHb29uAYhmPjLLY/cdoGGBrb1AXLaUvU=";
      type = "gem";
    };
    version = "0.25.0";
  };
  httparty = {
    dependencies = [
      "mime-types"
      "multi_xml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SQ0qAopazMYR8WhdR52A74CxKRQNJKk8U8EZ9XhhSGc=";
      type = "gem";
    };
    version = "0.20.0";
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
      hash = "sha256-EYCNeAzbJ+pdsBQ9v8JhuR7WPsXllfQko1+YIstJegI=";
      type = "gem";
    };
    version = "3.2025.0527";
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
  multi_xml = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MHqW3EhhO623svwXT9TmLXx7YZvDbqM7/QxJ9k9Xh84=";
      type = "gem";
    };
    version = "0.7.2";
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
}
