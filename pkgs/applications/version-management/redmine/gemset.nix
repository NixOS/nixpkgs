{
  actionmailer = {
    dependencies = ["actionpack" "actionview" "activejob" "mail" "rails-dom-testing"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18wwlj4f7jffv3vxm80d2z36nwza95l5xfcqc401hvvrls4xzhsy";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  actionpack = {
    dependencies = ["actionview" "activesupport" "rack" "rack-test" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rmldsk3a4lwxk0lrp6x1nz1v1r2xmbm3300l4ghgfygv3grdwjh";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  actionpack-xml_parser = {
    dependencies = ["actionpack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17am4nd7x6g8x7f8i35rzzv2qrxlkc230rbgzg98af0yf50j8gka";
      type = "gem";
    };
    version = "1.0.2";
  };
  actionview = {
    dependencies = ["activesupport" "builder" "erubis" "rails-dom-testing" "rails-html-sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0x7vjn8q6blzyf7j3kwg0ciy7vnfh28bjdkd1mp9k4ghp9jn0g9p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activejob = {
    dependencies = ["activesupport" "globalid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jy1c1r6syjqpa0sh9f1p4iaxzvp6qg4n6zs774j9z27q7h407mj";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activemodel = {
    dependencies = ["activesupport" "builder"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c1x0rd6wnk1f0gsmxs6x3gx7yf6fs9qqkdv7r4hlbcdd849in33";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activerecord = {
    dependencies = ["activemodel" "activesupport" "arel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07ixiwi0zzs9skqarvpfamsnay7npfswymrn28ngxaf8hi279q5p";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  activesupport = {
    dependencies = ["i18n" "minitest" "thread_safe" "tzinfo"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vbq7a805bfvyik2q3kl9s3r418f5qzvysqbz2cwy4hr7m2q4ir6";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  addressable = {
    dependencies = ["public_suffix"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fvchp2rhp2rmigx7qglf69xvjqvzq7x0g49naliw29r2bz656sy";
      type = "gem";
    };
    version = "2.7.0";
  };
  arel = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nfcrdiys6q6ylxiblky9jyssrw2xj96fmxmal7f4f0jj3417vj4";
      type = "gem";
    };
    version = "6.0.4";
  };
  builder = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qibi5s67lpdv1wgcj66wcymcr04q6j4mzws6a479n0mlrmh5wr1";
      type = "gem";
    };
    version = "3.2.3";
  };
  capybara = {
    dependencies = ["addressable" "mini_mime" "nokogiri" "rack" "rack-test" "xpath"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yv77rnsjlvs8qpfn9n5vf1h6b9agxwhxw09gssbiw9zn9j20jh8";
      type = "gem";
    };
    version = "2.18.0";
  };
  childprocess = {
    dependencies = ["ffi"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a61922kmvcxyj5l70fycapr87gz1dzzlkfpq85rfqk5vdh3d28p";
      type = "gem";
    };
    version = "0.9.0";
  };
  coderay = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15vav4bhcc2x3jmi3izb11l4d9f3xv8hp2fszb7iqmpsccv1pz4y";
      type = "gem";
    };
    version = "1.1.2";
  };
  concurrent-ruby = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1x07r23s7836cpp5z9yrlbpljcxpax14yw4fy4bnp6crhr6x24an";
      type = "gem";
    };
    version = "1.1.5";
  };
  crass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "030sc98kjrb36rh7g21qsbdfxrj6knsjkx0mn3b7gig8zknwhp2f";
      type = "gem";
    };
    version = "1.0.5";
  };
  css_parser = {
    dependencies = ["addressable"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1y4vc018b5mzp7winw4pbb22jk0dpxp22pzzxq7w0rgvfxzi89pd";
      type = "gem";
    };
    version = "1.7.0";
  };
  docile = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
      type = "gem";
    };
    version = "1.1.5";
  };
  erubis = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
      type = "gem";
    };
    version = "2.7.0";
  };
  ffi = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06mvxpjply8qh4j3fj9wh08kdzwkbnvsiysh0vrhlk5cwxzjmblh";
      type = "gem";
    };
    version = "1.11.1";
  };
  globalid = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1zkxndvck72bfw235bd9nl2ii0lvs5z88q14706cmn702ww2mxv1";
      type = "gem";
    };
    version = "0.4.2";
  };
  htmlentities = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1nkklqsn8ir8wizzlakncfv42i32wc0w9hxp00hvdlgjr7376nhj";
      type = "gem";
    };
    version = "4.3.4";
  };
  i18n = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
      type = "gem";
    };
    version = "0.7.0";
  };
  jquery-rails = {
    dependencies = ["railties" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lk7xqmms45czylxs22kv5khlbm7a0yqcchqijxb9m10zsqc6lp5";
      type = "gem";
    };
    version = "3.1.5";
  };
  loofah = {
    dependencies = ["crass" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06kfq90vi38gv6i128f4zg462kj32szs5vsgm25hxgw9zd12pj9x";
      type = "gem";
    };
    version = "2.3.0";
  };
  mail = {
    dependencies = ["mime-types"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d7lhj2dw52ycls6xigkfz6zvfhc6qggply9iycjmcyj9760yvz9";
      type = "gem";
    };
    version = "2.6.6";
  };
  metaclass = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hp99y2b1nh0nr8pc398n3f8lakgci6pkrg4bf2b2211j1f6hsc5";
      type = "gem";
    };
    version = "0.0.4";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0g7l18igjb9z7q4b2ykvyxyvjxlx5pwsmx5z3ibdbr6372xgfglk";
      type = "gem";
    };
    version = "3.3";
  };
  mime-types-data = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18x61fc36951vw7f74gq8cyybdpxvyg5d0azvqhrs82ddw3v16xh";
      type = "gem";
    };
    version = "3.2019.1009";
  };
  mimemagic = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04cp5sfbh1qx82yqxn0q75c7hlcx8y1dr5g3kyzwm4mx6wi2gifw";
      type = "gem";
    };
    version = "0.3.3";
  };
  mini_mime = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1axm0rxyx3ss93wbmfkm78a6x03l8y4qy60rhkkiq0aza0vwq3ha";
      type = "gem";
    };
    version = "1.0.2";
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
      sha256 = "0zjm24aiz42i9n37mcw8lydd7n0y7wfk27by06jx77ypcld3qvkw";
      type = "gem";
    };
    version = "5.12.2";
  };
  mocha = {
    dependencies = ["metaclass"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s56iivmwpv4979hd25v3ghwwgy8ah15nh378lrj8czlh4kf5k5s";
      type = "gem";
    };
    version = "1.9.0";
  };
  multi_json = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xy54mjf7xg41l8qrg1bqri75agdqmxap9z466fjismc1rn2jwfr";
      type = "gem";
    };
    version = "1.14.1";
  };
  mysql2 = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qjd97w6a0w9aldsrhb2y6jrc4wnnlbj5j8kcl7pp7vviwa0r5iq";
      type = "gem";
    };
    version = "0.4.10";
  };
  net-ldap = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0z1j0zklbbx3vi91zcd2v0fnkfgkvq3plisa6hxaid8sqndyak46";
      type = "gem";
    };
    version = "0.12.1";
  };
  nokogiri = {
    dependencies = ["mini_portile2"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byyxrazkfm29ypcx5q4syrv126nvjnf7z6bqi01sqkv4llsi4qz";
      type = "gem";
    };
    version = "1.8.5";
  };
  pg = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07dv4ma9xd75xpsnnwwg1yrpwpji7ydy0q1d9dl0yfqbzpidrw32";
      type = "gem";
    };
    version = "0.18.4";
  };
  protected_attributes = {
    dependencies = ["activemodel"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18lvrvmcwjvjr2mrn20vaf68a0q6mg4cy9f0m1i7x83p0ljhhyar";
      type = "gem";
    };
    version = "1.1.4";
  };
  public_suffix = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0xnfv2j2bqgdpg2yq9i2rxby0w2sc9h5iyjkpaas2xknwrgmhdb0";
      type = "gem";
    };
    version = "4.0.1";
  };
  rack = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1g9926ln2lw12lfxm4ylq1h6nl0rafl10za3xvjzc87qvnqic87f";
      type = "gem";
    };
    version = "1.6.11";
  };
  rack-openid = {
    dependencies = ["rack" "ruby-openid"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0sg85yn981j3a0iri3ch4znzdwscvz29l7vrk3dafqw4fdg31llc";
      type = "gem";
    };
    version = "1.4.2";
  };
  rack-test = {
    dependencies = ["rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
      type = "gem";
    };
    version = "0.6.3";
  };
  rails = {
    dependencies = ["actionmailer" "actionpack" "actionview" "activejob" "activemodel" "activerecord" "activesupport" "railties" "sprockets-rails"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ywvis59dd3v8qapi9ix6743zgk07l21x1cd6nb1ddpahxhm7dml";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  rails-deprecated_sanitizer = {
    dependencies = ["activesupport"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0qxymchzdxww8bjsxj05kbf86hsmrjx40r41ksj0xsixr2gmhbbj";
      type = "gem";
    };
    version = "1.0.3";
  };
  rails-dom-testing = {
    dependencies = ["activesupport" "nokogiri" "rails-deprecated_sanitizer"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0wssfqpn00byhvp2372p99mphkcj8qx6pf6646avwr9ifvq0q1x6";
      type = "gem";
    };
    version = "1.0.9";
  };
  rails-html-sanitizer = {
    dependencies = ["loofah"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1icpqmxbppl4ynzmn6dx7wdil5hhq6fz707m9ya6d86c7ys8sd4f";
      type = "gem";
    };
    version = "1.3.0";
  };
  railties = {
    dependencies = ["actionpack" "activesupport" "rake" "thor"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bjf21z9maiiazc1if56nnh9xmgbkcqlpznv34f40a1hsvgk1d1m";
      type = "gem";
    };
    version = "4.2.11.1";
  };
  rake = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "05l80mgaabdipkjsnjlffn9gc1wx9fi629d2kfbz8628cx3m6686";
      type = "gem";
    };
    version = "13.0.0";
  };
  rbpdf = {
    dependencies = ["htmlentities" "rbpdf-font"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fnhcn4z2zz6ic1yvl5hmhwmkdnybh8f8fnk1ni7bvl2s4ig5195";
      type = "gem";
    };
    version = "1.19.8";
  };
  rbpdf-font = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pxlr0l4vf785qpy55m439dyii63a26l0sd0yyhbwwcy9zm9hd1v";
      type = "gem";
    };
    version = "1.19.1";
  };
  rdoc = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13ba2mhqqcsp3k97x3iz9x29xk26rv4561lfzzzibcy41vvj1n4c";
      type = "gem";
    };
    version = "4.3.0";
  };
  redcarpet = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0h9qz2hik4s9knpmbwrzb3jcp3vc5vygp9ya8lcpl7f1l9khmcd7";
      type = "gem";
    };
    version = "3.4.0";
  };
  request_store = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ky19wb6mpq6dxb81a0h4hnzx7a4ka99n9ay2syi68djbr4bkbbh";
      type = "gem";
    };
    version = "1.0.5";
  };
  rmagick = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0m9x15cdlkcb9826s3s2jd97hxf50hln22p94x8hcccxi1lwklq6";
      type = "gem";
    };
    version = "2.16.0";
  };
  roadie = {
    dependencies = ["css_parser" "nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0frp5yb07ib9y1k43shd4xjkb9a6wavhqq892l8yi9y73qi2cqbc";
      type = "gem";
    };
    version = "3.2.2";
  };
  roadie-rails = {
    dependencies = ["railties" "roadie"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hxgl5marq2hi6lcc73f7g6afd7dz4w893rrgrbh7m3k8zrwjyk1";
      type = "gem";
    };
    version = "1.1.1";
  };
  ruby-openid = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "190p1m0bxd9xkfk1j6cpcv3x5c367g36nsglg4m1fcwqdd13k3kz";
      type = "gem";
    };
    version = "2.9.2";
  };
  rubyzip = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qxc2zxwwipm6kviiar4gfhcakpx1jdcs89v6lvzivn5hq1xk78l";
      type = "gem";
    };
    version = "1.3.0";
  };
  selenium-webdriver = {
    dependencies = ["childprocess" "rubyzip" "websocket"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15qyf7b9fa2nxhhwp551b9fjj82kb3wmy65559yrrcwpdadqvcs4";
      type = "gem";
    };
    version = "2.53.4";
  };
  simplecov = {
    dependencies = ["docile" "multi_json" "simplecov-html"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1a3wy9zlmfwl3f47cibnxyxrgfz16y6fmy0dj1vyidzyys4mvy12";
      type = "gem";
    };
    version = "0.9.2";
  };
  simplecov-html = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jv9pmpaxihrcsgcf6mgl3qg7rhf9scl5l2k67d768w9cz63xgvc";
      type = "gem";
    };
    version = "0.9.0";
  };
  sprockets = {
    dependencies = ["concurrent-ruby" "rack"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "182jw5a0fbqah5w9jancvfmjbk88h8bxdbwnl4d3q809rpxdg8ay";
      type = "gem";
    };
    version = "3.7.2";
  };
  sprockets-rails = {
    dependencies = ["actionpack" "activesupport" "sprockets"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ab42pm8p5zxpv3sfraq45b9lj39cz9mrpdirm30vywzrwwkm5p1";
      type = "gem";
    };
    version = "3.2.1";
  };
  test_after_commit = {
    dependencies = ["activerecord"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1fzg8qan6f0n0ynr594bld2k0rwwxj99yzhiga2f3pkj9ina1abb";
      type = "gem";
    };
    version = "0.4.2";
  };
  thor = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1yhrnp9x8qcy5vc7g438amd5j9sw83ih7c30dr6g6slgw9zj3g29";
      type = "gem";
    };
    version = "0.20.3";
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
      sha256 = "1fjx9j327xpkkdlxwmkl3a8wqj7i4l4jwlrv3z13mg95z9wl253z";
      type = "gem";
    };
    version = "1.2.5";
  };
  websocket = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f11rcn4qgffb1rq4kjfwi7di79w8840x9l74pkyif5arp0mb08x";
      type = "gem";
    };
    version = "1.2.8";
  };
  xpath = {
    dependencies = ["nokogiri"];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      type = "gem";
    };
    version = "3.2.0";
  };
  yard = {
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rxqwry3h2hjz069f0kfr140wgx1khgljnqf112dk5x9rm4l0xny";
      type = "gem";
    };
    version = "0.9.20";
  };
}