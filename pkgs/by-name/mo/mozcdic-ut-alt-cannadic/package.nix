{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-alt-cannadic";
  version = "0-unstable-2023-11-18";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-alt-cannadic";
    rev = "4e548e6356b874c76e8db438bf4d8a0b452f2435";
    hash = "sha256-4gzqVoCIhC0k3mh0qbEr8yYttz9YR0fItkFNlu7cYOY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-alt-cannadic.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Mozc UT Alt-Cannadic Dictionary is a dictionary converted from Alt-Cannadic for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-alt-cannadic";
    license = with lib.licenses;[ asl20 gpl2 ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
