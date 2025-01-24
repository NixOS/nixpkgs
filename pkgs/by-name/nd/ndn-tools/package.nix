{
  lib,
  stdenv,
  boost ? ndn-cxx.boost,
  fetchFromGitHub,
  libpcap,
  ndn-cxx,
  openssl,
  pkg-config,
  sphinx,
  wafHook,
}:

stdenv.mkDerivation rec {
  pname = "ndn-tools";
  version = "24.07";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-tools";
    rev = "ndn-tools-${version}";
    sha256 = "sha256-rzGd+8SkztrkXRXcEcQm6rOtAGnF7h/Jg8jaBb7FP9w=";
  };

  nativeBuildInputs = [
    pkg-config
    sphinx
    wafHook
  ];
  buildInputs = [
    libpcap
    ndn-cxx
    openssl
  ];

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    "--with-tests"
  ];

  doCheck = false; # some tests fail because of the sandbox environment
  checkPhase = ''
    runHook preCheck
    build/unit-tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) Essential Tools";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
