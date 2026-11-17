{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samurai";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "samurai";
    rev = finalAttrs.version;
    hash = "sha256-0AKbuoOG1PfH9li57X3FqGVRHlXtcmfweP5zSBks5y8=";
  };

  makeFlags = [
    "DESTDIR="
    "PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ninja-compatible build tool written in C";
    longDescription = ''
      samurai is a ninja-compatible build tool with a focus on simplicity,
      speed, and portability.

      It is written in C99, requires various POSIX.1-2008 interfaces, and
      nowadays implements ninja build language through version 1.9.0 except for
      Microsoft (R) Visual C++ (TM) dependency handling (deps = msvc).

      It is feature-complete (but not bug-compatible) and supports most of the
      same options as ninja, using the same format for .ninja_log and
      .ninja_deps as the original ninja tool, currently version 5 and 4
      respectively.
    '';
    homepage = "https://github.com/michaelforney/samurai";
    license = with lib.licenses; [
      mit
      asl20
    ]; # see LICENSE
    maintainers = [ ];
    mainProgram = "samu";
    platforms = lib.platforms.all;
  };
})
