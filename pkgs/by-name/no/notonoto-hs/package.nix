{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  fontforge,
  python3,
}:

let
  python3' = python3.withPackages (
    ps: with ps; [
      fonttools
      ttfautohint-py
    ]
  );
in

stdenvNoCC.mkDerivation rec {
  pname = "notonoto-hs";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "yuru7";
    repo = "NOTONOTO";
    tag = "v${version}";
    hash = "sha256-1dbx4yC8gL41OEAE/LNDyoDb4xhAwV5h8oRmdlPULUo=";
  };

  # ttfautohint: unrecognized option '--epoch'
  postPatch = ''
    substituteInPlace fonttools_script.py \
      --replace-fail 'print("exec hinting", options_)' 'options_.pop("epoch", None)'
  '';

  nativeBuildInputs = [
    fontforge
    python3'
  ];

  buildPhase = ''
    runHook preBuild

    fontforge --script fontforge_script.py --hidden-zenkaku-space
    python3 ./fonttools_script.py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/*.ttf -t $out/share/fonts/truetype/notonoto-hs

    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines Noto Sans Mono and Noto Sans JP";
    homepage = "https://github.com/yuru7/NOTONOTO";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ genga898 ];
    platforms = lib.platforms.all;
  };
}
