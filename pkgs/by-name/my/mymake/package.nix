{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mymake";
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "fstromback";
    repo = "mymake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQjvxdOvD9O6TrzBFJwh3CistDGZM9HZbcwVPx1n4+A=";
  };

  buildPhase = ''
    runHook preBuild

    ./compile.sh mm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 mm $out/bin/mm

    runHook postInstall
  '';

  meta = {
    description = "Tool for compiling and running programs with minimal configuration.";
    homepage = "https://github.com/fstromback/mymake";
    maintainers = [ lib.maintainers.nobbele ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "mm";
  };
})
