{
  lib,
  stdenv,
  fetchFromGitHub,
  python312Packages,
  libyaml,
  waf,
  pkg-config,
  ffmpeg_4,
  eigen,
  fftwSinglePrec,
  libsamplerate,
  taglib,
  wafHook,
  libresample,
  chromaprint,
  zlib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "essentia-extractor";
  version = "2.1_beta5";

  src = fetchFromGitHub {
    owner = "MTG";
    repo = "essentia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nPw3KxN2vXgAGnQIC5pMxZ35hbveERmvzMLn7vgx4kU=";
  };

  nativeBuildInputs = [
    libyaml
    waf
    wafHook
    pkg-config
  ];

  buildInputs = [
    libyaml
    python312Packages.setuptools
    python312Packages.six
    python312Packages.pyyaml
    python312Packages.distutils
    ffmpeg_4
    eigen
    fftwSinglePrec
    libsamplerate
    taglib
    chromaprint
    libresample
    zlib
  ];

  preConfigure = ''
    # Fixing error with python-utils
    export PYTHONPATH="$PWD:$PWD/src:$PYTHONPATH"
    rm waf
  '';

  wafConfigureFlags = [
    "--build-static"
    "--with-cpptests"
    "--with-examples"
  ];

  buildPhase = ''
    runHook preBuild
    waf build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/include" "$out/lib"
    waf install --prefix="$out"
    runHook postInstall
  '';

  postInstall = ''
    # Remove another files
    mv $out/bin/essentia_streaming_extractor_music $out/bin/streaming_extractor_music
    rm -f $out/bin/essentia_*
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/MTG/essentia";
    description = "AcousticBrainz audio feature extractor";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ lovesegfault ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    mainProgram = "streaming_extractor_music";
  };
})
