{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "tidgi";
  version = "0.8.0";

  src =
    if stdenvNoCC.isAarch64 then
      (fetchurl
        {
          url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-arm64-${version}.zip";
          hash = "sha256-e3ChSHljZSJiPh6KJ66BgAurBID/HiUQ7Gefq6mpU+c=";
        })
    else
      (
        fetchurl
          {
            url = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/download/v${version}/TidGi-darwin-x64-${version}.zip";
            sha256 = "sha256-w3oNaiaThsjX8kBCUEgBMRVb+R57bH7zABM2K3bdUeU=";
          });

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
  '';


  meta = with lib; {
    description = "Customizable personal knowledge-base with git as backup manager and blogging platform.";
    homepage = "https://github.com/tiddly-gittly/TidGi-Desktop";
    changelog = "https://github.com/tiddly-gittly/TidGi-Desktop/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ klchen0112 ];
    platforms = [ "aarch64-darwin" "x64-darwin" ];
  };
}
