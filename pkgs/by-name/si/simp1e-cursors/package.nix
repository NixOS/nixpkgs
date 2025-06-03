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
  version = "20250223";

  src = fetchFromGitLab {
    owner = "cursors";
    repo = "simp1e";
    tag = version;
    hash = "sha256-mNuGjpNZCaOlGLkHez4pFMPdCCbSoYQx1HTs7BI0DJA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.pillow ]))
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
    changelog = "https://gitlab.com/cursors/simp1e/-/tags/${version}";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.natto1784 ];
  };
}
