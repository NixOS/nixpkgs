{ skia_m102, fetchFromGitHub }:

skia_m102.overrideAttrs (oldAttrs: {
  version = "aseprite-m102";

  src = fetchFromGitHub {
    owner = "aseprite";
    repo = "skia";
    # latest commit from aseprite-m102 branch
    rev = "861e4743af6d9bf6077ae6dda7274e5a136ee4e2";
    hash = "sha256-IlZbalmHl549uDUfPG8hlzub8TLWhG0EsV6HVAPdsl0=";
  };

  installPhase = ''
    mkdir -p $out

    # Glob will match all subdirs.
    shopt -s globstar

    # All these paths are used in some way when building aseprite.
    cp -r --parents -t $out/ \
      include/codec \
      include/config \
      include/core \
      include/effects \
      include/gpu \
      include/private \
      include/utils \
      include/third_party/skcms/*.h \
      out/Release/*.a \
      src/gpu/**/*.h \
      src/core/*.h \
      modules/skshaper/include/*.h \
      third_party/externals/angle2/include \
      third_party/skcms/**/*.h
  '';
})
