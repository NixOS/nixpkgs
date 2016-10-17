{ stdenv
, lib
, fetchurl
, extra-cmake-modules
, makeQtWrapper
, kcmutils
, kconfigwidgets
, kdbusaddons
, kiconthemes
, ki18n
, knotifications
, qca-qt5
, libfakekey
, libXtst
, writeText
}:

let
  busName = "org.kde.kdeconnect";
  serviceName = "kdeconnectd.service";

  dbus = writeText "dbus-${serviceName}" ''
    [D-BUS Service]
    Name=${busName}
    Exec=@out@/lib/libexec/kdeconnectd
    SystemdService=dbus-${busName}.service
  '';

  service = writeText serviceName ''
    [Unit]
    Description=KDE Connect daemon

    [Service]
    Type=dbus
    BusName=${busName}
    ExecStart=@out@/lib/libexec/kdeconnectd
    ExecStop=${kdbusaddons}/bin/kquitapp5 kdeconnectd
    Restart=on-failure
    PrivateTmp=true
    Slice=kde.slice
  '';

in stdenv.mkDerivation rec {
  name = "kdeconnect-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "http://download.kde.org/stable/kdeconnect/${version}/src/kdeconnect-kde-${version}.tar.xz";
    sha256 = "00p1njkp80lhnpjs82b1xgkzb58xwbgycll1z74hzq32icrwqfsm";
  };

  buildInputs = [
    kcmutils
    kconfigwidgets
    kdbusaddons
    qca-qt5
    ki18n
    kiconthemes
    knotifications
    libfakekey
    libXtst
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    makeQtWrapper
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kdeconnect-cli"

    mkdir -p $out/lib/systemd/user $out/share/dbus-1/services
    sed "s|@out@|$out|g" ${service} > $out/lib/systemd/user/${serviceName}
    ln -sr $out/lib/systemd/user/${serviceName} $out/lib/systemd/user/dbus-${busName}.service

    rm -f $out/etc/xdg/autostart/${serviceName}

    sed "s|@out@|$out|g" ${dbus} > $out/share/dbus-1/services/${busName}.service
  '';

  meta = {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ fridh ];
    homepage = https://community.kde.org/KDEConnect;
  };
}
