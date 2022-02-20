{ mkDerivation
, stdenv
, lib
, fetchFromGitHub
, fetchpatch
, nix-update-script
, qtbase
, qtsvg
, qttools
, autoreconfHook
, cmake
, pkg-config
, ffmpeg
, libGLU
, alsa-lib
, libX11
, libXrandr
, sndio
}:

mkDerivation rec {
  pname = "punes";
  version = "0.108";

  src = fetchFromGitHub {
    owner = "punesemu";
    repo = "puNES";
    rev = "v${version}";
    sha256 = "0inkwmvbr2w4addmgk9r4f13yismang9ylfgflhh9352lf0lirv8";
  };

  patches = [
    # Drop when version > 0.108
    # https://github.com/punesemu/puNES/issues/185
    (fetchpatch {
      name = "0001-punes-Fixed-make-install.patch";
      url = "https://github.com/punesemu/puNES/commit/902434f50398ebcda0786ade4b28a0496084810e.patch";
      sha256 = "1a3052n3n1qipi4bd7f7gq4zl5jjjzzzpbijdisis2vxvhnfvcim";
    })
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace '`$PKG_CONFIG --variable=host_bins Qt5Core`/lrelease' '${qttools.dev}/bin/lrelease'
  '';

  nativeBuildInputs = [ autoreconfHook cmake pkg-config qttools ];

  buildInputs = [ ffmpeg qtbase qtsvg libGLU ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib libX11 libXrandr ]
    ++ lib.optionals stdenv.hostPlatform.isBSD [ sndio ];

  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--without-opengl-nvidia-cg"
    "--with-ffmpeg"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Qt-based Nintendo Entertainment System emulator and NSF/NSFe Music Player";
    homepage = "https://github.com/punesemu/puNES";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = with platforms; linux ++ freebsd ++ openbsd ++ windows;
  };
}
