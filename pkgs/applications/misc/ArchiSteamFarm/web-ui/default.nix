{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ArchiSteamFarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "cd42a0272ce9449b38d0654374867a409681a779";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-dQVfgQM1b+UON+UO+sybCbn8OsriJp/tahzInVNwoqw=";
  };

  npmDepsHash = "sha256-x2jBtpP3sVJNIFzlKvUhtqWX7H8OM4bnBcE70NQwCRA=";

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
