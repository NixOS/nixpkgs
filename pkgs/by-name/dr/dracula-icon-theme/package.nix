{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "dracula-icon-theme";
  version = "0-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "m4thewz";
    repo = "dracula-icons";
    rev = "6232e5217429a3ae6396c9e054f5338cecdbb7a5";
    hash = "sha256-u2cIUTLWYs8VIqg6ZAUyz0nmzuFAZC4oh7bE67+B1Vg=";
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
