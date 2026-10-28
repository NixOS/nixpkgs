{
  beam,
  lib,
  fetchFromGitHub,
  fetchFromForgejo,
  fetchHex,
  file,
  cmake,
  nixosTests,
  writeText,
  vips,
  pkg-config,
  glib,
  fetchpatch,
}:

let
  beamPackages = beam.packages.erlang_27.overrideScope (final: prev: { elixir = final.elixir_1_18; });
in
beamPackages.mixRelease rec {
  pname = "pleroma";
  version = "2.11.0";

  src = fetchFromForgejo {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = "pleroma";
    rev = "v${version}";
    hash = "sha256-yQcvmoqKepL5l1YbWsgTBN0XGKSBLF4Rz9n+SJTcfo0=";
  };

  patches = [ ./Revert-Config-Restrict-permissions-of-OTP-config.patch ];

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = final: prev: {
      # mix2nix does not support git dependencies yet,
      # so we need to add them manually
      prometheus_ex = beamPackages.buildMix {
        name = "prometheus_ex";
        version = "3.0.5";

        src = fetchFromGitHub {
          owner = "lanodan";
          repo = "prometheus.ex";
          rev = "31f7fbe4b71b79ba27efc2a5085746c4011ceb8f";
          hash = "sha256-2PZP+YnwnHt69HtIAQvjMBqBbfdbkRSoMzb1AL2Zsyc=";
        };
        beamDeps = with final; [ prometheus ];
      };

      syslog = beamPackages.buildRebar3 {
        name = "syslog";
        # the pleroma lockfile points to this git rev.
        # erlang-syslog did not get a release since 2021. A bunch of
        # fixes appeared since on main :/
        version = "unstable-614a1fde7a8654bee2815b599bbdaae1bb0323b5";
        src = fetchFromGitHub {
          owner = "Vagabond";
          repo = "erlang-syslog";
          rev = "614a1fde7a8654bee2815b599bbdaae1bb0323b5";
          hash = "sha256-Zs4gBs1bm2Grs+TRjtR89tPA0NmRN48yAtl1v4vU4KA=";
        };
        buildPlugins = with beamPackages; [ pc ];
      };
      majic = prev.majic.override { buildInputs = [ file ]; };
      # Some additional build inputs and build fixes
      http_signatures = prev.http_signatures.override {
        patchPhase = ''
          substituteInPlace mix.exs --replace ":logger" ":logger, :public_key"
        '';
      };
      fast_html = prev.fast_html.override {
        nativeBuildInputs = [ cmake ];
        dontUseCmakeConfigure = true;
      };

      phoenix_live_view = prev.phoenix_live_view.override {
        # This listener breaks with elixir 1.18.
        # It's only using for dev, let's remove it.
        postPatch = ''
          sed -i '/listeners: \[Phoenix.CodeReloader\]/d' mix.exs
        '';
      };

      oban_web = prev.oban_web.override {
        # This listener breaks with elixir 1.18.
        # It's only using for dev, let's remove it.
        postPatch = ''
          sed -i '/listeners: \[Phoenix.CodeReloader\]/d' mix.exs
        '';
      };

      vix = prev.vix.override {
        nativeBuildInputs = [ pkg-config ];
        buildInputs = [
          vips
          glib.dev
        ];
        env.VIX_COMPILATION_MODE = "PLATFORM_PROVIDED_LIBVIPS";
      };

      # This needs a different version (1.0.14 -> 1.0.18) to build properly with
      # our Erlang/OTP version.
      eimp = beamPackages.buildRebar3 rec {
        name = "eimp";
        version = "1.0.18";

        src = beamPackages.fetchHex {
          pkg = name;
          inherit version;
          sha256 = "0fnx2pm1n2m0zs2skivv43s42hrgpq9i143p9mngw9f3swjqpxvx";
        };

        patchPhase = ''
          echo '{plugins, [pc]}.' >> rebar.config
        '';
        buildPlugins = with beamPackages; [ pc ];

        beamDeps = with final; [ p1_utils ];
      };
      # Required by eimp
      p1_utils = beamPackages.buildRebar3 rec {
        name = "p1_utils";
        version = "1.0.18";

        src = fetchHex {
          pkg = "${name}";
          inherit version;
          sha256 = "120znzz0yw1994nk6v28zql9plgapqpv51n9g6qm6md1f4x7gj0z";
        };

        beamDeps = [ ];
      };

      mime = prev.mime.override {
        patchPhase =
          let
            cfgFile = writeText "config.exs" ''
              use Mix.Config
              config :mime, :types, %{
                "application/activity+json" => ["activity+json"],
                "application/jrd+json" => ["jrd+json"],
                "application/ld+json" => ["activity+json"],
                "application/xml" => ["xml"],
                "application/xrd+xml" => ["xrd+xml"]
              }
            '';
          in
          ''
            mkdir config
            cp ${cfgFile} config/config.exs
          '';
      };

      # mochiweb is unused by still in mix.lock
      # work around OTP 27+ incompat by forcing our build to use a newer version
      mochiweb = prev.mochiweb.override rec {
        version = "3.3.0";

        src = fetchHex {
          pkg = "mochiweb";
          version = "${version}";
          sha256 = "sha256-qoW3d/sj6ZcuvEJOQLXTUQbxm8mYhz4Cbe3Ydt+O5Qw=";
        };
      };
    };
  };

  passthru = {
    tests.pleroma = nixosTests.pleroma;
    inherit mixNixDeps;
  };

  meta = {
    description = "ActivityPub microblogging server";
    homepage = "https://git.pleroma.social/pleroma/pleroma";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      picnoir
      kloenk
    ];
    platforms = lib.platforms.unix;
  };
}
