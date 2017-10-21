{
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jsl6k27wjmssxbwv9wpf7hgp9r0nvizcf6qpjnr7qs2nia53lf7";
      type = "gem";
    };
    version = "0.7.3";
  };
  diff-lcs = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
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
      sha256 = "0lf1cr6pzqrbnxiiwym6q74b1a2ihdi91dynajk8hi1p093hl66n";
      type = "gem";
    };
    version = "2.8.1";
  };
  gollum = {
    dependencies = ["gemojione" "gollum-lib" "kramdown" "mustache" "sinatra" "useragent"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "051pm2f50daiqcqy87aq4809x4c95iwwml6ca4wgvvmj5zkk6k5a";
      type = "gem";
    };
    version = "4.1.2";
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
  json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01v6jjpvh3gnq6sgllpfqahlgxzj50ailwhj9b3cd20hi2dx0vxp";
      type = "gem";
    };
    version = "2.1.0";
  };
  kramdown = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12sral2xli39mnr4b9m2sxdlgam4ni0a1mkxawc5311z107zj3p0";
      type = "gem";
    };
    version = "1.9.0";
  };
  mime-types = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03j98xr0qw2p2jkclpmk7pm29yvmmh0073d8d43ajmr0h3w7i5l9";
      type = "gem";
    };
    version = "2.99.3";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g5bpgy08q0nc0anisg3yvwc1gc3inl854fcrg48wvg7glqd6dpm";
      type = "gem";
    };
    version = "2.2.0";
  };
  mustache = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5hplm0k06vwxwqzwn1mq5bd02yp0h3rym4zwzw26aqi7drcsl2";
      type = "gem";
    };
    version = "0.99.8";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nffsyx1xjg6v5n9rrbi8y1arrcx2i5f21cp6clgh9iwiqkr7rnn";
      type = "gem";
    };
    version = "1.8.0";
  };
  posix-spawn = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pmxmpins57qrbr31bs3bm7gidhaacmrp4md6i962gvpq4gyfcjw";
      type = "gem";
    };
    version = "0.3.13";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19m7aixb2ri7p1n0iqaqx8ldi97xdhvbxijbyrrcdcl6fv5prqza";
      type = "gem";
    };
    version = "1.6.8";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0cvb21zz7p9wy23wdav63z5qzfn4nialik22yqp6gihkgfqqrh5r";
      type = "gem";
    };
    version = "1.5.3";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wn6rq5qjmcwh9ixkljazv6gmg746rgbgs6av5qnk0mxim5qw11p";
      type = "gem";
    };
    version = "2.1.1";
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
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  stringex = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zc93v00av643lc6njl09wwki7h5yqayhh1din8zqfylw814l1dv";
      type = "gem";
    };
    version = "2.7.1";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  useragent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1139cjqyv1hk1qcw89k81ajjkqyakqgbcyvmfrsmjqi8yn9kgqhq";
      type = "gem";
    };
    version = "0.16.8";
  };
}