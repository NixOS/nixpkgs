# AWS-LC FIPS validated build
#
# This packages tracks the latest AWS-LC-FIPS release that has a FIPS 140-3
# validation certificate. It is typically not the latest release and may have
# known bugs and CVEs.
#
# See AWS-LC FIPS module status at
# https://github.com/aws/aws-lc/blob/main/crypto/fipsmodule/FIPS.md
#
# The build instruction from security policy documents are followed as closely as is practical.
#
{
  lib,
  clangStdenv, # FIPS delocator tool expects clang
  cmakeMinimal,
  fetchurl,
  unzip,
  gnumake,
  go,
  perl,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
  useSharedLibraries ? !clangStdenv.hostPlatform.isStatic,
}:

let
  version = "2.0.0";
  tag = "AWS-LC-FIPS-${version}";
in
clangStdenv.mkDerivation {
  pname = "aws-lc-fips";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  # Use fetchurl with zip so that hash correlates to hash from security policy documents.
  src = fetchurl {
    url = "https://github.com/aws/aws-lc/archive/refs/tags/${tag}.zip";
    hash = "sha256-YkHsLxOl+AIk7pzYWS7WapfUJkgQZv6qTvxvJOYLvJY=";
  };

  sourceRoot = "aws-lc-${tag}";

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    cmakeMinimal
    gnumake
    go
    perl
    unzip
  ];

  # Per NIST security policy:
  # Dynamic: cmake -DFIPS=1 -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=1 ..
  # Static:  cmake -DFIPS=1 ..
  #
  # CMAKE_POLICY_VERSION_MINIMUM works around AWS-LC-FIPS 2.0.0's
  # cmake_minimum_required(VERSION <3.5); CMake 4.x refuses such declarations
  # without this override.
  cmakeFlags = [
    "-DFIPS=1"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ]
  ++ lib.optionals useSharedLibraries [
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
    GOPROXY = "off";
    GOFLAGS = "-mod=vendor";
    GOCACHE = "/tmp/go-cache";
    # cast-function-type-mismatch: pre-existing, clang warning newer than upstream.
    # unterminated-string-initialization: clang 21+ flag, triggers on intentionally
    # non-null-terminated byte arrays (e.g. AES keys) in the FIPS self-check code.
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=cast-function-type-mismatch"
      "-Wno-error=unterminated-string-initialization"
    ];
  };

  passthru = {
    inherit useSharedLibraries;
    validated = true;
    # Picks the highest version listed under "validated" in
    # crypto/fipsmodule/FIPS_VERSIONS.json upstream. Presence in that list
    # is AWS-LC's signal that the release carries NIST validation, so
    # auto-bumps stay within the validated set by definition.
    #
    # For testing against an unmerged FIPS_VERSIONS.json, override the
    # source URL via FIPS_VERSIONS_URL, e.g.
    #   FIPS_VERSIONS_URL=file:///home/you/aws-lc/crypto/fipsmodule/FIPS_VERSIONS.json \
    #     nix-shell maintainers/scripts/update.nix --argstr package aws-lc-fips-validated
    updateScript = writeShellScript "update-aws-lc-fips-validated" ''
      set -euo pipefail
      url=''${FIPS_VERSIONS_URL:-https://raw.githubusercontent.com/aws/aws-lc/main/crypto/fipsmodule/FIPS_VERSIONS.json}
      json=$(${lib.getExe curl} -fsSL "$url")
      latest_tag=$(echo "$json" | ${lib.getExe jq} -r '.validated | keys[]' | sort -V | tail -1)
      if [ -z "$latest_tag" ]; then
        echo "no validated versions found in $url" >&2
        exit 1
      fi
      latest_version=''${latest_tag#AWS-LC-FIPS-}
      ${lib.getExe' common-updater-scripts "update-source-version"} \
        aws-lc-fips-validated "$latest_version"
    '';
  };

  meta = {
    description = "AWS-LC cryptographic library (FIPS validated)";
    homepage = "https://github.com/aws/aws-lc";
    license = [
      lib.licenses.asl20
      lib.licenses.isc
    ];
    maintainers = [ lib.maintainers.goertzenator ];
    platforms = lib.platforms.unix;
    mainProgram = "bssl";
  };
}
