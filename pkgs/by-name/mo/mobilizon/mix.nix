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
      absinthe = buildMix rec {
        name = "absinthe";
        version = "1.12.0";

        src = fetchHex {
          pkg = "absinthe";
          version = "${version}";
          sha256 = "b0672939fa75c24b6286c784edc01bec1bedfbe58885acdda5d097c7053b03c6";
        };

        beamDeps = [
          dataloader
          decimal
          nimble_parsec
          telemetry
        ];
      };

      absinthe_phoenix = buildMix rec {
        name = "absinthe_phoenix";
        version = "2.0.6";

        src = fetchHex {
          pkg = "absinthe_phoenix";
          version = "${version}";
          sha256 = "dbf0316a40e397d2f46e1093bfff88ccf9543e81ed7a96bfe01dcae26b220f33";
        };

        beamDeps = [
          absinthe
          absinthe_plug
          decimal
          phoenix
          phoenix_html
          phoenix_pubsub
        ];
      };

      absinthe_plug = buildMix rec {
        name = "absinthe_plug";
        version = "1.5.10";

        src = fetchHex {
          pkg = "absinthe_plug";
          version = "${version}";
          sha256 = "489ac1951c8e4128571141c60a0669a720619bc161f801a8c6be8cfaf7ab0979";
        };

        beamDeps = [
          absinthe
          plug
        ];
      };

      argon2_elixir = buildMix rec {
        name = "argon2_elixir";
        version = "4.1.3";

        src = fetchHex {
          pkg = "argon2_elixir";
          version = "${version}";
          sha256 = "7c295b8d8e0eaf6f43641698f962526cdf87c6feb7d14bd21e599271b510608c";
        };

        beamDeps = [
          comeonin
          elixir_make
        ];
      };

      atomex = buildMix rec {
        name = "atomex";
        version = "0.5.1";

        src = fetchHex {
          pkg = "atomex";
          version = "${version}";
          sha256 = "6248891b5fcab8503982e090eedeeadb757a6311c2ef2e2998b874f7d319ab3f";
        };

        beamDeps = [ xml_builder ];
      };

      bandit = buildMix rec {
        name = "bandit";
        version = "1.15.0";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          sha256 = "e3b29c4a5107f4bf7dfaa263c50b9b97ddcc132622197c110e2e10a921641c44";
        };

        beamDeps = [
          hpax
          plug
          telemetry
          thousand_island
          websock
        ];
      };

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

      cachex = buildMix rec {
        name = "cachex";
        version = "4.1.1";

        src = fetchHex {
          pkg = "cachex";
          version = "${version}";
          sha256 = "d6b7449ff98d6bb92dda58bd4fc3189cae9f99e7042054d669596f56dc503cd8";
        };

        beamDeps = [
          eternal
          ex_hash_ring
          jumper
          sleeplocks
          unsafe
        ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.22";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "c2a4d42723b4affbc1c3e15d8f6df3f7d8f1f627c84de643383634cce58493d5";
        };

        beamDeps = [ ];
      };

      certifi = buildRebar3 rec {
        name = "certifi";
        version = "2.19.0";

        src = fetchHex {
          pkg = "certifi";
          version = "${version}";
          sha256 = "7bac57b76eae5c4b576d4a61a4fd083d186ba7f7918ee2c2b42cb02095e366a8";
        };

        beamDeps = [ ];
      };

      cldr_utils = buildMix rec {
        name = "cldr_utils";
        version = "2.29.8";

        src = fetchHex {
          pkg = "cldr_utils";
          version = "${version}";
          sha256 = "b07af39dab4492f9f597e00f55e39bbbac9b821d88f7ae4990272a03588c98cf";
        };

        beamDeps = [
          castore
          certifi
          decimal
        ];
      };

      codepagex = buildMix rec {
        name = "codepagex";
        version = "0.1.13";

        src = fetchHex {
          pkg = "codepagex";
          version = "${version}";
          sha256 = "c328170767e3ec04682193e7a07a8074c934a995a903d1836777c0ca5edf0d46";
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

      comeonin = buildMix rec {
        name = "comeonin";
        version = "5.5.1";

        src = fetchHex {
          pkg = "comeonin";
          version = "${version}";
          sha256 = "65aac8f19938145377cee73973f192c5645873dcf550a8a6b18187d17c13ccdb";
        };

        beamDeps = [ ];
      };

      cors_plug = buildMix rec {
        name = "cors_plug";
        version = "3.0.3";

        src = fetchHex {
          pkg = "cors_plug";
          version = "${version}";
          sha256 = "3f2d759e8c272ed3835fab2ef11b46bddab8c1ab9528167bd463b6452edf830d";
        };

        beamDeps = [ plug ];
      };

      credo = buildMix rec {
        name = "credo";
        version = "1.7.19";

        src = fetchHex {
          pkg = "credo";
          version = "${version}";
          sha256 = "2d8bc95d5a7bb99dd2613621d4f08c6a3575c3fd4b62e6a2b48a100352a557b8";
        };

        beamDeps = [
          bunt
          file_system
          jason
        ];
      };

      credo_code_climate = buildMix rec {
        name = "credo_code_climate";
        version = "0.1.0";

        src = fetchHex {
          pkg = "credo_code_climate";
          version = "${version}";
          sha256 = "75529fe38056f4e229821d604758282838b8397c82e2c12e409fda16b16821ca";
        };

        beamDeps = [
          credo
          jason
        ];
      };

      dataloader = buildMix rec {
        name = "dataloader";
        version = "2.0.2";

        src = fetchHex {
          pkg = "dataloader";
          version = "${version}";
          sha256 = "4c6cabc0b55e96e7de74d14bf37f4a5786f0ab69aa06764a1f39dda40079b098";
        };

        beamDeps = [
          ecto
          telemetry
        ];
      };

      db_connection = buildMix rec {
        name = "db_connection";
        version = "2.10.2";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          sha256 = "510b14482330f1af6490a2fa0efd8d4f1435d1529b165647df22ac0f2df0fa93";
        };

        beamDeps = [ telemetry ];
      };

      decimal = buildMix rec {
        name = "decimal";
        version = "3.2.0";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "190bca80580ce61aa69bb0eacadd7677710205c770225c2c2c07e32a5c31b234";
        };

        beamDeps = [ ];
      };

      dialyxir = buildMix rec {
        name = "dialyxir";
        version = "1.4.9";

        src = fetchHex {
          pkg = "dialyxir";
          version = "${version}";
          sha256 = "1c049c22b47680f4fff78ed0b0fe377073a762e96af153fdfe28bf00131de76d";
        };

        beamDeps = [ erlex ];
      };

      digital_token = buildMix rec {
        name = "digital_token";
        version = "1.0.0";

        src = fetchHex {
          pkg = "digital_token";
          version = "${version}";
          sha256 = "8ed6f5a8c2fa7b07147b9963db506a1b4c7475d9afca6492136535b064c9e9e6";
        };

        beamDeps = [
          cldr_utils
          jason
        ];
      };

      doctor = buildMix rec {
        name = "doctor";
        version = "0.23.0";

        src = fetchHex {
          pkg = "doctor";
          version = "${version}";
          sha256 = "b8eb63380fa14d9aced609671600359b1fd057da167339c5031b683eb2bac973";
        };

        beamDeps = [ decimal ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.46";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "9c44636e8a1c68c62f526b2dcd85d941dbbcee7ab82cf64ba06ce28bef8e89f5";
        };

        beamDeps = [ ];
      };

      eblurhash = buildRebar3 rec {
        name = "eblurhash";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eblurhash";
          version = "${version}";
          sha256 = "8c20ca00904de023a835a9dcb7b7762fed32264c85a80c3cafa85288e405044c";
        };

        beamDeps = [ ];
      };

      ecto = buildMix rec {
        name = "ecto";
        version = "3.14.3";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "da2548bd3ced0f56c27d54255389bbbb8f110150ce15cffc95ec0cafa364465c";
        };

        beamDeps = [
          decimal
          jason
          telemetry
        ];
      };

      ecto_autoslug_field = buildMix rec {
        name = "ecto_autoslug_field";
        version = "3.1.0";

        src = fetchHex {
          pkg = "ecto_autoslug_field";
          version = "${version}";
          sha256 = "b6ddd614805263e24b5c169532c934440d0289181cce873061fca3a8e92fd9ff";
        };

        beamDeps = [
          ecto
          slugify
        ];
      };

      ecto_dev_logger = buildMix rec {
        name = "ecto_dev_logger";
        version = "0.15.0";

        src = fetchHex {
          pkg = "ecto_dev_logger";
          version = "${version}";
          sha256 = "b2c807d7d599a4fcf288139851c09262333b193bdb41f8d65f515853d117e88a";
        };

        beamDeps = [
          ecto
          geo
          jason
          postgrex
        ];
      };

      ecto_enum = buildMix rec {
        name = "ecto_enum";
        version = "1.4.0";

        src = fetchHex {
          pkg = "ecto_enum";
          version = "${version}";
          sha256 = "8fb55c087181c2b15eee406519dc22578fa60dd82c088be376d0010172764ee4";
        };

        beamDeps = [
          ecto
          ecto_sql
          postgrex
        ];
      };

      ecto_shortuuid = buildMix rec {
        name = "ecto_shortuuid";
        version = "0.4.1";

        src = fetchHex {
          pkg = "ecto_shortuuid";
          version = "${version}";
          sha256 = "26bfea6a2f5fe20f49e04efe6743a74e94d539718cc5191f75499048e56be7bf";
        };

        beamDeps = [
          ecto
          shortuuid
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.14.0";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "f4d8d36faf294c9417b5a37ec7ac8217ee2abdef5fcf197ba690f361548d3949";
        };

        beamDeps = [
          db_connection
          decimal
          ecto
          postgrex
          telemetry
        ];
      };

      elixir_feed_parser = buildMix rec {
        name = "elixir_feed_parser";
        version = "2.1.0";

        src = fetchHex {
          pkg = "elixir_feed_parser";
          version = "${version}";
          sha256 = "2d3c62fe7b396ee3b73d7160bc8fadbd78bfe9597c98c7d79b3f1038d9cba28f";
        };

        beamDeps = [ timex ];
      };

      elixir_make = buildMix rec {
        name = "elixir_make";
        version = "0.10.1";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "ce1eaa234bc87f0279718e793fd6f8ad35b4e8ee8d412329e3879eee8d40adba";
        };

        beamDeps = [ ];
      };

      erlex = buildMix rec {
        name = "erlex";
        version = "0.2.9";

        src = fetchHex {
          pkg = "erlex";
          version = "${version}";
          sha256 = "8cfffc0ec7159e6d73de2ab28a588064de80f88b2798d5cbe4482cbbc200178b";
        };

        beamDeps = [ ];
      };

      erlport = buildRebar3 rec {
        name = "erlport";
        version = "0.11.0";

        src = fetchHex {
          pkg = "erlport";
          version = "${version}";
          sha256 = "8eb136ccaf3948d329b8d1c3278ad2e17e2a7319801bc4cc2da6db278204eee4";
        };

        beamDeps = [ ];
      };

      eternal = buildMix rec {
        name = "eternal";
        version = "1.2.2";

        src = fetchHex {
          pkg = "eternal";
          version = "${version}";
          sha256 = "2c9fe32b9c3726703ba5e1d43a1d255a4f3f2d8f8f9bc19f094c7cb1a7a9e782";
        };

        beamDeps = [ ];
      };

      ex_cldr = buildMix rec {
        name = "ex_cldr";
        version = "2.47.5";

        src = fetchHex {
          pkg = "ex_cldr";
          version = "${version}";
          sha256 = "8637e14a966fa68381e9765afd03d8fc703d6f3bc5c7c3e5fe59354566777595";
        };

        beamDeps = [
          cldr_utils
          decimal
          gettext
          jason
          nimble_parsec
        ];
      };

      ex_cldr_calendars = buildMix rec {
        name = "ex_cldr_calendars";
        version = "2.4.4";

        src = fetchHex {
          pkg = "ex_cldr_calendars";
          version = "${version}";
          sha256 = "40a15cec56aa9c7752b4c9248cc321880f22ef2f3401b69c984c4da242b19a68";
        };

        beamDeps = [
          digital_token
          ex_cldr_numbers
          ex_doc
          jason
        ];
      };

      ex_cldr_currencies = buildMix rec {
        name = "ex_cldr_currencies";
        version = "2.17.2";

        src = fetchHex {
          pkg = "ex_cldr_currencies";
          version = "${version}";
          sha256 = "797095c106a2fe6632981531e29cfb1d2f8ee7de626f4d6243f974d6f74a0112";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_dates_times = buildMix rec {
        name = "ex_cldr_dates_times";
        version = "2.25.8";

        src = fetchHex {
          pkg = "ex_cldr_dates_times";
          version = "${version}";
          sha256 = "2025418bf63841d758fd6faae12c79186b50fcdca10fa41b7b2121ce66900685";
        };

        beamDeps = [
          ex_cldr_calendars
          jason
        ];
      };

      ex_cldr_languages = buildMix rec {
        name = "ex_cldr_languages";
        version = "0.3.3";

        src = fetchHex {
          pkg = "ex_cldr_languages";
          version = "${version}";
          sha256 = "22fb1fef72b7b4b4872d243b34e7b83734247a78ad87377986bf719089cc447a";
        };

        beamDeps = [
          ex_cldr
          jason
        ];
      };

      ex_cldr_numbers = buildMix rec {
        name = "ex_cldr_numbers";
        version = "2.38.5";

        src = fetchHex {
          pkg = "ex_cldr_numbers";
          version = "${version}";
          sha256 = "4f186b45ee836b35a86fe45d79902bbe471c8e553382be619fce327ec45d3d6e";
        };

        beamDeps = [
          cldr_utils
          decimal
          digital_token
          ex_cldr
          ex_cldr_currencies
          jason
        ];
      };

      ex_cldr_plugs = buildMix rec {
        name = "ex_cldr_plugs";
        version = "1.4.0";

        src = fetchHex {
          pkg = "ex_cldr_plugs";
          version = "${version}";
          sha256 = "0859ccd533bddd00a36008ea970ba2d6440c8f01b1d73b115f445015046277bc";
        };

        beamDeps = [
          ex_cldr
          gettext
          jason
          plug
        ];
      };

      ex_doc = buildMix rec {
        name = "ex_doc";
        version = "0.40.5";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "38c7a1a951583ffd710ae34be654aceeff32c164666de53498f89d781bdc2689";
        };

        beamDeps = [
          earmark_parser
          makeup_elixir
          makeup_erlang
        ];
      };

      ex_hash_ring = buildMix rec {
        name = "ex_hash_ring";
        version = "6.0.4";

        src = fetchHex {
          pkg = "ex_hash_ring";
          version = "${version}";
          sha256 = "89adabf31f7d3dfaa36802ce598ce918e9b5b33bae8909ac1a4d052e1e567d18";
        };

        beamDeps = [ ];
      };

      ex_ical = buildMix rec {
        name = "ex_ical";
        version = "0.2.0";

        src = fetchHex {
          pkg = "ex_ical";
          version = "${version}";
          sha256 = "db76473b2ae0259e6633c6c479a5a4d8603f09497f55c88f9ef4d53d2b75befb";
        };

        beamDeps = [ timex ];
      };

      ex_machina = buildMix rec {
        name = "ex_machina";
        version = "2.8.2";

        src = fetchHex {
          pkg = "ex_machina";
          version = "${version}";
          sha256 = "42f551b2a3a26d138788160d44e391a6bf31266af48125c2b935f24521ebd644";
        };

        beamDeps = [
          ecto
          ecto_sql
        ];
      };

      ex_optimizer = buildMix rec {
        name = "ex_optimizer";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ex_optimizer";
          version = "${version}";
          sha256 = "e6f5c059bcd58b66be2f6f257fdc4f69b74b0fa5c9ddd669486af012e4b52286";
        };

        beamDeps = [ file_info ];
      };

      ex_unit_notifier = buildMix rec {
        name = "ex_unit_notifier";
        version = "1.3.1";

        src = fetchHex {
          pkg = "ex_unit_notifier";
          version = "${version}";
          sha256 = "87eb1cea911ed1753e1cc046cbf1c7f86af9058e30672a355f0699b41e5e119d";
        };

        beamDeps = [ ];
      };

      excoveralls = buildMix rec {
        name = "excoveralls";
        version = "0.18.5";

        src = fetchHex {
          pkg = "excoveralls";
          version = "${version}";
          sha256 = "523fe8a15603f86d64852aab2abe8ddbd78e68579c8525ae765facc5eae01562";
        };

        beamDeps = [
          castore
          jason
        ];
      };

      exgravatar = buildMix rec {
        name = "exgravatar";
        version = "2.0.3";

        src = fetchHex {
          pkg = "exgravatar";
          version = "${version}";
          sha256 = "aca18ff9bd8991d3be3e5446d3bdefc051be084c1ffc9ab2d43b3e65339300e1";
        };

        beamDeps = [ ];
      };

      expo = buildMix rec {
        name = "expo";
        version = "1.1.1";

        src = fetchHex {
          pkg = "expo";
          version = "${version}";
          sha256 = "5fb308b9cb359ae200b7e23d37c76978673aa1b06e2b3075d814ce12c5811640";
        };

        beamDeps = [ ];
      };

      export = buildMix rec {
        name = "export";
        version = "0.1.1";

        src = fetchHex {
          pkg = "export";
          version = "${version}";
          sha256 = "3da7444ff4053f1824352f4bdb13fbd2c28c93c2011786fb686b649fdca1021f";
        };

        beamDeps = [ erlport ];
      };

      fast_html = buildMix rec {
        name = "fast_html";
        version = "2.5.0";

        src = fetchHex {
          pkg = "fast_html";
          version = "${version}";
          sha256 = "69eb46ed98a5d9cca1ccd4a5ac94ce5dd626fc29513fbaa0a16cd8b2da67ae3e";
        };

        beamDeps = [
          elixir_make
          nimble_pool
        ];
      };

      fast_sanitize = buildMix rec {
        name = "fast_sanitize";
        version = "0.2.3";

        src = fetchHex {
          pkg = "fast_sanitize";
          version = "${version}";
          sha256 = "e8ad286d10d0386e15d67d0ee125245ebcfbc7d7290b08712ba9013c8c5e56e2";
        };

        beamDeps = [
          fast_html
          plug
        ];
      };

      file_info = buildMix rec {
        name = "file_info";
        version = "0.0.4";

        src = fetchHex {
          pkg = "file_info";
          version = "${version}";
          sha256 = "50e7ad01c2c8b9339010675fe4dc4a113b8d6ca7eddce24d1d74fd0e762781a5";
        };

        beamDeps = [ mimetype_parser ];
      };

      file_system = buildMix rec {
        name = "file_system";
        version = "1.1.1";

        src = fetchHex {
          pkg = "file_system";
          version = "${version}";
          sha256 = "7a15ff97dfe526aeefb090a7a9d3d03aa907e100e262a0f8f7746b78f8f87a5d";
        };

        beamDeps = [ ];
      };

      finch = buildMix rec {
        name = "finch";
        version = "0.25.0";

        src = fetchHex {
          pkg = "finch";
          version = "${version}";
          sha256 = "9fd9a2c47a9033f4d70fad6e7d656948c08bc6652699de20e609a5917c0bb0a5";
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
        version = "0.38.5";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "c8c5b04455f01b076cd489fee7dc26b49edf9851ef61146e743f4676114bf6b0";
        };

        beamDeps = [ ];
      };

      gen_smtp = buildRebar3 rec {
        name = "gen_smtp";
        version = "1.3.0";

        src = fetchHex {
          pkg = "gen_smtp";
          version = "${version}";
          sha256 = "0b73fbf069864ecbce02fe653b16d3f35fd889d0fdd4e14527675565c39d84e6";
        };

        beamDeps = [ ranch ];
      };

      geo = buildMix rec {
        name = "geo";
        version = "4.1.0";

        src = fetchHex {
          pkg = "geo";
          version = "${version}";
          sha256 = "19edb2b3398ca9f701b573b1fb11bc90951ebd64f18b06bd1bf35abe509a2934";
        };

        beamDeps = [ jason ];
      };

      geo_postgis = buildMix rec {
        name = "geo_postgis";
        version = "3.7.1";

        src = fetchHex {
          pkg = "geo_postgis";
          version = "${version}";
          sha256 = "c20d823c600d35b7fe9ddd5be03052bb7136c57d6f1775dbd46871545e405280";
        };

        beamDeps = [
          ecto
          geo
          jason
          postgrex
        ];
      };

      geohax = buildMix rec {
        name = "geohax";
        version = "1.0.2";

        src = fetchHex {
          pkg = "geohax";
          version = "${version}";
          sha256 = "4c782de1e1ee781e2fa07ba6ebfbfb66b91c215b901073defe6196184b8b60a4";
        };

        beamDeps = [ ];
      };

      geolix = buildMix rec {
        name = "geolix";
        version = "2.1.0";

        src = fetchHex {
          pkg = "geolix";
          version = "${version}";
          sha256 = "0b871bc2db8efd0114d1fd7087c83180056a1fff20d90946c89d32200e368651";
        };

        beamDeps = [ ];
      };

      geolix_adapter_mmdb2 = buildMix rec {
        name = "geolix_adapter_mmdb2";
        version = "0.7.0";

        src = fetchHex {
          pkg = "geolix_adapter_mmdb2";
          version = "${version}";
          sha256 = "1207cf34d69e11953dcf12553c808c7ec8960c79bc3432a896f2a6031c2c4f7f";
        };

        beamDeps = [
          geolix
          mmdb2_decoder
        ];
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

      guardian = buildMix rec {
        name = "guardian";
        version = "2.5.0";

        src = fetchHex {
          pkg = "guardian";
          version = "${version}";
          sha256 = "bc75cc9374825194060b0cd3230ce4440df23d8509d1f17472b210d3ee525790";
        };

        beamDeps = [
          jose
          plug
        ];
      };

      guardian_db = buildMix rec {
        name = "guardian_db";
        version = "3.0.0";

        src = fetchHex {
          pkg = "guardian_db";
          version = "${version}";
          sha256 = "9c2ec4278efa34f9f1cc6ba795e552d41fdc7ffba5319d67eeb533b89392d183";
        };

        beamDeps = [
          ecto
          ecto_sql
          guardian
          postgrex
        ];
      };

      guardian_phoenix = buildMix rec {
        name = "guardian_phoenix";
        version = "2.0.1";

        src = fetchHex {
          pkg = "guardian_phoenix";
          version = "${version}";
          sha256 = "21f439246715192b231f228680465d1ed5fbdf01555a4a3b17165532f5f9a08c";
        };

        beamDeps = [
          guardian
          phoenix
        ];
      };

      h2 = buildRebar3 rec {
        name = "h2";
        version = "0.18.3";

        src = fetchHex {
          pkg = "h2";
          version = "${version}";
          sha256 = "cc53d7a6cb67dcca975dbaaa0b41c190677e77808a6748d11810cc1d76320e0f";
        };

        beamDeps = [ ];
      };

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "4.12.4";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "33cbe8273c94fa8be2f0312184c697857c18981fdba71a049c094dd8a299241a";
        };

        beamDeps = [
          certifi
          h2
          idna
          mimerl
          parse_trans
          quic
          ssl_verify_fun
          webtransport
        ];
      };

      hammer = buildMix rec {
        name = "hammer";
        version = "7.6.0";

        src = fetchHex {
          pkg = "hammer";
          version = "${version}";
          sha256 = "5777d22a2f96e53e489aa5a31aee73fe082da78464be52a688521772f96a934a";
        };

        beamDeps = [ ];
      };

      haversine = buildMix rec {
        name = "haversine";
        version = "0.1.0";

        src = fetchHex {
          pkg = "haversine";
          version = "${version}";
          sha256 = "54dc48e895bc18a59437a37026c873634e17b648a64cb87bfafb96f64d607060";
        };

        beamDeps = [ ];
      };

      hpax = buildMix rec {
        name = "hpax";
        version = "1.1.0";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "0b8d0f05832f55571d65ac720f79bf8994138ffbb133209dc4685eae0ad456a8";
        };

        beamDeps = [ ];
      };

      html_entities = buildMix rec {
        name = "html_entities";
        version = "0.5.2";

        src = fetchHex {
          pkg = "html_entities";
          version = "${version}";
          sha256 = "c53ba390403485615623b9531e97696f076ed415e8d8058b1dbaa28181f4fdcc";
        };

        beamDeps = [ ];
      };

      http_signatures = buildMix rec {
        name = "http_signatures";
        version = "0.1.3";

        src = fetchHex {
          pkg = "http_signatures";
          version = "${version}";
          sha256 = "20313a65516db88006f85b090f6f76cc5b04e9609b45943657e6781eb91174f4";
        };

        beamDeps = [ plug ];
      };

      httpoison = buildMix rec {
        name = "httpoison";
        version = "3.0.1";

        src = fetchHex {
          pkg = "httpoison";
          version = "${version}";
          sha256 = "2b937a4a789d822674b88c8667af6262a94b9a62cd2e6c1eaad499947af8154a";
        };

        beamDeps = [ hackney ];
      };

      idna = buildRebar3 rec {
        name = "idna";
        version = "8.0.0";

        src = fetchHex {
          pkg = "idna";
          version = "${version}";
          sha256 = "e0c5ce7846f14515af66142a55b8097d5f46d10df9235e781f168bef5622bcf9";
        };

        beamDeps = [ ];
      };

      inet_cidr = buildMix rec {
        name = "inet_cidr";
        version = "1.0.9";

        src = fetchHex {
          pkg = "inet_cidr";
          version = "${version}";
          sha256 = "172da15ff7cf635b1feaf14f5818be28c811b37cc5fb7c5f7c01058c1c1066cc";
        };

        beamDeps = [ ];
      };

      ip_reserved = buildMix rec {
        name = "ip_reserved";
        version = "0.1.1";

        src = fetchHex {
          pkg = "ip_reserved";
          version = "${version}";
          sha256 = "55fcd2b6e211caef09ea3f54ef37d43030bec486325d12fe865ab5ed8140a4fe";
        };

        beamDeps = [ inet_cidr ];
      };

      jason = buildMix rec {
        name = "jason";
        version = "1.4.5";

        src = fetchHex {
          pkg = "jason";
          version = "${version}";
          sha256 = "b0c823996102bcd0239b3c2444eb00409b72f6a140c1950bc8b457d836b30684";
        };

        beamDeps = [ decimal ];
      };

      jose = buildMix rec {
        name = "jose";
        version = "1.11.13";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          sha256 = "15d8bd0f01ab29d1771e8da1f60f9c98725b23a17f7312cdd40e8e2757bd98c7";
        };

        beamDeps = [ ];
      };

      jumper = buildMix rec {
        name = "jumper";
        version = "1.0.2";

        src = fetchHex {
          pkg = "jumper";
          version = "${version}";
          sha256 = "9b7782409021e01ab3c08270e26f36eb62976a38c1aa64b2eaf6348422f165e1";
        };

        beamDeps = [ ];
      };

      junit_formatter = buildMix rec {
        name = "junit_formatter";
        version = "3.4.0";

        src = fetchHex {
          pkg = "junit_formatter";
          version = "${version}";
          sha256 = "bb36e2ae83f1ced6ab931c4ce51dd3dbef1ef61bb4932412e173b0cfa259dacd";
        };

        beamDeps = [ ];
      };

      linkify = buildMix rec {
        name = "linkify";
        version = "0.5.3";

        src = fetchHex {
          pkg = "linkify";
          version = "${version}";
          sha256 = "3ef35a1377d47c25506e07c1c005ea9d38d700699d92ee92825f024434258177";
        };

        beamDeps = [ ];
      };

      makeup = buildMix rec {
        name = "makeup";
        version = "1.2.3";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          sha256 = "15970751b7021c2bcd7ed56a54b3def23affd3969fb7c214dffdf28e97ce6f76";
        };

        beamDeps = [ nimble_parsec ];
      };

      makeup_elixir = buildMix rec {
        name = "makeup_elixir";
        version = "1.0.1";

        src = fetchHex {
          pkg = "makeup_elixir";
          version = "${version}";
          sha256 = "7284900d412a3e5cfd97fdaed4f5ed389b8f2b4cb49efc0eb3bd10e2febf9507";
        };

        beamDeps = [
          makeup
          nimble_parsec
        ];
      };

      makeup_erlang = buildMix rec {
        name = "makeup_erlang";
        version = "1.1.0";

        src = fetchHex {
          pkg = "makeup_erlang";
          version = "${version}";
          sha256 = "1cd6780fb1dd1a03979abaed0fe82712b0625118fd5257d3ebbf73f960c73c3c";
        };

        beamDeps = [ makeup ];
      };

      meck = buildRebar3 rec {
        name = "meck";
        version = "0.9.2";

        src = fetchHex {
          pkg = "meck";
          version = "${version}";
          sha256 = "81344f561357dc40a8344afa53767c32669153355b626ea9fcbc8da6b3045826";
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
        version = "1.5.0";

        src = fetchHex {
          pkg = "mimerl";
          version = "${version}";
          sha256 = "db648ce065bae14ea84ca8b5dd123f42f49417cef693541110bf6f9e9be9ecc4";
        };

        beamDeps = [ ];
      };

      mimetype_parser = buildMix rec {
        name = "mimetype_parser";
        version = "0.1.3";

        src = fetchHex {
          pkg = "mimetype_parser";
          version = "${version}";
          sha256 = "7d8f80c567807ce78cd93c938e7f4b0a20b1aaaaab914bf286f68457d9f7a852";
        };

        beamDeps = [ ];
      };

      mint = buildMix rec {
        name = "mint";
        version = "1.11.0";

        src = fetchHex {
          pkg = "mint";
          version = "${version}";
          sha256 = "c6279ba2d6aa3a383a1d4cfbe7b59f42e6efd400f58d8e2acfeac48a438693ab";
        };

        beamDeps = [
          castore
          hpax
        ];
      };

      mix_test_watch = buildMix rec {
        name = "mix_test_watch";
        version = "1.4.0";

        src = fetchHex {
          pkg = "mix_test_watch";
          version = "${version}";
          sha256 = "2b4693e17c8ead2ef56d4f48a0329891e8c2d0d73752c0f09272a2b17dc38d1b";
        };

        beamDeps = [ file_system ];
      };

      mmdb2_decoder = buildMix rec {
        name = "mmdb2_decoder";
        version = "3.0.1";

        src = fetchHex {
          pkg = "mmdb2_decoder";
          version = "${version}";
          sha256 = "316af0f388fac824782d944f54efe78e7c9691bbbdb0afd5cccdd0510adf559d";
        };

        beamDeps = [ ];
      };

      mock = buildMix rec {
        name = "mock";
        version = "0.3.9";

        src = fetchHex {
          pkg = "mock";
          version = "${version}";
          sha256 = "9e1b244c4ca2551bb17bb8415eed89e40ee1308e0fbaed0a4fdfe3ec8a4adbd3";
        };

        beamDeps = [ meck ];
      };

      mogrify = buildMix rec {
        name = "mogrify";
        version = "0.9.3";

        src = fetchHex {
          pkg = "mogrify";
          version = "${version}";
          sha256 = "0189b1e1de27455f2b9ae8cf88239cefd23d38de9276eb5add7159aea51731e6";
        };

        beamDeps = [ ];
      };

      mox = buildMix rec {
        name = "mox";
        version = "1.3.2";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "97918a185e727f3128a826f01827b5b8168e1b815bda19eb4192c3ffdb6a8054";
        };

        beamDeps = [ nimble_ownership ];
      };

      nimble_csv = buildMix rec {
        name = "nimble_csv";
        version = "1.3.0";

        src = fetchHex {
          pkg = "nimble_csv";
          version = "${version}";
          sha256 = "41ccdc18f7c8f8bb06e84164fc51635321e80d5a3b450761c4997d620925d619";
        };

        beamDeps = [ ];
      };

      nimble_options = buildMix rec {
        name = "nimble_options";
        version = "1.2.0";

        src = fetchHex {
          pkg = "nimble_options";
          version = "${version}";
          sha256 = "3a784a75ef9e407619c8c9e98239b1acd29216deb737044a8c1063e2671ce6d9";
        };

        beamDeps = [ ];
      };

      nimble_ownership = buildMix rec {
        name = "nimble_ownership";
        version = "1.0.2";

        src = fetchHex {
          pkg = "nimble_ownership";
          version = "${version}";
          sha256 = "098af64e1f6f8609c6672127cfe9e9590a5d3fcdd82bc17a377b8692fd81a879";
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
        version = "1.2.0";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "bc442e72578c21842589fa8e5886b6175fa5245fdbbad35fc08db277ac2b2c0d";
        };

        beamDeps = [ ];
      };

      oauth2 = buildMix rec {
        name = "oauth2";
        version = "2.1.1";

        src = fetchHex {
          pkg = "oauth2";
          version = "${version}";
          sha256 = "1d5997cb1ff1643dac17076b6c00c91e4381d8389f3c49a8c390984606dad439";
        };

        beamDeps = [ tesla ];
      };

      oauther = buildMix rec {
        name = "oauther";
        version = "1.3.0";

        src = fetchHex {
          pkg = "oauther";
          version = "${version}";
          sha256 = "78eb888ea875c72ca27b0864a6f550bc6ee84f2eeca37b093d3d833fbcaec04e";
        };

        beamDeps = [ ];
      };

      oban = buildMix rec {
        name = "oban";
        version = "2.24.2";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "605a3b61d554ab416e0cf462b5ea060f7d19ae3dbf1516ec6b5ee30aeb1a5d0b";
        };

        beamDeps = [
          ecto_sql
          jason
          postgrex
          telemetry
        ];
      };

      oidcc = buildMix rec {
        name = "oidcc";
        version = "3.9.2";

        src = fetchHex {
          pkg = "oidcc";
          version = "${version}";
          sha256 = "e469213a2518904e805ff4f8325a405ac740a74a381e711968d32636c10d9c9b";
        };

        beamDeps = [
          jose
          telemetry
          telemetry_registry
        ];
      };

      paasaa = buildMix rec {
        name = "paasaa";
        version = "1.0.0";

        src = fetchHex {
          pkg = "paasaa";
          version = "${version}";
          sha256 = "709262e8df8fa3b93e502c04d255a63d8729e609d9eb7fc42b9479f3f98e02b7";
        };

        beamDeps = [ ];
      };

      parse_trans = buildRebar3 rec {
        name = "parse_trans";
        version = "3.4.2";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          sha256 = "4c25347de3b7c35732d32e69ab43d1ceee0beae3f3b3ade1b59cbd3dd224d9ca";
        };

        beamDeps = [ ];
      };

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.8.17";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "21fd4d6a33c6af4e86b95156a49815a59140c2ba4ef8cf19565dbb7be881633e";
        };

        beamDeps = [
          bandit
          jason
          phoenix_pubsub
          phoenix_template
          phoenix_view
          plug
          plug_crypto
          telemetry
          websock_adapter
        ];
      };

      phoenix_ecto = buildMix rec {
        name = "phoenix_ecto";
        version = "4.7.0";

        src = fetchHex {
          pkg = "phoenix_ecto";
          version = "${version}";
          sha256 = "1d75011e4254cb4ddf823e81823a9629559a1be93b4321a6a5f11a5306fbf4cc";
        };

        beamDeps = [
          ecto
          phoenix_html
          plug
          postgrex
        ];
      };

      phoenix_html = buildMix rec {
        name = "phoenix_html";
        version = "4.4.0";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "94832038da7ab8f86d4c0d36f7797a269fd06fe611f25c69f55108c075505228";
        };

        beamDeps = [ ];
      };

      phoenix_html_helpers = buildMix rec {
        name = "phoenix_html_helpers";
        version = "1.0.1";

        src = fetchHex {
          pkg = "phoenix_html_helpers";
          version = "${version}";
          sha256 = "cffd2385d1fa4f78b04432df69ab8da63dc5cf63e07b713a4dcf36a3740e3090";
        };

        beamDeps = [
          phoenix_html
          plug
        ];
      };

      phoenix_live_reload = buildMix rec {
        name = "phoenix_live_reload";
        version = "1.7.0";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "dc9f44271aa6fc4ab7797f2aa374ba096ef2c87520586280eb095626b7387a68";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.2.15";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "06de7d327a964c81e93a4d64f67088852bf3512f30c04af563101feaac1deaf1";
        };

        beamDeps = [
          jason
          phoenix
          phoenix_html
          phoenix_template
          phoenix_view
          plug
          telemetry
        ];
      };

      phoenix_pubsub = buildMix rec {
        name = "phoenix_pubsub";
        version = "2.4.1";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "352fba7a87bf61395b6e97da66944ad9b1bfe5459e5981039f60d68270bd9700";
        };

        beamDeps = [ ];
      };

      phoenix_swoosh = buildMix rec {
        name = "phoenix_swoosh";
        version = "1.2.1";

        src = fetchHex {
          pkg = "phoenix_swoosh";
          version = "${version}";
          sha256 = "4000eeba3f9d7d1a6bf56d2bd56733d5cadf41a7f0d8ffe5bb67e7d667e204a2";
        };

        beamDeps = [
          finch
          hackney
          phoenix
          phoenix_html
          phoenix_view
          swoosh
        ];
      };

      phoenix_template = buildMix rec {
        name = "phoenix_template";
        version = "1.1.0";

        src = fetchHex {
          pkg = "phoenix_template";
          version = "${version}";
          sha256 = "eba70070de79b2c3501ef205a74a69f98ab352f3785aa15da9ed161f9fe0fd5d";
        };

        beamDeps = [ phoenix_html ];
      };

      phoenix_view = buildMix rec {
        name = "phoenix_view";
        version = "2.0.4";

        src = fetchHex {
          pkg = "phoenix_view";
          version = "${version}";
          sha256 = "4e992022ce14f31fe57335db27a28154afcc94e9983266835bb3040243eb620b";
        };

        beamDeps = [
          phoenix_html
          phoenix_template
        ];
      };

      plug = buildMix rec {
        name = "plug";
        version = "1.20.4";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "96ee42c0b8b35bcb14e3e65afb85abe9bb7745a8576e8c602802bbb01e5acf72";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
        ];
      };

      plug_crypto = buildMix rec {
        name = "plug_crypto";
        version = "2.2.1";

        src = fetchHex {
          pkg = "plug_crypto";
          version = "${version}";
          sha256 = "4417ccbd8f85e627321cd07d2ab9c4b621f1fd883b9905af241f9b4b780b94b6";
        };

        beamDeps = [ ];
      };

      postgrex = buildMix rec {
        name = "postgrex";
        version = "0.23.0";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          sha256 = "f001ab3fd56f5ef2b8b3cd4a512005614fcaeccca068ddb29e57d338a7f104ec";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      progress_bar = buildMix rec {
        name = "progress_bar";
        version = "3.1.0";

        src = fetchHex {
          pkg = "progress_bar";
          version = "${version}";
          sha256 = "72e8c5f1657b610891de01fb20e8ba7b07a327ca5a10358946f0cd54db5eab34";
        };

        beamDeps = [ ];
      };

      quic = buildRebar3 rec {
        name = "quic";
        version = "3.3.2";

        src = fetchHex {
          pkg = "quic";
          version = "${version}";
          sha256 = "83675bfe6281abb6f0a68d208b8890ebd072e1d1110e80efb0794bfdb53b2fab";
        };

        beamDeps = [ idna ];
      };

      ranch = buildRebar3 rec {
        name = "ranch";
        version = "2.4.0";

        src = fetchHex {
          pkg = "ranch";
          version = "${version}";
          sha256 = "64d98b8c61d39b7b9a2e2cf92ae659b8623a69766f415ae13dc726864ec04ab9";
        };

        beamDeps = [ ];
      };

      remote_ip = buildMix rec {
        name = "remote_ip";
        version = "1.3.0";

        src = fetchHex {
          pkg = "remote_ip";
          version = "${version}";
          sha256 = "6a94bd5a57acc81e64a3f4ee9b787c35a0a03943c5e81a48c20a232f9453c28e";
        };

        beamDeps = [
          combine
          plug
        ];
      };

      replug = buildMix rec {
        name = "replug";
        version = "0.1.0";

        src = fetchHex {
          pkg = "replug";
          version = "${version}";
          sha256 = "f71f7a57e944e854fe4946060c6964098e53958074c69fb844b96e0bd58cfa60";
        };

        beamDeps = [ plug ];
      };

      sentry = buildMix rec {
        name = "sentry";
        version = "13.5.1";

        src = fetchHex {
          pkg = "sentry";
          version = "${version}";
          sha256 = "c8e104a67a72e0353c88a865baa3a163067e13aeb443a45258a43823a5acbf6e";
        };

        beamDeps = [
          finch
          hackney
          jason
          nimble_options
          nimble_ownership
          phoenix
          phoenix_live_view
          plug
          telemetry
        ];
      };

      shortuuid = buildMix rec {
        name = "shortuuid";
        version = "4.3.0";

        src = fetchHex {
          pkg = "shortuuid";
          version = "${version}";
          sha256 = "be660d08094567b3189a3e6128b710c2a7cef105745fc38912b066962107c056";
        };

        beamDeps = [ ];
      };

      sitemapper = buildMix rec {
        name = "sitemapper";
        version = "0.10.0";

        src = fetchHex {
          pkg = "sitemapper";
          version = "${version}";
          sha256 = "89ef80f04e4092cb3a8cbcf37520fa31784cc07104c0b47354539e38d2e62443";
        };

        beamDeps = [ xml_builder ];
      };

      sleeplocks = buildRebar3 rec {
        name = "sleeplocks";
        version = "1.1.4";

        src = fetchHex {
          pkg = "sleeplocks";
          version = "${version}";
          sha256 = "bc12752ab0693ea4e4a3bcf4e063cef408d71197a3c0fad75497fabd475f5481";
        };

        beamDeps = [ ];
      };

      slugger = buildMix rec {
        name = "slugger";
        version = "0.3.0";

        src = fetchHex {
          pkg = "slugger";
          version = "${version}";
          sha256 = "20d0ded0e712605d1eae6c5b4889581c3460d92623a930ddda91e0e609b5afba";
        };

        beamDeps = [ ];
      };

      slugify = buildMix rec {
        name = "slugify";
        version = "1.3.1";

        src = fetchHex {
          pkg = "slugify";
          version = "${version}";
          sha256 = "cb090bbeb056b312da3125e681d98933a360a70d327820e4b7f91645c4d8be76";
        };

        beamDeps = [ ];
      };

      sobelow = buildMix rec {
        name = "sobelow";
        version = "0.19.0";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          sha256 = "8d99af19f261075b790a356c41ac95a3c9bf6b0daf8f31babdb2114cb72275e5";
        };

        beamDeps = [ jason ];
      };

      ssl_verify_fun = buildRebar3 rec {
        name = "ssl_verify_fun";
        version = "1.1.9";

        src = fetchHex {
          pkg = "ssl_verify_fun";
          version = "${version}";
          sha256 = "19f24ad715ef6255d530b2f0db8b2d2191ae435b6527234e943f523e84ed0895";
        };

        beamDeps = [ ];
      };

      struct_access = buildMix rec {
        name = "struct_access";
        version = "1.1.2";

        src = fetchHex {
          pkg = "struct_access";
          version = "${version}";
          sha256 = "e4c411dcc0226081b95709909551fc92b8feb1a3476108348ea7e3f6c12e586a";
        };

        beamDeps = [ ];
      };

      sweet_xml = buildMix rec {
        name = "sweet_xml";
        version = "0.7.5";

        src = fetchHex {
          pkg = "sweet_xml";
          version = "${version}";
          sha256 = "193b28a9b12891cae351d81a0cead165ffe67df1b73fe5866d10629f4faefb12";
        };

        beamDeps = [ ];
      };

      swoosh = buildMix rec {
        name = "swoosh";
        version = "1.30.0";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "d1b553f5264ae39fb299e0da12e01e33aaba49c2509757065ca3aef06e659b0c";
        };

        beamDeps = [
          bandit
          finch
          gen_smtp
          hackney
          idna
          jason
          mime
          plug
          telemetry
        ];
      };

      telemetry = buildRebar3 rec {
        name = "telemetry";
        version = "1.4.3";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "17a63581cf2e832a238287f5fe6811e8ca1f333249f1376ad653164a3c4770d4";
        };

        beamDeps = [ ];
      };

      telemetry_registry = buildMix rec {
        name = "telemetry_registry";
        version = "0.3.2";

        src = fetchHex {
          pkg = "telemetry_registry";
          version = "${version}";
          sha256 = "e7ed191eb1d115a3034af8e1e35e4e63d5348851d556646d46ca3d1b4e16bab9";
        };

        beamDeps = [ telemetry ];
      };

      tesla = buildMix rec {
        name = "tesla";
        version = "1.23.0";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          sha256 = "674fac7a2edfc4e7dbb0c42b18f73780447a3c7fe9fd644156df507f47bad13f";
        };

        beamDeps = [
          castore
          finch
          hackney
          jason
          mime
          mint
          mox
          telemetry
        ];
      };

      thousand_island = buildMix rec {
        name = "thousand_island";
        version = "1.6.0";

        src = fetchHex {
          pkg = "thousand_island";
          version = "${version}";
          sha256 = "4d4720470f091fc21a1311777c2ac66916c43621bffc068590c9f9bb3cd057a3";
        };

        beamDeps = [ telemetry ];
      };

      timex = buildMix rec {
        name = "timex";
        version = "3.7.13";

        src = fetchHex {
          pkg = "timex";
          version = "${version}";
          sha256 = "09588e0522669328e973b8b4fd8741246321b3f0d32735b589f78b136e6d4c54";
        };

        beamDeps = [
          combine
          gettext
          tzdata
        ];
      };

      tls_certificate_check = buildRebar3 rec {
        name = "tls_certificate_check";
        version = "1.36.0";

        src = fetchHex {
          pkg = "tls_certificate_check";
          version = "${version}";
          sha256 = "e58b8626336b9cd483f0fd8346af501de648a07093b077be442f29ef6db28ef1";
        };

        beamDeps = [ ssl_verify_fun ];
      };

      tz_world = buildMix rec {
        name = "tz_world";
        version = "2.3.0";

        src = fetchHex {
          pkg = "tz_world";
          version = "${version}";
          sha256 = "4803fc62f1d2af63d38e14e78cf7ac6d56abb3f85380a47fe188936f6bf65984";
        };

        beamDeps = [
          castore
          certifi
          geo
          telemetry
        ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.2.2";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          sha256 = "4a2435eb3614711b220a9f9f9b56204d14518c6a84e94278cc8b697ca62221a7";
        };

        beamDeps = [ hackney ];
      };

      ueberauth = buildMix rec {
        name = "ueberauth";
        version = "0.10.8";

        src = fetchHex {
          pkg = "ueberauth";
          version = "${version}";
          sha256 = "f2d3172e52821375bccb8460e5fa5cb91cfd60b19b636b6e57e9759b6f8c10c1";
        };

        beamDeps = [ plug ];
      };

      ueberauth_cas = buildMix rec {
        name = "ueberauth_cas";
        version = "2.4.0";

        src = fetchHex {
          pkg = "ueberauth_cas";
          version = "${version}";
          sha256 = "49cff55431b4844cb3ea835903e542afaca70daeb609db3637b3289461260138";
        };

        beamDeps = [
          httpoison
          sweet_xml
          ueberauth
        ];
      };

      ueberauth_discord = buildMix rec {
        name = "ueberauth_discord";
        version = "0.7.0";

        src = fetchHex {
          pkg = "ueberauth_discord";
          version = "${version}";
          sha256 = "d6f98ef91abb4ddceada4b7acba470e0e68c4d2de9735ff2f24172a8e19896b4";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_facebook = buildMix rec {
        name = "ueberauth_facebook";
        version = "0.10.0";

        src = fetchHex {
          pkg = "ueberauth_facebook";
          version = "${version}";
          sha256 = "bf8ce5d66b1c50da8abff77e8086c1b710bdde63f4acaef19a651ba43a9537a8";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_github = buildMix rec {
        name = "ueberauth_github";
        version = "0.8.3";

        src = fetchHex {
          pkg = "ueberauth_github";
          version = "${version}";
          sha256 = "ae0ab2879c32cfa51d7287a48219b262bfdab0b7ec6629f24160564247493cc6";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_gitlab_strategy = buildMix rec {
        name = "ueberauth_gitlab_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_gitlab_strategy";
          version = "${version}";
          sha256 = "e86e2e794bb063c07c05a6b1301b73f2be3ba9308d8f47ecc4d510ef9226091e";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_google = buildMix rec {
        name = "ueberauth_google";
        version = "0.12.1";

        src = fetchHex {
          pkg = "ueberauth_google";
          version = "${version}";
          sha256 = "7f7deacd679b2b66e3bffb68ecc77aa1b5396a0cbac2941815f253128e458c38";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_keycloak_strategy = buildMix rec {
        name = "ueberauth_keycloak_strategy";
        version = "0.4.0";

        src = fetchHex {
          pkg = "ueberauth_keycloak_strategy";
          version = "${version}";
          sha256 = "c03027937bddcbd9ff499e457f9bb05f79018fa321abf79ebcfed2af0007211b";
        };

        beamDeps = [
          oauth2
          ueberauth
        ];
      };

      ueberauth_oidcc = buildMix rec {
        name = "ueberauth_oidcc";
        version = "0.4.2";

        src = fetchHex {
          pkg = "ueberauth_oidcc";
          version = "${version}";
          sha256 = "b9ea3c981464a5052e4f4fbf0a3c716e124da056aca30b9754654c5c6f90f8c2";
        };

        beamDeps = [
          oidcc
          plug
          ueberauth
        ];
      };

      unplug = buildMix rec {
        name = "unplug";
        version = "1.1.0";

        src = fetchHex {
          pkg = "unplug";
          version = "${version}";
          sha256 = "a3b302125ed60b658a9a7c0dff6941050bfc56dc77a0bca72facdb743159898f";
        };

        beamDeps = [ plug ];
      };

      unsafe = buildMix rec {
        name = "unsafe";
        version = "1.0.2";

        src = fetchHex {
          pkg = "unsafe";
          version = "${version}";
          sha256 = "b485231683c3ab01a9cd44cb4a79f152c6f3bb87358439c6f68791b85c2df675";
        };

        beamDeps = [ ];
      };

      vite_phx = buildMix rec {
        name = "vite_phx";
        version = "0.3.2";

        src = fetchHex {
          pkg = "vite_phx";
          version = "${version}";
          sha256 = "43e95d2d80e0cb62c33fc6db4aa6a6135efe1a70395c85a44bdc855da01587ba";
        };

        beamDeps = [
          jason
          phoenix
        ];
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
        version = "0.7.2";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "f9e80710008783864177c81e9d8418d05769ce10a26e9e538f5ed72e283f7358";
        };

        beamDeps = [
          bandit
          plug
          websock
        ];
      };

      webtransport = buildRebar3 rec {
        name = "webtransport";
        version = "0.5.13";

        src = fetchHex {
          pkg = "webtransport";
          version = "${version}";
          sha256 = "97c89ab850110df2edc000c37e880fedc629954e12e2a3beed7ef804b55a165b";
        };

        beamDeps = [
          h2
          quic
        ];
      };

      xml_builder = buildMix rec {
        name = "xml_builder";
        version = "2.4.1";

        src = fetchHex {
          pkg = "xml_builder";
          version = "${version}";
          sha256 = "1b9a1146feb1e6c94e29d8acad0c8e7bf7d6df0ec68eb8c3501e47708da9eb00";
        };

        beamDeps = [ ];
      };
    };
in
self
