{ fetchurl, autoPatchelfHook, dpkg, makeWrapper, wrapGAppsHook, xdg-utils
, stdenv, lib, zlib, glib, alsa-lib, dbus, gtk3, atk, pango, freetype, fontconfig
, gdk-pixbuf, cairo, cups, expat, libgpg-error, nspr
, nss, xorg, libcap, systemd, libnotify, libsecret, libuuid, at-spi2-atk
, at-spi2-core, libdbusmenu, libdrm, mesa, imagemagick, openssl_1_1
}:

stdenv.mkDerivation rec {
  pname = "pulsar";
  version = "1.103.0";

  src = fetchurl {
    url = "https://github.com/pulsar-edit/pulsar/releases/download/v${version}/Linux.pulsar_${version}_amd64.deb";
    sha256 = "sha256-PZF+JaeAqsn/kxgQwyEn4Igm7GUsc+ie2FBXwHOSY5o=";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg makeWrapper wrapGAppsHook ];

  buildInputs = [
    stdenv.cc.cc zlib glib dbus gtk3 atk pango freetype
    fontconfig gdk-pixbuf cairo cups expat libgpg-error alsa-lib nspr nss
    xorg.libXrender xorg.libX11 xorg.libXext xorg.libXdamage xorg.libXtst
    xorg.libXcomposite xorg.libXi xorg.libXfixes xorg.libXrandr
    xorg.libXcursor xorg.libxkbfile xorg.libXScrnSaver xorg.libxshmfence
    libcap systemd libnotify
    xorg.libxcb libsecret libuuid at-spi2-atk at-spi2-core libdbusmenu
    libdrm gtk3 mesa imagemagick openssl_1_1
  ];

  runtimeDependencies =
    [ (lib.getLib systemd) libnotify libdbusmenu xdg-utils ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    # chmod -R g-w "$out"

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/Pulsar/pulsar $out/bin/pulsar \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/share/applications/pulsar.desktop \
      --replace "/opt/Pulsar/pulsar" "pulsar"
  '';

  meta = with lib; {
    description = "A Community-led Hyper-Hackable Text Editor, Forked from Atom, built on Electron";
    homepage = "https://github.com/pulsar-edit/pulsar";
    changelog = "https://github.com/pulsar-edit/pulsar/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ anpin ];
    platforms = [ "x86_64-linux" ];
  };
}
