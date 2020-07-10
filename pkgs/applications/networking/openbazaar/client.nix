{ stdenv
, fetchurl
, gcc-unwrapped
, dpkg
, bash
, nodePackages
, makeWrapper
, electron_6
}:

stdenv.mkDerivation rec {
  pname = "openbazaar-client";
  version = "2.4.6";

  src = fetchurl {
    url = "https://github.com/OpenBazaar/openbazaar-desktop/releases/download/v${version}/openbazaar2client_${version}_amd64.deb";
    sha256 = "1p190az8llqh3089aygwash10wqqqfnjl2wvksn6bvx5wm5dpg1p";
  };

  dontBuild = true;
  dontConfigure = true;

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ${dpkg}/bin/dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{${pname},applications,pixmaps}

    cp -a usr/lib/openbazaar2client/{locales,resources} $out/share/${pname}
    cp -a usr/share/applications/openbazaar2client.desktop $out/share/applications/${pname}.desktop
    cp -a usr/share/pixmaps/openbazaar2client.png $out/share/pixmaps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'openbazaar2client' 'openbazaar-client'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_6}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
  '';

  meta = with stdenv.lib; {
    description = "Decentralized Peer to Peer Marketplace for Bitcoin - client";
    homepage = "https://www.openbazaar.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
