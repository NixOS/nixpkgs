{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  cmake,
  gdk-pixbuf,
  libGL,
  libgbm,
}:

stdenv.mkDerivation rec {
  pname = "blur-effect";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "sonald";
    repo = "blur-effect";
    tag = version;
    sha256 = "0cjw7iz0p7x1bi4vmwrivfidry5wlkgfgdl9wly88cm3z9ib98jj";
  };

  patches = [
    # Pull cmake-4 fix:
    #   https://github.com/sonald/blur-effect/pull/7
    (fetchpatch {
      name = "cmake-4.patch";
      url = "https://github.com/sonald/blur-effect/commit/76322ad8bd0e653726a6791eb8ebcc829cbb1b38.patch?full_index=1";
      hash = "sha256-f0PBhfdrcLCZBzYx+j8+qIG9boW3S4CSyz+bS9vFKRc=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    gdk-pixbuf
    libGL
    libgbm
  ];

  meta = with lib; {
    homepage = "https://github.com/sonald/blur-effect";
    description = "Off-screen image blurring utility using OpenGL ES 3.0";
    license = licenses.gpl3;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin; # packages 'libdrm' and 'gbm' not found
    maintainers = with maintainers; [ romildo ];
    mainProgram = "blur_image";
  };
}
