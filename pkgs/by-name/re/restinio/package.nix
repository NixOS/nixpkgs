{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Stiffstream";
    repo = "restinio";
    rev = "v.${finalAttrs.version}";
    hash = "sha256-XodG+dVW4iBgFx0Aq0+/pZyCLyqTBtW7e9r69y176Ro=";
  };

  patches = let
    useCommit = {id, name, hash}:
    fetchpatch {
      inherit name hash;
      url = "https://github.com/Stiffstream/restinio/commit/${id}.patch";
    };
  in [
    (useCommit {
      id = "57e6ae3f73a03a5120feb80a7bb5dca27179fa38";
      name = "restinio-unvendor-catch2_part1.patch";
      hash = "sha256-2Htt9WTP6nrh+1y7y2xleFj568IpnSEn9Qhb1ObLam8=";
    })
    (useCommit {
      id = "0060e493b99f03c38dda519763f6d6701bc18112";
      name = "restinio-unvendor-catch2_part2.patch";
      hash = "sha256-Eg/VNxPwNtEYmalP5myn+QvqwU6wln9v0vxbRelRHA8=";
    })
    (useCommit {
      id = "05bea25f82917602a49b72b8ea10eeb43984762f";
      name = "restinio-unvendor-catch2_part3.patch";
      hash = "sha256-fA+U/Y7FyrxDRiWSVXCy9dMF4gmfDLag7gBWoY74In0=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    expected-lite
    fmt
    llhttp
    openssl
    pcre2
    zlib
  ] ++ (if with_boost_asio then [
    boost
  ] else [
    asio
  ]);

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
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ tobim ];
  };
})
