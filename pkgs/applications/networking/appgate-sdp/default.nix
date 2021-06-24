{ alsaLib
, at-spi2-atk
, at-spi2-core
, atk
, bash
, cairo
, coreutils
, cups
, curl
, dbus
, dnsmasq
, dpkg
, e2fsprogs
, expat
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, icu
, iproute2
, krb5
, lib
, mesa
, libdrm
, libX11
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libsecret
, libuuid
, libxcb
, lttng-ust
, makeWrapper
, networkmanager
, nspr
, nss
, openssl
, pango
, procps
, python37
, python37Packages
, stdenv
, systemd
, xdg-utils
, zlib
}:
with lib;
let
  deps = [
    alsaLib
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
    mesa
    libdrm
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libsecret
    libuuid
    libxcb
    lttng-ust
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc
    systemd
    zlib
  ];
  rpath = lib.makeLibraryPath deps;
in
stdenv.mkDerivation rec {
  pname = "appgate-sdp";
  version = "5.3.3";

  src = fetchurl {
    url = "https://bin.appgate-sdp.com/${lib.versions.majorMinor version}/client/appgate-sdp_${version}_amd64.deb";
    sha256 = "1854m93mr2crg68zhh1pgwwis0dqdv0778wqrb8dz9sdz940rza8";
  };

  dontConfigure = true;
  dontBuild = true;
  enableParallelBuilding = true;

  buildInputs = [
    python37
    python37Packages.dbus-python
  ];

  nativeBuildInputs = [
    makeWrapper
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s "$out/opt/appgate/appgate" "$out/bin/appgate"
    cp -r $out/usr/share $out/share

    for file in $out/opt/appgate/linux/appgate-resolver.pre \
                $out/opt/appgate/linux/appgate-dumb-resolver.pre
    do
      substituteInPlace $file \
        --replace "/bin/sh" "${bash}/bin/sh" \
        --replace "cat" "${coreutils}/bin/cat" \
        --replace "chattr" "${e2fsprogs}/bin/chattr" \
        --replace "mv " "${coreutils}/bin/mv " \
        --replace "pkill" "${procps}/bin/pkill"
    done

    for file in $out/lib/systemd/system/appgatedriver.service \
                $out/lib/systemd/system/appgate-dumb-resolver.service \
                $out/lib/systemd/system/appgate-resolver.service
    do
      substituteInPlace $file \
        --replace "/bin/sh" "${bash}/bin/sh" \
        --replace "/opt/" "$out/opt/" \
        --replace "chattr" "${e2fsprogs}/bin/chattr" \
        --replace "mv " "${coreutils}/bin/mv "
    done

    substituteInPlace $out/lib/systemd/system/appgatedriver.service \
        --replace "InaccessiblePaths=/mnt /srv /boot /media" "InaccessiblePaths=-/mnt -/srv -/boot -/media"

    substituteInPlace $out/lib/systemd/system/appgate-resolver.service \
        --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"

    substituteInPlace $out/opt/appgate/linux/nm.py --replace "/usr/sbin/dnsmasq" "${dnsmasq}/bin/dnsmasq"
    substituteInPlace $out/opt/appgate/linux/set_dns --replace "/etc/appgate.conf" "$out/etc/appgate.conf"

  '';

  postFixup = ''
    find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} \;
    for binary in $out/opt/appgate/appgate-driver \
                  $out/opt/appgate/appgate \
                  $out/opt/appgate/service/createdump \
                  $out/opt/appgate/service/appgateservice.bin
    do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "$ORIGIN:$out/opt/appgate/service/:$out/opt/appgate/:${rpath}" $binary
    done

    wrapProgram $out/opt/appgate/appgate-driver --prefix PATH : ${lib.makeBinPath [ iproute2 networkmanager dnsmasq ]}
    wrapProgram $out/opt/appgate/linux/set_dns --set PYTHONPATH $PYTHONPATH
    wrapProgram $out/bin/appgate --prefix PATH : ${xdg-utils}/bin
  '';
  meta = with lib; {
    description = "Appgate SDP (Software Defined Perimeter) desktop client";
    homepage = "https://www.appgate.com/support/software-defined-perimeter-support";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ymatsiuk ];
  };
}
