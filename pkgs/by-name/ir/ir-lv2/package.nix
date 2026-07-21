{
  lib,
  stdenv,
  fetchurl,
  fftw,
  gtk2,
  lv2,
  libsamplerate,
  libsndfile,
  pkg-config,
  zita-convolver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ir.lv2";
  version = "1.4.0";

  # https://github.com/NixOS/nixpkgs/issues/463147#issuecomment-3658352031
  src = fetchurl {
    url = "https://web.archive.org/web/20251216014553/https://git.hq.sig7.se/ir.lv2.git/snapshot/1d4a4f9b1aad6223d541ebb0c16d85d527478222.tar.gz";
    hash = "sha256-lTzj4tf7jNOKnvcZzEbzPqg4aPgXcbCVwIHoV+5G+hU=";
  };

  buildInputs = [
    fftw
    gtk2
    lv2
    libsamplerate
    libsndfile
    zita-convolver
  ];

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

  postBuild = "make convert4chan";

  installPhase = ''
    runHook preInstall
    make PREFIX="$out" INSTDIR="$out/lib/lv2" install
    install -Dm755 convert4chan "$out/bin/convert4chan"
    runHook postInstall
  '';

  meta = {
    homepage = "http://factorial.hu/plugins/lv2/ir";
    description = "Low-latency, realtime, high performance signal convolver especially for creating reverb effects.";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
