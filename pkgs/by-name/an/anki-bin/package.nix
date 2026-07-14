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
  version = "26.05";

  sources = {
    linux-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-aarch64.tar.zst";
      hash = "sha256-z/w7+TKLW+xi/iJMXGOp50Yjwnv7FD5O0lNsu31dfqo=";
    };
    linux-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-linux-x86_64.tar.zst";
      hash = "sha256-YiPXBVY/catAzgcqXZajkZxUbV3eHkxJ3CeXXnAGcnQ=";
    };

    # For some reason anki distributes completely separate dmg-files for the aarch64 version and the x86_64 version
    darwin-x86_64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-intel.dmg";
      hash = "sha256-L/TXKh0cmTop7/ROA9YC4dyBz9iAFRhpXuNRbR3wwYk=";
    };
    darwin-aarch64 = fetchurl {
      url = "https://github.com/ankitects/anki/releases/download/${version}/anki-${version}-mac-apple.dmg";
      hash = "sha256-c5NZf0uWNB7XQDYBDtgrtCU+A5Cuck0rJ1xFG8hY0Sc=";
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
      "x86_64-darwin"
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
