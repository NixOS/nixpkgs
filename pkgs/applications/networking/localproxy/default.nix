{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  openssl,
  protobuf_21,
  catch2,
  boost181,
  icu,
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

  patches = [
    # gcc-13 compatibility fix:
    #   https://github.com/aws-samples/aws-iot-securetunneling-localproxy/pull/136
    (fetchpatch {
      name = "gcc-13-part-1.patch";
      url = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy/commit/f6ba73eaede61841534623cdb01b69d793124f4b.patch";
      hash = "sha256-sB9GuEuHLyj6DXNPuYAMibUJXdkThKbS/fxvnJU3rS4=";
    })
    (fetchpatch {
      name = "gcc-13-part-2.patch";
      url = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy/commit/de8779630d14e4f4969c9b171d826acfa847822b.patch";
      hash = "sha256-11k6mRvCx72+5G/5LZZx2qnx10yfKpcAZofn8t8BD3E=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
    protobuf
    catch2
    boost
    icu
  ];

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
