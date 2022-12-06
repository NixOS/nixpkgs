{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, dpkg
, alsa-lib
, atk
, cairo
, cups
, glib
, nss
, mesa
, systemd
}:

stdenv.mkDerivation rec {
  version = "1.0.40";
  name = "ticktick-${version}";

  src = fetchurl {
    url = "https://appest-public.s3.amazonaws.com/download/linux/linux_deb_x64/ticktick-${version}-amd64.deb";
    sha256 = "sha256-9WltRL7DimSYqM7gaENc7OqVuoir6+pi2KxskgJdB0g=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  buildInputs = [
    alsa-lib
    atk
    cups
    glib
    mesa # for libgbm
    nss
    systemd
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/bin"
    cp -R "opt" "$out"
    cp -R "usr/share" "$out/share"
    chmod -R g-w "$out"

    ln -s $out/opt/TickTick/ticktick $out/bin/ticktick

    # Otherwise it looks "suspicious"
    chmod -R g-w $out
  '';

  postFixup = ''
    substituteInPlace \
      $out/share/applications/ticktick.desktop \
      --replace /opt/ $out/opt/
  '';

  meta = with lib; {
    description = "The official TickTick app";
    homepage = https://ticktick.com/;
    license = licenses.unfree;
    maintainers = with maintainers; [ spebern ];
    platforms = [ "x86_64-linux" ];
  };
}
