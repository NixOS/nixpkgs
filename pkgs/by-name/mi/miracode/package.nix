{
  stdenvNoCC,
  lib,
  fetchurl,
}:

let
  version = "1.0";
in
stdenvNoCC.mkDerivation {
  pname = "miracode";
  inherit version;

  src = fetchurl {
    url = "https://github.com/IdreesInc/Miracode/releases/download/v${version}/Miracode.ttf";
    hash = "sha256-Q+/D/TPlqOt779qYS/dF7ahEd3Mm4a4G+wdHB+Gutmo=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/fonts/truetype/Miracode.ttf
    runHook postInstall
  '';

  meta = with lib; {
    description = "Sharp, readable, vector-y version of Monocraft";
    homepage = "https://github.com/IdreesInc/Miracode";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ coca ];
  };
}
