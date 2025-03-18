{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "3ae4df4206a3f5fbbe582403403df848fd29847f";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-81PESllqRmtfdYFda1fBRZMczlWQq2xSPWELIOIpi3s=";
  };

  npmDepsHash = "sha256-OIkT5XMWcVRbCemaC+hkHkZACCzNedJKHLvGmNXEye4=";

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
