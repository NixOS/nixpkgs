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

  meta = with lib; {
    description = "Dracula Icon theme";
    homepage = "https://github.com/m4thewz/dracula-icons";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ therealr5 ];
  };
}
