{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "78188871dfce90fb04096e9fd0b6ce2411312dae";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-NBxN3pQFiDsRYp2Ro0WwWdGzKVjPTKx4/xWQrMNuv0M=";
  };

  npmDepsHash = "sha256-9pLbSOMfKwkWtzmKNmeKNrgdtzh3riWWJlrbuoDRUrw=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official web interface for ASF";
    license = licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
