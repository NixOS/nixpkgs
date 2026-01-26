{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "apl2741-unicode";
  version = "0-unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "abrudz";
    repo = "APL2741";
    rev = "1e11efae38e5095bfe49a786b111d563e83dad03";
    hash = "sha256-/sAO+HL3zGMJZ+5SFHnkHxxevG0nJ7wo1yLTlHqYPkQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/truetype *.ttf

    runHook postInstall
  '';

  meta = {
    description = "APL font based on Adrian Smith's IBM Selectric APL2741 golf-ball font";
    license = lib.licenses.unlicense;
    homepage = "https://abrudz.github.io/APL2741/";
    maintainers = [ lib.maintainers.sternenseemann ];
    platforms = lib.platforms.all;
  };
}
