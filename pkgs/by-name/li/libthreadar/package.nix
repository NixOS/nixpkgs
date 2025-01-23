{
  lib,
  stdenv,
  fetchurl,
  gcc-unwrapped,
}:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "libthreadar";

  src = fetchurl {
    url = "mirror://sourceforge/libthreadar/${pname}-${version}.tar.gz";
    sha256 = "sha256-wJAkIUGK7Ud6n2p1275vNkSx/W7LlgKWXQaDevetPko=";
  };

  postPatch = ''
    # this field is not present on Darwin, ensure it is zero everywhere
    substituteInPlace src/thread_signal.cpp \
      --replace-fail 'sigac.sa_restorer = nullptr;' "" \
      --replace-fail 'struct sigaction sigac;' 'struct sigaction sigac = {0};'
  '';

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [ gcc-unwrapped ];

  CXXFLAGS = [ "-std=c++14" ];

  configureFlags = [
    "--disable-build-html"
  ];

  postInstall = ''
    # Disable html help
    rm -r "$out"/share
  '';

  meta = with lib; {
    homepage = "https://libthreadar.sourceforge.net/";
    description = "C++ library that provides several classes to manipulate threads";
    longDescription = ''
      Libthreadar is a C++ library providing a small set of C++ classes to manipulate
      threads in a very simple and efficient way from your C++ code.
    '';
    maintainers = with maintainers; [ izorkin ];
    license = licenses.lgpl3;
    platforms = platforms.unix;
  };
}
