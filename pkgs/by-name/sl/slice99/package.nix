{
  fetchFromGitHub,
  lib,
  metalang99,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "slice99";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "slice99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QEZ/kM3ie3j1dg18FTXDLv3gOyuH6E5JYXRc4G3T84Y=";
  };

  dontBuild = true;

  propagatedBuildInputs = [ metalang99 ];

  installPhase = ''
    runHook preInstall

    install -Dm644 slice99.h --target-directory="$out"/include

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Memory slices for C99";
    longDescription = ''
      This library provides array slicing facilities for pure C99.
    '';
    homepage = "https://github.com/hirrolot/slice99";
    changelog = "https://github.com/hirrolot/slice99/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
