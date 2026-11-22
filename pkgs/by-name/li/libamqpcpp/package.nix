{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libamqpcpp";
  version = "4.3.27";

  src = fetchFromGitHub {
    owner = "CopernicaMarketingSoftware";
    repo = "AMQP-CPP";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-iaOXdDIJOBXHyjE07CvU4ApTh71lmtMCyU46AV+MGXQ=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.4 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10 FATAL_ERROR)"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  patches = [ ./libamqpcpp-darwin.patch ];

  enableParallelBuilding = true;

  meta = {
    description = "Library for communicating with a RabbitMQ server";
    homepage = "https://github.com/CopernicaMarketingSoftware/AMQP-CPP";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mjp ];
    platforms = lib.platforms.all;
  };
})
