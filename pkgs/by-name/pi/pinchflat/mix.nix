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
        version = "1.0.14";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "7bc1b65249d31701393edaaac18ec8398d8974d52c647b7904d01b964137b9f4";
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
        version = "2.15.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "b147ed22ce71d72eafdad94f055165c1c182f61a2ff49df28bcc71d1d5b94a60";
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
        version = "2.13.0";

        src = fetchHex {
          pkg = "cowboy";
          version = "${version}";
          sha256 = "e724d3a70995025d654c1992c7b11dbfea95205c047d86ff9bf1cda92ddc5614";
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
        version = "2.15.0";

        src = fetchHex {
          pkg = "cowlib";
          version = "${version}";
          sha256 = "4f00c879a64b4fe7c8fcb42a4281925e9ffdb928820b03c3ad325a617e857532";
        };

        beamDeps = [ ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.12";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "8493d45c656c5427d9c729235b99d498bd133421f3e0a683e5c1b561471291e5";
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
        version = "2.3.0";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "a4d66355cb29cb47c3cf30e71329e58361cfcb37c34235ef3bf1d7bf3773aeac";
        };

        beamDeps = [ ];
      };

      dns_cluster = buildMix rec {
        name = "dns_cluster";
        version = "0.2.0";

        src = fetchHex {
          pkg = "dns_cluster";
          version = "${version}";
          sha256 = "ba6f1893411c69c01b9e8e8f772062535a4cf70f3f35bcc964a324078d8c8240";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.12.5";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "6eb18e80bef8bb57e17f5a7f068a1719fbda384d40fc37acb8eb8aeca493b6ea";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.12.1";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "aff5b958a899762c5f09028c847569f7dfb9cc9d63bdb8133bff8a5546de6bf5";
        };

        beamDeps = [
          db_connection
          ecto
          telemetry
        ];
      };

      ecto_sqlite3 = buildMix rec {
        name = "ecto_sqlite3";
        version = "0.19.0";

        src = fetchHex {
          pkg = "ecto_sqlite3";
          version = "${version}";
          sha256 = "297b16750fe229f3056fe32afd3247de308094e8b0298aef0d73a8493ce97c81";
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
        version = "0.9.0";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "db23d4fd8b757462ad02f8aa73431a426fe6671c80b200d9710caf3d1dd0ffdb";
        };

        beamDeps = [ ];
      };

      esbuild = buildMix rec {
        name = "esbuild";
        version = "0.10.0";

        src = fetchHex {
          pkg = "esbuild";
          version = "${version}";
          sha256 = "468489cda427b974a7cc9f03ace55368a83e1a7be12fba7e30969af78e5f8c70";
        };

        beamDeps = [ jason ];
      };

      ex_check = buildMix rec {
        name = "ex_check";
        version = "0.16.0";

        src = fetchHex {
          pkg = "ex_check";
          version = "${version}";
          sha256 = "4d809b72a18d405514dda4809257d8e665ae7cf37a7aee3be6b74a34dec310f5";
        };

        beamDeps = [ ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "1.1.0";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "fbadf93f4700fb44c331362177bdca9eeb8097e8b0ef525c9cc501cb9917c960";
        };

        beamDeps = [ ];
      };

      exqlite = buildMix rec {
        name = "exqlite";
        version = "0.31.0";

        src = fetchHex {
          pkg = "exqlite";
          version = "${version}";
          sha256 = "df352de99ba4ce1bac2ad4943d09dbe9ad59e0e7ace55917b493ae289c78fc75";
        };

        beamDeps = [
          cc_precompiler
          db_connection
          elixir_make
        ];
      };

      faker = buildMix rec {
        name = "faker";
        version = "0.18.0";

        src = fetchHex {
          pkg = "faker";
          version = "${version}";
          sha256 = "bfbdd83958d78e2788e99ec9317c4816e651ad05e24cfd1196ce5db5b3e81797";
        };

        beamDeps = [ ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "1.1.0";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "bfcf81244f416871f2a2e15c1b515287faa5db9c6bcf290222206d120b3d43f6";
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
        version = "0.37.1";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "673d040cb594d31318d514590246b6dd587ed341d3b67e17c1c0eb8ce7ca6f04";
        };

        beamDeps = [ ];
      };

      gettext = buildMix rec {
        name = "gettext";
        version = "0.26.2";

        src = fetchHex {
          pkg = "gettext";
          version = "${version}";
          sha256 = "aa978504bcf76511efdc22d580ba08e2279caab1066b76bb9aa81c4a1e0a32a5";
        };

        beamDeps = [ expo ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.24.1";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "f4a7392a0b53d8bbc3eb855bdcc919cd677358e65b2afd3840b5b3690c4c8a39";
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
        version = "1.0.3";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "8eab6e1cfa8d5918c2ce4ba43588e894af35dbd8e91e6e55c817bca5847df34a";
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
        version = "2.0.7";

        src = fetchHex {
          pkg = "mime";
          version = "${version}";
          sha256 = "6171188e399ee16023ffc5b76ce445eb6d9672e2e241d2df6050f3c771e80ccd";
        };

        beamDeps = [ ];
      };

      mimerl = buildRebar3 rec {
        name = "mimerl";
        version = "1.4.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          sha256 = "13af15f9f68c65884ecca3a3891d50a7b57d82152792f3e19d88650aa126b144";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.7.1";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "fceba0a4d0f24301ddee3024ae116df1c3f4bb7a563a731f45fdfeb9d39a231b";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.2.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "c7b92b3cc69ee24a7eeeaf944cd7be22013c52fcb580c1f33f50845ec821089a";
        };

        beamDeps = [ nimble_ownership ];
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

      nimble_ownership = buildMix rec {
        name = "nimble_ownership";
        version = "1.0.1";

        src = fetchHex {
          pkg = "nimble_ownership";
          version = "${version}";
          sha256 = "3825e461025464f519f3f3e4a1f9b68c47dc151369611629ad08b636b73bb22d";
        };

        beamDeps = [ ];
      };

      nimble_parsec = buildMix rec {
        name = "nimble_parsec";
        version = "1.4.2";

        src = fetchHex {
          pkg = "nimble_parsec";
          version = "${version}";
          sha256 = "4b21398942dda052b403bbe1da991ccd03a053668d147d53fb8c4e0efe09c973";
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
        version = "2.19.4";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "5fcc6219e6464525b808d97add17896e724131f498444a292071bf8991c99f97";
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
        version = "1.7.21";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "336dce4f86cba56fed312a7d280bf2282c720abb6074bdb1b61ec8095bdd0bc9";
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
        version = "4.6.4";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "f5b8584c36ccc9b903948a696fc9b8b81102c79c7c0c751a9f00cdec55d5f2d7";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "4.2.1";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "cff108100ae2715dd959ae8f2a8cef8e20b593f8dfd031c9cba92702cf23e053";
        };

        beamDeps = [ ];
      };

      phoenix_live_dashboard = buildMix rec {
        name = "phoenix_live_dashboard";
        version = "0.8.7";

        src = fetchHex {
          pkg = "phoenix_live_dashboard";
          version = "${version}";
          sha256 = "3a8625cab39ec261d48a13b7468dc619c0ede099601b084e343968309bd4d7d7";
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
        version = "1.6.0";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "b3a1fa036d7eb2f956774eda7a7638cf5123f8f2175aca6d6420a7f95e598e1c";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.0.17";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "a4ca05c1eb6922c4d07a508a75bfa12c45e5f4d8f77ae83283465f02c53741e1";
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
        version = "1.18.0";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "819f9e176d51e44dc38132e132fe0accaf6767eab7f0303431e404da8476cfa2";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_cowboy = buildMix rec {
        name = "plug_cowboy";
        version = "2.7.3";

        src = fetchHex {
          pkg = "plug_cowboy";
          version = "${version}";
          sha256 = "77c95524b2aa5364b247fa17089029e73b951ebc1adeef429361eab0bb55819d";
        };

        beamDeps = [
          cowboy
          cowboy_telemetry
          plug
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.1.1";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "6470bce6ffe41c8bd497612ffde1a7e4af67f36a15eea5f921af71cf3e11247c";
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
        version = "2.2.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          sha256 = "fa0b99a1780c80218a4197a59ea8d3bdae32fbff7e88527d7d8a4787eff4f8e7";
        };

        beamDeps = [ ];
      };

      sobelow = buildMix rec {
        name = "sobelow";
        version = "0.14.0";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          sha256 = "7ecf91e298acfd9b24f5d761f19e8f6e6ac585b9387fb6301023f1f2cd5eed5f";
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
        version = "1.19.1";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "eab57462d41a3330e82cb93a9d7640f5c79a85951f3457db25c1eb28fda193a6";
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
        version = "4.1.0";

        src = fetchHex {
          pkg = "table_rex";
          version = "${version}";
          sha256 = "95932701df195d43bc2d1c6531178fc8338aa8f38c80f098504d529c43bc2601";
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
        version = "1.1.0";

        src = fetchHex {
          pkg = "telemetry_metrics";
          version = "${version}";
          sha256 = "e7b79e8ddfde70adb6db8a6623d1778ec66401f366e9a8f5dd0955c56bc8ce67";
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
        version = "1.2.0";

        src = fetchHex {
          pkg = "telemetry_poller";
          version = "${version}";
          sha256 = "7216e21a6c326eb9aa44328028c34e9fd348fb53667ca837be59d0aa2a0156e8";
        };

        beamDeps = [ telemetry ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.12";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "220dc675e8afca1762568dad874d8fbc8a0a0ccb25a4d1bde8f7cf006707e04f";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.1.3";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          sha256 = "d4ca85575a064d29d4e94253ee95912edfb165938743dbf002acdf0dcecb0c28";
        };

        beamDeps = [ hackney ];
      };

      unicode_util_compat = buildRebar3 rec {
        name = "unicode_util_compat";
        version = "0.7.1";

        src = fetchHex {
          pkg = "unicode_util_compat";
          version = "${version}";
          sha256 = "b3a917854ce3ae233619744ad1e0102e05673136776fb2fa76234f3e03b23642";
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
