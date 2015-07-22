{
  "actionmailer" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0qjv5akjbpgd4cx518k522mssvc3y3nki65hi6fj5nbzi7a6rwq5";
    };
    dependencies = [
      "actionpack"
      "actionview"
      "mail"
    ];
  };
  "actionpack" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "07y1ny00h69xklq260smyl5md052f617gqrzkyw5sxafs5z25zax";
    };
    dependencies = [
      "actionview"
      "activesupport"
      "rack"
      "rack-test"
    ];
  };
  "actionview" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "06sp37gfpn2jn7j6vlpp1y6vfi5kig60vyvixrjhyz0g4vgm13ax";
    };
    dependencies = [
      "activesupport"
      "builder"
      "erubis"
    ];
  };
  "active_model_serializers" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1ws3gx3wwlm17w7k0agwzmcmww6627lvqaqm828lzm3g1xqilkkl";
    };
    dependencies = [
      "activemodel"
    ];
  };
  "activemodel" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0rlqzz25l7vsphgkilg80kmk20d9h357awi27ax6zzb9klkqh0jr";
    };
    dependencies = [
      "activesupport"
      "builder"
    ];
  };
  "activerecord" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "0j4r0m32mjbwmz9gs8brln35jzr1cn7h585ggj0w0f1ai4hjsby5";
    };
    dependencies = [
      "activemodel"
      "activesupport"
      "arel"
    ];
  };
  "activesupport" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "13i3mz66d5kp5y39gjwmcfqv0wb6mxm5k1nnz40wvd38dsf7n3bs";
    };
    dependencies = [
      "i18n"
      "json"
      "minitest"
      "thread_safe"
      "tzinfo"
    ];
  };
  "addressable" = {
    version = "2.3.6";
    source = {
      type = "gem";
      sha256 = "137fj0whmn1kvaq8wjalp8x4qbblwzvg3g4bfx8d8lfi6f0w48p8";
    };
  };
  "archive-tar-minitar" = {
    version = "0.5.2";
    source = {
      type = "gem";
      sha256 = "1j666713r3cc3wb0042x0wcmq2v11vwwy5pcaayy5f0lnd26iqig";
    };
  };
  "arel" = {
    version = "5.0.1.20140414130214";
    source = {
      type = "gem";
      sha256 = "0dhnc20h1v8ml3nmkxq92rr7qxxpk6ixhwvwhgl2dbw9mmxz0hf9";
    };
  };
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "coveralls" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "0sz30d7b83qqsj3i0fr691w05d62wj7x3afh0ryjkqkis3fq94j4";
    };
    dependencies = [
      "multi_json"
      "rest-client"
      "simplecov"
      "term-ansicolor"
      "thor"
    ];
  };
  "crack" = {
    version = "0.4.2";
    source = {
      type = "gem";
      sha256 = "1il94m92sz32nw5i6hdq14f1a2c3s9hza9zn6l95fvqhabq38k7a";
    };
    dependencies = [
      "safe_yaml"
    ];
  };
  "database_cleaner" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "19w25yda684pg29bggq26wy4lpyjvzscwg2hx3hmmmpysiwfnxgn";
    };
  };
  "diff-lcs" = {
    version = "1.2.5";
    source = {
      type = "gem";
      sha256 = "1vf9civd41bnqi6brr5d9jifdw73j9khc6fkhfl1f8r9cpkdvlx1";
    };
  };
  "docile" = {
    version = "1.1.5";
    source = {
      type = "gem";
      sha256 = "0m8j31whq7bm5ljgmsrlfkiqvacrw6iz9wq10r3gwrv5785y8gjx";
    };
  };
  "docker-api" = {
    version = "1.13.0";
    source = {
      type = "gem";
      sha256 = "1rara27gn7lxaf12dqkx8s1clssg10jndfcy4wz2fv6ms1i1lnp6";
    };
    dependencies = [
      "archive-tar-minitar"
      "excon"
      "json"
    ];
  };
  "erubis" = {
    version = "2.7.0";
    source = {
      type = "gem";
      sha256 = "1fj827xqjs91yqsydf0zmfyw9p4l2jz5yikg3mppz6d7fi8kyrb3";
    };
  };
  "excon" = {
    version = "0.37.0";
    source = {
      type = "gem";
      sha256 = "05x7asmsq5m419n1lhzk9bic02gwng4cqmrcqsfnd6kmkwm8csv2";
    };
  };
  "faraday" = {
    version = "0.8.9";
    source = {
      type = "gem";
      sha256 = "17d79fsgx0xwh0mfxyz5pbr435qlw79phlfvifc546w2axdkp718";
    };
    dependencies = [
      "multipart-post"
    ];
  };
  "faraday_middleware" = {
    version = "0.9.0";
    source = {
      type = "gem";
      sha256 = "1kwvi2sdxd6j764a7q5iir73dw2v6816zx3l8cgfv0wr2m47icq2";
    };
    dependencies = [
      "faraday"
    ];
  };
  "fleet-api" = {
    version = "0.6.0";
    source = {
      type = "gem";
      sha256 = "0136mzc0fxp6mzh38n6xbg87cw9g9vq1nrlr3ylazbflvmlxgan6";
    };
    dependencies = [
      "faraday"
      "faraday_middleware"
    ];
  };
  "hike" = {
    version = "1.2.3";
    source = {
      type = "gem";
      sha256 = "0i6c9hrszzg3gn2j41v3ijnwcm8cc2931fnjiv6mnpl4jcjjykhm";
    };
  };
  "i18n" = {
    version = "0.7.0";
    source = {
      type = "gem";
      sha256 = "1i5z1ykl8zhszsxcs8mzl8d0dxgs3ylz8qlzrw74jb0gplkx6758";
    };
  };
  "its" = {
    version = "0.2.0";
    source = {
      type = "gem";
      sha256 = "0rxwds9ipqp48mzqcaxzmfcqhawazg0zlhc1avv3i2cmm3np1z8g";
    };
    dependencies = [
      "rspec-core"
    ];
  };
  "json" = {
    version = "1.8.1";
    source = {
      type = "gem";
      sha256 = "0002bsycvizvkmk1jyv8px1hskk6wrjfk4f7x5byi8gxm6zzn6wn";
    };
  };
  "kmts" = {
    version = "2.0.1";
    source = {
      type = "gem";
      sha256 = "1wk680q443lg35a25am6i8xawf16iqg5xnq1m8xd2gib4dsy1d8v";
    };
  };
  "mail" = {
    version = "2.6.3";
    source = {
      type = "gem";
      sha256 = "1nbg60h3cpnys45h7zydxwrl200p7ksvmrbxnwwbpaaf9vnf3znp";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "mime-types" = {
    version = "2.4.3";
    source = {
      type = "gem";
      sha256 = "16nissnb31wj7kpcaynx4gr67i7pbkzccfg8k7xmplbkla4rmwiq";
    };
  };
  "minitest" = {
    version = "5.5.1";
    source = {
      type = "gem";
      sha256 = "1h8jn0rgmwy37jnhfcg55iilw0n370vgp8xnh0g5laa8rhv32fyn";
    };
  };
  "multi_json" = {
    version = "1.10.1";
    source = {
      type = "gem";
      sha256 = "1ll21dz01jjiplr846n1c8yzb45kj5hcixgb72rz0zg8fyc9g61c";
    };
  };
  "multipart-post" = {
    version = "1.2.0";
    source = {
      type = "gem";
      sha256 = "12p7lnmc52di1r4h73h6xrpppplzyyhani9p7wm8l4kgf1hnmwnc";
    };
  };
  "octokit" = {
    version = "3.2.0";
    source = {
      type = "gem";
      sha256 = "07ll3x1hv72zssb4hkdw56xg3xk6x4fch4yf38zljvbh388r11ng";
    };
    dependencies = [
      "sawyer"
    ];
  };
  "puma" = {
    version = "2.8.2";
    source = {
      type = "gem";
      sha256 = "1l57fmf8vyxfjv7ab5znq0k339cym5ghnm5xxfvd1simjp73db0k";
    };
    dependencies = [
      "rack"
    ];
  };
  "rack" = {
    version = "1.5.2";
    source = {
      type = "gem";
      sha256 = "19szfw76cscrzjldvw30jp3461zl00w4xvw1x9lsmyp86h1g0jp6";
    };
  };
  "rack-test" = {
    version = "0.6.3";
    source = {
      type = "gem";
      sha256 = "0h6x5jq24makgv2fq5qqgjlrk74dxfy62jif9blk43llw8ib2q7z";
    };
    dependencies = [
      "rack"
    ];
  };
  "rails" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "059mpljplmhfz8rr4hk40q67fllcpsy809m4mwwbkm8qwif2z5r0";
    };
    dependencies = [
      "actionmailer"
      "actionpack"
      "actionview"
      "activemodel"
      "activerecord"
      "activesupport"
      "railties"
      "sprockets-rails"
    ];
  };
  "railties" = {
    version = "4.1.7";
    source = {
      type = "gem";
      sha256 = "1n08h0rgj0aq5lvslnih6lvqz9wadpz6nnb25i4qhp37fhhyz9yz";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "rake"
      "thor"
    ];
  };
  "rake" = {
    version = "10.4.0";
    source = {
      type = "gem";
      sha256 = "0a10xzqc1lh6gjkajkslr0n40wjrniyiyzxkp9m5fc8wf7b74zw8";
    };
  };
  "rest-client" = {
    version = "1.6.7";
    source = {
      type = "gem";
      sha256 = "0nn7zalgidz2yj0iqh3xvzh626krm2al79dfiij19jdhp0rk8853";
    };
    dependencies = [
      "mime-types"
    ];
  };
  "rspec-core" = {
    version = "3.1.7";
    source = {
      type = "gem";
      sha256 = "01bawvln663gffljwzpq3mrpa061cghjbvfbq15jvhmip3csxqc9";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-expectations" = {
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "0m8d36wng1lpbcs54zhg1rxh63rgj345k3p0h0c06lgknz339nzh";
    };
    dependencies = [
      "diff-lcs"
      "rspec-support"
    ];
  };
  "rspec-mocks" = {
    version = "3.1.3";
    source = {
      type = "gem";
      sha256 = "0gxk5w3klia4zsnp0svxck43xxwwfdqvhr3srv6p30f3m5q6rmzr";
    };
    dependencies = [
      "rspec-support"
    ];
  };
  "rspec-rails" = {
    version = "3.1.0";
    source = {
      type = "gem";
      sha256 = "1b1in3n1dc1bpf9wb3p3b2ynq05iacmr48jxzc73lj4g44ksh3wq";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "railties"
      "rspec-core"
      "rspec-expectations"
      "rspec-mocks"
      "rspec-support"
    ];
  };
  "rspec-support" = {
    version = "3.1.2";
    source = {
      type = "gem";
      sha256 = "14y6v9r9lrh91ry9r79h85v0f3y9ja25w42nv5z9n0bipfcwhprb";
    };
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "sawyer" = {
    version = "0.5.4";
    source = {
      type = "gem";
      sha256 = "01kl4zpf0gaacnkra5nikrzfpwj8f10hsvgyzm7z2s1mz4iipx2v";
    };
    dependencies = [
      "addressable"
      "faraday"
    ];
  };
  "shoulda-matchers" = {
    version = "2.6.1";
    source = {
      type = "gem";
      sha256 = "1p3jhvd4dsj6d7nbmvnqhqhpmb8pnr05pi7jv9ajwqcys8140mc1";
    };
    dependencies = [
      "activesupport"
    ];
  };
  "simplecov" = {
    version = "0.9.1";
    source = {
      type = "gem";
      sha256 = "06hylxlalaxxldpbaqa54gc52wxdff0fixdvjyzr6i4ygxwzr7yf";
    };
    dependencies = [
      "docile"
      "multi_json"
      "simplecov-html"
    ];
  };
  "simplecov-html" = {
    version = "0.8.0";
    source = {
      type = "gem";
      sha256 = "0jhn3jql73x7hsr00wwv984iyrcg0xhf64s90zaqv2f26blkqfb9";
    };
  };
  "sprockets" = {
    version = "2.12.3";
    source = {
      type = "gem";
      sha256 = "1bn2drr8bc2af359dkfraq0nm0p1pib634kvhwn5lvj3r4vllnn2";
    };
    dependencies = [
      "hike"
      "multi_json"
      "rack"
      "tilt"
    ];
  };
  "sprockets-rails" = {
    version = "2.2.4";
    source = {
      type = "gem";
      sha256 = "172cdg38cqsfgvrncjzj0kziz7kv6b1lx8pccd0blyphs25qf4gc";
    };
    dependencies = [
      "actionpack"
      "activesupport"
      "sprockets"
    ];
  };
  "sqlite3" = {
    version = "1.3.9";
    source = {
      type = "gem";
      sha256 = "07m6a6flmyyi0rkg0j7x1a9861zngwjnximfh95cli2zzd57914r";
    };
  };
  "term-ansicolor" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1a2gw7gmpmx57sdpyhjwl0zn4bqp7jyjz7aslpvvphd075layp4b";
    };
    dependencies = [
      "tins"
    ];
  };
  "thor" = {
    version = "0.19.1";
    source = {
      type = "gem";
      sha256 = "08p5gx18yrbnwc6xc0mxvsfaxzgy2y9i78xq7ds0qmdm67q39y4z";
    };
  };
  "thread_safe" = {
    version = "0.3.4";
    source = {
      type = "gem";
      sha256 = "1cil2zcdzqkyr8zrwhlg7gywryg36j4mxlxw0h0x0j0wjym5nc8n";
    };
  };
  "tilt" = {
    version = "1.4.1";
    source = {
      type = "gem";
      sha256 = "00sr3yy7sbqaq7cb2d2kpycajxqf1b1wr1yy33z4bnzmqii0b0ir";
    };
  };
  "tins" = {
    version = "1.3.0";
    source = {
      type = "gem";
      sha256 = "1yxa5kyp9mw4w866wlg7c32ingzqxnzh3ir9yf06pwpkmq3mrbdi";
    };
  };
  "tzinfo" = {
    version = "1.2.2";
    source = {
      type = "gem";
      sha256 = "1c01p3kg6xvy1cgjnzdfq45fggbwish8krd0h864jvbpybyx7cgx";
    };
    dependencies = [
      "thread_safe"
    ];
  };
  "webmock" = {
    version = "1.20.0";
    source = {
      type = "gem";
      sha256 = "0bl5v0xzcj24lx7xpsnywv3liqnqb5lfxysmmfb2fgi0n8586i6m";
    };
    dependencies = [
      "addressable"
      "crack"
    ];
  };
}