{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openttd-ttf";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "zephyris";
    repo = "openttd-ttf";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Nr3oLiCEdpUhB/IczCEoLM8kb1hGDH/d6WYWRbjgOi8=";
  };

  nativeBuildInputs = [
    (python3.withPackages (
      pp: with pp; [
        fontforge
        pillow
        setuptools
      ]
    ))
  ];

  postPatch = ''
    chmod a+x build.sh
    # Test requires openttd source and an additional python module, doesn't seem worth it
    substituteInPlace build.sh \
      --replace-fail "python3 checkOpenTTDStrings.py ../openttd/src/lang" ""
    patchShebangs --build build.sh
  '';

  buildPhase = ''
    runHook preBuild
    ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -m444 -Dt $out/share/fonts/truetype */*.ttf
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/zephyris/openttd-ttf";
    changelog = "https://github.com/zephyris/openttd-ttf/releases/tag/${finalAttrs.version}";
    description = "TrueType typefaces for text in a pixel art style, designed for use in OpenTTD";
    license = [ licenses.gpl2 ];
    platforms = platforms.all;
    maintainers = [ maintainers.sfrijters ];
  };
})
