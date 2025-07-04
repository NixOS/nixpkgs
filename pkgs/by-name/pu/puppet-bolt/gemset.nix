{
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
  aws-eventstream = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8UNMwDqyJIdW6wLPpF6QDlmgYdf73Eqf2Cpd0j15bT8=";
      type = "gem";
    };
    version = "1.3.0";
  };
  aws-partitions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sfg/fkoCf7LDfWxLkUH/7OflR/KF1ygu5YGczWnO5FQ=";
      type = "gem";
    };
    version = "1.968.0";
  };
  aws-sdk-core = {
    dependencies = [
      "aws-eventstream"
      "aws-partitions"
      "aws-sigv4"
      "jmespath"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GEjFL6kxGM9SfysqcBlrH+RYb0033Kj/uGNltd8ZrFA=";
      type = "gem";
    };
    version = "3.201.5";
  };
  aws-sdk-ec2 = {
    dependencies = [
      "aws-sdk-core"
      "aws-sigv4"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zp0YlqDtVQvyfT6pW1BdPV50n0UYdoegpBj7n36Z/3w=";
      type = "gem";
    };
    version = "1.470.0";
  };
  aws-sigv4 = {
    dependencies = [ "aws-eventstream" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-d1PjIMOfgPgvngiDsw3g57medWrbrtyAxQtq1Z1Jw3k=";
      type = "gem";
    };
    version = "1.9.1";
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
  bigdecimal = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qJRn7VpE+K4Bgkr0nLxXWHH6B4My6Pd+pCVyXB/+J74=";
      type = "gem";
    };
    version = "3.1.8";
  };
  bindata = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KdzLi6HMneFI8ku4iTCEDGLbVnFfD4Dsyt1iTZ89JiM=";
      type = "gem";
    };
    version = "2.5.0";
  };
  bolt = {
    dependencies = [
      "CFPropertyList"
      "addressable"
      "aws-sdk-ec2"
      "concurrent-ruby"
      "ffi"
      "hiera-eyaml"
      "jwt"
      "logging"
      "minitar"
      "net-scp"
      "net-ssh"
      "net-ssh-krb"
      "orchestrator_client"
      "puppet"
      "puppet-resource_api"
      "puppet-strings"
      "puppetfile-resolver"
      "r10k"
      "ruby_smb"
      "terminal-table"
      "winrm"
      "winrm-fs"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CC8Tn07r+Jg3fM5jXKU3wCz4alcfruhfGGW14GslOk8=";
      type = "gem";
    };
    version = "3.30.0";
  };
  builder = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SXkY0vncpSj9ykuI2E5O9DhyVtmEuBVOnV0/5anIg18=";
      type = "gem";
    };
    version = "3.3.0";
  };
  CFPropertyList = {
    dependencies = [
      "base64"
      "nkf"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xFchYUrKjV62+iFvLsKOw43hqUUF6XZqIOmHRUksPEw=";
      type = "gem";
    };
    version = "3.0.7";
  };
  colored2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sTwr1+6uLPc1amJQHTmOcv3nh4C9Jq7GqXlXgpPCi0o=";
      type = "gem";
    };
    version = "3.1.2";
  };
  concurrent-ruby = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1KqSYzmwqGtbUFSgqMWAFj5vXcvf0PS7kWsaJXBzHDI=";
      type = "gem";
    };
    version = "1.3.4";
  };
  connection_pool = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-D0DPmXCR8fBP9m2mfqvWGp/g1JKLmjZFIoUyUS+rYvQ=";
      type = "gem";
    };
    version = "2.4.1";
  };
  cri = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ir/pJO9T53Ko5O6QfnkdO/z8p4vGKlhZ47mJm6KZVuU=";
      type = "gem";
    };
    version = "2.15.12";
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
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/KYbR9rv2GXQ+1DRaGNPJ61AGBhnRFut9kJ8RZwzzWI=";
      type = "gem";
    };
    version = "1.13.0";
  };
  facter = {
    dependencies = [
      "hocon"
      "thor"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-R5lx6C3osIT43UKtdVL778gYRlB6qAxnyg0Qx1yjt18=";
      type = "gem";
    };
    version = "4.6.1";
  };
  faraday = {
    dependencies = [
      "faraday-em_http"
      "faraday-em_synchrony"
      "faraday-excon"
      "faraday-httpclient"
      "faraday-multipart"
      "faraday-net_http"
      "faraday-net_http_persistent"
      "faraday-patron"
      "faraday-rack"
      "faraday-retry"
      "ruby2_keywords"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IPUun3MjHl89Q/tkWQFXPOK3XwvQHqUqJ3ITPQEG5rA=";
      type = "gem";
    };
    version = "1.10.3";
  };
  faraday-em_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ej1McHl4kSEFT1fgjNTvfkCtFUm2MQHzjHCTqdbFlok=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-em_synchrony = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Rg2tHDDMaS1ud9TDkcyttOykhUsxVjLNflYPdCdc+e0=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-excon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sFXIQjdnNNf3Q1D+hhFUKuIADFOHNI2bqXCBCdbkCUA=";
      type = "gem";
    };
    version = "1.1.0";
  };
  faraday-httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-TI/x8Jc/+DW+jQQ+8WqvVPR/JbdXj22Rbe7oOZoE0zs=";
      type = "gem";
    };
    version = "1.0.1";
  };
  faraday-multipart = {
    dependencies = [ "multipart-post" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kBICGrV3kPfXEvWQtI1flIsZtDz6EcqD5kWfBgkLByU=";
      type = "gem";
    };
    version = "1.0.4";
  };
  faraday-net_http = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Y5ku/qQskloggYzzwIMJR5SFQf3PNFhCdVUQ0mbkxoI=";
      type = "gem";
    };
    version = "1.0.2";
  };
  faraday-net_http_persistent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Cwy8jwPauUPD4cxY2Le+sULZ3waLOccYzYPjkmA0gzU=";
      type = "gem";
    };
    version = "1.2.0";
  };
  faraday-patron = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CzXs0C7PMjja8uebn7/Q9E0ttUm1fNCnHp2gN3Tj6c=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72DslporuVuNvyRAAVWu5koA/IumxqTTloVivMkjKMA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  faraday-retry = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rdFU9POZJDy+BwgG7UG5aQaULn9SWbsf5try7I9JcZQ=";
      type = "gem";
    };
    version = "1.0.3";
  };
  faraday_middleware = {
    dependencies = [ "faraday" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3tFdV01Q6SvQREjVVmkTr1yxoBsvoxHO7MJGT6CriK8=";
      type = "gem";
    };
    version = "1.2.0";
  };
  fast_gettext = {
    dependencies = [ "prime" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/SbExAaqEL408P0oR84//cHp2XmN6HU4WUdXu7kXX78=";
      type = "gem";
    };
    version = "2.4.0";
  };
  ffi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UWMOQ0JQeDEcBWynX5Ybs72hZBqzbkStTEVeCw5KIxw=";
      type = "gem";
    };
    version = "1.17.0";
  };
  forwardable = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8X30vWr6b0agAyFwI/5XFu+IziYfXEzw7b3u1kcMr6w=";
      type = "gem";
    };
    version = "1.3.3";
  };
  getoptlong = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/SPwc5e5lL+TENRTHP20MyYpqbjoycRXwyt+31vyG6U=";
      type = "gem";
    };
    version = "0.2.1";
  };
  gettext = {
    dependencies = [
      "erubi"
      "locale"
      "prime"
      "racc"
      "text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KShk/moVwiTO5BJaSnL6tCb9uygOTP88/kSTX1SbAJo=";
      type = "gem";
    };
    version = "3.4.9";
  };
  gettext-setup = {
    dependencies = [
      "fast_gettext"
      "gettext"
      "locale"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KtT6mVddhp8YBWlB2Y3Jyyplarx7mR82D70+MtKP1Ow=";
      type = "gem";
    };
    version = "1.1.0";
  };
  gssapi = {
    dependencies = [ "ffi" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xRzzCELuOb2Tzn/DPiBAX/igTNqd7GCSBxthJYKEruE=";
      type = "gem";
    };
    version = "1.3.1";
  };
  gyoku = {
    dependencies = [
      "builder"
      "rexml"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OJ2Ic4THd/Jxy5N3u2QvILvgxjPR71r3hWnU21PBos0=";
      type = "gem";
    };
    version = "1.4.0";
  };
  hiera-eyaml = {
    dependencies = [
      "highline"
      "optimist"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zay2g9xe/vyum8Zoq4gfF85Vl8rBwEk67nxDh8fI/1Q=";
      type = "gem";
    };
    version = "3.4.0";
  };
  highline = {
    dependencies = [ "reline" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FBg+Rij0H7QhF2bQ04+xU/AfHsOa36g/X3xubr6yuOs=";
      type = "gem";
    };
    version = "3.1.0";
  };
  hocon = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5xAj7XxWrngOw0wM53iaIzvOrQjARdULx7OvQPWvzYA=";
      type = "gem";
    };
    version = "1.4.0";
  };
  httpclient = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KVHkmRIURkw+khB+RkOFJ9IwSOY0867pHHGeC9+uvaY=";
      type = "gem";
    };
    version = "2.8.3";
  };
  io-console = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8NzP8lL4d6T2DQSk3GtEKxhev/tLMgq2khKpK0inoiE=";
      type = "gem";
    };
    version = "0.7.2";
  };
  jmespath = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-I413SlhyPWwJBJTIh5temRjBlIX36EDywcdTLPhOvLE=";
      type = "gem";
    };
    version = "1.6.2";
  };
  jwt = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BzV80vGAc5svgYTtqWniUthQrJlu0KI/YW6P8KkK4Zs=";
      type = "gem";
    };
    version = "2.7.1";
  };
  little-plugger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1fNHwA2dZIBA73wX1usJ09Bxmt8ZyjDRo7b7JtCmMbs=";
      type = "gem";
    };
    version = "1.1.4";
  };
  locale = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ui+Zc+8+7mSqybygbSHbL7pnX6PSz2HSH0LRyhip94A=";
      type = "gem";
    };
    version = "2.1.4";
  };
  log4r = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-m0UpKMlkt8VMCa6yX/BFtacis4exbJzjfLG67AAGKWY=";
      type = "gem";
    };
    version = "1.1.10";
  };
  logging = {
    dependencies = [
      "little-plugger"
      "multi_json"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-uoiTo8IRuDb0Exu5Oz6zE3oMOx/NDsPVcOMk2L3ADMs=";
      type = "gem";
    };
    version = "2.4.0";
  };
  minitar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Oh27roxMjmerjjlRujbLk7hEwiWyn4PjuQ9IIm89YDg=";
      type = "gem";
    };
    version = "0.12.1";
  };
  molinillo = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-77/ycWMk4qMLzNProf86c19NXVP/3bxqLzLAypQzBF0=";
      type = "gem";
    };
    version = "0.8.0";
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
  multipart-post = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mHLQOo5VICDKCWra2/XjyxzRzdas08FhE2uKVzfNtKg=";
      type = "gem";
    };
    version = "2.4.1";
  };
  net-http-persistent = {
    dependencies = [ "connection_pool" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A/gnozhXsdVrTnlpV60Zv1tYNn2FP9CiJOtw+6jQKkQ=";
      type = "gem";
    };
    version = "4.0.2";
  };
  net-scp = {
    dependencies = [ "net-ssh" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sy3tDUjIjOcIRKBj5OFO+0SpXlGp4MC/sMVLQxO2Iuo=";
      type = "gem";
    };
    version = "4.0.0";
  };
  net-ssh = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FgX2ctFGMClPBhSjpDL7qTR7PRAeirYatb0nPVXBC2s=";
      type = "gem";
    };
    version = "7.2.3";
  };
  net-ssh-krb = {
    dependencies = [
      "gssapi"
      "net-ssh"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DBRI8y17HcTezF4rsynzjFAsn+1vsWEislfl3Iy2FYg=";
      type = "gem";
    };
    version = "0.5.1";
  };
  nkf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+8FRvaAlRR9if6/fyz9PE9CyKuEfWMbTopOcdsX18SY=";
      type = "gem";
    };
    version = "0.2.0";
  };
  nori = {
    dependencies = [ "bigdecimal" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YWbNM2lZhUdiBz4vuuiIWTgJysGz6QT0+wCTE9ciaGE=";
      type = "gem";
    };
    version = "2.7.1";
  };
  optimist = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gYhvU+6JGfMwqjAHbTINiO75vIWq4idTdrSvsAfGkmA=";
      type = "gem";
    };
    version = "3.1.0";
  };
  orchestrator_client = {
    dependencies = [
      "faraday"
      "net-http-persistent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-T1eMs5XsQKi4Uafb0BcZ5wM74oQs6Is8LzI7Jx8ISxY=";
      type = "gem";
    };
    version = "0.7.0";
  };
  prime = {
    dependencies = [
      "forwardable"
      "singleton"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1OlWyt+vBN4DbcfcdPlb9qKFpizFCbKLemayRdGf46Q=";
      type = "gem";
    };
    version = "0.1.2";
  };
  public_suffix = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puppet = {
    dependencies = [
      "concurrent-ruby"
      "deep_merge"
      "facter"
      "fast_gettext"
      "getoptlong"
      "locale"
      "multi_json"
      "puppet-resource_api"
      "scanf"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UXMwGff0D8mF+RbomyicSBcYwaSnXtq6iy3aYdXEUmw=";
      type = "gem";
    };
    version = "8.8.1";
  };
  puppet-resource_api = {
    dependencies = [ "hocon" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-S4Lnf60dOBDzqErXJ6qf18TosRebrMA06QccCo8uvmc=";
      type = "gem";
    };
    version = "1.9.0";
  };
  puppet-strings = {
    dependencies = [
      "rgen"
      "yard"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+ujYc+kB3V2MLV9Zcc/G0yUr/OZRjuJntW72XsRmn0=";
      type = "gem";
    };
    version = "4.1.2";
  };
  puppet_forge = {
    dependencies = [
      "faraday"
      "faraday_middleware"
      "minitar"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0raaf5Qx7VvAd9/UgvIxrnsh3RfDk/Hw5cP5F5r9Sg0=";
      type = "gem";
    };
    version = "3.2.0";
  };
  puppetfile-resolver = {
    dependencies = [
      "molinillo"
      "semantic_puppet"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-1UaVJRu2LKAz0Qu6LZ2RJD//R0Jl1JefJ4MlmpdGNM4=";
      type = "gem";
    };
    version = "0.6.3";
  };
  r10k = {
    dependencies = [
      "colored2"
      "cri"
      "fast_gettext"
      "gettext"
      "gettext-setup"
      "jwt"
      "log4r"
      "minitar"
      "multi_json"
      "puppet_forge"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-l3WnJrqUpUO/SZUrENzSNpClT10qNhdGt4sSkqvjLrk=";
      type = "gem";
    };
    version = "3.16.2";
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
  reline = {
    dependencies = [ "io-console" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XS3X7Q/QeOeaBeTqpH3JG42s7HNY6eHdbZxGNs/303g=";
      type = "gem";
    };
    version = "0.5.9";
  };
  rexml = {
    dependencies = [ "strscan" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-evBFnRCN/W/6fTjGfIRk4gD1ydR21Maj0YmekoCNY8Y=";
      type = "gem";
    };
    version = "3.3.6";
  };
  rgen = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dxdRIBchyxIM0rpTbvsZ/erSXDVYMZIXt9FM9bMbb6k=";
      type = "gem";
    };
    version = "0.9.1";
  };
  ruby2_keywords = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  ruby_smb = {
    dependencies = [
      "bindata"
      "rubyntlm"
      "windows_error"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xGkuyJg/SSFhI502p0OyqM0wnUUjyDKnHeFOrWqNt4g=";
      type = "gem";
    };
    version = "1.1.0";
  };
  rubyntlm = {
    dependencies = [ "base64" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RwE0Arma4p7pP5MK9R7a7IxgCFVvS+JXBaQitEMDFPU=";
      type = "gem";
    };
    version = "0.6.5";
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
  scanf = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Uz239+Wsr+oaFF1sUynO9melj7y31kN5qAj/EZnuGwA=";
      type = "gem";
    };
    version = "1.0.0";
  };
  semantic_puppet = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UtEI0I4aXZXAA0PLOkk2+x3uz/K+YS7DnJy2a+WouFk=";
      type = "gem";
    };
    version = "1.1.0";
  };
  singleton = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pstzBEIWhNgAk4Wa7TiyYDX25Uo4w+T+ZFbPtWskBWM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  strscan = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AbioHSFPv3tTCMb7UbWXK7/EpqofFm/TYYupfg/NVVU=";
      type = "gem";
    };
    version = "3.1.0";
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
  text = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L7u8gsHOecQZWxMBiofLsA12K9o5JBuzzcMnknWd0/Q=";
      type = "gem";
    };
    version = "1.3.1";
  };
  thor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+n40cdT2onE449nJsNTarJw9c4OSdmeug+mrQq50Ae8=";
      type = "gem";
    };
    version = "1.3.1";
  };
  unicode-display_width = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-fnaB3K3hrdcMuf2iDdd/MAuFh8geu9Fl0U/ZMUT/CrQ=";
      type = "gem";
    };
    version = "2.5.0";
  };
  windows_error = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Wagnt0qcetyPnUB4Lo7cE2gGojnbeaaN1h1QtuHZRaA=";
      type = "gem";
    };
    version = "0.1.5";
  };
  winrm = {
    dependencies = [
      "builder"
      "erubi"
      "gssapi"
      "gyoku"
      "httpclient"
      "logging"
      "nori"
      "rexml"
      "rubyntlm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-72t2fFdy0G4YYwC1BupeZa+4SZBKVR+EgqXPwqG+XQY=";
      type = "gem";
    };
    version = "2.3.9";
  };
  winrm-fs = {
    dependencies = [
      "erubi"
      "logging"
      "rubyzip"
      "winrm"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DSzdnh+2/I0B9Woy3OQdmK5u77SBk37Q4Fj6oM0MaT0=";
      type = "gem";
    };
    version = "1.3.5";
  };
  yard = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-VQVzbBsAySb3EFOmBqt18CBwxZYNB3i5Af6diwpHC+Q=";
      type = "gem";
    };
    version = "0.9.36";
  };
}
