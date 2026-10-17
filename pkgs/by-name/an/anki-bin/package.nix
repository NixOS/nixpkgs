{
  fetchurl,
  stdenv,
  lib,
  buildFHSEnv,
  appimageTools,
  writeShellScript,
  anki,
  undmg,
  zstd,
  cacert,
  commandLineArgs ? [ ],
}:

let
  pname = "anki-bin";
  # Update hashes for both Linux and Darwin!
  version = "26.09.3";

  sources = {
    linux-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-aarch64.tar.zst";
      hash = "sha256-C1hu/bDjWCvuO50IufpX32gfuXqAZtdqZ0PhvD/DMes=";
    };
    linux-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-x86_64.tar.zst";
      hash = "sha256-1w4Blxp6oZCxiZJ1c+5kPyUl/4QOr67Meo+M3lBWULM=";
    };

    # For some reason anki distributes completely separate dmg-files for the aarch64 version and the x86_64 version
    darwin-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-intel.dmg";
      hash = "sha256-exI+/sqxOV0D/fTl303xbvxyyWKcOLUO+MrWktMQvXc=";
    };
    darwin-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-apple.dmg";
      hash = "sha256-s2/o9sAVpgL+rz7zj1lnwnyJZO4wpcdMolMiJc9gI0U=";
    };
  };

  unpacked = stdenv.mkDerivation {
    inherit pname version;

    nativeBuildInputs = [ zstd ];
    src = if stdenv.hostPlatform.isAarch64 then sources.linux-aarch64 else sources.linux-x86_64;

    installPhase = ''
      runHook preInstall

      xdg-mime () {
        echo Stubbed!
      }
      export -f xdg-mime

      PREFIX=$out bash install.sh

      runHook postInstall
    '';
  };

  meta = {
    inherit (anki.meta)
      license
      homepage
      description
      mainProgram
      longDescription
      ;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      mahmoudk1000
      cything
    ];
  };

  passthru = {
    inherit sources;
  };

  fhsEnvAnki = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs
    // {
      inherit pname version;

      profile = ''
        # anki vendors QT and mixing QT versions usually causes crashes
        unset QT_PLUGIN_PATH
        # anki uses the system ssl cert, without it plugins do not download/update
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
      '';

      # Dependencies of anki
      targetPkgs =
        pkgs:
        (with pkgs; [
          libxkbfile
          libxshmfence
          libxcb-cursor
          krb5
          zstd
        ]);

      runScript = writeShellScript "anki-wrapper.sh" ''
        exec ${unpacked}/bin/anki ${lib.strings.escapeShellArgs commandLineArgs} "$@"
      '';

      extraInstallCommands = ''
        ln -s ${pname} $out/bin/anki

        mkdir -p $out/share
        cp -R ${unpacked}/share/applications \
          ${unpacked}/share/man \
          ${unpacked}/share/pixmaps \
          $out/share/
      '';

      inherit meta passthru;
    }
  );
in

if stdenv.hostPlatform.isLinux then
  fhsEnvAnki
else
  stdenv.mkDerivation {
    inherit pname version passthru;

    src = if stdenv.hostPlatform.isAarch64 then sources.darwin-aarch64 else sources.darwin-x86_64;

    nativeBuildInputs = [ undmg ];
    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications/
      cp -a Anki.app $out/Applications/
    '';

    inherit meta;
  }
