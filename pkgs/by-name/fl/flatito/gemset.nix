{
  ast = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "10yknjyn0728gjn6b5syynvrvrwm66bhssbxq8mkhshxghaiailm";
      type = "gem";
    };
    version = "2.4.3";
  };
  colorize = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0dy8ryhcdzgmbvj7jpa1qq3bhhk1m7a2pz6ip0m6dxh30rzj7d9h";
      type = "gem";
    };
    version = "1.1.0";
  };
  flatito = {
    dependencies = [ "colorize" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "03xmxibb069x0b48mj1sv3appi6x4j7ji2fbfkza1h8lka4qynlz";
      type = "gem";
    };
    version = "0.1.1";
  };
  json = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1hfcz73wszgqprg2pr83qjbyfb0k93frbdvyhgmw0ryyl9cgc44s";
      type = "gem";
    };
    version = "2.11.3";
  };
  language_server-protocol = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0scnz2fvdczdgadvjn0j9d49118aqm3hj66qh8sd2kv6g1j65164";
      type = "gem";
    };
    version = "3.17.0.4";
  };
  lint_roller = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "11yc0d84hsnlvx8cpk4cbj6a4dz9pk0r1k29p0n1fz9acddq831c";
      type = "gem";
    };
    version = "1.1.0";
  };
  minitest = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0mn7q9yzrwinvfvkyjiz548a4rmcwbmz2fn9nyzh4j1snin6q6rr";
      type = "gem";
    };
    version = "5.25.5";
  };
  parallel = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0c719bfgcszqvk9z47w2p8j2wkz5y35k48ywwas5yxbbh3hm3haa";
      type = "gem";
    };
    version = "1.27.0";
  };
  parser = {
    dependencies = [
      "ast"
      "racc"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0i9w8msil4snx5w11ix9b0wf52vjc3r49khy3ddgl1xk890kcxi4";
      type = "gem";
    };
    version = "3.3.8.0";
  };
  prism = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0gkhpdjib9zi9i27vd9djrxiwjia03cijmd6q8yj2q1ix403w3nw";
      type = "gem";
    };
    version = "1.4.0";
  };
  racc = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  rainbow = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0smwg4mii0fm38pyb5fddbmrdpifwv22zv3d3px2xx497am93503";
      type = "gem";
    };
    version = "3.1.1";
  };
  rake = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  regexp_parser = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0qccah61pjvzyyg6mrp27w27dlv6vxlbznzipxjcswl7x3fhsvyb";
      type = "gem";
    };
    version = "2.10.0";
  };
  rubocop = {
    dependencies = [
      "json"
      "language_server-protocol"
      "lint_roller"
      "parallel"
      "parser"
      "rainbow"
      "regexp_parser"
      "rubocop-ast"
      "ruby-progressbar"
      "unicode-display_width"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0zg97d12pwqk12iwphs9glkmlibklpis2ga5rvd82g826n37rnka";
      type = "gem";
    };
    version = "1.75.5";
  };
  rubocop-ast = {
    dependencies = [
      "parser"
      "prism"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "14lf3d9bdr8cv8x3xcn3ijql5x23svk5zy7mdinlzw1f7ch09k73";
      type = "gem";
    };
    version = "1.44.1";
  };
  rubocop-minitest = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1kpmvzny34ks8kj6f9w40v9z99vfkfyn72fanmc810ykzqivw8b0";
      type = "gem";
    };
    version = "0.38.0";
  };
  rubocop-performance = {
    dependencies = [
      "lint_roller"
      "rubocop"
      "rubocop-ast"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1h9flnqk2f3llwf8g0mk0fvzzznfj7hsil3qg88m803pi9b06zbg";
      type = "gem";
    };
    version = "1.25.0";
  };
  rubocop-rake = {
    dependencies = [
      "lint_roller"
      "rubocop"
    ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0kdfrckz1v32dy7c7bdiksjysx9l9zsda9kc6zvrsghch6vg55rp";
      type = "gem";
    };
    version = "0.7.1";
  };
  ruby-progressbar = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0cwvyb7j47m7wihpfaq7rc47zwwx9k4v7iqd9s1xch5nm53rrz40";
      type = "gem";
    };
    version = "1.13.0";
  };
  unicode-display_width = {
    dependencies = [ "unicode-emoji" ];
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "1has87asspm6m9wgqas8ghhhwyf2i1yqrqgrkv47xw7jq3qjmbwc";
      type = "gem";
    };
    version = "3.1.4";
  };
  unicode-emoji = {
    groups = [ "default" ];
    platforms = [ ];
    source = {
      remotes = [ "https://rubygems.org" ];
      sha256 = "0ajk6rngypm3chvl6r0vwv36q1931fjqaqhjjya81rakygvlwb1c";
      type = "gem";
    };
    version = "4.0.4";
  };
}
