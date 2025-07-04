{
  asciidoctor = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UiCIB/I336DKKYgvixPWC4IElhFq0ZHPGXylbyt/3fM=";
      type = "gem";
    };
    version = "2.0.23";
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
  creole = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lRcB4tgHYPFWscsqk0ccqXwHYom+zAZ6M7dFEz7TLAM=";
      type = "gem";
    };
    version = "0.5.0";
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
  expression_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-K1bbPP/EjDM39PKfW8I3TIbnuimstAJpx0u1Wvn4aKQ=";
      type = "gem";
    };
    version = "0.9.0";
  };
  gemojione = {
    dependencies = [ "json" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-qkYjQalo0+GJDioMdJoof7+nTUz/cmn44OLkd4cojTs=";
      type = "gem";
    };
    version = "4.3.3";
  };
  github-markup = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-P3CIiUunlsjHKZEgLfawCDql8hrrUQExZ+SVPSCgYlc=";
      type = "gem";
    };
    version = "4.0.2";
  };
  gollum = {
    dependencies = [
      "gemojione"
      "gollum-lib"
      "i18n"
      "kramdown"
      "kramdown-parser-gfm"
      "mustache-sinatra"
      "octicons"
      "rack"
      "rackup"
      "rdoc"
      "rss"
      "sinatra"
      "sinatra-contrib"
      "sprockets"
      "sprockets-helpers"
      "therubyrhino"
      "useragent"
      "webrick"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WblQYLjggquXuM6td3vfhkMC2tg+BayCVtdpRnIFS7Y=";
      type = "gem";
    };
    version = "6.1.0";
  };
  gollum-lib = {
    dependencies = [
      "gemojione"
      "github-markup"
      "gollum-rugged_adapter"
      "loofah"
      "nokogiri"
      "rouge"
      "twitter-text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-PGa4NTPdegiFK1h8LWkkdqR/T1ec0pI4j2zAXH5t++0=";
      type = "gem";
    };
    version = "6.0";
  };
  gollum-rugged_adapter = {
    dependencies = [
      "mime-types"
      "rugged"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-E5/2kcXEC6jGWaa2hL4HJ+0zXGb4cFrYSViPLV91gQI=";
      type = "gem";
    };
    version = "3.0";
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
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-3CKadPXRgfCZQt1gq11uZn9zksTugm81CW2zbR/jYUw=";
      type = "gem";
    };
    version = "1.14.6";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0r3vRkQFL62RwXhdSCY3Vv4y/KwIuWoguxWEDpZVDRE=";
      type = "gem";
    };
    version = "2.9.1";
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
  logger = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-w8/lbQFlZJDd0QPTi4mT1z2GKWrevF9YzvyewDdB5Ws=";
      type = "gem";
    };
    version = "1.6.5";
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
  mime-types = {
    dependencies = [
      "logger"
      "mime-types-data"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b3HblXhAzq5EIRUx7/Pi9+DdRkX++19TXbrrYwerZGQ=";
      type = "gem";
    };
    version = "3.6.0";
  };
  mime-types-data = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IypJfMaM/KWJgmhdR/sm8Q7y6wCcTRxTp+FZ1XJ0Pco=";
      type = "gem";
    };
    version = "3.2025.0107";
  };
  mini_portile2 = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-jkcTbNrATOgXULtsCXM7N4lb8GliVU5LQFbXgWjXCnU=";
      type = "gem";
    };
    version = "2.8.8";
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
  mustache = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kIkf3VC1ORnKM0yMEDHq2hIV540ibVeV5SPWEjonF9A=";
      type = "gem";
    };
    version = "1.1.1";
  };
  mustache-sinatra = {
    dependencies = [ "mustache" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0QyAyuhynksfI85ytKG+dprS2yiRO8piqtZCA2Pjwg0=";
      type = "gem";
    };
    version = "2.0.0";
  };
  mustermann = {
    dependencies = [ "ruby2_keywords" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0fjpui3a7UcVDd+B9qfqBGgmtkxnL7yS2DvOa3Blfog=";
      type = "gem";
    };
    version = "3.0.3";
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
      hash = "sha256-3xi+fpbDRza2q/3tqAxuhFE0+5r+L+XU+8HPH4nGhHU=";
      type = "gem";
    };
    version = "1.18.1";
  };
  octicons = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-x0Zls5nWtiDYeDn1AmgI2c5dKw2ZOlvRP7QzB7LeLyg=";
      type = "gem";
    };
    version = "19.14.0";
  };
  org-ruby = {
    dependencies = [ "rubypants" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-k8vsOkRwy53KakqY3CdqZDTqnZ57wtQuozw67dXRyXQ=";
      type = "gem";
    };
    version = "0.9.12";
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
      hash = "sha256-hKVLuVLRRgT+oi2Zk4NIgUZ4eC9YsSZI/N+k0vzoWe4=";
      type = "gem";
    };
    version = "5.2.3";
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
  rack = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-0/vLykPcK0PJxtffusAWZ65YZDxCzqEAE9DalwIYobE=";
      type = "gem";
    };
    version = "3.1.8";
  };
  rack-protection = {
    dependencies = [
      "base64"
      "logger"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UaJUpdV0p/DKTwZyAlzipe98jDvQnEMTSdaD6CXX0Wo=";
      type = "gem";
    };
    version = "4.1.1";
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
  rdoc = {
    dependencies = [ "psych" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-vsZvubAZvmT3un0s0q7LKDo6Af7yOpWzPiNJxtGqAEA=";
      type = "gem";
    };
    version = "6.11.0";
  };
  RedCloth = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UjGy/dkakzkVy6Mw5f0adAJed7VvV7dATHGR6/KBIpc=";
      type = "gem";
    };
    version = "4.3.4";
  };
  rexml = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-776h77p/oVEVjg7h5kNSWDTaLY60z3RKpo9kgLyYBLI=";
      type = "gem";
    };
    version = "3.4.0";
  };
  rouge = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-o9NTIiqnLkniyGcmwLz9cZ+CWS9X1JRHRlX0jmaezrY=";
      type = "gem";
    };
    version = "3.30.0";
  };
  rss = {
    dependencies = [ "rexml" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-tGI0wEVRuSUYD4vt/G9gRb8tmZhBf+2nLzAOeYAiZzc=";
      type = "gem";
    };
    version = "0.3.1";
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
  rubypants = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MOtnSt1FfdBSMsY1f37mdFNmBvedn1Xg+E20QrziYk8=";
      type = "gem";
    };
    version = "0.7.1";
  };
  rugged = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-f6qpEsWIjW40jSD6MSCbZAnxV0NGsbgOMJ28fo1j76w=";
      type = "gem";
    };
    version = "1.9.0";
  };
  sinatra = {
    dependencies = [
      "logger"
      "mustermann"
      "rack"
      "rack-protection"
      "rack-session"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-Tpl7hZqhtdLmJPhdWw/Q8LOrwNpE2qbL3xD3wNqfTQA=";
      type = "gem";
    };
    version = "4.1.1";
  };
  sinatra-contrib = {
    dependencies = [
      "multi_json"
      "mustermann"
      "rack-protection"
      "sinatra"
      "tilt"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-HqS1iYCl5ZkkVHl1P16rc0rYBv8fECcDKnG+ihyPP74=";
      type = "gem";
    };
    version = "4.1.1";
  };
  sprockets = {
    dependencies = [
      "concurrent-ruby"
      "rack"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-lRsT3S8vyuhApxhHImiagD4P+dJwLZAr2ESxltp3P5c=";
      type = "gem";
    };
    version = "4.2.1";
  };
  sprockets-helpers = {
    dependencies = [ "sprockets" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-MgodIQo+mQtoLIfcypiB54RhxDBjaTi1pgU8U4aqIxQ=";
      type = "gem";
    };
    version = "1.4.0";
  };
  stringio = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-IE8YKPhc2znVfKxKvG3ESwRQWiI/ExWH8uIK43KboTE=";
      type = "gem";
    };
    version = "3.1.2";
  };
  therubyrhino = {
    dependencies = [ "therubyrhino_jar" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-zI0Fgjhqjhbo+nYVvdTcaQn8IGyFKJ5J1PKP2uf9lQw=";
      type = "gem";
    };
    version = "2.1.2";
  };
  therubyrhino_jar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-RUBFTrrFaJacHqAAKD3aVAVsBrLnaMf2mccKuzUtKpE=";
      type = "gem";
    };
    version = "1.7.8";
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
  twitter-text = {
    dependencies = [ "unf" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-b79RHUSdYaLiGY3XWGIhk6p01ulabscRFyXM4OGBYpw=";
      type = "gem";
    };
    version = "1.14.7";
  };
  unf = {
    dependencies = [ "unf_ext" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-SZlRelMfKpVXUPiDGUGJH2FYSY7Jtsscgc6JOI5jAi4=";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-kmEUqFiTQSbGu/0yVDR9rbXa41RxGGk2jA9143Zfxuk=";
      type = "gem";
    };
    version = "0.0.9.1";
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
  wikicloth = {
    dependencies = [
      "builder"
      "expression_parser"
      "htmlentities"
      "nokogiri"
      "twitter-text"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-UC5ohXnPtsQI01PCZgjUSVVhwgqAdpdZLquO9HLI6DA=";
      type = "gem";
    };
    version = "0.8.3";
  };
}
