{ fetchFromGitHub
, lib
, stdenvNoCC

, # build deps
  clickgen
, python3Packages
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pokemon-cursor";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "pokemon-cursor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EL6Ztbzjm1YuQP+8ZbrhbuBXn+GFiJGG0iGNWzU/rBY=";
  };

  nativeBuildInputs = [
    clickgen
    python3Packages.attrs
  ];

  buildPhase = ''
    runHook preBuild

    ctgen build.toml -p x11 -o $out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv $out/Pokemon $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unofficial open-source Pokemon cursor theme";
    homepage = "https://github.com/ful1e5/pokemon-cursor";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.getpsyched ];
    platforms = platforms.linux;
  };
})
