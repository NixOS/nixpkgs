{
  fetchFromGitHub,
  lib,
  metalang99,
  nix-update-script,
  runCommandCC,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "interface99";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "interface99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TEyInO0k3efBtufUanGOj/3Sejhf8RMXvjYOxB/MSRk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  propagatedBuildInputs = [ metalang99 ];

  installPhase = ''
    runHook preInstall

    install -Dm644 interface99.h --target-directory="$out"/include

    runHook postInstall
  '';

  passthru = {
    tests.compile =
      runCommandCC "interface99-compile-test"
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
    description = "Full-featured interfaces for C99";
    longDescription = ''
      Full-featured interfaces inspired by Rust and Golang.  Multiple
      inheritance, superinterfaces, and default implementations
      supported.  No external tools required, pure C99.
    '';
    homepage = "https://github.com/hirrolot/interface99";
    changelog = "https://github.com/hirrolot/interface99/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
