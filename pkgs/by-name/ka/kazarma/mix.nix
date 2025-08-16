{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    bunt = buildMix rec {
      name = "bunt";
      version = "1.0.0";

      src = fetchHex {
        pkg = "bunt";
        version = "${version}";
        sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
      };

      beamDeps = [];
    };

    cachex = buildMix rec {
      name = "cachex";
      version = "3.4.0";

      src = fetchHex {
        pkg = "cachex";
        version = "${version}";
        sha256 = "370123b1ab4fba4d2965fb18f87fd758325709787c8c5fce35b3fe80645ccbe5";
      };

      beamDeps = [ eternal jumper sleeplocks unsafe ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.7";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "da7785a4b0d2a021cd1292a60875a784b6caef71e76bf4917bdee1f390455cf5";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.12.0";

      src = fetchHex {
        pkg = "certifi";
        version = "${version}";
        sha256 = "ee68d85df22e554040cdb4be100f33873ac6051387baf6a8f6ce82272340ff1c";
      };

      beamDeps = [];
    };

    cldr_utils = buildMix rec {
      name = "cldr_utils";
      version = "2.24.1";

      src = fetchHex {
        pkg = "cldr_utils";
        version = "${version}";
        sha256 = "1820300531b5b849d0bc468e5a87cd64f8f2c5191916f548cbe69b2efc203780";
      };

      beamDeps = [ castore certifi decimal ];
    };

    cobertura_cover = buildMix rec {
      name = "cobertura_cover";
      version = "0.9.0";

      src = fetchHex {
        pkg = "cobertura_cover";
        version = "${version}";
        sha256 = "870bc4658cacc5c80d13f1206b688925234d2dc4e00278e8a3e72fbbd6bea0b1";
      };

      beamDeps = [];
    };

    combine = buildMix rec {
      name = "combine";
      version = "0.10.0";

      src = fetchHex {
        pkg = "combine";
        version = "${version}";
        sha256 = "1b1dbc1790073076580d0d1d64e42eae2366583e7aecd455d1215b0d16f2451b";
      };

      beamDeps = [];
    };

    connection = buildMix rec {
      name = "connection";
      version = "1.1.0";

      src = fetchHex {
        pkg = "connection";
        version = "${version}";
        sha256 = "722c1eb0a418fbe91ba7bd59a47e28008a189d47e37e0e7bb85585a016b2869c";
      };

      beamDeps = [];
    };

    covertool = buildRebar3 rec {
      name = "covertool";
      version = "2.0.4";

      src = fetchHex {
        pkg = "covertool";
        version = "${version}";
        sha256 = "5c9568ba4308fda2082172737c80c31d991ea83961eb10791f06106a870d0cdc";
      };

      beamDeps = [];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.12.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "8a7abe6d183372ceb21caa2709bec928ab2b72e18a3911aa1771639bef82651e";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "cowboy_telemetry";
        version = "${version}";
        sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.13.0";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "e1e1284dc3fc030a64b1ad0d8382ae7e99da46c3246b815318a4b848873800a4";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.7";

      src = fetchHex {
        pkg = "credo";
        version = "${version}";
        sha256 = "8bc87496c9aaacdc3f90f01b7b0582467b69b4bd2441fe8aae3109d843cc2f2e";
      };

      beamDeps = [ bunt file_system jason ];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.6.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "c2f992d15725e721ec7fbc1189d4ecdb8afef76648c746a8e1cad35e3b8a35f3";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.1.1";

      src = fetchHex {
        pkg = "decimal";
        version = "${version}";
        sha256 = "53cfe5f497ed0e7771ae1a475575603d77425099ba5faef9394932b35020ffcc";
      };

      beamDeps = [];
    };

    decorator = buildMix rec {
      name = "decorator";
      version = "1.4.0";

      src = fetchHex {
        pkg = "decorator";
        version = "${version}";
        sha256 = "0a07cedd9083da875c7418dea95b78361197cf2bf3211d743f6f7ce39656597f";
      };

      beamDeps = [];
    };

    dialyxir = buildMix rec {
      name = "dialyxir";
      version = "1.4.3";

      src = fetchHex {
        pkg = "dialyxir";
        version = "${version}";
        sha256 = "bf2cfb75cd5c5006bec30141b131663299c661a864ec7fbbc72dfa557487a986";
      };

      beamDeps = [ erlex ];
    };

    digital_token = buildMix rec {
      name = "digital_token";
      version = "0.6.0";

      src = fetchHex {
        pkg = "digital_token";
        version = "${version}";
        sha256 = "2455d626e7c61a128b02a4a8caddb092548c3eb613ac6f6a85e4cbb6caddc4d1";
      };

      beamDeps = [ cldr_utils jason ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.39";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "06553a88d1f1846da9ef066b87b57c6f605552cfbe40d20bd8d59cc6bde41944";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.11.2";

      src = fetchHex {
        pkg = "ecto";
        version = "${version}";
        sha256 = "3c38bca2c6f8d8023f2145326cc8a80100c3ffe4dcbd9842ff867f7fc6156c65";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.11.2";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "73c07f995ac17dbf89d3cfaaf688fcefabcd18b7b004ac63b0dc4ef39499ed6b";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    erlex = buildMix rec {
      name = "erlex";
      version = "0.2.6";

      src = fetchHex {
        pkg = "erlex";
        version = "${version}";
        sha256 = "2ed2e25711feb44d52b17d2780eabf998452f6efda104877a3881c2f8c0c0c75";
      };

      beamDeps = [];
    };

    eternal = buildMix rec {
      name = "eternal";
      version = "1.2.2";

      src = fetchHex {
        pkg = "eternal";
        version = "${version}";
        sha256 = "2c9fe32b9c3726703ba5e1d43a1d255a4f3f2d8f8f9bc19f094c7cb1a7a9e782";
      };

      beamDeps = [];
    };

    ex_cldr = buildMix rec {
      name = "ex_cldr";
      version = "2.37.2";

      src = fetchHex {
        pkg = "ex_cldr";
        version = "${version}";
        sha256 = "c8467b1d5080716ace6621703b6656cb2f9545572a54b341da900791a0cf92ba";
      };

      beamDeps = [ cldr_utils decimal gettext jason nimble_parsec ];
    };

    ex_cldr_calendars = buildMix rec {
      name = "ex_cldr_calendars";
      version = "1.21.0";

      src = fetchHex {
        pkg = "ex_cldr_calendars";
        version = "${version}";
        sha256 = "8ce8737b70f9c36828324995f96464a1a4c87cf2f76e5868e20662ca31c4098f";
      };

      beamDeps = [ ex_cldr_numbers ex_doc jason ];
    };

    ex_cldr_currencies = buildMix rec {
      name = "ex_cldr_currencies";
      version = "2.15.0";

      src = fetchHex {
        pkg = "ex_cldr_currencies";
        version = "${version}";
        sha256 = "0521316396c66877a2d636219767560bb2397c583341fcb154ecf9f3000e6ff8";
      };

      beamDeps = [ ex_cldr jason ];
    };

    ex_cldr_dates_times = buildMix rec {
      name = "ex_cldr_dates_times";
      version = "2.12.0";

      src = fetchHex {
        pkg = "ex_cldr_dates_times";
        version = "${version}";
        sha256 = "c15b424c1f9512e1be17cc128415f8b69bd5a283e63db71c44bf60e70253eba0";
      };

      beamDeps = [ ex_cldr_calendars ex_cldr_numbers jason ];
    };

    ex_cldr_numbers = buildMix rec {
      name = "ex_cldr_numbers";
      version = "2.32.2";

      src = fetchHex {
        pkg = "ex_cldr_numbers";
        version = "${version}";
        sha256 = "91257684a9c4d6abdf738f0cc5671837de876e69552e8bd4bc5fa1bfd5817713";
      };

      beamDeps = [ decimal digital_token ex_cldr ex_cldr_currencies jason ];
    };

    ex_cldr_plugs = buildMix rec {
      name = "ex_cldr_plugs";
      version = "1.2.0";

      src = fetchHex {
        pkg = "ex_cldr_plugs";
        version = "${version}";
        sha256 = "e111249ed7a7e2ef6322c93ff2d1c930d9e296dc8181351ff6c6a1be50b1cf8e";
      };

      beamDeps = [ ex_cldr gettext jason plug ];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.34.0";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "60734fb4c1353f270c3286df4a0d51e65a2c1d9fba66af3940847cc65a8066d7";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_ulid = buildMix rec {
      name = "ex_ulid";
      version = "0.1.0";

      src = fetchHex {
        pkg = "ex_ulid";
        version = "${version}";
        sha256 = "a2befd477aebc4639563de7e233e175cacf8a8f42c8f6778c88d60c13bf20860";
      };

      beamDeps = [];
    };

    excoveralls = buildMix rec {
      name = "excoveralls";
      version = "0.18.1";

      src = fetchHex {
        pkg = "excoveralls";
        version = "${version}";
        sha256 = "d65f79db146bb20399f23046015974de0079668b9abb2f5aac074d078da60b8d";
      };

      beamDeps = [ castore jason ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.5.2";

      src = fetchHex {
        pkg = "expo";
        version = "${version}";
        sha256 = "8c9bfa06ca017c9cb4020fabe980bc7fdb1aaec059fd004c2ab3bff03b1c599c";
      };

      beamDeps = [];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "file_system";
        version = "${version}";
        sha256 = "41195edbfb562a593726eda3b3e8b103a309b733ad25f3d642ba49696bf715dc";
      };

      beamDeps = [];
    };

    finch = buildMix rec {
      name = "finch";
      version = "0.16.0";

      src = fetchHex {
        pkg = "finch";
        version = "${version}";
        sha256 = "f660174c4d519e5fec629016054d60edd822cdfe2b7270836739ac2f97735ec5";
      };

      beamDeps = [ castore mime mint nimble_options nimble_pool telemetry ];
    };

    flexto = buildMix rec {
      name = "flexto";
      version = "0.2.2";

      src = fetchHex {
        pkg = "flexto";
        version = "${version}";
        sha256 = "a3c1875b4cdc4ce2bc4408d648a5368183805ec02cd651fc1a990b1dd3c6681b";
      };

      beamDeps = [ ecto ];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.33.1";

      src = fetchHex {
        pkg = "floki";
        version = "${version}";
        sha256 = "461035fd125f13fdf30f243c85a0b1e50afbec876cbf1ceefe6fddd2e6d712c6";
      };

      beamDeps = [ html_entities ];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.24.0";

      src = fetchHex {
        pkg = "gettext";
        version = "${version}";
        sha256 = "bdf75cdfcbe9e4622dd18e034b227d77dd17f0f133853a1c73b97b3d6c770e8b";
      };

      beamDeps = [ expo ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.20.1";

      src = fetchHex {
        pkg = "hackney";
        version = "${version}";
        sha256 = "fe9094e5f1a2a2c0a7d10918fee36bfec0ec2a979994cff8cfe8058cd9af38e3";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hammer = buildMix rec {
      name = "hammer";
      version = "6.1.0";

      src = fetchHex {
        pkg = "hammer";
        version = "${version}";
        sha256 = "b47e415a562a6d072392deabcd58090d8a41182cf9044cdd6b0d0faaaf68ba57";
      };

      beamDeps = [ poolboy ];
    };

    hammer_plug = buildMix rec {
      name = "hammer_plug";
      version = "3.0.0";

      src = fetchHex {
        pkg = "hammer_plug";
        version = "${version}";
        sha256 = "35275f98f887bef8d84a8e0a3021ba1cd14d0e15c11221f6f8c833a3d43f35d8";
      };

      beamDeps = [ hammer plug ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "0.1.2";

      src = fetchHex {
        pkg = "hpax";
        version = "${version}";
        sha256 = "2c87843d5a23f5f16748ebe77969880e29809580efdaccd615cd3bed628a8c13";
      };

      beamDeps = [];
    };

    html_entities = buildMix rec {
      name = "html_entities";
      version = "0.5.2";

      src = fetchHex {
        pkg = "html_entities";
        version = "${version}";
        sha256 = "c53ba390403485615623b9531e97696f076ed415e8d8058b1dbaa28181f4fdcc";
      };

      beamDeps = [];
    };

    html_sanitize_ex = buildMix rec {
      name = "html_sanitize_ex";
      version = "1.4.3";

      src = fetchHex {
        pkg = "html_sanitize_ex";
        version = "${version}";
        sha256 = "87748d3c4afe949c7c6eb7150c958c2bcba43fc5b2a02686af30e636b74bccb7";
      };

      beamDeps = [ mochiweb ];
    };

    httpoison = buildMix rec {
      name = "httpoison";
      version = "2.2.1";

      src = fetchHex {
        pkg = "httpoison";
        version = "${version}";
        sha256 = "51364e6d2f429d80e14fe4b5f8e39719cacd03eb3f9a9286e61e216feac2d2df";
      };

      beamDeps = [ hackney ];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.1.1";

      src = fetchHex {
        pkg = "idna";
        version = "${version}";
        sha256 = "92376eb7894412ed19ac475e4a86f7b413c1b9fbb5bd16dccd57934157944cea";
      };

      beamDeps = [ unicode_util_compat ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.1";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "fbb01ecdfd565b56261302f7e1fcc27c4fb8f32d56eab74db621fc154604a7a1";
      };

      beamDeps = [ decimal ];
    };

    jumper = buildMix rec {
      name = "jumper";
      version = "1.0.1";

      src = fetchHex {
        pkg = "jumper";
        version = "${version}";
        sha256 = "318c59078ac220e966d27af3646026db9b5a5e6703cb2aa3e26bcfaba65b7433";
      };

      beamDeps = [];
    };

    junit_formatter = buildMix rec {
      name = "junit_formatter";
      version = "3.3.0";

      src = fetchHex {
        pkg = "junit_formatter";
        version = "${version}";
        sha256 = "4d040410925324b155ae4c7d41e884a0cdebe53b917bee4f22adf152e987a666";
      };

      beamDeps = [];
    };

    logger_file_backend = buildMix rec {
      name = "logger_file_backend";
      version = "0.0.13";

      src = fetchHex {
        pkg = "logger_file_backend";
        version = "${version}";
        sha256 = "71a453a7e6e899ae4549fb147b1c6621f4233f8f48f58ca10a64ec67b6c50018";
      };

      beamDeps = [];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.1.2";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "cce1566b81fbcbd21eca8ffe808f33b221f9eee2cbc7a1706fc3da9ff18e6cac";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.16.2";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "41193978704763f6bbe6cc2758b84909e62984c7752b3784bd3c218bb341706b";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "1.0.0";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "ea7a9307de9d1548d2a72d299058d1fd2339e3d398560a0e46c27dab4891e4d2";
      };

      beamDeps = [ makeup ];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "metrics";
        version = "${version}";
        sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.5";

      src = fetchHex {
        pkg = "mime";
        version = "${version}";
        sha256 = "da0d64a365c45bc9935cc5c8a7fc5e49a0e0f9932a761c55d6c52b142780a05c";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.3.0";

      src = fetchHex {
        pkg = "mimerl";
        version = "${version}";
        sha256 = "a1e15a50d1887217de95f0b9b0793e32853f7c258a5cd227650889b38839fe9d";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.5.1";

      src = fetchHex {
        pkg = "mint";
        version = "${version}";
        sha256 = "4a63e1e76a7c3956abd2c72f370a0d0aecddc3976dea5c27eccbecfa5e7d5b1e";
      };

      beamDeps = [ castore hpax ];
    };

    mochiweb = buildRebar3 rec {
      name = "mochiweb";
      version = "3.2.2";

      src = fetchHex {
        pkg = "mochiweb";
        version = "${version}";
        sha256 = "4114e51f1b44c270b3242d91294fe174ce1ed989100e8b65a1fab58e0cba41d5";
      };

      beamDeps = [];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.0.0";

      src = fetchHex {
        pkg = "mox";
        version = "${version}";
        sha256 = "201b0a20b7abdaaab083e9cf97884950f8a30a1350a1da403b3145e213c6f4df";
      };

      beamDeps = [];
    };

    mutex = buildMix rec {
      name = "mutex";
      version = "1.1.3";

      src = fetchHex {
        pkg = "mutex";
        version = "${version}";
        sha256 = "2b83b92784add2611c23dd527073b5e8dfe3c9c6c94c5bf9e3081b5c41c3ff3e";
      };

      beamDeps = [];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.0.2";

      src = fetchHex {
        pkg = "nimble_options";
        version = "${version}";
        sha256 = "fd12a8db2021036ce12a309f26f564ec367373265b53e25403f0ee697380f1b8";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.4.0";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "9c565862810fb383e9838c1dd2d7d2c437b3d13b267414ba6af33e50d2d1cf28";
      };

      beamDeps = [];
    };

    nimble_pool = buildMix rec {
      name = "nimble_pool";
      version = "1.0.0";

      src = fetchHex {
        pkg = "nimble_pool";
        version = "${version}";
        sha256 = "80be3b882d2d351882256087078e1b1952a28bf98d0a287be87e4a24a710b67a";
      };

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.17.1";

      src = fetchHex {
        pkg = "oban";
        version = "${version}";
        sha256 = "c02686ada7979b00e259c0efbafeae2749f8209747b3460001fe695c5bdbeee6";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    octo_fetch = buildMix rec {
      name = "octo_fetch";
      version = "0.3.0";

      src = fetchHex {
        pkg = "octo_fetch";
        version = "${version}";
        sha256 = "c07e44f2214ab153743b7b3182f380798d0b294b1f283811c1e30cff64096d3d";
      };

      beamDeps = [ castore ];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.4.1";

      src = fetchHex {
        pkg = "parse_trans";
        version = "${version}";
        sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
      };

      beamDeps = [];
    };

    pc = buildRebar3 rec {
      name = "pc";
      version = "1.15.0";

      src = fetchHex {
        pkg = "pc";
        version = "${version}";
        sha256 = "4c0fad4f6437cae353d517da218fe78347b8ffa44b9817887494caaae54595b3";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.10";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "cf784932e010fd736d656d7fead6a584a4498efefe5b8227e9f383bf15bb79d0";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template phoenix_view plug plug_cowboy plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.0";

      src = fetchHex {
        pkg = "phoenix_ecto";
        version = "${version}";
        sha256 = "09864e558ed31ee00bd48fcc1d4fc58ae9678c9e81649075431e69dbabb43cc1";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.3.3";

      src = fetchHex {
        pkg = "phoenix_html";
        version = "${version}";
        sha256 = "923ebe6fec6e2e3b3e569dfbdc6560de932cd54b000ada0208b5f45024bdd76c";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.8.3";

      src = fetchHex {
        pkg = "phoenix_live_dashboard";
        version = "${version}";
        sha256 = "f9470a0a8bae4f56430a23d42f977b5a6205fdba6559d76f932b876bfaec652d";
      };

      beamDeps = [ ecto mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.4.1";

      src = fetchHex {
        pkg = "phoenix_live_reload";
        version = "${version}";
        sha256 = "9bffb834e7ddf08467fe54ae58b5785507aaba6255568ae22b4d46e2bb3615ab";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.20.1";

      src = fetchHex {
        pkg = "phoenix_live_view";
        version = "${version}";
        sha256 = "be494fd1215052729298b0e97d5c2ce8e719c00854b82cd8cf15c1cd7fcf6294";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template phoenix_view plug telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "phoenix_pubsub";
        version = "${version}";
        sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.3";

      src = fetchHex {
        pkg = "phoenix_template";
        version = "${version}";
        sha256 = "16f4b6588a4152f3cc057b9d0c0ba7e82ee23afa65543da535313ad8d25d8e2c";
      };

      beamDeps = [ phoenix_html ];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "2.0.3";

      src = fetchHex {
        pkg = "phoenix_view";
        version = "${version}";
        sha256 = "cd34049af41be2c627df99cd4eaa71fc52a328c0c3d8e7d4aa28f880c30e7f64";
      };

      beamDeps = [ phoenix_html phoenix_template ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.16.0";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "cbf53aa1f5c4d758a7559c0bd6d59e286c2be0c6a1fac8cc3eee2f638243b93e";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.7.1";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "02dbd5f9ab571b864ae39418db7811618506256f6d13b4a45037e5fe78dc5de3";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "2.1.0";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
      };

      beamDeps = [];
    };

    pointers = buildMix rec {
      name = "pointers";
      version = "0.5.1";

      src = fetchHex {
        pkg = "pointers";
        version = "${version}";
        sha256 = "0ee81db5fa11008a508b6b029b59a2be66a1264879b5361d4586c1533f2e818a";
      };

      beamDeps = [ ecto_sql flexto pointers_ulid ];
    };

    polyjuice_util = buildMix rec {
      name = "polyjuice_util";
      version = "0.2.2";

      src = fetchHex {
        pkg = "polyjuice_util";
        version = "${version}";
        sha256 = "ea916266e88a8ba74f1e3d79614f909e40cc5e69e5406b55cdce622b9e33e74e";
      };

      beamDeps = [ jason uuid ];
    };

    poolboy = buildRebar3 rec {
      name = "poolboy";
      version = "1.5.2";

      src = fetchHex {
        pkg = "poolboy";
        version = "${version}";
        sha256 = "dad79704ce5440f3d5a3681c8590b9dc25d1a561e8f5a9c995281012860901e3";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.18.0";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "a042989ba1bc1cca7383ebb9e461398e3f89f868c92ce6671feb7ef132a252d1";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    prom_ex = buildMix rec {
      name = "prom_ex";
      version = "1.8.0";

      src = fetchHex {
        pkg = "prom_ex";
        version = "${version}";
        sha256 = "3eea763dfa941e25de50decbf17a6a94dbd2270e7b32f88279aa6e9bbb8e23e7";
      };

      beamDeps = [ ecto finch jason oban octo_fetch phoenix phoenix_live_view plug plug_cowboy telemetry telemetry_metrics telemetry_metrics_prometheus_core telemetry_poller ];
    };

    protobuf = buildMix rec {
      name = "protobuf";
      version = "0.10.0";

      src = fetchHex {
        pkg = "protobuf";
        version = "${version}";
        sha256 = "4ae21a386142357aa3d31ccf5f7d290f03f3fa6f209755f6e87fc2c58c147893";
      };

      beamDeps = [ jason ];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.8.0";

      src = fetchHex {
        pkg = "ranch";
        version = "${version}";
        sha256 = "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5";
      };

      beamDeps = [];
    };

    sentry = buildMix rec {
      name = "sentry";
      version = "8.0.6";

      src = fetchHex {
        pkg = "sentry";
        version = "${version}";
        sha256 = "051a2d0472162f3137787c7c9d6e6e4ef239de9329c8c45b1f1bf1e9379e1883";
      };

      beamDeps = [ hackney jason plug plug_cowboy ];
    };

    sleeplocks = buildRebar3 rec {
      name = "sleeplocks";
      version = "1.1.1";

      src = fetchHex {
        pkg = "sleeplocks";
        version = "${version}";
        sha256 = "84ee37aeff4d0d92b290fff986d6a95ac5eedf9b383fadfd1d88e9b84a1c02e1";
      };

      beamDeps = [];
    };

    sleipnir = buildMix rec {
      name = "sleipnir";
      version = "0.1.3";

      src = fetchHex {
        pkg = "sleipnir";
        version = "${version}";
        sha256 = "59c73b2cf597df41cce4a19b22ee453556cdcf810db15c01904e5e03053cebf2";
      };

      beamDeps = [ hackney protobuf snappyer telemetry tesla ];
    };

    snappyer = buildRebar3 rec {
      name = "snappyer";
      version = "1.2.9";

      src = fetchHex {
        pkg = "snappyer";
        version = "${version}";
        sha256 = "18d00ca218ae613416e6eecafe1078db86342a66f86277bd45c95f05bf1c8b29";
      };

      beamDeps = [];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.7";

      src = fetchHex {
        pkg = "ssl_verify_fun";
        version = "${version}";
        sha256 = "fe4c190e8f37401d30167c8c405eda19469f34577987c76dde613e838bbc67f8";
      };

      beamDeps = [];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "dad9ce9d8effc621708f99eac538ef1cbe05d6a874dd741de2e689c47feafed5";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "0.6.1";

      src = fetchHex {
        pkg = "telemetry_metrics";
        version = "${version}";
        sha256 = "7be9e0871c41732c233be71e4be11b96e56177bf15dde64a8ac9ce72ac9834c6";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_metrics_prometheus_core = buildMix rec {
      name = "telemetry_metrics_prometheus_core";
      version = "1.1.0";

      src = fetchHex {
        pkg = "telemetry_metrics_prometheus_core";
        version = "${version}";
        sha256 = "0dd10e7fe8070095df063798f82709b0a1224c31b8baf6278b423898d591a069";
      };

      beamDeps = [ telemetry telemetry_metrics ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.0.0";

      src = fetchHex {
        pkg = "telemetry_poller";
        version = "${version}";
        sha256 = "b3a24eafd66c3f42da30fc3ca7dda1e9d546c12250a2d60d7b81d264fbec4f6e";
      };

      beamDeps = [ telemetry ];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.7.0";

      src = fetchHex {
        pkg = "tesla";
        version = "${version}";
        sha256 = "2e64f01ebfdb026209b47bc651a0e65203fcff4ae79c11efb73c4852b00dc313";
      };

      beamDeps = [ castore finch hackney jason mime mint telemetry ];
    };

    timex = buildMix rec {
      name = "timex";
      version = "3.7.6";

      src = fetchHex {
        pkg = "timex";
        version = "${version}";
        sha256 = "a296327f79cb1ec795b896698c56e662ed7210cc9eb31f0ab365eb3a62e2c589";
      };

      beamDeps = [ combine gettext tzdata ];
    };

    tzdata = buildMix rec {
      name = "tzdata";
      version = "1.1.0";

      src = fetchHex {
        pkg = "tzdata";
        version = "${version}";
        sha256 = "18f453739b48d3dc5bcf0e8906d2dc112bb40baafe2c707596d89f3c8dd14034";
      };

      beamDeps = [ hackney ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "unicode_util_compat";
        version = "${version}";
        sha256 = "25eee6d67df61960cf6a794239566599b09e17e668d3700247bc498638152521";
      };

      beamDeps = [];
    };

    unsafe = buildMix rec {
      name = "unsafe";
      version = "1.0.1";

      src = fetchHex {
        pkg = "unsafe";
        version = "${version}";
        sha256 = "6c7729a2d214806450d29766abc2afaa7a2cbecf415be64f36a6691afebb50e5";
      };

      beamDeps = [];
    };

    uuid = buildMix rec {
      name = "uuid";
      version = "1.1.8";

      src = fetchHex {
        pkg = "uuid";
        version = "${version}";
        sha256 = "c790593b4c3b601f5dc2378baae7efaf5b3d73c4c6456ba85759905be792f2ac";
      };

      beamDeps = [];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.3";

      src = fetchHex {
        pkg = "websock";
        version = "${version}";
        sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.5";

      src = fetchHex {
        pkg = "websock_adapter";
        version = "${version}";
        sha256 = "4b977ba4a01918acbf77045ff88de7f6972c2a009213c515a445c48f224ffce9";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };
  };
in self

