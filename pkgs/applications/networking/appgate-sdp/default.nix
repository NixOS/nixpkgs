{ alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, autoPatchelfHook
, cairo
, cups
, curl
, dbus
, dnsmasq
, dpkg
, expat
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, icu
, iproute2
, krb5
, lib
, libdrm
, libsecret
, libuuid
, libxcb
, libxkbcommon
, lttng-ust
, makeWrapper
, mesa
, networkmanager
, nspr
, nss
, openssl
, pango
, procps
, python3
, stdenv
, systemd
, xdg-utils
, xorg
, zlib
}:
with lib;
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
    mesa
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc
    systemd
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
    zlib
  ];
in
stdenv.mkDerivation rec {
  pname = "appgate-sdp";
  version = "5.5.5";

  src = fetchurl {
    url = "https://bin.appgate-sdp.com/${versions.majorMinor version}/client/appgate-sdp_${version}_amd64.deb";
    sha256 = "sha256-eXcGHd3TGNFqjFQ+wSg4+1hF/6DJTPOs0ldjegFktGo=";
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
        --set LD_LIBRARY_PATH "${makeLibraryPath [ stdenv.cc.cc ]}"

    wrapProgram $out/opt/appgate/appgate-driver \
        --prefix PATH : ${makeBinPath [ iproute2 networkmanager dnsmasq ]} \
        --set LD_LIBRARY_PATH $out/opt/appgate/service

    makeWrapper $out/opt/appgate/Appgate $out/bin/appgate \
        --prefix PATH : ${makeBinPath [ xdg-utils ]} \
        --set LD_LIBRARY_PATH $out/opt/appgate:${makeLibraryPath deps}

    wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
  '';

  meta = with lib; {
    description = "Appgate SDP (Software Defined Perimeter) desktop client";
    homepage = "https://www.appgate.com/support/software-defined-perimeter-support";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}
