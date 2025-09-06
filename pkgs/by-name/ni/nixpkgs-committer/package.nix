{
  lib,
  stdenvNoCC,
  fetchurl,
  bashNonInteractive,
  gh,
  makeWrapper,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nixpkgs-committer";
  version = "0-unstable-2024-07-09";

  src = fetchurl {
    # latest commit to gist
    url = "https://gist.githubusercontent.com/lorenzleutgeb/239214f1d60b1cf8c79e7b0dc0483deb/raw/2d9f486711177fc3de26e109cefac15b85e42456/committer-progress.sh";
    hash = "sha256-Fwf6Qb5+uznKgy5PHHZmzYfbqxGBX8KBNg3R2/N8uas=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bashNonInteractive ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm0755 ${src} ${placeholder "out"}/bin/nixpkgs-committer

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram ${placeholder "out"}/bin/nixpkgs-committer \
      --prefix PATH ":" ${
        lib.makeBinPath [
          gh
        ]
      }
  '';

  meta = {
    homepage = "https://gist.github.com/lorenzleutgeb/239214f1d60b1cf8c79e7b0dc0483deb";
    description = "Simple shell script to detect nixpkgs commit progress";
    mainProgram = "nixpkgs-committer";
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    platforms = lib.platforms.unix;
  };
}
