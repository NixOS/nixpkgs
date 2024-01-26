{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, protobuf_21
, catch2
, boost181
, icu
}:
let
  boost = boost181.override { enableStatic = true; };
  protobuf = protobuf_21.override { enableShared = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "localproxy";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "aws-samples";
    repo = "aws-iot-securetunneling-localproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-voUKfXa43mOltePQEXgmJ2EBaN06E6R/2Zz6O09ogyY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl protobuf catch2 boost icu ];

  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];

  meta = with lib; {
    description = "AWS IoT Secure Tunneling Local Proxy Reference Implementation C++";
    homepage = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy";
    license = licenses.asl20;
    maintainers = with maintainers; [ spalf ];
    platforms = platforms.unix;
    mainProgram = "localproxy";
  };
})
