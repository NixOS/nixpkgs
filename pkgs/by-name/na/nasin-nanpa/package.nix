{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa";
  version = "4.0.2";

  src = fetchurl {
    url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}.otf";
    hash = "sha256-eWPcFUo0yE2r4cL3kyFBcdHp0RBKUF3kgYqV5B55w0M=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp $src $out/share/fonts/opentype/nasin-nanpa.otf
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ETBCOR/nasin-nanpa";
    description = ''UCSUR OpenType monospaced font for the Toki Pona writing system, Sitelen Pona ("main" version; uses UCSUR and ligatures from latin characters)'';
    longDescription = ''
      ni li nasin pi sitelen pona.
      sitelen ale pi nasin ni li sama mute weka.
      sitelen pi nasin ni li lon nasin UCSUR kin.
    '';
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      somasis
      feathecutie
    ];
  };
}
