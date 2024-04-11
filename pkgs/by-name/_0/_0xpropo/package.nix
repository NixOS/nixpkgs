{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "0xpropo";
  version = "1.000";

  src = let
    underscoreVersion = builtins.replaceStrings ["."] ["_"] version;
  in
    fetchzip {
      url = "https://github.com/0xType/0xPropo/releases/download/${version}/0xPropo_${underscoreVersion}.zip";
      hash = "sha256-yIhabwHjBipkcmsSRaokBXCbawQkUNOU8v+fbn2iiY4=";
    };

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Proportional version of the 0xProto font";
    homepage = "https://github.com/0xType/0xPropo";
    changelog = "https://github.com/0xType/0xPropo/releases/tag/${version}";
    license = licenses.ofl;
    maintainers = with maintainers; [vinnymeller];
    platforms = platforms.all;
  };
}
