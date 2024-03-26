{ fetchFromGitHub
, lib
, stdenvNoCC

, # build deps
  clickgen
, python3Packages
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "banana-cursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "banana-cursor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-PI7381xf/GctQTnfcE0W3M3z2kqbX4VexMf17C61hT8=";
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
    mv $out/Banana $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "The Banana Cursor";
    homepage = "https://github.com/ful1e5/banana-cursor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ getpsyched yrd ];
    platforms = platforms.linux;
  };
})
