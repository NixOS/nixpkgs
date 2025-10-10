{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa-helvetica";
  version = "4.0.2";

  src = fetchurl {
    url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}-Helvetica.otf";
    hash = "sha256-isteUDpgdHufXYkcbsC7wbT+e4LzArFe42Tw9wfj04E=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp $src $out/share/fonts/opentype/nasin-nanpa-helvetica.otf
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ETBCOR/nasin-nanpa";
    description = ''UCSUR OpenType monospaced font for the Toki Pona writing system, Sitelen Pona ("Discord" version; makes UCSUR visible in vanilla Discord)'';
    longDescription = ''
      ni li nasin pi sitelen pona.
      sitelen ale pi nasin ni li sama mute weka.
      sitelen pi nasin ni li lon nasin UCSUR kin.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ feathecutie ];
  };
}
