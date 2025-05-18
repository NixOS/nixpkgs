{
  lib,
  beamPackages,
  overrides ? (x: y: { }),
}:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages =
    with beamPackages;
    with self;
    {
      bunt = buildMix rec {
        name = "bunt";
        version = "1.0.0";

        src = fetchHex {
          pkg = "bunt";
          version = "${version}";
          sha256 = "dc5f86aa08a5f6fa6b8096f0735c4e76d54ae5c9fa2c143e5a1fc7c1cd9bb6b5";
        };

        beamDeps = [ ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.11";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "e03990b4db988df56262852f20de0f659871c35154691427a5047f4967a16a62";
        };

        beamDeps = [ ];
      };

      cc_precompiler = buildMix rec {
        name = "cc_precompiler";
        version = "0.1.10";

        src = fetchHex {
          pkg = "cc_precompiler";
          version = "${version}";
          sha256 = "f6e046254e53cd6b41c6bacd70ae728011aa82b2742a80d6e2214855c6e06b22";
        };

        beamDeps = [ elixir_make ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.12.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "ee68d85df22e554040cdb4be100f33873ac6051387baf6a8f6ce82272340ff1c";
        };

        beamDeps = [ ];
      };

      combine = buildMix rec {
        name = "combine";
        version = "0.10.0";

        src = fetchHex {
          pkg = "combine";
          version = "${version}";
          sha256 = "1b1dbc1790073076580d0d1d64e42eae2366583e7aecd455d1215b0d16f2451b";
        };

        beamDeps = [ ];
      };

      cowboy = buildErlangMk rec {
        name = "cowboy";
        version = "2.12.0";

        src = fetchHex {
          pkg = "cowboy";
          version = "${version}";
          sha256 = "8a7abe6d183372ceb21caa2709bec928ab2b72e18a3911aa1771639bef82651e";
        };

        beamDeps = [
          cowlib
          ranch
        ];
      };

      cowboy_telemetry = buildRebar3 rec {
        name = "cowboy_telemetry";
        version = "0.4.0";

        src = fetchHex {
          pkg = "cowboy_telemetry";
          version = "${version}";
          sha256 = "7d98bac1ee4565d31b62d59f8823dfd8356a169e7fcbb83831b8a5397404c9de";
        };

        beamDeps = [
          cowboy
          telemetry
        ];
      };

      cowlib = buildRebar3 rec {
        name = "cowlib";
        version = "2.13.0";

        src = fetchHex {
          pkg = "cowlib";
          version = "${version}";
          sha256 = "e1e1284dc3fc030a64b1ad0d8382ae7e99da46c3246b815318a4b848873800a4";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.7";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "8bc87496c9aaacdc3f90f01b7b0582467b69b4bd2441fe8aae3109d843cc2f2e";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      credo_naming = buildMix rec {
        name = "credo_naming";
        version = "2.1.0";

        src = fetchHex {
          pkg = "credo_naming";
          version = "${version}";
          sha256 = "830e23b3fba972e2fccec49c0c089fe78c1e64bc16782a2682d78082351a2909";
        };

        beamDeps = [ credo ];
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
        version = "2.2.0";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "af8daf87384b51b7e611fb1a1f2c4d4876b65ef968fa8bd3adf44cff401c7f21";
        };

        beamDeps = [ ];
      };

      dns_cluster = buildMix rec {
        name = "dns_cluster";
        version = "0.1.2";

        src = fetchHex {
          pkg = "dns_cluster";
          version = "${version}";
          sha256 = "7494272040f847637bbdb01bcdf4b871e82daf09b813e7d3cb3b84f112c6f2f8";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.12.3";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "9efd91506ae722f95e48dc49e70d0cb632ede3b7a23896252a60a14ac6d59165";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.12.0";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "dc9e4d206f274f3947e96142a8fdc5f69a2a6a9abb4649ef5c882323b6d512f0";
        };

        beamDeps = [
          db_connection
          ecto
          telemetry
        ];
      };

      ecto_sqlite3 = buildMix rec {
        name = "ecto_sqlite3";
        version = "0.17.2";

        src = fetchHex {
          pkg = "ecto_sqlite3";
          version = "${version}";
          sha256 = "a3838919c5a34c268c28cafab87b910bcda354a9a4e778658da46c149bb2c1da";
        };

        beamDeps = [
          decimal
          ecto
          ecto_sql
          exqlite
        ];
      };

      ecto_sqlite3_extras = buildMix rec {
        name = "ecto_sqlite3_extras";
        version = "1.2.2";

        src = fetchHex {
          pkg = "ecto_sqlite3_extras";
          version = "${version}";
          sha256 = "2b66ba7246bb4f7e39e2578acd4a0e4e4be54f60ff52d450a01be95eeb78ff1e";
        };

        beamDeps = [
          exqlite
          table_rex
        ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.8.4";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "6e7f1d619b5f61dfabd0a20aa268e575572b542ac31723293a4c1a567d5ef040";
        };

        beamDeps = [
          castore
          certifi
        ];
      };

      esbuild = buildMix rec {
        name = "esbuild";
        version = "0.8.1";

        src = fetchHex {
          pkg = "esbuild";
          version = "${version}";
          sha256 = "25fc876a67c13cb0a776e7b5d7974851556baeda2085296c14ab48555ea7560f";
        };

        beamDeps = [
          castore
          jason
        ];
      };

      ex_check = buildMix rec {
        name = "ex_check";
        version = "0.14.0";

        src = fetchHex {
          pkg = "ex_check";
          version = "${version}";
          sha256 = "8a602e98c66e6a4be3a639321f1f545292042f290f91fa942a285888c6868af0";
        };

        beamDeps = [ ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "0.5.1";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "68a4233b0658a3d12ee00d27d37d856b1ba48607e7ce20fd376958d0ba6ce92b";
        };

        beamDeps = [ ];
      };

      exqlite = buildMix rec {
        name = "exqlite";
        version = "0.23.0";

        src = fetchHex {
          pkg = "exqlite";
          version = "${version}";
          sha256 = "404341cceec5e6466aaed160cf0b58be2019b60af82588c215e1224ebd3ec831";
        };

        # This needs to be re-added manually after running mix2nix, see: https://github.com/ydlr/mix2nix/issues/3#issuecomment-2508889881
        preConfigure = ''
          export ELIXIR_MAKE_CACHE_DIR="$TMPDIR/.cache"
        '';

        beamDeps = [
          cc_precompiler
          db_connection
          elixir_make
        ];
      };

      faker = buildMix rec {
        name = "faker";
        version = "0.17.0";

        src = fetchHex {
          pkg = "faker";
          version = "${version}";
          sha256 = "a7d4ad84a93fd25c5f5303510753789fc2433ff241bf3b4144d3f6f291658a6a";
        };

        beamDeps = [ ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "0.2.10";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "41195edbfb562a593726eda3b3e8b103a309b733ad25f3d642ba49696bf715dc";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.19.0";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          sha256 = "fc5324ce209125d1e2fa0fcd2634601c52a787aff1cd33ee833664a5af4ea2b6";
        };

        beamDeps = [
          mime
          mint
          nimble_options
          nimble_pool
          telemetry
        ];
      };

      floki = buildMix rec {
        name = "floki";
        version = "0.36.3";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "fe0158bff509e407735f6d40b3ee0d7deb47f3f3ee7c6c182ad28599f9f6b27a";
        };

        beamDeps = [ ];
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

        beamDeps = [
          certifi
          idna
          metrics
          mimerl
          parse_trans
          ssl_verify_fun
          unicode_util_compat
        ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "1.0.2";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "2f09b4c1074e0abd846747329eaa26d535be0eb3d189fa69d812bfb8bfefd32f";
        };

        beamDeps = [ ];
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

      metrics = buildRebar3 rec {
        name = "metrics";
        version = "1.0.1";

        src = fetchHex {
          pkg = "metrics";
          version = "${version}";
          sha256 = "69b09adddc4f74a40716ae54d140f93beb0fb8978d8636eaded0c31b6f099f16";
        };

        beamDeps = [ ];
      };

      mime = buildMix rec {
        name = "mime";
        version = "2.0.6";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "c9945363a6b26d747389aac3643f8e0e09d30499a138ad64fe8fd1d13d9b153e";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.3.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          sha256 = "a1e15a50d1887217de95f0b9b0793e32853f7c258a5cd227650889b38839fe9d";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.6.2";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "5ee441dffc1892f1ae59127f74afe8fd82fda6587794278d924e4d90ea3d63f9";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.1.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "d44474c50be02d5b72131070281a5d3895c0e7a95c780e90bc0cfe712f633a13";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.1.1";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "821b2470ca9442c4b6984882fe9bb0389371b8ddec4d45a9504f00a66f650b44";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.0";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "9c565862810fb383e9838c1dd2d7d2c437b3d13b267414ba6af33e50d2d1cf28";
        };

        beamDeps = [ ];
      };

      nimble_pool = buildMix rec {
        name = "nimble_pool";
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.18.3";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "36ca6ca84ef6518f9c2c759ea88efd438a3c81d667ba23b02b062a0aa785475e";
        };

        beamDeps = [
          ecto_sql
          ecto_sqlite3
          jason
          telemetry
        ];
      };

      octo_fetch = buildMix rec {
        name = "octo_fetch";
        version = "0.4.0";

        src = fetchHex {
          pkg = "octo_fetch";
          version = "${version}";
          sha256 = "cf8be6f40cd519d7000bb4e84adcf661c32e59369ca2827c4e20042eda7a7fc6";
        };

        beamDeps = [
          castore
          ssl_verify_fun
        ];
      };

      parse_trans = buildRebar3 rec {
        name = "parse_trans";
        version = "3.4.1";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
        };

        beamDeps = [ ];
      };

      peep = buildMix rec {
        name = "peep";
        version = "3.4.1";

        src = fetchHex {
          pkg = "peep";
          version = "${version}";
          sha256 = "7a9b8c1f17b8b9475efb27b7048afa4d89ab84ef33a3d1df13696c85c12cd632";
        };

        beamDeps = [
          nimble_options
          plug
          telemetry_metrics
        ];
      };

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.7.17";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "50e8ad537f3f7b0efb1509b2f75b5c918f697be6a45d48e49a30d3b7c0e464c9";
        };

        beamDeps = [
          castore
          jason
          phoenix_pubsub
          phoenix_template
          plug
          plug_cowboy
          plug_crypto
          telemetry
          websock_adapter
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.4.3";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "d36c401206f3011fefd63d04e8ef626ec8791975d9d107f9a0817d426f61ac07";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "3.3.4";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "0249d3abec3714aff3415e7ee3d9786cb325be3151e6c4b3021502c585bf53fb";
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

        beamDeps = [
          ecto
          ecto_sqlite3_extras
          mime
          phoenix_live_view
          telemetry_metrics
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.4.1";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "9bffb834e7ddf08467fe54ae58b5785507aaba6255568ae22b4d46e2bb3615ab";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.0.0";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "254caef0028765965ca6bd104cc7d68dcc7d57cc42912bef92f6b03047251d99";
        };

        beamDeps = [
          floki
          jason
          phoenix
          phoenix_html
          phoenix_template
          plug
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.1.3";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "bba06bc1dcfd8cb086759f0edc94a8ba2bc8896d5331a1e2c2902bf8e36ee502";
        };

        beamDeps = [ ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.0.4";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          sha256 = "2c0c81f0e5c6753faf5cca2f229c9709919aba34fab866d3bc05060c9c444206";
        };

        beamDeps = [ phoenix_html ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.16.1";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "a13ff6b9006b03d7e33874945b2755253841b238c34071ed85b0e86057f8cddc";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_cowboy = buildMix rec {
        name = "plug_cowboy";
        version = "2.7.2";

        src = fetchHex {
          pkg = "plug_cowboy";
          version = "${version}";
          sha256 = "245d8a11ee2306094840c000e8816f0cbed69a23fc0ac2bcf8d7835ae019bb2f";
        };

        beamDeps = [
          cowboy
          cowboy_telemetry
          plug
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.1.0";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "131216a4b030b8f8ce0f26038bc4421ae60e4bb95c5cf5395e1421437824c4fa";
        };

        beamDeps = [ ];
      };

      prom_ex = buildMix rec {
        name = "prom_ex";
        version = "1.11.0";

        src = fetchHex {
          pkg = "prom_ex";
          version = "${version}";
          sha256 = "76b074bc3730f0802978a7eb5c7091a65473eaaf07e99ec9e933138dcc327805";
        };

        beamDeps = [
          ecto
          finch
          jason
          oban
          octo_fetch
          peep
          phoenix
          phoenix_live_view
          plug
          plug_cowboy
          telemetry
          telemetry_metrics
          telemetry_metrics_prometheus_core
          telemetry_poller
        ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "1.8.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          sha256 = "49fbcfd3682fab1f5d109351b61257676da1a2fdbe295904176d5e521a2ddfe5";
        };

        beamDeps = [ ];
      };

      sobelow = buildMix rec {
        name = "sobelow";
        version = "0.13.0";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          sha256 = "cd6e9026b85fc35d7529da14f95e85a078d9dd1907a9097b3ba6ac7ebbe34a0d";
        };

        beamDeps = [ jason ];
      };

      ssl_verify_fun = buildRebar3 rec {
        name = "ssl_verify_fun";
        version = "1.1.7";

        src = fetchHex {
          pkg = "ssl_verify_fun";
          version = "${version}";
          sha256 = "fe4c190e8f37401d30167c8c405eda19469f34577987c76dde613e838bbc67f8";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.14.4";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "081c5a590e4ba85cc89baddf7b2beecf6c13f7f84a958f1cd969290815f0f026";
        };

        beamDeps = [
          cowboy
          finch
          hackney
          jason
          mime
          plug
          plug_cowboy
          telemetry
        ];
      };

      table_rex = buildMix rec {
        name = "table_rex";
        version = "4.0.0";

        src = fetchHex {
          pkg = "table_rex";
          version = "${version}";
          sha256 = "c35c4d5612ca49ebb0344ea10387da4d2afe278387d4019e4d8111e815df8f55";
        };

        beamDeps = [ ];
      };

      tailwind = buildMix rec {
        name = "tailwind";
        version = "0.2.2";

        src = fetchHex {
          pkg = "tailwind";
          version = "${version}";
          sha256 = "ccfb5025179ea307f7f899d1bb3905cd0ac9f687ed77feebc8f67bdca78565c4";
        };

        beamDeps = [ castore ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.3.0";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "7015fc8919dbe63764f4b4b87a95b7c0996bd539e0d499be6ec9d7f3875b79e6";
        };

        beamDeps = [ ];
      };

      telemetry_metrics = buildMix rec {
        name = "telemetry_metrics";
        version = "1.0.0";

        src = fetchHex {
          pkg = "telemetry_metrics";
          version = "${version}";
          sha256 = "f23713b3847286a534e005126d4c959ebcca68ae9582118ce436b521d1d47d5d";
        };

        beamDeps = [ telemetry ];
      };

      telemetry_metrics_prometheus_core = buildMix rec {
        name = "telemetry_metrics_prometheus_core";
        version = "1.2.1";

        src = fetchHex {
          pkg = "telemetry_metrics_prometheus_core";
          version = "${version}";
          sha256 = "5e2c599da4983c4f88a33e9571f1458bf98b0cf6ba930f1dc3a6e8cf45d5afb6";
        };

        beamDeps = [
          telemetry
          telemetry_metrics
        ];
      };

      telemetry_poller = buildRebar3 rec {
        name = "telemetry_poller";
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_poller";
          version = "${version}";
          sha256 = "9eb9d9cbfd81cbd7cdd24682f8711b6e2b691289a0de6826e58452f28c103c8f";
        };

        beamDeps = [ telemetry ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.11";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "8b9024f7efbabaf9bd7aa04f65cf8dcd7c9818ca5737677c7b76acbc6a94d1aa";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
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

        beamDeps = [ ];
      };

      websock = buildMix rec {
        name = "websock";
        version = "0.5.3";

        src = fetchHex {
          pkg = "websock";
          version = "${version}";
          sha256 = "6105453d7fac22c712ad66fab1d45abdf049868f253cf719b625151460b8b453";
        };

        beamDeps = [ ];
      };

      websock_adapter = buildMix rec {
        name = "websock_adapter";
        version = "0.5.8";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "315b9a1865552212b5f35140ad194e67ce31af45bcee443d4ecb96b5fd3f3782";
        };

        beamDeps = [
          plug
          plug_cowboy
          websock
        ];
      };
    };
in
self
