{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "srt-xtransmit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "maxsharabayko";
    repo = "srt-xtransmit";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-v2JMkuSChO6SWh33qG1Js6JSOXAQls0FKFkg314ULUU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cmakeFlags = [
    "-DENABLE_CXX17=OFF"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  # Upstream CMake does not install srt-xtransmit by default.
  installPhase = ''
    runHook preInstall

    install -Dm755 bin/srt-xtransmit -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "SRT xtransmit application for generating and receiving test traffic";
    homepage = "https://github.com/maxsharabayko/srt-xtransmit";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ randomizedcoder ];
    platforms = lib.platforms.unix;
    mainProgram = "srt-xtransmit";
  };
}
