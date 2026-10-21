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
        version = "1.11.0";

        src = fetchHex {
          pkg = "absinthe";
          version = "${version}";
          sha256 = "39b3b4b6e3eb405fa98b449feef0dacff81d89bf01c2866cfa513616c5530ba6";
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
        version = "2.0.5";

        src = fetchHex {
          pkg = "absinthe_phoenix";
          version = "${version}";
          sha256 = "086c6d4a1c32f7444713130d204c87b1b006169f5159026b73f02f7d38ccd05c";
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
        version = "1.12.0";

        src = fetchHex {
          pkg = "bandit";
          version = "${version}";
          sha256 = "45dac82dc86f45cf4a196dee9cc5a8b791d9c9469d996055f055e6ee36c66e20";
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
        version = "3.6.0";

        src = fetchHex {
          pkg = "cachex";
          version = "${version}";
          sha256 = "ebf24e373883bc8e0c8d894a63bbe102ae13d918f790121f5cfe6e485cc8e2e2";
        };

        beamDeps = [
          eternal
          jumper
          sleeplocks
          unsafe
        ];
      };

      castore = buildMix rec {
        name = "castore";
        version = "1.0.19";

        src = fetchHex {
          pkg = "castore";
          version = "${version}";
          sha256 = "3669e6cab13f54c2df26b3e6833745d647f35b6e30d8ddd5975df0d5c842ca98";
        };

        beamDeps = [ ];
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

      cldr_utils = buildMix rec {
        name = "cldr_utils";
        version = "2.29.7";

        src = fetchHex {
          pkg = "cldr_utils";
          version = "${version}";
          sha256 = "4bddcd597fee34e2d2829ae9ef62bcfef8d97ae5f6b75f0c6ee37a3db31aa73a";
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
        version = "2.10.1";

        src = fetchHex {
          pkg = "db_connection";
          version = "${version}";
          sha256 = "18ed94c6e627b4bf452dbd4df61b69a35a1e768525140bc1917b7a685026a6a3";
        };

        beamDeps = [ telemetry ];
      };

      decimal = buildMix rec {
        name = "decimal";
        version = "2.4.1";

        src = fetchHex {
          pkg = "decimal";
          version = "${version}";
          sha256 = "7e618897933a8455f19a727d7c5e50a2c071a544b700e5e724298ecb4340187f";
        };

        beamDeps = [ ];
      };

      dialyxir = buildMix rec {
        name = "dialyxir";
        version = "1.4.7";

        src = fetchHex {
          pkg = "dialyxir";
          version = "${version}";
          sha256 = "b34527202e6eb8cee198efec110996c25c5898f43a4094df157f8d28f27d9efe";
        };

        beamDeps = [ erlex ];
      };

      digital_token = buildMix rec {
        name = "digital_token";
        version = "2.0.0";

        src = fetchHex {
          pkg = "digital_token";
          version = "${version}";
          sha256 = "cbd2fff52770284a8251540a4b4e529e9738c6fe052d7f3c3428eb5c817385cd";
        };

        beamDeps = [ ];
      };

      doctor = buildMix rec {
        name = "doctor";
        version = "0.22.0";

        src = fetchHex {
          pkg = "doctor";
          version = "${version}";
          sha256 = "96e22cf8c0df2e9777dc55ebaa5798329b9028889c4023fed3305688d902cd5b";
        };

        beamDeps = [ decimal ];
      };

      earmark_parser = buildMix rec {
        name = "earmark_parser";
        version = "1.4.45";

        src = fetchHex {
          pkg = "earmark_parser";
          version = "${version}";
          sha256 = "d3ec045bf122965db20c0bdb420e19ee1415843135327124918473feb4b328e8";
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
        version = "3.13.6";

        src = fetchHex {
          pkg = "ecto";
          version = "${version}";
          sha256 = "8afa059bc16cd2c94739ec0a11e3e5df69d828125119109bef35f20a21a76af2";
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
        version = "0.4.0";

        src = fetchHex {
          pkg = "ecto_shortuuid";
          version = "${version}";
          sha256 = "1edb0e17f689c564039cb780b6a7409076f179ad236ad96413f00c7613db8bb3";
        };

        beamDeps = [
          ecto
          shortuuid
        ];
      };

      ecto_sql = buildMix rec {
        name = "ecto_sql";
        version = "3.13.5";

        src = fetchHex {
          pkg = "ecto_sql";
          version = "${version}";
          sha256 = "aa36751f4e6a2b56ae79efb0e088042e010ff4935fc8684e74c23b1f49e25fdc";
        };

        beamDeps = [
          db_connection
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
        version = "0.10.0";

        src = fetchHex {
          pkg = "elixir_make";
          version = "${version}";
          sha256 = "dc1f09fb7fa68866b886abd5f0f3c83553b1a19a52359a899e92af1bb3b31982";
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
        version = "2.47.4";

        src = fetchHex {
          pkg = "ex_cldr";
          version = "${version}";
          sha256 = "918aabc032955f3eac70abbdf2c5469433132edfaaaccee55451f074ee1ccdba";
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
        version = "2.4.3";

        src = fetchHex {
          pkg = "ex_cldr_calendars";
          version = "${version}";
          sha256 = "b46ef6bd74f7e2dc3de27366f79372b1e630563bcf09b7803fec162e28d4a85e";
        };

        beamDeps = [
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
        version = "2.25.6";

        src = fetchHex {
          pkg = "ex_cldr_dates_times";
          version = "${version}";
          sha256 = "926ff5662b849f86088832ee66b61a96aab0fa5a54d5e14240e08ad3030663e2";
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
        version = "2.38.3";

        src = fetchHex {
          pkg = "ex_cldr_numbers";
          version = "${version}";
          sha256 = "3a0d87ef2747c66d78ae8967023d415d3d76aa310981047ad601e3287e8fe73c";
        };

        beamDeps = [
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
        version = "0.40.3";

        src = fetchHex {
          pkg = "ex_doc";
          version = "${version}";
          sha256 = "2756e357742fecd9749b489b85d67c9ce99c465f2e75728d9e6dc8d704b973de";
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
        version = "2.8.0";

        src = fetchHex {
          pkg = "ex_machina";
          version = "${version}";
          sha256 = "79fe1a9c64c0c1c1fab6c4fa5d871682cb90de5885320c187d117004627a7729";
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

      floki = buildMix rec {
        name = "floki";
        version = "0.38.4";

        src = fetchHex {
          pkg = "floki";
          version = "${version}";
          sha256 = "bdb34645eee8e79845c7edaca2d4099a52804ee4d4a3ecc683a69451f0244973";
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
        version = "0.6.0";

        src = fetchHex {
          pkg = "geolix_adapter_mmdb2";
          version = "${version}";
          sha256 = "06ff962feae8a310cffdf86b74bfcda6e2d0dccb439bb1f62df2b657b1c0269b";
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
        version = "2.4.0";

        src = fetchHex {
          pkg = "guardian";
          version = "${version}";
          sha256 = "5c80103a9c538fbc2505bf08421a82e8f815deba9eaedb6e734c66443154c518";
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

      hackney = buildRebar3 rec {
        name = "hackney";
        version = "1.25.0";

        src = fetchHex {
          pkg = "hackney";
          version = "${version}";
          sha256 = "7209bfd75fd1f42467211ff8f59ea74d6f2a9e81cbcee95a56711ee79fd6b1d4";
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

      hammer = buildMix rec {
        name = "hammer";
        version = "6.2.1";

        src = fetchHex {
          pkg = "hammer";
          version = "${version}";
          sha256 = "b9476d0c13883d2dc0cc72e786bac6ac28911fba7cc2e04b70ce6a6d9c4b2bdc";
        };

        beamDeps = [ poolboy ];
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
        version = "1.0.3";

        src = fetchHex {
          pkg = "hpax";
          version = "${version}";
          sha256 = "8eab6e1cfa8d5918c2ce4ba43588e894af35dbd8e91e6e55c817bca5847df34a";
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
        version = "1.8.2";

        src = fetchHex {
          pkg = "httpoison";
          version = "${version}";
          sha256 = "2bb350d26972e30c96e2ca74a1aaf8293d61d0742ff17f01e0279fef11599921";
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
        version = "1.11.12";

        src = fetchHex {
          pkg = "jose";
          version = "${version}";
          sha256 = "31e92b653e9210b696765cdd885437457de1add2a9011d92f8cf63e4641bab7b";
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
        version = "1.2.1";

        src = fetchHex {
          pkg = "makeup";
          version = "${version}";
          sha256 = "d36484867b0bae0fea568d10131197a4c2e47056a6fbe84922bf6ba71c8d17ce";
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
        version = "1.2.0";

        src = fetchHex {
          pkg = "mox";
          version = "${version}";
          sha256 = "c7b92b3cc69ee24a7eeeaf944cd7be22013c52fcb580c1f33f50845ec821089a";
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
        version = "1.1.0";

        src = fetchHex {
          pkg = "nimble_pool";
          version = "${version}";
          sha256 = "af2e4e6b34197db81f7aad230c1118eac993acc0dae6bc83bac0126d4ae0813a";
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
        version = "2.23.0";

        src = fetchHex {
          pkg = "oban";
          version = "${version}";
          sha256 = "8e5f0cec5abecce78dd08cb14dc5438db90ec3884987b44773ce76fe60dd3f81";
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
        version = "3.7.2";

        src = fetchHex {
          pkg = "oidcc";
          version = "${version}";
          sha256 = "e3f1ed91509fdeb31ec8b9de4ecda0e80cb68b463a9f5b7a9ee1ee40e521e445";
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
        version = "3.4.1";

        src = fetchHex {
          pkg = "parse_trans";
          version = "${version}";
          sha256 = "620a406ce75dada827b82e453c19cf06776be266f5a67cff34e1ef2cbb60e49a";
        };

        beamDeps = [ ];
      };

      phoenix = buildMix rec {
        name = "phoenix";
        version = "1.8.8";

        src = fetchHex {
          pkg = "phoenix";
          version = "${version}";
          sha256 = "f0c843037bd2e7012fc1d1ec9574dfa6972b7e3d09e9b77fd23aa283af0aa994";
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
        version = "4.3.0";

        src = fetchHex {
          pkg = "phoenix_html";
          version = "${version}";
          sha256 = "3eaa290a78bab0f075f791a46a981bbe769d94bc776869f4f3063a14f30497ad";
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
        version = "1.6.2";

        src = fetchHex {
          pkg = "phoenix_live_reload";
          version = "${version}";
          sha256 = "d1f89c18114c50d394721365ffb428cce24f1c13de0467ffa773e2ff4a30d5b9";
        };

        beamDeps = [
          file_system
          phoenix
        ];
      };

      phoenix_live_view = buildMix rec {
        name = "phoenix_live_view";
        version = "1.2.3";

        src = fetchHex {
          pkg = "phoenix_live_view";
          version = "${version}";
          sha256 = "449affd6aea24daaa2f6b43748fc1e2c6a87610df996cc1f54e7b19a7a18e638";
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
        version = "2.2.0";

        src = fetchHex {
          pkg = "phoenix_pubsub";
          version = "${version}";
          sha256 = "adc313a5bf7136039f63cfd9668fde73bba0765e0614cba80c06ac9460ff3e96";
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
          hackney
          phoenix
          phoenix_html
          phoenix_view
          swoosh
        ];
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
        version = "1.20.1";

        src = fetchHex {
          pkg = "plug";
          version = "${version}";
          sha256 = "892d2a1a7a3f5368c5a3b9067bba1050c031495f48c430ec00b09691dbf211b7";
        };

        beamDeps = [
          mime
          plug_crypto
          telemetry
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

      poolboy = buildRebar3 rec {
        name = "poolboy";
        version = "1.5.2";

        src = fetchHex {
          pkg = "poolboy";
          version = "${version}";
          sha256 = "dad79704ce5440f3d5a3681c8590b9dc25d1a561e8f5a9c995281012860901e3";
        };

        beamDeps = [ ];
      };

      postgrex = buildMix rec {
        name = "postgrex";
        version = "0.22.2";

        src = fetchHex {
          pkg = "postgrex";
          version = "${version}";
          sha256 = "8946382ddb06294f56026ac4278b3cc212bac8a2c82ed68b4087819ed1abc53b";
        };

        beamDeps = [
          db_connection
          decimal
          jason
        ];
      };

      progress_bar = buildMix rec {
        name = "progress_bar";
        version = "3.0.0";

        src = fetchHex {
          pkg = "progress_bar";
          version = "${version}";
          sha256 = "6981c2b25ab24aecc91a2dc46623658e1399c21a2ae24db986b90d678530f2b7";
        };

        beamDeps = [ decimal ];
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

      remote_ip = buildMix rec {
        name = "remote_ip";
        version = "1.2.0";

        src = fetchHex {
          pkg = "remote_ip";
          version = "${version}";
          sha256 = "2ff91de19c48149ce19ed230a81d377186e4412552a597d6a5137373e5877cb7";
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
        version = "11.0.4";

        src = fetchHex {
          pkg = "sentry";
          version = "${version}";
          sha256 = "feaafc284dc204c82aadaddc884227aeaa3480decb274d30e184b9d41a700c66";
        };

        beamDeps = [
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
        version = "4.1.0";

        src = fetchHex {
          pkg = "shortuuid";
          version = "${version}";
          sha256 = "7336719118b3cca1ac73e95810199b0b9b7d00f9d71bd2c2d27fed4c4f74388e";
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
        version = "0.14.1";

        src = fetchHex {
          pkg = "sobelow";
          version = "${version}";
          sha256 = "8fac9a2bd90fdc4b15d6fca6e1608efb7f7c600fa75800813b794ee9364c87f2";
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
        version = "1.26.2";

        src = fetchHex {
          pkg = "swoosh";
          version = "${version}";
          sha256 = "08c6a1636b82721d0f64259053a733526526d077011ff6a7776f80e21dc60757";
        };

        beamDeps = [
          bandit
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
        version = "1.4.2";

        src = fetchHex {
          pkg = "telemetry";
          version = "${version}";
          sha256 = "928f6495066506077862c0d1646609eed891a4326bee3126ba54b60af61febb1";
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
        version = "1.20.0";

        src = fetchHex {
          pkg = "tesla";
          version = "${version}";
          sha256 = "3ecb41cb458772332752c3acdfe983e23abb991f5a43cfd69a64e9ea3f4b0061";
        };

        beamDeps = [
          castore
          hackney
          jason
          mime
          mox
          telemetry
        ];
      };

      thousand_island = buildMix rec {
        name = "thousand_island";
        version = "1.5.0";

        src = fetchHex {
          pkg = "thousand_island";
          version = "${version}";
          sha256 = "708923d40523e43cf99041ab37a0d4b0ec426ac6438fa3716ab23d919eaeb412";
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
        version = "1.33.0";

        src = fetchHex {
          pkg = "tls_certificate_check";
          version = "${version}";
          sha256 = "cab9a7439e2dbfe91b38104f2d8a4b6d61dbc4d3a5ad59ac364713a88c6cfd9b";
        };

        beamDeps = [ ssl_verify_fun ];
      };

      tz_world = buildMix rec {
        name = "tz_world";
        version = "1.4.2";

        src = fetchHex {
          pkg = "tz_world";
          version = "${version}";
          sha256 = "ee260d860d475a1a0fa7cd5d76b114007dbbc902144b61d1ca24e6bc23432a4c";
        };

        beamDeps = [
          castore
          certifi
          geo
          jason
        ];
      };

      tzdata = buildMix rec {
        name = "tzdata";
        version = "1.1.4";

        src = fetchHex {
          pkg = "tzdata";
          version = "${version}";
          sha256 = "ab48888699de8ff4a255522fd858abe81bac2e64690a375e6cb590112cf4a24e";
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
        version = "2.3.1";

        src = fetchHex {
          pkg = "ueberauth_cas";
          version = "${version}";
          sha256 = "5068ae2b9e217c2f05aa9a67483a6531e21ba0be9a6f6c8749bb7fd1599be321";
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

      ueberauth_twitter = buildMix rec {
        name = "ueberauth_twitter";
        version = "0.4.1";

        src = fetchHex {
          pkg = "ueberauth_twitter";
          version = "${version}";
          sha256 = "83ca8ea3e1a3f976f1adbebfb323b9ebf53af453fbbf57d0486801a303b16065";
        };

        beamDeps = [
          httpoison
          oauther
          ueberauth
        ];
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
        version = "0.5.9";

        src = fetchHex {
          pkg = "websock_adapter";
          version = "${version}";
          sha256 = "5534d5c9adad3c18a0f58a9371220d75a803bf0b9a3d87e6fe072faaeed76a08";
        };

        beamDeps = [
          bandit
          plug
          websock
        ];
      };

      xml_builder = buildMix rec {
        name = "xml_builder";
        version = "2.4.0";

        src = fetchHex {
          pkg = "xml_builder";
          version = "${version}";
          sha256 = "833e325bb997f032b5a1b740d2fd6feed3c18ca74627f9f5f30513a9ae1a232d";
        };

        beamDeps = [ ];
      };
    };
in
self
