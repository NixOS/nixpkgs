{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asio,
  boost,
  expected-lite,
  fmt,
  llhttp,
  openssl,
  pcre2,
  zlib,
  catch2_3,
  # Build with the asio library bundled in boost instead of the standalone asio package.
  with_boost_asio ? false,
}:

assert with_boost_asio -> boost != null;
assert !with_boost_asio -> asio != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "restinio";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Stiffstream";
    repo = "restinio";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-Nv/VVdHciCv+DsVu3MqfXeAa8Ef+qi6c1OaTAVrYUg0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs =
    [
      expected-lite
      fmt
      llhttp
      openssl
      pcre2
      zlib
    ]
    ++ (
      if with_boost_asio then
        [
          boost
        ]
      else
        [
          asio
        ]
    );

  checkInputs = [
    catch2_3
  ];

  cmakeDir = "../dev";
  cmakeFlags = [
    "-DRESTINIO_TEST=ON"
    "-DRESTINIO_SAMPLE=OFF"
    "-DRESTINIO_BENCHMARK=OFF"
    "-DRESTINIO_WITH_SOBJECTIZER=OFF"
    "-DRESTINIO_ASIO_SOURCE=${if with_boost_asio then "boost" else "standalone"}"
    "-DRESTINIO_DEP_EXPECTED_LITE=find"
    "-DRESTINIO_DEP_FMT=find"
    "-DRESTINIO_DEP_LLHTTP=find"
    "-DRESTINIO_DEP_CATCH2=find"
  ];

  doCheck = true;
  enableParallelChecking = false;

  meta = with lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP(S)/WebSocket server C++ library";
    homepage = "https://github.com/Stiffstream/restinio";
    changelog = "https://github.com/Stiffstream/restinio/releases/tag/${finalAttrs.src.rev}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ tobim ];
  };
})
