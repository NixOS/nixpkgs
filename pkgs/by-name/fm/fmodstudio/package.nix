{
  stdenv,
  lib,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  libXcomposite,
  nss,
  jq,
  curl,
  glib,
  libglvnd,
  libdrm,
  libxkbcommon,
  fontconfig,
  xorg,
  dbus,
  krb5,
  xcbutilcursor,
  xcbutilkeysyms,
  xcbutilwm,
}:

let
  pname = "fmodstudio";
  version = "2.03.07";
  hash = "sha256-ekYMEzbkfvW23OT1H6zKvSQsgKebKhhvu4kTGsZDfF4=";

  fetchFmodWithLogin =
    {
      pname,
      version,
      hash,
    }:
    stdenv.mkDerivation {
      pname = "${pname}-src";
      inherit version;
      src = null;
      nativeBuildInputs = [
        jq
        curl
      ];

      impureEnvVars = [
        "NIX_FMOD_USERNAME"
        "NIX_FMOD_PASSWORD"
      ];

      outputHashAlgo = "sha256";
      outputHashMode = "flat";
      outputHash = hash;

      builder = builtins.toFile "builder.sh" ''
        set -euo pipefail

        if [ -z "''${NIX_FMOD_USERNAME-}" ] || [ -z "''${NIX_FMOD_PASSWORD-}" ]; then
            echo "Error: Downloading FMOD Studio requires FMOD credentials." >&2
            echo "Please set the following environment variables:" >&2
            echo "  NIX_FMOD_USERNAME - Your FMOD account username/email" >&2
            echo "  NIX_FMOD_PASSWORD - Your FMOD account password" >&2
            echo "" >&2
            echo "You can create an account at https://fmod.com/ if you don't have one." >&2
            echo "" >&2
            echo "When using the Nix daemon, add these to your configuration:" >&2
            echo "  systemd.services.nix-daemon.serviceConfig.Environment = [" >&2
            echo "      \"NIX_FMOD_USERNAME=xxx\"" >&2
            echo "      \"NIX_FMOD_PASSWORD=xxx\"" >&2
            echo "  ];" >&2
            exit 1
          fi

        echo "Logging in to fmod.com..."
        token=$(
          curl --silent -k -X POST https://fmod.com/api-login \
            --user "$NIX_FMOD_USERNAME:$NIX_FMOD_PASSWORD" \
          | jq -r '.token // empty'
        )

        if [ -z "$token" ]; then
          echo "Login failed to fmod.com." >&2
          exit 1
        fi

        echo "Fetching download link..."
        download_url=$(
          curl -k -G "https://fmod.com/api-get-download-link" \
            --data-urlencode path="files/fmodstudio/tool/Linux/" \
            --data-urlencode filename="fmodstudio${
              lib.replaceStrings [ "." ] [ "" ] version
            }linux64-installer.deb" \
            -H "Authorization: FMOD $token" \
          | jq -r '.url // empty'
        )

        if [ -z "$download_url" ]; then
          echo "Failed to get download url." >&2
          exit 1
        fi

        echo "Downloading FMOD Studio..."
        curl -k --fail --location --output "$out" "$download_url"
      '';

      phases = [ "buildPhase" ];
      buildPhase = ''
        bash ${./.}/builder.sh
      '';
    };
in

stdenv.mkDerivation {
  inherit pname version;
  src = fetchFmodWithLogin {
    inherit hash pname version;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    libXcomposite
    nss
    glib
    libglvnd
    libdrm
    libxkbcommon
    fontconfig
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
    xorg.libxshmfence
    xorg.libxkbfile
    dbus
    krb5
    xcbutilcursor
    xcbutilkeysyms
    xcbutilwm
  ];

  unpackPhase = ''
    ar p $src data.tar.xz | tar -xJ
  '';

  installPhase = ''
    mkdir -p $out/opt/fmodstudio
    cp -r opt/fmodstudio/* $out/opt/fmodstudio/
    chmod +x $out/opt/fmodstudio/fmodstudio
    chmod +x $out/opt/fmodstudio/fmodstudiocl
    chmod +x $out/opt/fmodstudio/libexec/QtWebEngineProcess

    mkdir -p $out/bin
    ln -s $out/opt/fmodstudio/fmodstudio $out/bin/fmodstudio
    ln -s $out/opt/fmodstudio/fmodstudiocl $out/bin/fmodstudiocl

    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor

    if [ -e usr/share/applications/fmodstudio.desktop ]; then
      install -Dm644 usr/share/applications/fmodstudio.desktop $out/share/applications/
      # Update paths in desktop file
      substituteInPlace $out/share/applications/fmodstudio.desktop \
        --replace-fail "/opt/fmodstudio" "$out/opt/fmodstudio"
    fi

    cp -r usr/share/icons/hicolor $out/share/icons/
  '';

  meta = {
    description = "Proprietary sound effects engine and authoring tool";
    homepage = "https://fmod.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ eymeric ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
