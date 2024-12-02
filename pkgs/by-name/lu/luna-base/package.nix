{
  lib,
  stdenv,
  autoPatchelfHook,
  fetchFromGitHub,
  fftw,
}:

stdenv.mkDerivation rec {
  pname = "luna-base";
  version = "1.0.0";
  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "remnrem";
    repo = "luna-base";
    rev = "v${version}";
    hash = "sha256-IWftBR1rU5yejdmngg6eFrLe/Pyfq/Qok/fq/cXyKX8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    fftw
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 luna destrat behead tocol -t $out/bin
    find . -name '*.h' -exec install -Dm644 {} $out/include/{} \;

    # These do not have .h extensions
    mkdir -p $out/include/stats
    find stats/Eigen/ -maxdepth 1 -type f -exec cp {} $out/include/stats/Eigen/ \;

    mkdir -p $out/lib
    cp *.a *.so *.o $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "Library supporting large-scale objective studies of sleep";
    homepage = "https://zzz.bwh.harvard.edu/luna";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ beaudan ];
    platforms = lib.platforms.linux;
    mainProgram = "luna";
  };
}
