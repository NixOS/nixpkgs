{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "0xpropo";
  version = "1.100";

  src =
    let
      underscoreVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
    in
    fetchzip {
      url = "https://github.com/0xType/0xPropo/releases/download/${version}/0xPropo_${underscoreVersion}.zip";
      hash = "sha256-ZlZNvn9xiOxS+dfGI1rGbh6XlXo3/puAm2vhKh63sK4=";
    };

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/opentype/ *.otf
    install -Dm644 -t $out/share/fonts/truetype/ *.ttf
    runHook postInstall
  '';

  meta = {
    description = "Proportional version of the 0xProto font";
    homepage = "https://github.com/0xType/0xPropo";
    changelog = "https://github.com/0xType/0xPropo/releases/tag/${version}";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ vinnymeller ];
    platforms = lib.platforms.all;
  };
}
