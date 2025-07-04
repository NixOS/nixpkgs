{
  ansi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VAglMnTjPZ0n1KmMRtKZgmb9Uculin650I9Q5X7SNZI=";
      type = "gem";
    };
    version = "1.5.0";
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
  bcrypt_pbkdf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L5B33eg30fDdLrD55TJ8aHHGjryOuoiHD7a3lW4eKxM=";
      type = "gem";
    };
    version = "1.1.1";
  };
  docker-api = {
    dependencies = [
      "excon"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gkvnNPTMhxgYm+nI55W2QUrLv36LCCoG+VmifdjdY+Y=";
      type = "gem";
    };
    version = "2.4.0";
  };
  ed25519 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ful/UZhomhVCRxafNFPvTP0/ekdIH94K4zIGzf3KxQY=";
      type = "gem";
    };
    version = "1.4.0";
  };
  excon = {
    dependencies = [ "logger" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ygQLthvABZlo80oXEVoA0tuFYuPAxcXHQyBytVHIWp0=";
      type = "gem";
    };
    version = "1.2.5";
  };
  hashie = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nWxOUfKjbUYWy8ijItYZoWLY9CgVp5JZYDn8lVlWA9o=";
      type = "gem";
    };
    version = "5.0.0";
  };
  itamae = {
    dependencies = [
      "ansi"
      "hashie"
      "schash"
      "specinfra"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nXrnGWpfqb5LudemLQOsb3lGz6ayNzzGxXLeaCcDHf4=";
      type = "gem";
    };
    version = "1.14.1";
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
  multi_json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-H9BBOLbkqQAX6NG4BMA5AxOZhm/z+6u3girqNnx4YV0=";
      type = "gem";
    };
    version = "1.15.0";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qZsLkqHl02Cw3k/78twMkVMVAtPU9WwosBOafAk9Gl0=";
      type = "gem";
    };
    version = "4.1.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FyB2xLMM5W+yWgOWGwxNoU4SRkJkAbD4nLoaO1S/PvA=";
      type = "gem";
    };
    version = "7.3.0";
  };
  net-telnet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JTAHwPjcP9ZuVp1T67zl726U1iRqucBNc6dimw7r05o=";
      type = "gem";
    };
    version = "0.2.0";
  };
  schash = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TaF9XIOfDO0Ipdii8wb0zMql+Cx7PG488X1eU2IXRkU=";
      type = "gem";
    };
    version = "0.1.2";
  };
  sfl = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mXOeUcMwYuOWThgCpwDunNjQ+cOJsqB/il/fhOGGpOI=";
      type = "gem";
    };
    version = "2.3";
  };
  specinfra = {
    dependencies = [
      "base64"
      "net-scp"
      "net-ssh"
      "net-telnet"
      "sfl"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0vAllw3ioll3EQ+T5eFcPbSJDHv/WCNjrYADbjq9+9Q=";
      type = "gem";
    };
    version = "2.94.0";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
}
