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
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "Stiffstream";
    repo = "restinio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PXm9s586V1aZ7D5GwYzBc/Fljif/Iq3VChDe2NHWKSU=";
  };

  # https://www.github.com/Stiffstream/restinio/issues/230
  # > string sub-command JSON failed parsing json string: * Line 1, Column 1
  # > Syntax error: value, object or array expected.
  postPatch = ''
    substituteInPlace dev/test/CMakeLists.txt \
      --replace-fail "add_subdirectory(metaprogramming)" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    expected-lite
    fmt
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

  buildInputs = [
    catch2_3
    llhttp
  ];

  cmakeDir = "../dev";
  cmakeFlags = [
    "-DCMAKE_CATCH_DISCOVER_TESTS_DISCOVERY_MODE=PRE_TEST"
    "-DRESTINIO_TEST=ON"
    "-DRESTINIO_SAMPLE=OFF"
    "-DRESTINIO_BENCHMARK=OFF"
    "-DRESTINIO_WITH_SOBJECTIZER=OFF"
    "-DRESTINIO_ASIO_SOURCE=${if with_boost_asio then "boost" else "standalone"}"
    "-DRESTINIO_DEP_EXPECTED_LITE=find"
    "-DRESTINIO_DEP_FMT=find"
    "-DRESTINIO_DEP_LLHTTP=system"
    "-DRESTINIO_DEP_CATCH2=find"
  ];

  doCheck = true;
  enableParallelChecking = false;
  __darwinAllowLocalNetworking = true;
  preCheck =
    let
      disabledTests =
        [ ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          # Tests that fail with error: 'unable to write: Operation not permitted'
          "HTTP echo server"
          "single_thread_connection_limiter"
          "simple sendfile"
          "simple sendfile with std::filesystem::path"
          "sendfile the same file several times"
          "sendfile 2 files"
          "sendfile offsets_and_size"
          "sendfile chunks"
          "sendfile with partially-read response"
        ];
      excludeRegex = "^(${builtins.concatStringsSep "|" disabledTests})";
    in
    lib.optionalString (builtins.length disabledTests != 0) ''
      checkFlagsArray+=(ARGS="--exclude-regex '${excludeRegex}'")
    '';

  meta = with lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP(S)/WebSocket server C++ library";
    homepage = "https://github.com/Stiffstream/restinio";
    changelog = "https://github.com/Stiffstream/restinio/releases/tag/${finalAttrs.src.rev}";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ tobim ];
  };
})
