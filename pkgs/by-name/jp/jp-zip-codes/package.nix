{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "jp-zip-code";
  version = "0-unstable-2025-09-01";

  # This package uses a mirror as the source because the
  # original provider uses the same URL for updated content.
  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "87a760cee8a6b103d834197caca72c3392ccbcde";
    hash = "sha256-7vOcScEk4fKIeUa+FGCnBczlAwUC00E7EKQq7wQ2bUI=";
  };

  installPhase = ''
    runHook preInstall
    install -Dt $out ken_all.zip
    install -Dt $out jigyosyo.zip
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Zip files containing japanese zip codes";
    longDescription = "Zip files with japanese zip codes for japanese IME dictionaries";
    homepage = "https://github.com/musjj/jp-zip-codes";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
