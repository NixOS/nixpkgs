{ stdenv, lib, fetchFromGitHub, makeWrapper, wofi, networkmanager, bc, wirelesstools }:

stdenv.mkDerivation rec {
  pname = "wofi-wifi-menu";
  version = "0.18";

  src = fetchFromGitHub {
    owner = "fourstepper";
    repo = pname;
    rev = "cb8da9cfd7e10d48ec831410c55104a4857251d3";
    sha256 = "jp6PKqRrUy9ACwbvLNs3Y7x1P5Ok6rwu8QETsSBGqJE=";
  };

  buildInputs = [
    bc
    networkmanager
    wirelesstools
    wofi
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv wofi-wifi-menu.sh $out/bin/wofi-wifi-menu
    wrapProgram $out/bin/wofi-wifi-menu \
      --prefix PATH : ${lib.makeBinPath buildInputs}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fork of rofi-wifi-menu for wofi";
    homepage = "https://github.com/fourstepper/wofi-wifi-menu";
    maintainers = [ maintainers.calwe ];
    license = licenses.unfree;
    platforms = platforms.all;
  };
}
