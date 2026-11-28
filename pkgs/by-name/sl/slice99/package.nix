{
  fetchFromGitHub,
  lib,
  nix-update-script,
  runCommandCC,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "slice99";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "slice99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9mfZaDw1QWkfuyAMZpN6mZDbMDPSAw0TnqwJKYzzwkk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 slice99.h --target-directory="$out"/include

    runHook postInstall
  '';

  passthru = {
    tests.compile =
      runCommandCC "slice99-compile-test"
        {
          strictDeps = true;
          buildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          $CC -std=c99 -o main ${./test.c}
          ./main
          touch "$out"
        '';

    updateScript = nix-update-script { };
  };

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
