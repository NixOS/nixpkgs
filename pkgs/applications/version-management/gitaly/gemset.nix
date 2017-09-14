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
  gitaly = {
    dependencies = ["google-protobuf" "grpc"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16ya0vqmrr3nsrsrcph1rqnb43gpvszhvs8v6viki5lvg9rdxb67";
      type = "gem";
    };
    version = "0.30.0";
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
  google-protobuf = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1q0ka7x53b9vx4wdb2jdvwxxpb5i5ns7fhqb9zgbrp8yy1bg9m9p";
      type = "gem";
    };
    version = "3.3.0";
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
      sha256 = "0hp8sfvl99imzp3c5sp96qpi49550v7ri7ljfvb3nllcmd3jw7sk";
      type = "gem";
    };
    version = "1.4.1";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s6971zmjxszdrp59vybns9gzxpdxzdklakc5lp8nl4fx5kpxkbp";
      type = "gem";
    };
    version = "0.8.1";
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
  os = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1llv8w3g2jwggdxr5a5cjkrnbbfnvai3vxacxxc0fy84xmz3hymz";
      type = "gem";
    };
    version = "0.9.6";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "040jf98jpp6w140ghkhw2hvc1qx41zvywx5gj7r2ylr1148qnj7q";
      type = "gem";
    };
    version = "2.0.5";
  };
  rugged = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1rqhg6g2q2av3fb6iyzfd3hfjxvr8hs32w7llil2kbx73crvc2dy";
      type = "gem";
    };
    version = "0.26.0";
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
}