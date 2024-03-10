{ lib
, stdenvNoCC
, fetchFromGitHub
, python3
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "openttd-ttf";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "zephyris";
    repo = "openttd-ttf";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-GjtfwM268i3bUAX8Pw5/Og9029AuD1OZuJ2VIlFTogY=";
  };

  nativeBuildInputs = [
    (python3.withPackages (pp: with pp; [
      fontforge
      pillow
      setuptools
    ]))
  ];

  postPatch = ''
    chmod a+x build.sh
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
