{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  archisteamfarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "b8704cb1f5f2f57676b745e2e865af3cd6e7ca9a";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-AwZhmYHqrOcsbK2Vj4mB4ayysAS7qHruid1qKx9IBhg=";
  };

  npmDepsHash = "sha256-A+BH8oYInndabovBvD+SCMg/+9gfajwGaWVu9jULuoA=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Official web interface for ASF";
    license = lib.licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (archisteamfarm.meta) maintainers platforms;
  };
}
