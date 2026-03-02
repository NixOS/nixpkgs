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
  beamPackages = beam.packages.erlang_27.extend (self: super: { elixir = self.elixir_1_18; });

  common = callPackage ./common.nix { };
in
beamPackages.mixRelease rec {
  inherit (common) pname version src;

  # A typo that is a build failure on elixir 1.18
  patches = [ ./alias.patch ];

  nativeBuildInputs = [
    git
    cmake
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
            hash =
              assert old.version == "2.44.1";
              "sha256-5XLPQYDW9yV0ZkWbyiB2s213GTccFjdqckBmx09n4eE=";
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
            owner = "danhper";
            repo = "elixir-web-push-encryption";
            rev = "6e143dcde0a2854c4f0d72816b7ecab696432779";
            hash = "sha256-Da+/28SPZuUQBi8fQj31zmMvhMrYUaQIW4U4E+mRtMg=";
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
            rev = "b8fc5360b1755f60f2768d40f6aca949ef598a00";
            hash = "sha256-UAdlYTRt1itkR/dmC2/AM89MlJIABJw9N0XfYR6IcVI=";
          };
          beamDeps = with final; [
            mix_test_watch
            ex_doc
            timex
          ];
        };
        rajska = beamPackages.buildMix rec {
          name = "rajska";
          version = "1.3.3";
          src = fetchFromGitHub {
            owner = "tcitworld";
            repo = name;
            rev = "0c036448e261e8be6a512581c592fadf48982d84";
            hash = "sha256-4pfply1vTAIT2Xvm3kONmrCK05xKfXFvcb8EKoSCXBE=";
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
            owner = "tcitworld";
            repo = name;
            rev = "8b5485fde00fafbde20f315bec387a77f7358334";
            hash = "sha256-ttgCWoBKU7VTjZJBhZNtqVF4kN7psBr/qOeR65MbTqw=";
          };
          beamDeps = with final; [
            httpoison
            ex_doc
            credo
            doctor
            dialyxir
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
    updateScript = writeShellScriptBin "update.sh" ''
      set -eou pipefail

      ${lib.getExe mix2nix} '${src}/mix.lock' > pkgs/servers/mobilizon/mix.nix
      ${lib.getExe nixfmt} pkgs/servers/mobilizon/mix.nix
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
      minijackson
      erictapen
    ];
  };
}
