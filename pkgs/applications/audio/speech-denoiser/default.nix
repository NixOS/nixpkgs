{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, lv2, meson, ninja }:

let
  speech-denoiser-src = fetchFromGitHub {
    owner = "lucianodato";
    repo = "speech-denoiser";
    rev = "04cfba929630404f8d4f4ca5bac8d9b09a99152f";
    sha256 = "189l6lz8sz5vr6bjyzgcsrvksl1w6crqsg0q65r94b5yjsmjnpr4";
  };

  rnnoise-nu = stdenv.mkDerivation rec {
    pname = "rnnoise-nu";
    version = "unstable-07-10-2019";
    src = speech-denoiser-src;
    sourceRoot = "source/rnnoise";
    nativeBuildInputs = [ autoreconfHook ];
    configureFlags = [ "--disable-examples" "--disable-doc" "--disable-shared" "--enable-static" ];
    installTargets = [ "install-rnnoise-nu" ];
  };
in
stdenv.mkDerivation  rec {
  pname = "speech-denoiser";
  version = "unstable-07-10-2019";

  src = speech-denoiser-src;

  nativeBuildInputs = [ pkgconfig meson ninja ];
  buildInputs = [ lv2 rnnoise-nu ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace "cc.find_library('rnnoise-nu',dirs: meson.current_source_dir() + '/rnnoise/.libs/',required : true)" "cc.find_library('rnnoise-nu', required : true)"
  '';

  meta = with stdenv.lib; {
    description = "Speech denoise lv2 plugin based on RNNoise library";
    homepage = https://github.com/lucianodato/speech-denoiser;
    license = licenses.lgpl3;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
