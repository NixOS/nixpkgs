{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  hyprcursor,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "posy-cursors-hyprcursor";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Morxemplum";
    repo = "posys-cursor-scalable";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tbNMFTam2msn3z+COLr/CWXEVIuLR/6o/uaNF3kzs38=";
  };

  strictDeps = true;

  nativeBuildInputs = [ hyprcursor ];

  buildPhase = ''
    runHook preBuild
    hyprcursor-util --create hyprcursor_themes/white
    hyprcursor-util --create hyprcursor_themes/black
    hyprcursor-util --create hyprcursor_themes/mono
    hyprcursor-util --create hyprcursor_themes/mono_black
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r hyprcursor_themes/theme_* $out/share/icons
    cd $out/share/icons
    for dir in theme_*; do mv "$dir" "''${dir#theme_}"; done
    runHook postInstall
  '';

  meta = {
    description = "Posy's Improved Cursors for Hyprcursor";
    homepage = "https://github.com/Morxemplum/posys-cursor-scalable";
    platforms = lib.platforms.unix;
    license = lib.licenses.cc-by-nc-40;
    maintainers = with lib.maintainers; [ mkez ];
  };
})
