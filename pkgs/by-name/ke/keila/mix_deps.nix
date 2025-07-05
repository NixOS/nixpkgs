{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    argon2_elixir = buildMix rec {
      name = "argon2_elixir";
      version = "2.4.0";

      src = fetchHex {
        pkg = "argon2_elixir";
        version = "${version}";
        sha256 = "4ea82e183cf8e7f66dab1f767fedcfe6a195e140357ef2b0423146b72e0a551d";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.4";

      src = fetchHex {
        pkg = "castore";
        version = "${version}";
        sha256 = "9418c1b8144e11656f0be99943db4caf04612e3eaecefb5dae9a2a87565584f8";
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

    comeonin = buildMix rec {
      name = "comeonin";
      version = "5.3.3";

      src = fetchHex {
        pkg = "comeonin";
        version = "${version}";
        sha256 = "3e38c9c2cb080828116597ca8807bb482618a315bfafd98c90bc22a821cc84df";
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

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "cowboy";
        version = "${version}";
        sha256 = "3afdccb7183cc6f143cb14d3cf51fa00e53db9ec80cdcd525482f5e99bc41d6b";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.3.1";

      src = fetchHex {
        pkg = "cowboy_telemetry";
        version = "${version}";
        sha256 = "3a6efd3366130eab84ca372cbd4a7d3c3a97bdfcfb4911233b035d117063f0af";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "cowlib";
        version = "${version}";
        sha256 = "163b73f6367a7341b33c794c4e88e7dbfe6498ac42dcd69ef44c5bc5507c8db0";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.7.0";

      src = fetchHex {
        pkg = "db_connection";
        version = "${version}";
        sha256 = "dcf08f31b2701f857dfc787fbad78223d61a32204f217f15e881dd93e4bdd3ff";
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

    earmark = buildMix rec {
      name = "earmark";
      version = "1.4.27";

      src = fetchHex {
        pkg = "earmark";
        version = "${version}";
        sha256 = "579ebe2eaf4c7e040815a73a268036bcd96e6aab8ad2b1fcd979aaeb1ea47e15";
      };

      beamDeps = [ earmark_parser ];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.33";

      src = fetchHex {
        pkg = "earmark_parser";
        version = "${version}";
        sha256 = "2d526833729b59b9fdb85785078697c72ac5e5066350663e5be6a1182da61b8f";
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
      version = "3.11.3";

      src = fetchHex {
        pkg = "ecto_sql";
        version = "${version}";
        sha256 = "e5f36e3d736b99c7fee3e631333b8394ade4bafe9d96d35669fca2d81c2be928";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.6.3";

      src = fetchHex {
        pkg = "elixir_make";
        version = "${version}";
        sha256 = "f5cbd651c5678bcaabdbb7857658ee106b12509cd976c2c2fca99688e1daf716";
      };

      beamDeps = [];
    };

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.8.1";

      src = fetchHex {
        pkg = "esbuild";
        version = "${version}";
        sha256 = "25fc876a67c13cb0a776e7b5d7974851556baeda2085296c14ab48555ea7560f";
      };

      beamDeps = [ castore jason ];
    };

    ex2ms = buildMix rec {
      name = "ex2ms";
      version = "1.6.1";

      src = fetchHex {
        pkg = "ex2ms";
        version = "${version}";
        sha256 = "a7192899d84af03823a8ec2f306fa858cbcce2c2e7fd0f1c49e05168fb9c740e";
      };

      beamDeps = [];
    };

    ex_aws = buildMix rec {
      name = "ex_aws";
      version = "2.2.7";

      src = fetchHex {
        pkg = "ex_aws";
        version = "${version}";
        sha256 = "85e08e0db506062171534626266de34804c1871f529b7d5d63267339ac30a601";
      };

      beamDeps = [ hackney jason mime sweet_xml telemetry ];
    };

    ex_aws_ses = buildMix rec {
      name = "ex_aws_ses";
      version = "2.4.1";

      src = fetchHex {
        pkg = "ex_aws_ses";
        version = "${version}";
        sha256 = "dddac42d4d7b826f7099bbe7402a35e68eb76434d6c58bfa332002ea2b522645";
      };

      beamDeps = [ ex_aws ];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.25.5";

      src = fetchHex {
        pkg = "ex_doc";
        version = "${version}";
        sha256 = "688cfa538cdc146bc4291607764a7f1fcfa4cce8009ecd62de03b27197528350";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_rated = buildMix rec {
      name = "ex_rated";
      version = "2.1.0";

      src = fetchHex {
        pkg = "ex_rated";
        version = "${version}";
        sha256 = "936c155337253ed6474f06d941999dd3a9cf0fe767ec99a59f2d2989dc2cc13f";
      };

      beamDeps = [ ex2ms ];
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

    floki = buildMix rec {
      name = "floki";
      version = "0.32.0";

      src = fetchHex {
        pkg = "floki";
        version = "${version}";
        sha256 = "1c5a91cae1fd8931c26a4826b5e2372c284813904c8bacb468b5de39c7ececbd";
      };

      beamDeps = [ html_entities ];
    };

    gen_smtp = buildRebar3 rec {
      name = "gen_smtp";
      version = "1.2.0";

      src = fetchHex {
        pkg = "gen_smtp";
        version = "${version}";
        sha256 = "5ee0375680bca8f20c4d85f58c2894441443a743355430ff33a783fe03296779";
      };

      beamDeps = [ ranch ];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.20.0";

      src = fetchHex {
        pkg = "gettext";
        version = "${version}";
        sha256 = "1c03b177435e93a47441d7f681a7040bd2a816ece9e2666d1c9001035121eb3d";
      };

      beamDeps = [];
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

    hashids = buildMix rec {
      name = "hashids";
      version = "2.0.5";

      src = fetchHex {
        pkg = "hashids";
        version = "${version}";
        sha256 = "ef47d8679f20d7bea59d0d49c202258c89f61b9b741bd3dceef2c1985cf95554";
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

    httpoison = buildMix rec {
      name = "httpoison";
      version = "1.8.0";

      src = fetchHex {
        pkg = "httpoison";
        version = "${version}";
        sha256 = "28089eaa98cf90c66265b6b5ad87c59a3729bea2e74e9d08f9b51eb9729b3c3a";
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
      version = "1.4.4";

      src = fetchHex {
        pkg = "jason";
        version = "${version}";
        sha256 = "c5eb0cab91f094599f94d55bc63409236a8ec69a21a67814529e8d5f6cc90b3b";
      };

      beamDeps = [ decimal ];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.1.0";

      src = fetchHex {
        pkg = "makeup";
        version = "${version}";
        sha256 = "0a45ed501f4a8897f580eabf99a2e5234ea3e75a4373c8a52824f6e873be57a6";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.16.0";

      src = fetchHex {
        pkg = "makeup_elixir";
        version = "${version}";
        sha256 = "28b2cbdc13960a46ae9a8858c4bebdec3c9a6d7b4b9e7f4ed1502f8159f338e7";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.1";

      src = fetchHex {
        pkg = "makeup_erlang";
        version = "${version}";
        sha256 = "174d0809e98a4ef0b3309256cbf97101c6ec01c4ab0b23e926a9e17df2077cbb";
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

    mjml = buildMix rec {
      name = "mjml";
      version = "4.0.0";

      src = fetchHex {
        pkg = "mjml";
        version = "${version}";
        sha256 = "0886a411f9a850bc4ac6b878c9c0dbea168669176fde1f6583acf55fa8b628dd";
      };

      beamDeps = [ rustler_precompiled ];
    };

    nimble_csv = buildMix rec {
      name = "nimble_csv";
      version = "1.1.0";

      src = fetchHex {
        pkg = "nimble_csv";
        version = "${version}";
        sha256 = "e986755bc302832cac429be6deda0fc9d82d3c82b47abefb68b3c17c9d949a3f";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.2.3";

      src = fetchHex {
        pkg = "nimble_parsec";
        version = "${version}";
        sha256 = "c8d789e39b9131acf7b99291e93dae60ab48ef14a7ee9d58c6964f59efb570b0";
      };

      beamDeps = [];
    };

    oban = buildMix rec {
      name = "oban";
      version = "2.18.0";

      src = fetchHex {
        pkg = "oban";
        version = "${version}";
        sha256 = "aace1eff6f8227ae38d4274af967d96f051c2f0a5152f2ef9809dd1f97866745";
      };

      beamDeps = [ ecto_sql jason postgrex telemetry ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.11.0";

      src = fetchHex {
        pkg = "open_api_spex";
        version = "${version}";
        sha256 = "640bd09f6bdd96cc0264213bfa229b0f8b3868df3384311de57e0f3fa22fc3af";
      };

      beamDeps = [ jason plug ];
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

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.6.11";

      src = fetchHex {
        pkg = "phoenix";
        version = "${version}";
        sha256 = "1664e34f80c25ea4918fbadd957f491225ef601c0e00b4e644b1a772864bfbc2";
      };

      beamDeps = [ jason phoenix_pubsub phoenix_view plug plug_cowboy plug_crypto telemetry ];
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
      version = "3.2.0";

      src = fetchHex {
        pkg = "phoenix_html";
        version = "${version}";
        sha256 = "36ec97ba56d25c0136ef1992c37957e4246b649d620958a1f9fa86165f8bc54f";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.6.5";

      src = fetchHex {
        pkg = "phoenix_live_dashboard";
        version = "${version}";
        sha256 = "ef4fa50dd78364409039c99cf6f98ab5209b4c5f8796c17f4db118324f0db852";
      };

      beamDeps = [ ecto mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.3.3";

      src = fetchHex {
        pkg = "phoenix_live_reload";
        version = "${version}";
        sha256 = "766796676e5f558dbae5d1bdb066849673e956005e3730dfd5affd7a6da4abac";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.17.11";

      src = fetchHex {
        pkg = "phoenix_live_view";
        version = "${version}";
        sha256 = "7177791944b7f90ed18f5935a6a5f07f760b36f7b3bdfb9d28c57440a3c43f99";
      };

      beamDeps = [ jason phoenix phoenix_html telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.1";

      src = fetchHex {
        pkg = "phoenix_pubsub";
        version = "${version}";
        sha256 = "81367c6d1eea5878ad726be80808eb5a787a23dee699f96e72b1109c57cdd8d9";
      };

      beamDeps = [];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "1.1.2";

      src = fetchHex {
        pkg = "phoenix_view";
        version = "${version}";
        sha256 = "7ae90ad27b09091266f6adbb61e1d2516a7c3d7062c6789d46a7554ec40f3a56";
      };

      beamDeps = [ phoenix_html ];
    };

    php_serializer = buildMix rec {
      name = "php_serializer";
      version = "2.0.0";

      src = fetchHex {
        pkg = "php_serializer";
        version = "${version}";
        sha256 = "61e402e99d9062c0225a3f4fcf7e43b4cba1b8654944c0e7c139c3ca9de481da";
      };

      beamDeps = [];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.14.2";

      src = fetchHex {
        pkg = "plug";
        version = "${version}";
        sha256 = "842fc50187e13cf4ac3b253d47d9474ed6c296a8732752835ce4a86acdf68d13";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.1";

      src = fetchHex {
        pkg = "plug_cowboy";
        version = "${version}";
        sha256 = "de36e1a21f451a18b790f37765db198075c25875c64834bcc82d90b309eb6613";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "1.2.5";

      src = fetchHex {
        pkg = "plug_crypto";
        version = "${version}";
        sha256 = "26549a1d6345e2172eb1c233866756ae44a9609bd33ee6f99147ab3fd87fd842";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.19.0";

      src = fetchHex {
        pkg = "postgrex";
        version = "${version}";
        sha256 = "dba2d2a0a8637defbf2307e8629cb2526388ba7348f67d04ec77a5d6a72ecfae";
      };

      beamDeps = [ db_connection decimal jason ];
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

    rustler_precompiled = buildMix rec {
      name = "rustler_precompiled";
      version = "0.7.2";

      src = fetchHex {
        pkg = "rustler_precompiled";
        version = "${version}";
        sha256 = "7663faaeadc9e93e605164dcf9e69168e35f2f8b7f2b9eb4e400d1a8e0fe2999";
      };

      beamDeps = [ castore ];
    };

    solid = buildMix rec {
      name = "solid";
      version = "0.14.1";

      src = fetchHex {
        pkg = "solid";
        version = "${version}";
        sha256 = "5fda2b9176d7a71f52cca7f694d8ca75aed3f1b5b76dd175ada30b2756f96bae";
      };

      beamDeps = [ nimble_parsec ];
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

    sweet_xml = buildMix rec {
      name = "sweet_xml";
      version = "0.7.1";

      src = fetchHex {
        pkg = "sweet_xml";
        version = "${version}";
        sha256 = "8bc7b7b584a6a87113071d0d2fd39fe2251cf2224ecaeed7093bdac1b9c1555f";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.11.6";

      src = fetchHex {
        pkg = "swoosh";
        version = "${version}";
        sha256 = "7fbb7bd0b674e344dbd3a15c33ca787357663ef534dde2cc5ee74d00f7427fd5";
      };

      beamDeps = [ cowboy ex_aws gen_smtp hackney jason mime plug plug_cowboy telemetry ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "0.4.3";

      src = fetchHex {
        pkg = "telemetry";
        version = "${version}";
        sha256 = "eb72b8365ffda5bed68a620d1da88525e326cb82a75ee61354fc24b844768041";
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

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "0.5.1";

      src = fetchHex {
        pkg = "telemetry_poller";
        version = "${version}";
        sha256 = "4cab72069210bc6e7a080cec9afffad1b33370149ed5d379b81c7c5f0c663fd4";
      };

      beamDeps = [ telemetry ];
    };

    tls_certificate_check = buildRebar3 rec {
      name = "tls_certificate_check";
      version = "1.22.1";

      src = fetchHex {
        pkg = "tls_certificate_check";
        version = "${version}";
        sha256 = "3092be0babdc0e14c2e900542351e066c0fa5a9cf4b3597559ad1e67f07938c0";
      };

      beamDeps = [ ssl_verify_fun ];
    };

    tzdata = buildMix rec {
      name = "tzdata";
      version = "1.1.2";

      src = fetchHex {
        pkg = "tzdata";
        version = "${version}";
        sha256 = "cec7b286e608371602318c414f344941d5eb0375e14cfdab605cca2fe66cba8b";
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
  };
in self

