{
  charlock_holmes = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf1l31n10yaark2rrg5qzyzcx9w80681449s3j09qmnipsl8rl5";
      type = "gem";
    };
    version = "0.7.6";
  };
  diff-lcs = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18w22bjz424gzafv6nzv98h0aqkwz3d9xhm7cbr1wfbyas8zayza";
      type = "gem";
    };
    version = "1.3";
  };
  gemojione = {
    dependencies = ["json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ayk8r147k1s38nj18pwk76npx1p7jhi86silk800nj913pjvrhj";
      type = "gem";
    };
    version = "3.3.0";
  };
  github-markup = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17g6g18gdjg63k75sfwiskjzl9i0hfcnrkcpb4fwrnb20v3jgswp";
      type = "gem";
    };
    version = "1.7.0";
  };
  gitlab-grit = {
    dependencies = ["charlock_holmes" "diff-lcs" "mime-types" "posix-spawn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xgs3l81ghlc5nm75n0pz7b2cj3hpscfq5iy27c483nnjn2v5mc4";
      type = "gem";
    };
    version = "2.8.2";
  };
  gollum = {
    dependencies = ["gemojione" "gollum-lib" "kramdown" "mustache" "sinatra" "useragent"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ik1b0f73lcxfwfml1h84dp6br79g0z9v6x54wvl46n9d1ndrhl7";
      type = "gem";
    };
    version = "4.1.4";
  };
  gollum-grit_adapter = {
    dependencies = ["gitlab-grit"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fcibm63v1afc0fj5rki0mm51m7nndil4cjcjjvkh3yigfn4nr4b";
      type = "gem";
    };
    version = "1.0.1";
  };
  gollum-lib = {
    dependencies = ["gemojione" "github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex" "twitter-text"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1699wiir6f2a8yawk3qg0xn3zdc10mz783v53ri1ivfnzdrm3dvf";
      type = "gem";
    };
    version = "4.2.10";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sx97bm9by389rbzv8r1f43h06xcz8vwi3h5jv074gvparql7lcx";
      type = "gem";
    };
    version = "2.2.0";
  };
  kramdown = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12sral2xli39mnr4b9m2sxdlgam4ni0a1mkxawc5311z107zj3p0";
      type = "gem";
    };
    version = "1.9.0";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1m00pg19cm47n1qlcxgl91ajh2yq0fszvn1vy8fy0s1jkrp9fw4a";
      type = "gem";
    };
    version = "3.2019.0331";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15zplpfw3knqifj9bpf604rb3wc1vhq6363pd6lvhayng8wql5vy";
      type = "gem";
    };
    version = "2.4.0";
  };
  mustache = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g5hplm0k06vwxwqzwn1mq5bd02yp0h3rym4zwzw26aqi7drcsl2";
      type = "gem";
    };
    version = "0.99.8";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nmdrqqz1gs0fwkgzxjl4wr554gr8dc1fkrqjc2jpsvwgm41rygv";
      type = "gem";
    };
    version = "1.10.4";
  };
  posix-spawn = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pmxmpins57qrbr31bs3bm7gidhaacmrp4md6i962gvpq4gyfcjw";
      type = "gem";
    };
    version = "0.3.13";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rouge = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kpahk5nkc33yxnn75649kzxaz073wvazr2zyg491nndykgnvcs";
      type = "gem";
    };
    version = "2.2.1";
  };
  sanitize = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12ip1d80r0dgc621qn7c32bk12xxgkkg3w6q21s1ckxivcd7r898";
      type = "gem";
    };
    version = "2.1.1";
  };
  sinatra = {
    dependencies = ["rack" "rack-protection" "tilt"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byxzl7rx3ki0xd7aiv1x8mbah7hzd8f81l65nq8857kmgzj1jqq";
      type = "gem";
    };
    version = "1.4.8";
  };
  stringex = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15ns7j5smw04w6w7bqd5mm2qcl7w9lhwykyb974i4isgg9yc23ys";
      type = "gem";
    };
    version = "2.8.5";
  };
  tilt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ca4k0clwf0rkvy7726x4nxpjxkpv67w043i39saxgldxd97zmwz";
      type = "gem";
    };
    version = "2.0.9";
  };
  twitter-text = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1732h7hy1k152w8wfvjsx7b79alk45i5imwd37ia4qcx8hfm3gvg";
      type = "gem";
    };
    version = "1.14.7";
  };
  unf = {
    dependencies = ["unf_ext"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ll6w64ibh81qwvjx19h8nj7mngxgffg7aigjx11klvf5k2g4nxf";
      type = "gem";
    };
    version = "0.0.7.6";
  };
  useragent = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fv5kvq494swy0p17h9qya9r50w15xsi9zmvhzb8gh55kq6ki50p";
      type = "gem";
    };
    version = "0.16.10";
  };
}