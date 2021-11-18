{ stdenv, fetchurl, lib
, autoPatchelfHook, dpkg
, libX11, libXext, libXi, libXau, libXrender, libXft, libXmu, libSM, libXcomposite, libXfixes, libXpm
, libXinerama, libXdamage, libICE, libXtst, libXaw, fontconfig, pango, cairo, glib, libxml2, atk, gtk3
, gdk-pixbuf, nss, nspr, libXScrnSaver, alsa-lib, udev, libdrm, libGL, mesa
}:

stdenv.mkDerivation rec {
  pname = "hyperspace";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/hyperspacedev/${pname}/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "TCkMe4uxgWWSzemJfsbxKYHB2vUavhI1248t5CcsD+8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  unpackPhase = ''
    dpkg-deb -vx $src .
  '';

  installPhase = ''
    mkdir -p $out

    mv ./usr/* $out/

    mv ./opt/Hyperspace\ Desktop $out/share/hyperspace

    mkdir -p $out/bin
    ln -s $out/share/hyperspace/hyperspace $out/bin/hyperspace

    rm -vrf $out/share/hyperspace/{libGLESv2.so,libEGL.so,swiftshader}

    substituteInPlace $out/share/applications/hyperspace.desktop \
     --replace 'Exec="/opt/Hyperspace Desktop/hyperspace"' \
               'Exec="$out/bin/hyperspace"'
  '';

  buildInputs = [
    stdenv.cc.cc libX11 libXext libXi libXau libXrender libXft libXmu libSM libXcomposite libXfixes libXpm
    libXinerama libXdamage libICE libXtst libXaw fontconfig pango cairo glib libxml2 atk gtk3
    gdk-pixbuf nss nspr libXScrnSaver alsa-lib libdrm mesa
  ];

  runtimeDependencies = [ libGL udev ];

  dontBuild = true;
  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "A beautiful, fluffy client for the fediverse";
    homepage = "https://hyperspace.marquiskurt.net";
    license = licenses.npl4;
    maintainers = with maintainers; [ dtzWill ];
  };
}
