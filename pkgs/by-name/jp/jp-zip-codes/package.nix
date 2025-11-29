{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "jp-zip-code";
  version = "0-unstable-2025-11-01";

  # This package uses a mirror as the source because the
  # original provider uses the same URL for updated content.
  src = fetchFromGitHub {
    owner = "musjj";
    repo = "jp-zip-codes";
    rev = "0a99a3d07b1f129abae2f475daa6890e2aa86cd4";
    hash = "sha256-6sShwbPZxV9/yNhFA7rUGFQBgz7nC27mtBoGVH9+V9c=";
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
