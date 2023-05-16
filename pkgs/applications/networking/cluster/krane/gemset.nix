{
  activesupport = {
    dependencies = ["concurrent-ruby" "i18n" "minitest" "tzinfo"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1vlzcnyqlbchaq85phmdv73ydlc18xpvxy1cbsk191cwd29i7q32";
      type = "gem";
    };
    version = "7.0.7.2";
=======
      sha256 = "15m0b1im6i401ab51vzr7f8nk8kys1qa0snnl741y3sir3xd07jp";
      type = "gem";
    };
    version = "7.0.4.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "05r1fwy487klqkya7vzia8hnklcxy4vr92m9dmni3prfwk6zpw33";
      type = "gem";
    };
    version = "2.8.5";
=======
      sha256 = "15s8van7r2ad3dq6i03l3z4hqnvxcq75a3h72kxvf9an53sqma20";
      type = "gem";
    };
    version = "2.8.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  colorize = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "133rqj85n400qk6g3dhf2bmfws34mak1wqihvh3bgy9jhajw580b";
      type = "gem";
    };
    version = "0.8.1";
  };
  concurrent-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0krcwb6mn0iklajwngwsg850nk8k9b35dhmc2qkbdqvmifdi2y9q";
      type = "gem";
    };
    version = "1.2.2";
  };
  domain_name = {
    dependencies = ["unf"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lcqjsmixjp52bnlgzh4lg9ppsk52x9hpwdjd53k8jnbah2602h0";
      type = "gem";
    };
    version = "0.5.20190701";
  };
  ejson = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1bpry4i9ajh2h8fyljp0cb17iy03ar36yc9mpfxflmdznl7dwsjf";
      type = "gem";
    };
    version = "1.4.1";
=======
      sha256 = "0gmfyyzzvb9k5nm1a5x83d7krajfghghfsakhxmdpvncyj2vnrpa";
      type = "gem";
    };
    version = "1.3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  faraday = {
    dependencies = ["faraday-net_http" "ruby2_keywords"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "187clqhp9mv5mnqmjlfdp57svhsg1bggz84ak8v333j9skrnrgh9";
      type = "gem";
    };
    version = "2.7.10";
=======
      sha256 = "1f20vjx0ywx0zdb4dfx4cpa7kd51z6vg7dw5hs35laa45dy9g9pj";
      type = "gem";
    };
    version = "2.7.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  faraday-net_http = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13byv3mp1gsjyv8k0ih4612y6vw5kqva6i03wcg4w2fqpsd950k8";
      type = "gem";
    };
    version = "3.0.2";
  };
  ffi = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1862ydmclzy1a0cjbvm8dz7847d9rch495ib0zb64y84d3xd4bkg";
      type = "gem";
    };
    version = "1.15.5";
  };
  ffi-compiler = {
    dependencies = ["ffi" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0c2caqm9wqnbidcb8dj4wd3s902z15qmgxplwyfyqbwa0ydki7q1";
      type = "gem";
    };
    version = "1.0.1";
  };
  googleauth = {
    dependencies = ["faraday" "jwt" "memoist" "multi_json" "os" "signet"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0h1k47vjaq37l0w9q49g3f50j1b0c1svhk07rmd1h49w38v2hxag";
      type = "gem";
    };
    version = "1.7.0";
=======
      sha256 = "1lj5haarpn7rybbq9s031zcn9ji3rlz5bk64bwa2j34q5s1h5gis";
      type = "gem";
    };
    version = "1.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  http = {
    dependencies = ["addressable" "http-cookie" "http-form_data" "llhttp-ffi"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1bzb8p31kzv6q5p4z5xq88mnqk414rrw0y5rkhpnvpl29x5c3bpw";
      type = "gem";
    };
    version = "5.1.1";
  };
  http-accept = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09m1facypsdjynfwrcv19xcb1mqg8z6kk31g8r33pfxzh838c9n6";
      type = "gem";
    };
    version = "1.7.0";
  };
  http-cookie = {
    dependencies = ["domain_name"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13rilvlv8kwbzqfb644qp6hrbsj82cbqmnzcvqip1p6vqx36sxbk";
      type = "gem";
    };
    version = "1.0.5";
  };
  http-form_data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1wx591jdhy84901pklh1n9sgh74gnvq1qyqxwchni1yrc49ynknc";
      type = "gem";
    };
    version = "2.3.0";
  };
  i18n = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0qaamqsh5f3szhcakkak8ikxlzxqnv49n2p7504hcz2l0f4nj0wx";
      type = "gem";
    };
    version = "1.14.1";
=======
      sha256 = "1vdcchz7jli1p0gnc669a7bj3q1fv09y9ppf0y3k0vb1jwdwrqwi";
      type = "gem";
    };
    version = "1.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  jsonpath = {
    dependencies = ["multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1i1idcl0rpfkzkxngadw33a33v3gqf93a3kj52y2ha2zs26bdzjp";
      type = "gem";
    };
    version = "1.1.3";
=======
      sha256 = "0fkdjic88hh0accp0sbx5mcrr9yaqwampf5c3214212d4i614138";
      type = "gem";
    };
    version = "1.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  jwt = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "16z11alz13vfc4zs5l3fk6n51n2jw9lskvc4h4prnww0y797qd87";
      type = "gem";
    };
    version = "2.7.1";
  };
  krane = {
    dependencies = ["activesupport" "colorize" "concurrent-ruby" "ejson" "googleauth" "jsonpath" "kubeclient" "multi_json" "statsd-instrument" "thor"];
=======
      sha256 = "09yj3z5snhaawh2z1w45yyihzmh57m6m7dp8ra8gxavhj5kbiq5p";
      type = "gem";
    };
    version = "2.7.0";
  };
  krane = {
    dependencies = ["activesupport" "colorize" "concurrent-ruby" "ejson" "googleauth" "jsonpath" "kubeclient" "oj" "statsd-instrument" "thor"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1qf5la1w4zrbda5n3s01pb9gij5hyknwglsnqsrc0vcm6bslfygj";
      type = "gem";
    };
    version = "3.3.0";
=======
      sha256 = "1d8vdj3wd2qp8agyadn0w33qf7z2p5lk3vlslb8jlph8x5y3mm70";
      type = "gem";
    };
    version = "3.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  kubeclient = {
    dependencies = ["http" "jsonpath" "recursive-open-struct" "rest-client"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1k1zi27fnasqpinfxnajm81pyr11k2j510wacr53d37v97bzr1a9";
      type = "gem";
    };
    version = "4.11.0";
  };
  llhttp-ffi = {
    dependencies = ["ffi-compiler" "rake"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00dh6zmqdj59rhcya0l4b9aaxq6n8xizfbil93k0g06gndyk5xz5";
      type = "gem";
    };
    version = "0.4.0";
  };
  memoist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0i9wpzix3sjhf6d9zw60dm4371iq8kyz7ckh2qapan2vyaim6b55";
      type = "gem";
    };
    version = "0.16.2";
  };
  mime-types = {
    dependencies = ["mime-types-data"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0q8d881k1b3rbsfcdi3fx0b5vpdr5wcrhn88r2d9j7zjdkxp5mw5";
      type = "gem";
    };
    version = "3.5.1";
=======
      sha256 = "0ipw892jbksbxxcrlx9g5ljq60qx47pm24ywgfbyjskbcl78pkvb";
      type = "gem";
    };
    version = "3.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  mime-types-data = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "17zdim7kzrh5j8c97vjqp4xp78wbyz7smdp4hi5iyzk0s9imdn5a";
      type = "gem";
    };
    version = "3.2023.0808";
=======
      sha256 = "1pky3vzaxlgm9gw5wlqwwi7wsw3jrglrfflrppvvnsrlaiz043z9";
      type = "gem";
    };
    version = "3.2023.0218.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  minitest = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0jnpsbb2dbcs95p4is4431l2pw1l5pn7dfg3vkgb4ga464j0c5l6";
      type = "gem";
    };
    version = "5.19.0";
=======
      sha256 = "0ic7i5z88zcaqnpzprf7saimq2f6sad57g5mkkqsrqrcd6h3mx06";
      type = "gem";
    };
    version = "5.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  multi_json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pb1g1y3dsiahavspyzkdy39j4q377009f6ix0bh1ag4nqw43l0z";
      type = "gem";
    };
    version = "1.15.0";
  };
  netrc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
      type = "gem";
    };
    version = "0.11.0";
  };
<<<<<<< HEAD
=======
  oj = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0l8l90iibzrxs33vn3adrhbg8cbmbn1qfh962p7gzwwybsdw73qy";
      type = "gem";
    };
    version = "3.14.3";
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  os = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gwd20smyhxbm687vdikfh1gpi96h8qb1x28s2pdcysf6dm6v0ap";
      type = "gem";
    };
    version = "1.1.4";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0n9j7mczl15r3kwqrah09cxj8hxdfawiqxa60kga2bmxl9flfz9k";
      type = "gem";
    };
    version = "5.0.3";
=======
      sha256 = "0hz0bx2qs2pwb0bwazzsah03ilpf3aai8b7lk7s35jsfzwbkjq35";
      type = "gem";
    };
    version = "5.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15whn7p9nrkxangbs9hh75q585yfn66lv0v2mhj6q6dl6x8bzr2w";
      type = "gem";
    };
    version = "13.0.6";
  };
  recursive-open-struct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0nnyr6qsqrcszf6c10n4zfjs8h9n67zvsmx6mp8brkigamr8llx3";
      type = "gem";
    };
    version = "1.1.3";
  };
  rest-client = {
    dependencies = ["http-accept" "http-cookie" "mime-types" "netrc"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1qs74yzl58agzx9dgjhcpgmzfn61fqkk33k1js2y5yhlvc5l19im";
      type = "gem";
    };
    version = "2.1.0";
  };
  ruby2_keywords = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vz322p8n39hz3b4a9gkmz9y7a5jaz41zrm2ywf31dvkqm03glgz";
      type = "gem";
    };
    version = "0.0.5";
  };
  signet = {
    dependencies = ["addressable" "faraday" "jwt" "multi_json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0100rclkhagf032rg3r0gf3f4znrvvvqrimy6hpa73f21n9k2a0x";
      type = "gem";
    };
    version = "0.17.0";
  };
  statsd-instrument = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "1zpr5ms18ynygpwx73v0a8nkf41kpjylc9m3fyhvchq3ms17hcb0";
      type = "gem";
    };
    version = "3.5.11";
=======
      sha256 = "1pg308z3ck1vpazrmczklqa6f9qciay8nysnhc16pgfsh2npzzrz";
      type = "gem";
    };
    version = "3.5.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  thor = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
<<<<<<< HEAD
      sha256 = "0k7j2wn14h1pl4smibasw0bp66kg626drxb59z7rzflch99cd4rg";
      type = "gem";
    };
    version = "1.2.2";
=======
      sha256 = "0inl77jh4ia03jw3iqm5ipr76ghal3hyjrd6r8zqsswwvi9j2xdi";
      type = "gem";
    };
    version = "1.2.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
  tzinfo = {
    dependencies = ["concurrent-ruby"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16w2g84dzaf3z13gxyzlzbf748kylk5bdgg3n1ipvkvvqy685bwd";
      type = "gem";
    };
    version = "2.0.6";
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
      sha256 = "1yj2nz2l101vr1x9w2k83a0fag1xgnmjwp8w8rw4ik2rwcz65fch";
      type = "gem";
    };
    version = "0.0.8.2";
  };
}
