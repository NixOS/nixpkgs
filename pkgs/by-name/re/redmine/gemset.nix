{
  actioncable = {
    dependencies = [
      "actionpack"
      "activesupport"
      "nio4r"
      "websocket-driver"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WzuIUHWoB2fWPL8rWGy/gkZqJBZ1t5hSM/lXq7Ab/7Q=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionmailbox = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activestorage"
      "activesupport"
      "mail"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-iWpHwlIPRQfHXd5nxuofXuw6BB/nv781aMTgFJoIDiU=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionmailer = {
    dependencies = [
      "actionpack"
      "actionview"
      "activejob"
      "activesupport"
      "mail"
      "rails-dom-testing"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-sCrlI8Msitdi1NuUHnbzwQjBBgMBMiR+56e4yGvHsh8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionpack = {
    dependencies = [
      "actionview"
      "activesupport"
      "nokogiri"
      "racc"
      "rack"
      "rack-session"
      "rack-test"
      "rails-dom-testing"
      "rails-html-sanitizer"
      "useragent"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-F7IWCnvL1aVp0Gsa5UpLtczHuggV1z/1doEAp53B9zQ=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionpack-xml_parser = {
    dependencies = [
      "actionpack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QMtGHumURTFKtYCng/t0E1gN64soETyecOzXwbM01eY=";
      type = "gem";
    };
    version = "2.0.1";
  };
  actiontext = {
    dependencies = [
      "actionpack"
      "activerecord"
      "activestorage"
      "activesupport"
      "globalid"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-82nO5BpmdLaXv5JX2Rej3OV1osiZNa9De0MtZzej8NY=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  actionview = {
    dependencies = [
      "activesupport"
      "builder"
      "erubi"
      "rails-dom-testing"
      "rails-html-sanitizer"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-afyIDPPYsbryGwSM97to8e7wh2D/gQTX1gpqG+izWaU=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activejob = {
    dependencies = [
      "activesupport"
      "globalid"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8vlahXOzlKpPfCSEPwxKYGXAc6XGTW8V7NmNmMLCPls=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activemodel = {
    dependencies = [ "activesupport" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-g5iGH57ixGcag1erOemzigRf1lb2aFo91YkMJBnb/a8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activerecord = {
    dependencies = [
      "activemodel"
      "activesupport"
      "timeout"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-eaMfccMtUThxfCEE4P8QX12CkiJHyFvcoUTycg5n+rk=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  activestorage = {
    dependencies = [
      "actionpack"
      "activejob"
      "activerecord"
      "activesupport"
      "marcel"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tOw1/5TU1mVu5pUs5DnD+A4klVLUn9LTmW7lOIDFUl8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
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
    ];
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hCvL+Kkpd/gPtHUGYaI3z13U/dRCBms8NeiK+0iGR/U=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  addressable = {
    dependencies = [ "public_suffix" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RimGU3zzc1q188D1V/FBVdd49LQ+pPSFqd65yPfFgjI=";
      type = "gem";
    };
    version = "2.8.7";
  };
  ast = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lUYVFXwdajgrwn1pDZcxleedt/Vel2WsfEgcYL2004M=";
      type = "gem";
    };
    version = "2.4.3";
  };
  base64 = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DyXpshoCoMwM6o75KyBBA105NQlG6HicVistGj2gFQc=";
      type = "gem";
    };
    version = "0.2.0";
  };
  benchmark = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DxL4xJVUXjcQw+TwSA9j8GtMhCzJTOx/M6lW9RgOh0o=";
      type = "gem";
    };
    version = "0.4.0";
  };
  bigdecimal = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-L/x0IDFSGtacLfyBWpjkJqIwo9Iq6sGZWCanXav62Mw=";
      type = "gem";
    };
    version = "3.1.9";
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
  bundle-audit = {
    dependencies = [ "bundler-audit" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-yPCFkgzeaBuoN75pyHsIWYwaf0b3CHfxs6FxG+kaekM=";
      type = "gem";
    };
    version = "0.1.0";
  };
  bundler-audit = {
    dependencies = [ "thor" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cwUdqgmGXENkUKNcTYfO7xXz+Xd/Sq1P0BXMbx8rEEg=";
      type = "gem";
    };
    version = "0.9.2";
  };
  capybara = {
    dependencies = [
      "addressable"
      "matrix"
      "mini_mime"
      "nokogiri"
      "rack"
      "rack-test"
      "regexp_parser"
      "xpath"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-QtunIFeOocpl/XpB0WPdNoUCwZGARVj24PcbORBUru8=";
      type = "gem";
    };
    version = "3.40.0";
  };
  chunky_png = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-idWzG1XAz02jz4mitOvDF42Kvoy68Rah26lWaFAv3P4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  commonmarker = {
    groups = [ "common_mark" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-nR0101h0AVG84pI1rr/sxjMU+1fdiag+ctQGG0/j0r8=";
      type = "gem";
    };
    version = "0.23.11";
  };
  concurrent-ruby = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gTs+N6ym3yoho7nx1Jf4y6skorlMqzJb/+Ze4PbL68Y=";
      type = "gem";
    };
    version = "1.3.5";
  };
  connection_pool = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-z9dKgrmwlNHOMMTxo0baI+4Z3IoGKhaoX1jqsc7UMFs=";
      type = "gem";
    };
    version = "2.5.3";
  };
  crass = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3FFgIqVuezsVYJmryBttKwjqHtEmdqx6VldhfwEr1F0=";
      type = "gem";
    };
    version = "1.0.6";
  };
  css_parser = {
    dependencies = [ "addressable" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bP0//AqXMzs50rG0nJU5ewXg47aE1o937EcbpOwu98c=";
      type = "gem";
    };
    version = "1.21.1";
  };
  csv = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SRnzDXpmQzL+NeYyLv9a1TJnRGvbt7GTZP+6XrZB6bo=";
      type = "gem";
    };
    version = "3.2.9";
  };
  date = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vyaOFO9xWACb/q7EC1+jxycZBuiLGW2VionUtAir5k8=";
      type = "gem";
    };
    version = "3.4.1";
  };
  debug = {
    dependencies = [
      "irb"
      "reline"
    ];
    groups = [
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EeKMp0h1l55hJEQQTzlyvV/7nnkXmQfXrUbbpEvS56Q=";
      type = "gem";
    };
    version = "1.10.0";
  };
  deckar01-task_list = {
    dependencies = [ "html-pipeline" ];
    groups = [ "common_mark" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WhkJJUjSQwnYssJwTWTNwIpKYVgjyaci9BQu3sHeiAU=";
      type = "gem";
    };
    version = "2.3.2";
  };
  docile = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lhWb55m/pzzbchuEDpgCEm5OA9/CaGPbc2RyBMcn8h4=";
      type = "gem";
    };
    version = "1.4.1";
  };
  drb = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-6dRyv3hfVYuWslNYuuEVZG2g2/1FEHrYWLC8DZNcs0A=";
      type = "gem";
    };
    version = "2.2.1";
  };
  erubi = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oIIQOwiF28Xs8Rcv7eiX+evbdFpLl6Xo3GOVPbHuStk=";
      type = "gem";
    };
    version = "1.13.1";
  };
  ffi = {
    groups = [
      "default"
      "development"
      "test"
    ];
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
        engine = "ruby";
      }
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-KXI1hC5ZR8wwNuvmQHdYS/9YPNek6U6aAv3sOZ70baY=";
      type = "gem";
    };
    version = "1.17.2";
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
  html-pipeline = {
    dependencies = [
      "activesupport"
      "nokogiri"
    ];
    groups = [
      "common_mark"
      "default"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-od6D970tNGTzoGjjkbZhmD/GCZ0ZTI2c65Gs4C2tuAM=";
      type = "gem";
    };
    version = "2.13.2";
  };
  htmlentities = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Elpzxsny0bYhALfDxAHjYkRBtmN2Kvp/5ChHZDWmc9o=";
      type = "gem";
    };
    version = "4.3.4";
  };
  i18n = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zrpXP4E4/ywJFUJ/H8W99Ko6uK6IyM4lXrPs8KEaXQ8=";
      type = "gem";
    };
    version = "1.14.7";
  };
  io-console = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zWqfrLxphx1pssuLkm/G6n7wbwblBegaZPFKRw/d76I=";
      type = "gem";
    };
    version = "0.8.0";
  };
  irb = {
    dependencies = [
      "pp"
      "rdoc"
      "reline"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Ii8ylS4njaNLWP/kXoY0v0r8LceqnaI/7WflgapQ/bo=";
      type = "gem";
    };
    version = "1.15.2";
  };
  json = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-mhD2WKLeZ8Drg363ld1IEyznl8QD5Stevvh9zcf5zME=";
      type = "gem";
    };
    version = "2.11.3";
  };
  language_server-protocol = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xIRiZHhmT9E0gtgYCUfFCoWQSEsSWLmbeu2ztp34lmk=";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  listen = {
    dependencies = [
      "rb-fsevent"
      "rb-inotify"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-255EJODlg0SAOFGXwTnLawrg7yjMEzEM/Ryng3fVnGc=";
      type = "gem";
    };
    version = "3.9.0";
  };
  logger = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GW7ex8xEtmz7QPl1XOEbOS8h95Z2lq8V0nTd5+3/AgM=";
      type = "gem";
    };
    version = "1.7.0";
  };
  loofah = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YeanEIg6u4IQiH89yGjPPtZllMUJ2f9ph2Ie+mZR7h4=";
      type = "gem";
    };
    version = "2.24.0";
  };
  mail = {
    dependencies = [
      "mini_mime"
      "net-imap"
      "net-pop"
      "net-smtp"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7Dufrc8rN1XHh4XLF7yaDKnumFcQimS29c/JwLW/ya0=";
      type = "gem";
    };
    version = "2.8.1";
  };
  marcel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-DVZJ/rZLjxnz00aLlsaAuul0YzXQIZQnAoeGimYVFqQ=";
      type = "gem";
    };
    version = "1.0.4";
  };
  matrix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cQg8y9Z6FKQ7+njT5NwPS1A7nMGOW0sdaG3A+e98TMA=";
      type = "gem";
    };
    version = "0.4.2";
  };
  mini_magick = {
    groups = [ "minimagick" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5muzk7RtkVUBkkXgcK7xrYT4cUVvv+RIYcVhgBN958U=";
      type = "gem";
    };
    version = "5.0.1";
  };
  mini_mime = {
    groups = [
      "default"
      "test"
    ];
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
      "common_mark"
      "default"
      "development"
      "test"
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
    groups = [
      "common_mark"
      "default"
      "test"
    ];
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
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-j31TjV0+vHX8eIs9kvurkTqTp4Ri0qPOmdG93nr3+FE=";
      type = "gem";
    };
    version = "2.7.1";
  };
  mysql2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cPRH1F1rPMFrAPfdMDZvcIqBtAk6NdAm/3E113jY2jM=";
      type = "gem";
    };
    version = "0.5.6";
  };
  net-imap = {
    dependencies = [
      "date"
      "net-protocol"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b3bKFyIFlGrVAuzsmF6f1cClX6XhCK5hsgGqfacQM8Y=";
      type = "gem";
    };
    version = "0.4.21";
  };
  net-ldap = {
    groups = [ "ldap" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UlcbVfkVcSCDOsFmfylpzgE5JRgR0Km2RlfBwTUGnPk=";
      type = "gem";
    };
    version = "0.17.1";
  };
  net-pop = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hItOmCATwVsvA4J5Imh2O3SMzpHJ6R42sPJ+0mQg3/M=";
      type = "gem";
    };
    version = "0.1.2";
  };
  net-protocol = {
    dependencies = [ "timeout" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qnPgy6ahJTad6YN7jY74KmGEk2DroFIZAOLDcTqhYqg=";
      type = "gem";
    };
    version = "0.2.2";
  };
  net-smtp = {
    dependencies = [ "net-protocol" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-CY0o+rnZvCgKLPrad2ks3Kicg8Z4m9u42EKfl/G/WjM=";
      type = "gem";
    };
    version = "0.4.0.1";
  };
  nio4r = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2V3uaOC7JRuP+QrDQjpRHjt4QSTl23/19IE6IgrnPKk=";
      type = "gem";
    };
    version = "2.7.4";
  };
  nokogiri = {
    dependencies = [
      "mini_portile2"
      "racc"
    ];
    groups = [
      "common_mark"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jHRkh12cp/cQgMJMDbe8qjlA6L48b8S868z4uaABY2U=";
      type = "gem";
    };
    version = "1.18.8";
  };
  parallel = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SsFR4YBrdV+04twjMsvw5U8uJLqCH/LT3Phr9txK4TA=";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-JHY2QUKzB/paGx7ORPJgcoviOFipxxB46VYTGnVFPEU=";
      type = "gem";
    };
    version = "3.3.8.0";
  };
  pg = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-dh7733O2ZRbwwm/L5lFdx1AMPwqhobhT/q4kVDPGT9w=";
      type = "gem";
    };
    version = "1.5.9";
  };
  pp = {
    dependencies = [ "prettyprint" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lH7DEgxvkhlfjuiqJaeyxSl7sQbYO0G6oCmDaGV3tv8=";
      type = "gem";
    };
    version = "0.6.2";
  };
  prettyprint = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K8nhVYGpR0IGSjzIsPudRarj0Dobqm74CSJiegdm8ZM=";
      type = "gem";
    };
    version = "0.2.0";
  };
  prism = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3A4+AOkxYCE9wqZVGdkAKkoee5YttX1ETPGnFWW7cD4=";
      type = "gem";
    };
    version = "1.4.0";
  };
  propshaft = {
    dependencies = [
      "actionpack"
      "activesupport"
      "rack"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-04k2H69mrrF+jSBIKJYsHlBu3RShoXrbP6R1Q1wHD2s=";
      type = "gem";
    };
    version = "1.1.0";
  };
  psych = {
    dependencies = [
      "date"
      "stringio"
    ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
  };
  public_suffix = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YdROHKtcu75bMQaEgc8Wl23Q3BtrB72VYX74xePgDG8=";
      type = "gem";
    };
    version = "6.0.1";
  };
  puma = {
    dependencies = [ "nio4r" ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-8lwGhz6z1d5fCk68eDrMgaTM/lgMdgz+MjSXeYAYrYc=";
      type = "gem";
    };
    version = "6.6.0";
  };
  racc = {
    groups = [
      "common_mark"
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Sn9pKWkdvsi1IJoLNzvCYUiCtV/F0uRHohqqaRMD1i8=";
      type = "gem";
    };
    version = "1.8.1";
  };
  rack = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Fwx522IYgohNmijZzVvSKMZj/dzTZ8TeoiyaGAhkV5I=";
      type = "gem";
    };
    version = "3.1.13";
  };
  rack-session = {
    dependencies = [
      "base64"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Q3w5FlNbWO9xyBbOSi3uCgHIpSrmB33Cts0ZCFdgopA=";
      type = "gem";
    };
    version = "2.1.0";
  };
  rack-test = {
    dependencies = [ "rack" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-AFo2aSwwasC0qTUDVe4ID9Cd3vEUil+LKsY2xyD1xGM=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rackup = {
    dependencies = [ "rack" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-9zcZH9XFs0i38KRBKjuGOD+IxD4TuCF7Y9TI2QueeY0=";
      type = "gem";
    };
    version = "2.2.1";
  };
  rails = {
    dependencies = [
      "actioncable"
      "actionmailbox"
      "actionmailer"
      "actionpack"
      "actiontext"
      "actionview"
      "activejob"
      "activemodel"
      "activerecord"
      "activestorage"
      "activesupport"
      "railties"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-rtsWBLQPTkO16AZuWhqjTa4CwzqpZpsh/USX0PjJu0A=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  rails-dom-testing = {
    dependencies = [
      "activesupport"
      "minitest"
      "nokogiri"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5RVxLkjfH2h6HXw4D9ewe4VY+qJkZEdNpkGDp0JvqTs=";
      type = "gem";
    };
    version = "2.2.0";
  };
  rails-html-sanitizer = {
    dependencies = [
      "loofah"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-NfziyoJC2od1yDtrqcG8qtZ1HZ63PBq6qEA0dauJpWA=";
      type = "gem";
    };
    version = "1.6.2";
  };
  railties = {
    dependencies = [
      "actionpack"
      "activesupport"
      "irb"
      "rackup"
      "rake"
      "thor"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4/Eb8RbdbQ2HRSKEPMxw7A+J+/7T6cLuSKR3jNBC/h8=";
      type = "gem";
    };
    version = "7.2.2.1";
  };
  rainbow = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-A5SRqjqJ9C76HW3sL8TmLt6W62rNleUvGtWBGCt5vGo=";
      type = "gem";
    };
    version = "3.1.1";
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
    groups = [
      "default"
      "development"
    ];
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
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-oKcARBI5sP8Y62XjhmI2zXhhPWufeP6h+axHqF5Hvm4=";
      type = "gem";
    };
    version = "0.11.1";
  };
  rbpdf = {
    dependencies = [
      "htmlentities"
      "rbpdf-font"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-FqSkf4WYIHideXYC+KtrNFx/0IWrI9zwA/G7dDr+ZmU=";
      type = "gem";
    };
    version = "1.21.3";
  };
  rbpdf-font = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-OzSY6k+ecb6g96BpQI1Qw8ToWxqkluIvLui4TSjItF8=";
      type = "gem";
    };
    version = "1.19.1";
  };
  rdoc = {
    dependencies = [ "psych" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-YqDayZSTyU6Ot6P7ROVa78tM7LEZ95kfJb3cXtjUcvc=";
      type = "gem";
    };
    version = "6.13.1";
  };
  regexp_parser = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-y28N3eiHcs1kv/Hbv2jfZtN2BD/i5mqe93/LGwxUjGE=";
      type = "gem";
    };
    version = "2.10.0";
  };
  reline = {
    dependencies = [ "io-console" ];
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-GvzJ18sQKc2+eA1y8vCSUc5G03gAUPPsOcPMxrYGdfs=";
      type = "gem";
    };
    version = "0.6.1";
  };
  rexml = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0UnqaCgS07DHb4NxO1gBLlgr5Q9jbQuU57d46hxq8o=";
      type = "gem";
    };
    version = "3.4.1";
  };
  roadie = {
    dependencies = [
      "css_parser"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-5KT2HOeSvZGyKLaES0utaxYM3BuN+GyBqLmDCCpQAdY=";
      type = "gem";
    };
    version = "5.2.1";
  };
  roadie-rails = {
    dependencies = [
      "railties"
      "roadie"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kKU0hX/P6f2+T56/28R+XTNGLE829Hj8gLpqe2JXQz8=";
      type = "gem";
    };
    version = "3.2.0";
  };
  rotp = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ddQAh+Ze0NgCLDMFWmMGwcQA0cEiYZMlM7XWy82GiFQ=";
      type = "gem";
    };
    version = "6.3.0";
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
  rqrcode = {
    dependencies = [
      "chunky_png"
      "rqrcode_core"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-4tWZY3X26aATgjwontV12+pni44DiFdDAsH6xWPwmK8=";
      type = "gem";
    };
    version = "3.1.0";
  };
  rqrcode_core = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HkC4I6tXqWSCpBf/9d1cM2RaAM6m712eNC/sxe+R2as=";
      type = "gem";
    };
    version = "2.0.0";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-B99QhQTYHpcXTo0hAw8l1Swb5+6GFZOdtD87N36mwSs=";
      type = "gem";
    };
    version = "1.68.0";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-48wEIDsu8E9tbPX4X+bWQ/RCsYzDsj462gzltlIbjpI=";
      type = "gem";
    };
    version = "1.44.1";
  };
  rubocop-performance = {
    dependencies = [
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ntlzevHukGVWVLSD4OrE5kcCE56F0zM1v3RLV6MJpnk=";
      type = "gem";
    };
    version = "1.22.1";
  };
  rubocop-rails = {
    dependencies = [
      "activesupport"
      "rack"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w6bO9QlTnN7+UEOZKrNTBhCx/sw9Z77+P/AhW5by9P4=";
      type = "gem";
    };
    version = "2.27.0";
  };
  ruby-progressbar = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-gPycR6m2QNaDTg3Hs8lMnfN/CMsHK3dh5KceIs/ymzM=";
      type = "gem";
    };
    version = "1.13.0";
  };
  ruby2_keywords = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/9E3QMVztzAc96LmH8hXsqjj06/zJUXW+DANi64Q4+8=";
      type = "gem";
    };
    version = "0.0.5";
  };
  rubyzip = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P1fjk13CJVxBRIT7+NZztJCdimpXAH7XVN3jk0LSNz8=";
      type = "gem";
    };
    version = "2.3.2";
  };
  sanitize = {
    dependencies = [
      "crass"
      "nokogiri"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pCzl+TPYJ2WoJDWZ1asuiGcjfnbPWmmcqt3+YLuUQVI=";
      type = "gem";
    };
    version = "6.1.3";
  };
  securerandom = {
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zFGT1BSkNBtuIl8MtERqzsqOUNXhiIdD+sFph2OOoLE=";
      type = "gem";
    };
    version = "0.4.1";
  };
  selenium-webdriver = {
    dependencies = [
      "base64"
      "logger"
      "rexml"
      "rubyzip"
      "websocket"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3bLYju4jzdtdap2t2QlCep5RY3GDOOEake7y++rRAOk=";
      type = "gem";
    };
    version = "4.31.0";
  };
  simplecov = {
    dependencies = [
      "docile"
      "simplecov-html"
      "simplecov_json_formatter"
    ];
    groups = [ "test" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-/iYix4NP8juYBmuwqFQoSycppWmsZZ+CYh/CLvNiE6U=";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-html = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-XasLfuYS5g6Yh61XaTgy/fRpW0wMhZ6upflcGHke8Qs=";
      type = "gem";
    };
    version = "0.13.1";
  };
  simplecov_json_formatter = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UpQY++jeFxOsKy1hKqPapW0xaXXTByRDmfpIOMYBtCg=";
      type = "gem";
    };
    version = "0.1.4";
  };
  sqlite3 = {
    dependencies = [ "mini_portile2" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-+nf2PHCVSPRtTptrtFzaUqo4gaoSzIWZETJ1jolocBw=";
      type = "gem";
    };
    version = "1.7.3";
  };
  stringio = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-W3i3yyQqMV+0/KYaglXWLsQ49Y2iuQvmYEhUat5FB/o=";
      type = "gem";
    };
    version = "3.1.7";
  };
  svg_optimizer = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "development"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-2HRtHUCZZs86s7eTEyeVyCjUuoeAfHtZTgxeBSgREWw=";
      type = "gem";
    };
    version = "0.3.0";
  };
  svg_sprite = {
    dependencies = [
      "nokogiri"
      "svg_optimizer"
      "thor"
    ];
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-xt6/k8+Fmke5/uiMpLGjZYUM+ZQaFoInd4ONb7ANrsk=";
      type = "gem";
    };
    version = "1.0.3";
  };
  thor = {
    groups = [
      "default"
      "development"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-7vApO54kFYzK16s4Oug1NLetTtmcCflvGmsDZVCrvto=";
      type = "gem";
    };
    version = "1.3.2";
  };
  timeout = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lQnwebK1X+QjbXljO9deNMHB5+P7S1bLX9ph+AoP4w4=";
      type = "gem";
    };
    version = "0.4.3";
  };
  tzinfo = {
    dependencies = [ "concurrent-ruby" ];
    groups = [
      "common_mark"
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-ja+CjMd7z31jsOO9tsqkfiJy3Pr0+/5G+MOp3wh6gps=";
      type = "gem";
    };
    version = "2.0.6";
  };
  unicode-display_width = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-EieYdLum1eTScozvgUsZGX27ENeng3qGm6tl2pQ7f1o=";
      type = "gem";
    };
    version = "2.6.0";
  };
  useragent = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-cA5kE61LuVS7Y1R/oJjd33sOvnW0DMb5O41UJVsXOEQ=";
      type = "gem";
    };
    version = "0.16.11";
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
  websocket = {
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-t+enTiQQtehcJYWLJrMyLykWHjAJNfcKDg08NeBGJzc=";
      type = "gem";
    };
    version = "1.2.11";
  };
  websocket-driver = {
    dependencies = [
      "base64"
      "websocket-extensions"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BW2Z8s1UVxLPsSkWUP3nR45PJmHcHbag+juWYjGhRrQ=";
      type = "gem";
    };
    version = "0.7.7";
  };
  websocket-extensions = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HGumMJLNo0PrU/xlcRDHHHVMVkhKrUJXhJUifXF6gkE=";
      type = "gem";
    };
    version = "0.1.5";
  };
  with_advisory_lock = {
    dependencies = [
      "activerecord"
      "zeitwerk"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-BpLNggE7JxxZql4fYDt0GrlJJtvOCYmQ+6zl3VQS/tc=";
      type = "gem";
    };
    version = "5.1.0";
  };
  xpath = {
    dependencies = [ "nokogiri" ];
    groups = [
      "default"
      "test"
    ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-bf2nnZG7O5SblH7MWRnwQu8vOZuQQBPrPvbSDdOkCC4=";
      type = "gem";
    };
    version = "3.2.0";
  };
  yard = {
    groups = [ "development" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-pukQOZ545hP4C6mt2bp8OUsak18IPMy++CkDo9KiaZI=";
      type = "gem";
    };
    version = "0.9.37";
  };
  zeitwerk = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-hC4GfLEeuSPXRySbrftfzcllLW8gofBkUzF5IP3NRnM=";
      type = "gem";
    };
    version = "2.7.2";
  };
}
