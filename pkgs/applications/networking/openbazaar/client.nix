{ lib, stdenv
, fetchurl
, gcc-unwrapped
, dpkg
, bash
, nodePackages
, makeWrapper
, electron_6
}:

let
  electron = electron_6;
in
stdenv.mkDerivation rec {
  pname = "openbazaar-client";
  version = "2.4.10";

  src = fetchurl {
    url = "https://github.com/OpenBazaar/openbazaar-desktop/releases/download/v${version}/openbazaar2client_${version}_amd64.deb";
    sha256 = "sha256-X0iTTLOJsZeyVZwNU3y39cFMHnxlnYXmqQERE26CLTY=";
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
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --add-flags $out/share/${pname}/resources/app \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ gcc-unwrapped.lib ]}"
  '';

  meta = with lib; {
    description = "Decentralized Peer to Peer Marketplace for Bitcoin - client";
    homepage = "https://www.openbazaar.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
    platforms = [ "x86_64-linux" ];
  };
}
