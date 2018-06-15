{
  "builder" = {
    version = "3.2.2";
    source = {
      type = "gem";
      sha256 = "14fii7ab8qszrvsvhz6z2z3i4dw0h41a62fjr2h1j8m41vbrmyv2";
    };
  };
  "colored" = {
    version = "1.2";
    source = {
      type = "gem";
      sha256 = "0b0x5jmsyi0z69bm6sij1k89z7h0laag3cb4mdn7zkl9qmxb90lx";
    };
  };
  "crack" = {
    version = "0.4.3";
    source = {
      type = "gem";
      sha256 = "0abb0fvgw00akyik1zxnq7yv391va148151qxdghnzngv66bl62k";
    };
    dependencies = [
      "safe_yaml"
    ];
  };
  "domain_name" = {
    version = "0.5.25";
    source = {
      type = "gem";
      sha256 = "16qvfrmcwlzz073aas55mpw2nhyhjcn96s524w0g1wlml242hjav";
    };
    dependencies = [
      "unf"
    ];
  };
  "highline" = {
    version = "1.7.8";
    source = {
      type = "gem";
      sha256 = "1nf5lgdn6ni2lpfdn4gk3gi47fmnca2bdirabbjbz1fk9w4p8lkr";
    };
  };
  "hirb" = {
    version = "0.7.3";
    source = {
      type = "gem";
      sha256 = "0mzch3c2lvmf8gskgzlx6j53d10j42ir6ik2dkrl27sblhy76cji";
    };
  };
  "http-cookie" = {
    version = "1.0.2";
    source = {
      type = "gem";
      sha256 = "0cz2fdkngs3jc5w32a6xcl511hy03a7zdiy988jk1sf3bf5v3hdw";
    };
    dependencies = [
      "domain_name"
    ];
  };
  "mime-types" = {
    version = "2.99";
    source = {
      type = "gem";
      sha256 = "1hravghdnk9qbibxb3ggzv7mysl97djh8n0rsswy3ssjaw7cbvf2";
    };
  };
  "mini_portile2" = {
    version = "2.0.0";
    source = {
      type = "gem";
      sha256 = "056drbn5m4khdxly1asmiik14nyllswr6sh3wallvsywwdiryz8l";
    };
  };
  "netrc" = {
    version = "0.11.0";
    source = {
      type = "gem";
      sha256 = "0gzfmcywp1da8nzfqsql2zqi648mfnx6qwkig3cv36n9m0yy676y";
    };
  };
  "nokogiri" = {
    version = "1.6.7.1";
    source = {
      type = "gem";
      sha256 = "12nwv3lad5k2k73aa1d1xy4x577c143ixks6rs70yp78sinbglk2";
    };
    dependencies = [
      "mini_portile2"
    ];
  };
  "nokogiri-happymapper" = {
    version = "0.5.9";
    source = {
      type = "gem";
      sha256 = "0xv5crnzxdbd0ykx1ikfg1h0yw0h70lk607x1g45acsb1da97mkq";
    };
    dependencies = [
      "nokogiri"
    ];
  };
  "pivotal-tracker" = {
    version = "0.5.13";
    source = {
      type = "gem";
      sha256 = "0vxs69qb0k4g62250zbf5x78wpkhpj98clg2j09ncy3s8yklr0pd";
    };
    dependencies = [
      "builder"
      "crack"
      "nokogiri"
      "nokogiri-happymapper"
      "rest-client"
    ];
  };
  "pt" = {
    version = "0.7.3";
    source = {
      type = "gem";
      sha256 = "0bf821yf0zq5bhs65wmx339bm771lcnd6dlsljj3dnisjj068dk8";
    };
    dependencies = [
      "colored"
      "highline"
      "hirb"
      "pivotal-tracker"
    ];
  };
  "rest-client" = {
    version = "1.8.0";
    source = {
      type = "gem";
      sha256 = "1m8z0c4yf6w47iqz6j2p7x1ip4qnnzvhdph9d5fgx081cvjly3p7";
    };
    dependencies = [
      "http-cookie"
      "mime-types"
      "netrc"
    ];
  };
  "safe_yaml" = {
    version = "1.0.4";
    source = {
      type = "gem";
      sha256 = "1hly915584hyi9q9vgd968x2nsi5yag9jyf5kq60lwzi5scr7094";
    };
  };
  "unf" = {
    version = "0.1.4";
    source = {
      type = "gem";
      sha256 = "0bh2cf73i2ffh4fcpdn9ir4mhq8zi50ik0zqa1braahzadx536a9";
    };
    dependencies = [
      "unf_ext"
    ];
  };
  "unf_ext" = {
    version = "0.0.7.1";
    source = {
      type = "gem";
      sha256 = "0ly2ms6c3irmbr1575ldyh52bz2v0lzzr2gagf0p526k12ld2n5b";
    };
  };
}