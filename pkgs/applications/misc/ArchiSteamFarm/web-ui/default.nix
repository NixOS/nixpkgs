{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ArchiSteamFarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "6be24065cd4904389d94140f4ed1f6738b1f7fbb";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-DFl+DCNj4JFKZG1awX5rlsHzj+67OFyBj9d16zDiKRA=";
  };

  npmDepsHash = "sha256-jZSiWZDckfGfgrBMHTX/sm7Pcl5ap3lfmwGi8SHXqu8=";

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
