{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-personal-names";
  version = "0-unstable-2026-10-02";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-personal-names";
    rev = "b557dd4c1548cc7c2164d5f8b14170c40cbb6f81";
    hash = "sha256-/Qwt6WvNR6EVYpMXcmEpdORa39mksllI/6oVDahgAVE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-personal-names.txt.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-personal-names";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
