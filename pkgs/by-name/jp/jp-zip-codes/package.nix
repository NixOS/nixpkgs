{ lib
, fetchFromGitHub
, stdenvNoCC
, nix-update-script
}:

stdenvNoCC.mkDerivation {
  pname = "jp-zip-code";
  version = "0-unstable-2024-05-01";

  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "7d4142d8081e2114c4b59c3875ce00308268b595";
    hash = "sha256-aYovn44FXgBzGxiRZ/nigMCFyFAHkJawtbVIKMCnXpY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dt $out ken_all.zip
    install -Dt $out jigyosyo.zip
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version" "branch" ]; };

  meta = {
    description = "Zip files containing japanese zip codes";
    longDescription = "Zip files with japanese zip codes for japanese IME dictionaries";
    homepage = "https://github.com/musjj/jp-zip-codes";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
