{
  pname,
  version,
  src,
  passthru,
  meta,

  lib,
  stdenv,
  dpkg,
  makeWrapper,
  asar,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
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
  gtk3,
  libGL,
  libappindicator-gtk3,
  libdrm,
  libnotify,
  libpulseaudio,
  libuuid,
  libxcb,
  libxkbcommon,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  systemd,
  wayland,
  xdg-utils,
  xorg,
}:
stdenv.mkDerivation rec {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  rpath =
    lib.makeLibraryPath [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libGL
      libappindicator-gtk3
      libdrm
      libnotify
      libpulseaudio
      libuuid
      libxcb
      libxkbcommon
      libgbm
      nspr
      nss
      pango
      pipewire
      stdenv.cc.cc
      systemd
      wayland
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxkbfile
      xorg.libxshmfence
    ]
    + ":${lib.getLib stdenv.cc.cc}/lib64";

  buildInputs = [
    gtk3 # needed for GSETTINGS_SCHEMAS_PATH
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
    asar
  ];

  dontUnpack = true;
  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract
    rm -rf usr/share/lintian

    mkdir -p $out
    mv usr/* $out

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/slack $file || true
    done

    # Replace the broken bin/slack symlink with a startup wrapper.
    # Make xdg-open overrideable at runtime.
    rm $out/bin/slack
    makeWrapper $out/lib/slack/slack $out/bin/slack \
      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}"

    # Fix the desktop link
    substituteInPlace $out/share/applications/slack.desktop \
      --replace /usr/bin/ $out/bin/ \
      --replace /usr/share/pixmaps/slack.png slack \
      --replace bin/slack "bin/slack -s"

    # Prevent Un-blacklist pipewire integration to enable screen sharing on wayland.
    # https://github.com/flathub/com.slack.Slack/issues/101#issuecomment-1807073763
    sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

    runHook postInstall
  '';
}
