{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nasin-nanpa-ucsur";
  version = "4.0.2";

  src = fetchurl {
    url = "https://github.com/ETBCOR/nasin-nanpa/releases/download/n${version}/nasin-nanpa-${version}-UCSUR.otf";
    hash = "sha256-9DkY7wbB22IFsIAAgyg8gYALpkfROKzzc5AhpYKt6oI=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cp $src $out/share/fonts/opentype/nasin-nanpa-ucsur.otf
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/ETBCOR/nasin-nanpa";
    description = ''UCSUR OpenType monospaced font for the Toki Pona writing system, Sitelen Pona ("UCSUR only" version; doesn't have latin ligatures)'';
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
