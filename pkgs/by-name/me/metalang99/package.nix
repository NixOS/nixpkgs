{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "metalang99";
  version = "1.13.5";

  src = fetchFromGitHub {
    owner = "hirrolot";
    repo = "metalang99";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GzIpWiBFPAxAE6tt9c3NfefzK/gJnFJnOrMpQCL6f/s=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --recursive include $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-blown preprocessor metaprogramming";
    longDescription = ''
      Metalang99 is a firm foundation for writing reliable and
      maintainable metaprograms in pure C99.  It is implemented as an
      interpreted FP language atop of preprocessor macros: just
      `#include <metalang99.h>` and you are ready to go.  Metalang99
      features algebraic data types, pattern matching, recursion,
      currying, and collections; in addition, it provides means for
      compile-time error reporting and debugging.  With our built-in
      syntax checker, macro errors should be perfectly comprehensible,
      enabling you for convenient development.

      Currently, Metalang99 is used at OpenIPC as an indirect
      dependency of Datatype99 and Interface99; this includes an RTSP
      1.0 implementation along with ~50k lines of private code.
    '';
    homepage = "https://github.com/hirrolot/metalang99";
    changelog = "https://github.com/hirrolot/metalang99/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
