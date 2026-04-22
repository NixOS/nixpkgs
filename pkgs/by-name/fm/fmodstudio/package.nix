{
  stdenv,
  lib,
  autoPatchelfHook,
  makeWrapper,
  requireFile,
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
  dpkg,
  fetchMethod ? "requireFile", # "requireFile" or "download"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fmodstudio";
  version = "2.03.08";
  hash = "sha256-FSz4y+MevllXKyNeyoABLtcLzyePSTBNWOLB53TFyzg=";

  src =
    if fetchMethod == "download" then
      stdenv.mkDerivation {
        pname = "${finalAttrs.pname}-src";
        version = finalAttrs.version;

        dontUnpack = true;

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
        outputHash = finalAttrs.hash;

        buildPhase = ''
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
                lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
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
      }
    else
      requireFile rec {
        name = "fmodstudio${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}linux64-installer.deb";
        url = "https://fmod.com/";
        hash = finalAttrs.hash;
        message = ''
          FMOD Studio is available from ${url} and requires a free account.

          Please:
          1. Create an account at https://fmod.com/ if you don't have one
          2. Log in and navigate to the download page
          3. Download the Linux installer (.deb): ${name}
          4. Add it to the nix store using either:
             nix-store --add-fixed sha256 ${name}
             or
             nix-prefetch-url --type sha256 file:///path/to/${name}

          Alternatively, you can use automatic download by overriding with:
          fmodstudio.override { fetchMethod = "download"; }
          (requires setting NIX_FMOD_USERNAME and NIX_FMOD_PASSWORD environment variables)
        '';
      };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
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

  unpackCmd = "dpkg-deb -x $src .";
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fmodstudio
    cp -r opt/fmodstudio/* $out/share/fmodstudio/
    chmod +x $out/share/fmodstudio/fmodstudio
    chmod +x $out/share/fmodstudio/fmodstudiocl
    chmod +x $out/share/fmodstudio/libexec/QtWebEngineProcess

    mkdir -p $out/bin
    ln -s $out/share/fmodstudio/fmodstudio $out/bin/fmodstudio
    ln -s $out/share/fmodstudio/fmodstudiocl $out/bin/fmodstudiocl

    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor

    if [ -e usr/share/applications/fmodstudio.desktop ]; then
      install -Dm644 usr/share/applications/fmodstudio.desktop $out/share/applications/
      # Update paths in desktop file
      substituteInPlace $out/share/applications/fmodstudio.desktop \
        --replace-fail "/opt/fmodstudio" "$out/share/fmodstudio"
    fi

    cp -r usr/share/icons/hicolor $out/share/icons/
    runHook postInstall
  '';

  meta = {
    description = "Proprietary sound effects engine and authoring tool";
    homepage = "https://fmod.com";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ eymeric ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
