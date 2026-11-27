{
  lib,
  callPackage,
  writeShellScriptBin,
  beam,
  mix2nix,
  fetchFromGitHub,
  git,
  cmake,
  nixosTests,
  nixfmt,
  mobilizon-frontend ? callPackage ./frontend.nix { },
}:

let
  beamPackages = beam.packages.erlang_27.overrideScope (
    final: _prev: { elixir = final.elixir_1_18; }
  );

  common = callPackage ./common.nix { };
in
beamPackages.mixRelease rec {
  inherit (common)
    pname
    version
    src
    ;

  nativeBuildInputs = [
    git
  ];

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
    overrides = (
      final: prev:
      (lib.mapAttrs (
        _: value:
        value.override {
          appConfigPath = src + "/config";
        }
      ) prev)
      // {
        fast_html = prev.fast_html.override {
          nativeBuildInputs = [ cmake ];
          dontUseCmakeConfigure = true;
        };
        ex_cldr = prev.ex_cldr.overrideAttrs (old: {
          # We have to use the GitHub sources, as it otherwise tries to download
          # the locales at build time.
          src = fetchFromGitHub {
            owner = "elixir-cldr";
            repo = "cldr";
            rev = "v${old.version}";
            hash = lib.throwIfNot (
              old.version == "2.47.5"
            ) "ex_cldr needs hash for ${old.version}" "sha256-nGVuv8jyGCMZS63ga2iObjl+ldIZmM/xDfpQbB/ZRjE=";
          };
          postInstall = ''
            cp $src/priv/cldr/locales/* $out/lib/erlang/lib/ex_cldr-${old.version}/priv/cldr/locales/
          '';
        });

        # The remainder are Git dependencies (and their deps) that are not supported by mix2nix currently.
        web_push_encryption = beamPackages.buildMix {
          name = "web_push_encryption";
          version = "0.3.1";
          src = fetchFromGitHub {
            owner = "mobilizon-tools";
            repo = "elixir-web-push-encryption";
            rev = "f8cb3571af1b9d4e360a5a15039dac2b42abe19d";
            hash = "sha256-KO5zQ4d4DyC/1k8FhoLYBsnw7FUTBYQCw7r4Ge65Z0g=";
          };
          beamDeps = with final; [
            httpoison
            jose
          ];
        };
        icalendar = beamPackages.buildMix rec {
          name = "icalendar";
          version = "1.1.2";
          src = fetchFromGitHub {
            owner = "mobilizon-tools";
            repo = name;
            rev = "b352e47fa28fdefcf6f184ae70f9cb447c8b5eec";
            hash = "sha256-UWEOmig/ALHhm/rYMQomx2osdNmK+mISprc8NrJwDZk=";
          };
          beamDeps = with final; [
            mix_test_watch
            ex_doc
            timex
          ];
        };
        rajska = beamPackages.buildMix rec {
          name = "rajska";
          version = "1.3.5";
          src = fetchFromGitHub {
            owner = "mobilizon-tools";
            repo = name;
            rev = "7fcbb1a2dbe682fc72649b3c31bcfbfb256e92f5";
            hash = "sha256-Fo5fpkJvs3e0m+6TsP9ECSco82eS01Ov+o0A+xkOp8k=";
          };
          beamDeps = with final; [
            ex_doc
            credo
            absinthe
            excoveralls
            hammer
            mock
          ];
        };
        exkismet = beamPackages.buildMix rec {
          name = "exkismet";
          version = "0.0.3";
          src = fetchFromGitHub {
            owner = "mobilizon-tools";
            repo = name;
            rev = "b7e2ed706e834e28b9390a801a08952158e9a3d8";
            hash = "sha256-hD7h7QYrk2JVQCJuC/ca2fvFBNV0qXhKggHTr2UuxpE=";
          };
          beamDeps = with final; [
            httpoison
            ex_doc
            credo
            doctor
            dialyxir
          ];
        };
        ueberauth_twitter = beamPackages.buildMix rec {
          name = "ueberauth_twitter";
          version = "0.4.1";
          src = fetchFromGitHub {
            owner = "mobilizon-tools";
            repo = name;
            rev = "8217b7f0f9f602e64e908453dbfafcf3151a020c";
            hash = "sha256-Ze1D7R5iDzZ+23xG82osOvuPEHmq+euOOkvGthzcIPM=";
          };
          beamDeps = with final; [
            httpoison
            oauther
            ueberauth
          ];
        };

      }
    );
  };

  # Install the compiled js part
  preBuild = ''
    cp -a "${mobilizon-frontend}/static" ./priv
    chmod 770 -R ./priv
  '';

  postBuild = ''
    mix phx.digest --no-deps-check
  '';

  passthru = {
    tests = { inherit (nixosTests) mobilizon; };
    updateScript = writeShellScriptBin "update-mobilizon" ''
      set -euo pipefail

      ${lib.getExe mix2nix} '${src}/mix.lock' > pkgs/by-name/mo/mobilizon/mix.nix
      ${lib.getExe nixfmt} pkgs/by-name/mo/mobilizon/mix.nix
    '';
    elixirPackage = beamPackages.elixir;
    inherit mixNixDeps;
  };

  meta = {
    description = "Mobilizon is an online tool to help manage your events, your profiles and your groups";
    homepage = "https://joinmobilizon.org/";
    changelog = "https://framagit.org/framasoft/mobilizon/-/releases/${src.tag}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      erictapen
    ];
  };
}
