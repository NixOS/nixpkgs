{
  lib,
  stdenv,
  fetchurl,
  squashfsTools,
  writeScript,
  alsa-lib,
  atk,
  cairo,
  cups,
  curl,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  glibc,
  gnome-keyring,
  gtk3,
  libappindicator-gtk3,
  libnotify,
  libpulseaudio,
  libsecret,
  libv4l,
  nspr,
  nss,
  pango,
  systemd,
  wrapGAppsHook3,
  xorg,
  at-spi2-atk,
  libuuid,
  at-spi2-core,
  libdrm,
  mesa,
  libxkbcommon,
  libxshmfence,
}:

let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "8.133.0.202";
  revision = "375";

  rpath =
    lib.makeLibraryPath [
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      glib
      glibc
      libsecret
      libuuid

      gdk-pixbuf
      gtk3
      libappindicator-gtk3

      gnome-keyring

      libnotify
      libpulseaudio
      nspr
      nss
      pango
      stdenv.cc.cc
      systemd

      libv4l
      libdrm
      mesa
      libxkbcommon
      libxshmfence
      xorg.libxkbfile
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libXScrnSaver
      xorg.libxcb
    ]
    + ":${lib.getLib stdenv.cc.cc}/lib64";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        name = "skypeforlinux-${version}-${revision}.snap";
        url = "https://api.snapcraft.io/api/v1/snaps/download/QRDEfjn4WJYnm0FzDKwqqRZZI77awQEV_${revision}.snap";
        hash = "sha512-xTkVc/0IWMzVOogWXsphX1YIRWqm7GYgKMeGBxi1lP19eVXjOCghUGIQEd431QkTc2WMdmkWtuYD2toFMtkfWA==";
      }
    else
      throw "Skype for linux is not supported on ${stdenv.hostPlatform.system}";

in
stdenv.mkDerivation {
  pname = "skypeforlinux";
  inherit version revision;

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    wrapGAppsHook3
    glib # For setup hook populating GSETTINGS_SCHEMA_PATH
  ];

  buildInputs = [ squashfsTools ];

  unpackPhase = ''
    runHook preUnpack

    unsquashfs "$src" '/meta/gui/*.desktop' \
        /usr/share/{doc/skypeforlinux,'icons/hicolor/*/apps/skypeforlinux.png',kservices5,pixmaps,skypeforlinux}
    sourceRoot=squashfs-root

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv meta/gui usr/share/applications
    mv usr/share "$out"
    ln -s "$out/share/skypeforlinux/skypeforlinux" "$out/bin"

    runHook postInstall
  '';

  postFixup = ''
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* -or -name \*.node\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/share/skypeforlinux $file || true
    done

    # Fix the desktop link
    substituteInPlace "$out/share/applications/"*.desktop \
      --replace-fail 'Exec=skype ' 'Exec=skypeforlinux ' \
      --replace-fail 'Icon=''${SNAP}/meta/gui/skypeforlinux.png' 'Icon=skypeforlinux'
    substituteInPlace "$out/share/kservices5/ServiceMenus/skypeforlinux.desktop" \
      --replace-fail 'Exec=/usr/bin/skypeforlinux ' 'Exec=skypeforlinux '
  '';

  passthru.updateScript = writeScript "update-skypeforlinux" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p common-updater-scripts curl jq

    set -eu -o pipefail

    data=$(curl -H 'X-Ubuntu-Series: 16' \
      'https://api.snapcraft.io/api/v1/snaps/details/skype?channel=stable&fields=download_sha512,revision,version')

    version=$(jq -r .version <<<"$data")

    if [[ "x$UPDATE_NIX_OLD_VERSION" != "x$version" ]]; then

        revision=$(jq -r .revision <<<"$data")
        hash=$(nix hash to-sri "sha512:$(jq -r .download_sha512 <<<"$data")")

        update-source-version "$UPDATE_NIX_ATTR_PATH" "$version" "$hash"
        update-source-version --ignore-same-hash --version-key=revision "$UPDATE_NIX_ATTR_PATH" "$revision" "$hash"

    fi
  '';

  meta = {
    description = "Linux client for Skype";
    homepage = "https://www.skype.com";
    changelog = "https://support.microsoft.com/en-us/skype/what-s-new-in-skype-for-windows-mac-linux-and-web-d32f674c-abb3-40a5-a0b7-ee269ca60831";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.mjoerg ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "skypeforlinux";
  };
}
