{ lib
, stdenvNoCC
, fetchFromGitHub
, buildPackages
, pkg-config
, cairo
, imagemagick
, zopfli
, pngquant
, which
}:

let
  emojiPythonEnv =
    buildPackages.python3.withPackages (p: with p; [ fonttools nototools ]);
in
stdenvNoCC.mkDerivation rec {
  pname = "noto-fonts-color-emoji";
  version = "2.042";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "noto-emoji";
    rev = "v${version}";
    hash = "sha256-otJQMXrBIPrxD1vCdgcrZ2h1a9XAMbqEBFumjz1XJ54=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
    cairo
  ];

  nativeBuildInputs = [
    imagemagick
    zopfli
    pngquant
    which
    emojiPythonEnv
  ];

  postPatch = ''
    patchShebangs *.py
    patchShebangs third_party/color_emoji/*.py
    # remove check for virtualenv, since we handle
    # python requirements using python.withPackages
    sed -i '/ifndef VIRTUAL_ENV/,+2d' Makefile
    # Make the build verbose so it won't get culled by Hydra thinking that
    # it somehow got stuck doing nothing.
    sed -i 's;\t@;\t;' Makefile
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/noto
    cp NotoColorEmoji.ttf $out/share/fonts/noto
    runHook postInstall
  '';

  meta = {
    description = "Color emoji font";
    homepage = "https://github.com/googlefonts/noto-emoji";
    license = with lib.licenses; [ ofl asl20 ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mathnerd314 sternenseemann ];
  };
}
