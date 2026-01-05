{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libjpeg,
  libmcrypt,
  libmhash,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steghide";
  version = "0.5.1.1";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "steghide";
    rev = finalAttrs.version;
    hash = "sha256-uUXEipIUfu9AbG7Ekz+25JkWSEGzqA7sJHZqezLzUto=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libjpeg
    libmcrypt
    libmhash
    zlib
  ];

  postPatch = ''
    cd src
  '';

  # std::binary_function and std::unary_function has been removed in c++17
  makeFlags = lib.optionals stdenv.cc.isClang [
    "CXXFLAGS=-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION"
  ];

  meta = with lib; {
    homepage = "https://github.com/museoa/steghide";
    description = "Open source steganography program";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = with platforms; unix;
    mainProgram = "steghide";
  };
})
