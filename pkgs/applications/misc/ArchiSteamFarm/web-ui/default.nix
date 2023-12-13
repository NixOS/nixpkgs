{ lib, fetchFromGitHub, buildNpmPackage, ArchiSteamFarm }:

buildNpmPackage rec {
  pname = "asf-ui";
  version = "c582499d60f0726b6ec7f0fd27bd533c1f67b937";

  src = fetchFromGitHub {
    owner = "JustArchiNET";
    repo = "ASF-ui";
    # updated by the update script
    # this is always the commit that should be used with asf-ui from the latest asf version
    rev = version;
    hash = "sha256-dTSYlswMWWRafieWqNDIi3qCBvNAkcmZWKhQgJiv2Ts=";
  };

  npmDepsHash = "sha256-0zzP1z3VO9Y4gBWJ+T7oHhKE/H2dzMUMg71BKupVcH4=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -rv dist/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "The official web interface for ASF";
    license = licenses.asl20;
    homepage = "https://github.com/JustArchiNET/ASF-ui";
    inherit (ArchiSteamFarm.meta) maintainers platforms;
  };
}
