{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  openssl,
  protobuf_21,
  catch2,
  boost,
  icu,
}:
let
  boost' = boost.override { enableStatic = true; };
  protobuf = protobuf_21.override { enableShared = false; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "localproxy";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "aws-samples";
    repo = "aws-iot-securetunneling-localproxy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bIJLGJhSzBVqJaTWJj4Pmw/shA4Y0CzX4HhHtQZjfj0=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy/commit/de8779630d14e4f4969c9b171d826acfa847822b.patch";
      hash = "sha256-11k6mRvCx72+5G/5LZZx2qnx10yfKpcAZofn8t8BD3E=";
    })
    (fetchpatch {
      name = "boost187.patch";
      url = "https://github.com/aws-samples/aws-iot-securetunneling-localproxy/commit/12022770e89c6787c3eda4ca01a7cedaf2affa92.patch";
      hash = "sha256-THY+dRkKhpbpK+wLskRjWvqr6uFuT0JMt/VHvgzKTzw=";
      excludes = [ ".github/workflows/ci.yml" ];
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openssl
    protobuf
    catch2
    boost'
    icu
  ];

  postPatch = ''
    sed -i '/set(OPENSSL_USE_STATIC_LIBS TRUE)/d' CMakeLists.txt
    substituteInPlace ./CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.2 FATAL_ERROR)" \
      "cmake_minimum_required(VERSION 4.0)"
  '';

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
