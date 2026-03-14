{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-icon-theme";
  version = "0-unstable-2025-08-2";

  src = fetchFromGitHub {
    owner  = "m4thewz";
    repo   = "dracula-icons";
    rev    = "de2a8edd94608ba0ac4dcf5a187af0ffaa511ebc";
    sha256 = "sha256-JUjC6oalD7teSzzdMqLTXn7eJTZQbPP/oDeLBC7bG6E=";
  };

  nativeBuildInputs = [
    jdupes
  ];

  dontDropIconThemeCache = true;

  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Dracula
    cp -a * $out/share/icons/Dracula/
    jdupes --quiet --link-soft --recurse $out/share

    runHook postInstall
  '';

  meta = {
    description = "Dracula Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ therealr5 ];
  };
}
