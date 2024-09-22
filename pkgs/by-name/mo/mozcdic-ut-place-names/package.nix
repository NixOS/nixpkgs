{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-place-names";
  version = "0-unstable-2024-08-06";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-place-names";
    rev = "e606f2336b79bf0fa7fad3a0eb6a1a9baebafcb9";
    hash = "sha256-IKn5ge8OiAidAmqr5+F7f4b1nUPa0ZT0n+5PfvkJKAs=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-place-names.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT Place Name Dictionary is a dictionary converted from the Japan Post's ZIP code data for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-place-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
