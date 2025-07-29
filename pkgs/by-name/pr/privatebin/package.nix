{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "privatebin";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "PrivateBin";
    repo = "PrivateBin";
    tag = finalAttrs.version;
    hash = "sha256-/28uzEDVEn7uy8c6/oCMFjKDJFPyHH50f890cc6fmjg=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R $src/* $out
    runHook postInstall
  '';

  passthru = {
    tests = nixosTests.privatebin;
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/PrivateBin/PrivateBin/releases/tag/${finalAttrs.version}";
    description = "Minimalist, open source online pastebin where the server has zero knowledge of pasted data";
    homepage = "https://privatebin.info";
    license = with lib.licenses; [
      # privatebin
      zlib
      # dependencies, see https://github.com/PrivateBin/PrivateBin/blob/master/LICENSE.md
      gpl2Only
      bsd3
      mit
      asl20
      cc-by-40
    ];
    maintainers = with lib.maintainers; [
      savyajha
      defelo
    ];
  };
})
