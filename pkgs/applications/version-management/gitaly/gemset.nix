{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g85lqq0smj71g8a2dxb54ajjzw59c9snana4p61knryc83q3yg6";
      type = "gem";
    };
    version = "5.0.6";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0viqszpkggqi8hq87pqp0xykhvz60g99nwmkwsb0v45kc2liwxvk";
      type = "gem";
    };
    version = "2.5.2";
  };
  ast = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pp82blr5fakdk27d1d21xq9zchzb6vmyb1zcsl520s3ygvprn8m";
      type = "gem";
    };
    version = "2.3.0";
  };
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09dn56sx0kcw0k8ypiynhnhhiq7ff9m7b57l8wvnxj82wxsjb54y";
      type = "gem";
    };
    version = "0.7.5";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "183lszf5gx84kcpb779v6a2y0mx9sssy8dgppng1z9a505nj1qcf";
      type = "gem";
    };
    version = "1.0.5";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  escape_utils = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "088r5c2mz2vy2jbbx1xjbi8msnzg631ggli29nhik2spbcp1z6vh";
      type = "gem";
    };
    version = "1.1.1";
  };
  faraday = {
    dependencies = ["multipart-post"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c3x3s8vb5nf7inyfvhdxwa4q3swmnacpxby6pish5fgmhws7zrr";
      type = "gem";
    };
    version = "0.14.0";
  };
  gemojione = {
    dependencies = ["json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ayk8r147k1s38nj18pwk76npx1p7jhi86silk800nj913pjvrhj";
      type = "gem";
    };
    version = "3.3.0";
  };
  gitaly-proto = {
    dependencies = ["google-protobuf" "grpc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z3asy104q36sshq9zhmgcm32sg8qr8jvy0mi19nakkq7prrkwqv";
      type = "gem";
    };
    version = "0.83.0";
  };
  github-linguist = {
    dependencies = ["charlock_holmes" "escape_utils" "mime-types" "rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c8w92yzjfs7pjnm8bdjsgyd1jpisn10fb6dy43381k1k8pxsifd";
      type = "gem";
    };
    version = "4.7.6";
  };
  github-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nyb9ck2c9z5qi86n7r52w0m126qpnvc93yh35cn8bwsnkjqx0iq";
      type = "gem";
    };
    version = "1.6.1";
  };
  gitlab-grit = {
    dependencies = ["charlock_holmes" "diff-lcs" "mime-types" "posix-spawn"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgs3l81ghlc5nm75n0pz7b2cj3hpscfq5iy27c483nnjn2v5mc4";
      type = "gem";
    };
    version = "2.8.2";
  };
  gitlab-markup = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pvx257azpr00yvb74lgjpgnj72nwyd29l9a18280rgmp4cjniki";
      type = "gem";
    };
    version = "1.6.3";
  };
  gitlab-styles = {
    dependencies = ["rubocop" "rubocop-gitlab-security" "rubocop-rspec"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k8xrkjx8rcny8p0gsp18wskvn1qbw4rfgdp1f6x0p4xp6dlhjf4";
      type = "gem";
    };
    version = "2.0.0";
  };
  gollum-grit_adapter = {
    dependencies = ["gitlab-grit"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fcibm63v1afc0fj5rki0mm51m7nndil4cjcjjvkh3yigfn4nr4b";
      type = "gem";
    };
    version = "1.0.1";
  };
  gollum-lib = {
    dependencies = ["gemojione" "github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1filwvjfj5q2m6w4q274ai36d6f0mrsv2l2khhk4bv1q6pqby2fq";
      type = "gem";
    };
    version = "4.2.7";
  };
  gollum-rugged_adapter = {
    dependencies = ["mime-types" "rugged"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0khfmakp65frlaj7ajs6ihqg4xi7yc9z96kpsf1b7giqi3fqhhv4";
      type = "gem";
    };
    version = "0.4.4";
  };
  google-protobuf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0s8ijd9wdrkqwsb6nasrsv7f9i5im2nyax7f7jlb5y9vh8nl98qi";
      type = "gem";
    };
    version = "3.5.1";
  };
  googleapis-common-protos-types = {
    dependencies = ["google-protobuf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yf10s7w8wpa49hc86z7z2fkn9yz7j2njz0n8xmqb24ji090z4ck";
      type = "gem";
    };
    version = "1.0.1";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "logging" "memoist" "multi_json" "os" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08z4zfj9cwry13y8c2w5p4xylyslxxjq4wahd95bk1ddl5pknd4f";
      type = "gem";
    };
    version = "0.6.2";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleapis-common-protos-types" "googleauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02b80pyg4rgkiafyh1jqnfh6xp9abpd1x0a9c2h98f0851scw28b";
      type = "gem";
    };
    version = "1.8.7";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6971zmjxszdrp59vybns9gzxpdxzdklakc5lp8nl4fx5kpxkbp";
      type = "gem";
    };
    version = "0.8.1";
  };
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  jwt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1w0kaqrbl71cq9sbnixc20x5lqah3hs2i93xmhlfdg2y3by7yzky";
      type = "gem";
    };
    version = "2.1.0";
  };
  little-plugger = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1frilv82dyxnlg8k1jhrvyd73l6k17mxc5vwxx080r4x1p04gwym";
      type = "gem";
    };
    version = "1.1.4";
  };
  logging = {
    dependencies = ["little-plugger" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06j6iaj89h9jhkx1x3hlswqrfnqds8br05xb1qra69dpvbdmjcwn";
      type = "gem";
    };
    version = "2.2.2";
  };
  memoist = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pq8fhqh8w25qcw9v3vzfb0i6jp0k3949ahxc3wrwz2791dpbgbh";
      type = "gem";
    };
    version = "0.16.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0087z9kbnlqhci7fxh9f6il63hj1k02icq2rs0c6cppmqchr753m";
      type = "gem";
    };
    version = "3.1";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04my3746hwa4yvbx1ranhfaqkgf6vavi1kyijjnw8w3dy37vqhkm";
      type = "gem";
    };
    version = "3.2016.0521";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
  };
  minitest = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0300naf4ilpd9sf0k8si9h9sclkizaschn8bpnri5fqmvm9ybdbq";
      type = "gem";
    };
    version = "5.9.1";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rl0qy4inf1mp8mybfk56dfga0mvx97zwpmq5xmiwl5r770171nv";
      type = "gem";
    };
    version = "1.13.1";
  };
  multipart-post = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09k0b3cybqilk1gwrwwain95rdypixb2q9w65gd44gfzsd84xi1x";
      type = "gem";
    };
    version = "2.0.0";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "105xh2zkr8nsyfaj2izaisarpnkrrl9000y3nyflg9cbzrfxv021";
      type = "gem";
    };
    version = "1.8.1";
  };
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llv8w3g2jwggdxr5a5cjkrnbbfnvai3vxacxxc0fy84xmz3hymz";
      type = "gem";
    };
    version = "0.9.6";
  };
  parallel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qv2yj4sxr36ga6xdxvbq9h05hn10bwcbkqv6j6q1fiixhsdnnzd";
      type = "gem";
    };
    version = "1.12.0";
  };
  parser = {
    dependencies = ["ast"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "130rfk8a2ws2fyq52hmi1n0xakylw39wv4x1qhai4z17x2b0k9cq";
      type = "gem";
    };
    version = "2.4.0.0";
  };
  posix-spawn = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pmxmpins57qrbr31bs3bm7gidhaacmrp4md6i962gvpq4gyfcjw";
      type = "gem";
    };
    version = "0.3.13";
  };
  powerpack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fnn3fli5wkzyjl4ryh0k90316shqjfnhydmc7f8lqpi0q21va43";
      type = "gem";
    };
    version = "0.1.1";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mvzd9ycjw8ydb9qy3daq3kdzqs2vpqvac4dqss6ckk4rfcjc637";
      type = "gem";
    };
    version = "3.0.1";
  };
  rainbow = {
    dependencies = ["rake"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "08w2ghc5nv0kcq5b257h7dwjzjz1pqcavajfdx2xjyxqsvh2y34w";
      type = "gem";
    };
    version = "2.2.2";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mfqgpp3m69s5v1rd51lfh5qpjwyia5p4rg337pw8c8wzm6pgfsw";
      type = "gem";
    };
    version = "12.1.0";
  };
  rdoc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ba2mhqqcsp3k97x3iz9x29xk26rv4561lfzzzibcy41vvj1n4c";
      type = "gem";
    };
    version = "4.3.0";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kpahk5nkc33yxnn75649kzxaz073wvazr2zyg491nndykgnvcs";
      type = "gem";
    };
    version = "2.2.1";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nd50hycab2a2vdah9lxi585g8f63jxjvmzmxqyln51grxwx9hzb";
      type = "gem";
    };
    version = "3.6.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18np8wyw2g79waclpaacba6nd7x60ixg07ncya0j0qj1z9b37grd";
      type = "gem";
    };
    version = "3.6.0";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "028ifzf9mqp3kxx40q1nbwj40g72g9zk0wr78l146phblkv96w0a";
      type = "gem";
    };
    version = "3.6.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nv6jkxy24sag1i9w9wi3850k6skk2fm6yhcrgnmlz6vmwxvizp8";
      type = "gem";
    };
    version = "3.6.0";
  };
  rspec-support = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "050paqqpsml8w88nf4a15zbbj3vvm471zpv73sjfdnz7w21wnypb";
      type = "gem";
    };
    version = "3.6.0";
  };
  rubocop = {
    dependencies = ["parallel" "parser" "powerpack" "rainbow" "ruby-progressbar" "unicode-display_width"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hpd7zcv4y9y750wj630abvmcjwv39dsrj1fjff60ik7gfri0xlz";
      type = "gem";
    };
    version = "0.50.0";
  };
  rubocop-gitlab-security = {
    dependencies = ["rubocop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0aw9qmyc6xj6fi0jxp8m4apk358rd91z492ragn6jp4rghkqj5cy";
      type = "gem";
    };
    version = "0.1.0";
  };
  rubocop-rspec = {
    dependencies = ["rubocop"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hf48ng67yswvshmv4cyysj1rs1z3fnvlycr50jdcgwlynpyxkhs";
      type = "gem";
    };
    version = "1.17.0";
  };
  ruby-progressbar = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "029kv0q3kfq53rjyak4ypn7196l8z4hflfmv4p5787n78z7baiqf";
      type = "gem";
    };
    version = "1.8.3";
  };
  rugged = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rqhg6g2q2av3fb6iyzfd3hfjxvr8hs32w7llil2kbx73crvc2dy";
      type = "gem";
    };
    version = "0.26.0";
  };
  sanitize = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xsv6xqrlz91rd8wifjknadbl3z5h6qphmxy0hjb189qbdghggn3";
      type = "gem";
    };
    version = "2.1.0";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0js81lxqirdza8gf2f6avh11fny49ygmxfi1qx7jp8l9wrhznbkv";
      type = "gem";
    };
    version = "0.8.1";
  };
  stringex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zc93v00av643lc6njl09wwki7h5yqayhh1din8zqfylw814l1dv";
      type = "gem";
    };
    version = "2.7.1";
  };
  thread_safe = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmhcgq6cgz44srylra07bmaw99f5271l0dpsvl5f75m44l0gmwy";
      type = "gem";
    };
    version = "0.3.6";
  };
  tzinfo = {
    dependencies = ["thread_safe"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
      type = "gem";
    };
    version = "1.2.2";
  };
  unicode-display_width = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12pi0gwqdnbx1lv5136v3vyr0img9wr0kxcn4wn54ipq4y41zxq8";
      type = "gem";
    };
    version = "1.3.0";
  };
}