{
  charlock_holmes = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nf1l31n10yaark2rrg5qzyzcx9w80681449s3j09qmnipsl8rl5";
      type = "gem";
    };
    version = "0.7.6";
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
      sha256 = "17g6g18gdjg63k75sfwiskjzl9i0hfcnrkcpb4fwrnb20v3jgswp";
      type = "gem";
    };
    version = "1.7.0";
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
  gollum = {
    dependencies = ["gemojione" "gollum-lib" "kramdown" "mustache" "sinatra" "useragent"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ik1b0f73lcxfwfml1h84dp6br79g0z9v6x54wvl46n9d1ndrhl7";
      type = "gem";
    };
    version = "4.1.4";
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
    dependencies = ["gemojione" "github-markup" "gollum-grit_adapter" "nokogiri" "rouge" "sanitize" "stringex" "twitter-text"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1699wiir6f2a8yawk3qg0xn3zdc10mz783v53ri1ivfnzdrm3dvf";
      type = "gem";
    };
    version = "4.2.10";
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
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fjxy1jm52ixpnv3vg9ld9pr9f35gy0jp66i1njhqjvmnvq0iwwk";
      type = "gem";
    };
    version = "3.2.2";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07wvp0aw2gjm4njibb70as6rh5hi1zzri5vky1q6jx95h8l56idc";
      type = "gem";
    };
    version = "3.2018.0812";
  };
  mini_portile2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13d32jjadpjj6d2wdhkfpsmy68zjx90p49bgf8f7nkpz86r1fr11";
      type = "gem";
    };
    version = "2.3.0";
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
      sha256 = "1h9nml9h3m0mpvmh8jfnqvblnz5n5y3mmhgfc38avfmfzdrq9bgc";
      type = "gem";
    };
    version = "1.8.4";
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
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-protection = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0my0wlw4a5l3hs79jkx2xzv7djhajgf8d28k8ai1ddlnxxb0v7ss";
      type = "gem";
    };
    version = "1.5.5";
  };
  rouge = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02kpahk5nkc33yxnn75649kzxaz073wvazr2zyg491nndykgnvcs";
      type = "gem";
    };
    version = "2.2.1";
  };
  sanitize = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12ip1d80r0dgc621qn7c32bk12xxgkkg3w6q21s1ckxivcd7r898";
      type = "gem";
    };
    version = "2.1.1";
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
      sha256 = "0c5dfrjzkskzfsdvwsviq4111rwwpbk9022nxwdidz014mky5vi1";
      type = "gem";
    };
    version = "2.8.4";
  };
  tilt = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0020mrgdf11q23hm1ddd6fv691l51vi10af00f137ilcdb2ycfra";
      type = "gem";
    };
    version = "2.0.8";
  };
  twitter-text = {
    dependencies = ["unf"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1732h7hy1k152w8wfvjsx7b79alk45i5imwd37ia4qcx8hfm3gvg";
      type = "gem";
    };
    version = "1.14.7";
  };
  unf = {
    dependencies = ["unf_ext"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
      type = "gem";
    };
    version = "0.1.4";
  };
  unf_ext = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06p1i6qhy34bpb8q8ms88y6f2kz86azwm098yvcc0nyqk9y729j1";
      type = "gem";
    };
    version = "0.0.7.5";
  };
  useragent = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fv5kvq494swy0p17h9qya9r50w15xsi9zmvhzb8gh55kq6ki50p";
      type = "gem";
    };
    version = "0.16.10";
  };
}