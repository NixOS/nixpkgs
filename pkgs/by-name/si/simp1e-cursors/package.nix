{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3,
  librsvg,
  xcursorgen,
}:

stdenvNoCC.mkDerivation rec {
  pname = "simp1e-cursors";
  version = "20221103.2";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    rev = version;
    hash = "sha256-3DCF6TwxWwYK5pF2Ykr3OwF76H7J03vLNZch/XoZZZk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ pillow ]))
    librsvg
    xcursorgen
  ];

  buildPhase = ''
    runHook preBuild
    patchShebangs ./build.sh ./cursor-generator
    HOME=$TMP ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -dm 755 $out/share/icons
    cp -r built_themes/* $out/share/icons/
    runHook postInstall
  '';

  meta = {
    description = "Aesthetic cursor theme for Linux desktops";
    homepage = "https://gitlab.com/cursors/simp1e";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ natto1784 ];
  };
}
