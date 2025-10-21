{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  libxml2,
  python3,
  libuuid,
  curl,
  gsoap,
  rapidjson,
  enableTools ? true,
  # Use libcurl instead of libneon
  # Note that the libneon used is bundled in the project
  # See https://github.com/cern-fts/davix/issues/23
  defaultToLibcurl ? false,
  enableIpv6 ? true,
  enableTcpNodelay ? true,
  # Build davix_copy.so
  enableThirdPartyCopy ? false,
}:

let
  boolToUpper = b: lib.toUpper (lib.boolToString b);
in
stdenv.mkDerivation rec {
  version = "0.8.10";
  pname = "davix" + lib.optionalString enableThirdPartyCopy "-copy";
  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
  buildInputs = [
    curl
    libxml2
    openssl
    rapidjson
  ]
  ++ lib.optional (!stdenv.hostPlatform.isDarwin) libuuid
  ++ lib.optional enableThirdPartyCopy gsoap;

  src = fetchFromGitHub {
    owner = "cern-fts";
    repo = "davix";
    rev = "refs/tags/R_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-n4NeHBgQwGwgHAFQzPc3oEP9k3F/sqrTmkI/zHW+Miw=";
  };

  preConfigure = ''
    find . -mindepth 1 -maxdepth 1 -type f -name "patch*.sh" -print0 | while IFS= read -r -d ''' file; do
      patchShebangs "$file"
    done
  '';

  cmakeFlags = [
    "-DDAVIX_TESTS=OFF"
    "-DENABLE_TOOLS=${boolToUpper enableTools}"
    "-DEMBEDDED_LIBCURL=OFF"
    "-DLIBCURL_BACKEND_BY_DEFAULT=${boolToUpper defaultToLibcurl}"
    "-DENABLE_IPV6=${boolToUpper enableIpv6}"
    "-DENABLE_TCP_NODELAY=${boolToUpper enableTcpNodelay}"
    "-DENABLE_THIRD_PARTY_COPY=${boolToUpper enableThirdPartyCopy}"
  ];

  patches = [
    # Update CMake minimum requirement and supported versions, backport from unreleased davix 0.8.11
    (fetchpatch {
      url = "https://github.com/cern-fts/davix/commit/687d424c9f87888c94d96f3ea010de11ef70cd23.patch";
      hash = "sha256-FNXOQrY0gsMK+D4jwbJmYyEqD3lFui0giXUd+Rr0jLk=";
    })
  ];

  meta = with lib; {
    description = "Toolkit for Http-based file management";

    longDescription = "Davix is a toolkit designed for file
    operations with Http based protocols (WebDav, Amazon S3, ...).
    Davix provides an API and a set of command line tools";

    license = licenses.lgpl2Plus;
    homepage = "https://github.com/cern-fts/davix";
    changelog = "https://github.com/cern-fts/davix/blob/R_${
      lib.replaceStrings [ "." ] [ "_" ] version
    }/RELEASE-NOTES.md";
    maintainers = with maintainers; [ adev ];
    platforms = platforms.all;
  };
}
