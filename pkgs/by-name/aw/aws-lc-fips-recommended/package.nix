# AWS-LC FIPS recommended build
#
# This packages tracks the latest AWS-LC-FIPS release.  It is "recommended" in
# the sense that it addresses known CVEs and bugs, but it may not have formal NIST
# FIPS 140-3 validation.
#
# See AWS-LC FIPS module status at
# https://github.com/aws/aws-lc/blob/main/crypto/fipsmodule/FIPS.md
#
# The build instruction from security policy documents are followed as closely as is practical.
#
{ lib
, clangStdenv  # FIPS delocator tool expects clang
, cmakeMinimal
, fetchurl
, unzip
, gnumake
, go
, perl
, nix-update-script
, useSharedLibraries ? !clangStdenv.hostPlatform.isStatic
}:

let
  version = "3.3.0";
  tag = "AWS-LC-FIPS-${version}";
in
clangStdenv.mkDerivation {
  pname = "aws-lc-fips";
  inherit version;

  # Use fetchurl with zip so that hash correlates to hash from security policy documents.
  src = fetchurl {
    url = "https://github.com/aws/aws-lc/archive/refs/tags/${tag}.zip";
    hash = "sha256-b5N1aHdQYa7O2Mm/8pXz10Xm+iI102cJ1PXrSFLLr7A=";
  };

  sourceRoot = "aws-lc-${tag}";

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [ cmakeMinimal gnumake go perl unzip ];

  # Per NIST security policy:
  # Dynamic: cmake -DFIPS=1 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 ..
  # Static:  cmake -DFIPS=1 ..
  cmakeFlags = [
    "-DFIPS=1"
  ] ++ lib.optionals useSharedLibraries [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=1"
  ];

  postFixup = ''
    for f in $out/lib/crypto/cmake/*/crypto-targets.cmake; do
      substituteInPlace "$f" \
        --replace-fail 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  hardeningDisable = [ "fortify" ];

  env = {
    # No GOFLAGS - let Go use its default behavior (the vendor dir in 3.3.0 is incomplete)
    GOPROXY = "off";
    GOCACHE = "/tmp/go-cache";
    NIX_CFLAGS_COMPILE = "-Wno-error=cast-function-type-mismatch";
  };

  passthru = {
    inherit useSharedLibraries;
    validated = false;
    # Filters git tags to FIPS releases only, ignoring mainline aws-lc tags (vX.Y.Z).
    # `--url` is explicit because `src` uses fetchurl; without it nix-update
    # may fail to locate the upstream repo for tag enumeration.
    updateScript = nix-update-script {
      extraArgs = [
        "--url"
        "https://github.com/aws/aws-lc"
        "--version-regex"
        "AWS-LC-FIPS-(.*)"
      ];
    };
  };

  meta = {
    description = "AWS-LC cryptographic library (FIPS recommended)";
    homepage = "https://github.com/aws/aws-lc";
    license = [ lib.licenses.asl20 lib.licenses.isc ];
    maintainers = [ lib.maintainers.goertzenator ];
    platforms = lib.platforms.unix;
    mainProgram = "bssl";
  };
}
