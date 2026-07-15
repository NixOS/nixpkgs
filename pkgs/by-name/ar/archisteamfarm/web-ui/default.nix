{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  archisteamfarm,
}:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "a4d5a9a4fbd09ad2ed00ec09db8344175f120898";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-PP9VT1F8EX5AgNr3OGsirDkUSVAzKHbBpJi6XBlEWeg=";
  };

  npmDepsHash = "sha256-bqwDKSaQt6ptfZC7B332Ig/BAZvJRQ/NaxPgA5VQ884=";

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
