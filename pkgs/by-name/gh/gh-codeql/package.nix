{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gh-codeql";
  version = "0-unstable-2024-06-09";

  src = fetchFromGitHub {
    owner = "github";
    repo = "gh-codeql";
    rev = "0c422da4b003d8de22e6f98a31888d7c0b080837";
    hash = "sha256-0hpvUyFw3oC5UT6VU3rtMKR6RCKVvhJ6inY9gjOknrE=";
  };

  installPhase = ''
    runHook preInstall

    install -m755 -D $src/gh-codeql $out/bin/gh-codeql

    runHook postInstall
  '';

  meta = {
    description = "GitHub CLI extension for working with CodeQL";
    homepage = "https://github.com/github/gh-codeql";
    license = lib.licenses.mit;
    mainProgram = "gh-codeql";
    maintainers = [ lib.maintainers.luftmensch-luftmensch ];
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
