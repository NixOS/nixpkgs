{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  boost,
  fmt,
  python3,
  snappy,
  zlib,
  zstd,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avro-c++";
  version = "1.12.2";

  # Use the archive tarball as the share/test/data/schemas/*/ dirs need to be writable
  src = fetchurl {
    url = "mirror://apache/avro/avro-${finalAttrs.version}/avro-src-${finalAttrs.version}.tar.gz";
    hash = "sha256-RJcixELslRTY5pM/nHzPLgVEy3XJUcJbgE6h2Oc9Ers=";
  };

  sourceRoot = "avro-src-${finalAttrs.version}/lang/c++";

  patches = [
    # Remove in next release
    (fetchpatch {
      name = "remove-boost-system-component.patch";
      url = "https://github.com/apache/avro/commit/2b11dba4fb28c7bb6ff08b40509a6a71fcaf4c21.patch";
      hash = "sha256-jqLB4EvFyAMbb/oRQEoVCXMdWEsqNuxV4KqbCMehXpU=";
      stripLen = 2;
    })
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  propagatedBuildInputs = [
    boost
    fmt
    snappy
    zlib
    zstd
  ];

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  postPatch = ''
    # Replace wrong include dir that makes clients fail (fmt::format is not in core)
    # Remove in next release as they have switched to std::format
    substituteInPlace include/avro/Exception.hh --replace-fail '<fmt/core.h>' '<fmt/format.h>'
  '';

  meta = {
    description = "C++ library which implements parts of the Avro Specification";
    mainProgram = "avrogencpp";
    homepage = "https://avro.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ smancill ];
    platforms = lib.platforms.all;
  };
})
