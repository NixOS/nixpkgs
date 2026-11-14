{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  lv2,
  meson,
  ninja,
}:

let
  speech-denoiser-src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "speech-denoiser";
    rev = "04cfba929630404f8d4f4ca5bac8d9b09a99152f";
    hash = "sha256-JF8rq5a+LJJyMRg8jTMzPFA9d9bsfS+Xybt8jT41NKE=";
  };

  rnnoise-nu = stdenv.mkDerivation {
    pname = "rnnoise-nu";
    version = "0-unstable-2018-10-08";
    src = speech-denoiser-src;
    sourceRoot = "${speech-denoiser-src.name}/rnnoise";
    nativeBuildInputs = [ autoreconfHook ];
    configureFlags = [
      "--disable-examples"
      "--disable-doc"
      "--disable-shared"
      "--enable-static"
    ];
    installTargets = [ "install-rnnoise-nu" ];
  };
in
stdenv.mkDerivation {
  pname = "speech-denoiser";
  version = "0-unstable-2018-10-08";

  src = speech-denoiser-src;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    lv2
    rnnoise-nu
  ];

  mesonFlags = [ "--prefix=${placeholder "out"}/lib/lv2" ];

  # Install the generated manifest.ttl by reference; Meson >= 1.12 resolves the
  # hardcoded 'build/manifest.ttl' string inside the build dir and fails.
  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "cc.find_library('rnnoise-nu',dirs: meson.current_source_dir() + '/rnnoise/.libs/',required : true)" "cc.find_library('rnnoise-nu', required : true)" \
      --replace-fail "configure_file(input" "manifest_ttl = configure_file(input" \
      --replace-fail "'build/manifest.ttl'" "manifest_ttl"
  '';

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Speech denoise lv2 plugin based on RNNoise library";
    homepage = "https://github.com/lucianodato/speech-denoiser";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
}
