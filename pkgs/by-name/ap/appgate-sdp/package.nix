{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  curl,
  dbus,
  dnsmasq,
  dpkg,
  expat,
  fetchurl,
  gdk-pixbuf,
  glib,
  gtk3,
  icu,
  iproute2,
  krb5,
  lib,
  libdrm,
  libsecret,
  libuuid,
  libxcb,
  libxkbcommon,
  lttng-ust,
  makeWrapper,
  libgbm,
  networkmanager,
  nspr,
  nss,
  openssl,
  pango,
  python3,
  stdenv,
  systemd,
  xdg-utils,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
  libxkbfile,
  zlib,
}:

let
  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    icu
    krb5
    libdrm
    libsecret
    libuuid
    libxcb
    libxkbcommon
    lttng-ust
    libgbm
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc
    systemd
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxkbfile
    libxshmfence
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "appgate-sdp";
  version = "6.4.2";

  src = fetchurl {
    url = "https://bin.appgate-sdp.com/${lib.versions.majorMinor version}/client/appgate-sdp_${version}_amd64.deb";
    sha256 = "sha256-xFpBC6X95C01wUfzJ3a0kMz898k6BItkpJLcUmfd7oY=";
  };

  # just patch interpreter
  autoPatchelfIgnoreMissingDeps = true;
  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    python3
    python3.pkgs.dbus-python
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    cp -r $out/usr/share $out/share

    substituteInPlace $out/lib/systemd/system/appgate-dumb-resolver.service \
        --replace "/opt/" "$out/opt/"

    substituteInPlace $out/lib/systemd/system/appgatedriver.service \
        --replace "/opt/" "$out/opt/" \
        --replace "InaccessiblePaths=/mnt /srv /boot /media" "InaccessiblePaths=-/mnt -/srv -/boot -/media"

    substituteInPlace $out/lib/systemd/system/appgate-resolver.service \
        --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq" \
        --replace "/opt/" "$out/opt/"

    substituteInPlace $out/opt/appgate/linux/nm.py \
        --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"

    substituteInPlace $out/opt/appgate/linux/set_dns \
        --replace "/etc/appgate.conf" "$out/etc/appgate.conf"

    wrapProgram $out/opt/appgate/service/createdump \
        --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ stdenv.cc.cc ]}"

    wrapProgram $out/opt/appgate/appgate-driver \
        --prefix PATH : ${
          lib.makeBinPath [
            iproute2
            networkmanager
            dnsmasq
          ]
        } \
        --set LD_LIBRARY_PATH $out/opt/appgate/service

    # make xdg-open overrideable at runtime
    makeWrapper $out/opt/appgate/Appgate $out/bin/appgate \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --set LD_LIBRARY_PATH $out/opt/appgate:${lib.makeLibraryPath deps}

    wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
  '';

  meta = {
    description = "Appgate SDP (Software Defined Perimeter) desktop client";
    homepage = "https://www.appgate.com/support/software-defined-perimeter-support";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ymatsiuk ];
    mainProgram = "appgate";
  };
}
