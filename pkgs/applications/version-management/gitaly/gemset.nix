{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vgjr48yiynwf9rh2nsxa8w134na0805l40chf9g9scii9k70rj9";
      type = "gem";
    };
    version = "5.0.0.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i8q32a4gr0zghxylpyy7jfqwxvwrivsxflg9mks6kx92frh75mh";
      type = "gem";
    };
    version = "2.5.1";
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
      sha256 = "157c4cmb5g1b3ny6k9qf9z57rfijl54fcq3hnqqf6g31g1m096b2";
      type = "gem";
    };
    version = "0.12.2";
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
      sha256 = "0s86126iqhbmkix6zs357ixlc1syyxmwk2blaimsav7f0x9swy82";
      type = "gem";
    };
    version = "0.59.0";
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
      sha256 = "1jh8axm5m75rvdf2i3s24pmi7p613armh9vk3p1d0ryfx159mqkl";
      type = "gem";
    };
    version = "3.4.0.2";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "logging" "memoist" "multi_json" "os" "signet"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1xpmvrzhczak25nm0k3r9aa083lmfnzi94mir3g1xyrgzz66vxli";
      type = "gem";
    };
    version = "0.5.3";
  };
  grpc = {
    dependencies = ["google-protobuf" "googleauth"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "056ipqai887x5jpbgcc215kdi0lfqjzcjbx3hx11cjrfww01zc52";
      type = "gem";
    };
    version = "1.6.0";
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
      sha256 = "124zz1142bi2if7hl5pcrcamwchv4icyr5kaal9m2q6wqbdl6aw4";
      type = "gem";
    };
    version = "1.5.6";
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
      sha256 = "1wpc23ls6v2xbk3l1qncsbz16npvmw8p0b38l8czdzri18mp51xk";
      type = "gem";
    };
    version = "1.12.1";
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
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
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
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kpahk5nkc33yxnn75649kzxaz073wvazr2zyg491nndykgnvcs";
      type = "gem";
    };
    version = "2.2.1";
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
      sha256 = "149668991xqibvm8kvl10kzy891yd6f994b4gwlx6c3vl24v5jq6";
      type = "gem";
    };
    version = "0.7.3";
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