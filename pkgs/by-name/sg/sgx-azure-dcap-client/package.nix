{
  stdenv,
  fetchFromGitHub,
  lib,
  curl,
  nlohmann_json,
  openssl,
  pkg-config,
  linkFarmFromDrvs,
  callPackage,
}:
let
  # Although those headers are also included in the source of `sgx-psw`, the `azure-dcap-client` build needs specific versions
  filterSparse = list: ''
    cp -r "$out"/. .
    find "$out" -mindepth 1 -delete
    cp ${lib.concatStringsSep " " list} "$out/"
  '';
  headers = linkFarmFromDrvs "azure-dcap-client-intel-headers" [
    (fetchFromGitHub rec {
      name = "${repo}-headers";
      owner = "intel";
      repo = "linux-sgx";
      # See: <src/Linux/configure> for the revision `azure-dcap-client` uses.
      rev = "1ccf25b64abd1c2eff05ead9d14b410b3c9ae7be";
      hash = "sha256-WJRoS6+NBVJrFmHABEEDpDhW+zbWFUl65AycCkRavfs=";
      sparseCheckout = [
        "common/inc/sgx_report.h"
        "common/inc/sgx_key.h"
        "common/inc/sgx_attributes.h"
      ];
      postFetch = filterSparse sparseCheckout;
    })
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "azure-dcap-client";
  version = "1.13.0-pre0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "azure-dcap-client";
    rev = "839ac4a2acc11b90cb91a483fcfc0cf7ae6a75c7";
    hash = "sha256-dVO5cSOcpkOuxql06exS4aLJgvtRg+Oi6k8HBIjwPlg=";
  };

  patches = [
    # missing `#include <cstdint>`
    ./missing-includes.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    nlohmann_json
    openssl
  ];

  postPatch = ''
    mkdir -p src/Linux/ext/intel
    find -L '${headers}' -type f -exec ln -s {} src/Linux/ext/intel \;

    substitute src/Linux/Makefile{.in,} \
      --replace-fail '##CURLINC##' '${curl.dev}/include/curl/' \
      --replace-fail '$(TEST_SUITE): $(PROVIDER_LIB) $(TEST_SUITE_OBJ)' '$(TEST_SUITE): $(TEST_SUITE_OBJ)'
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  makeFlags = [
    "-C src/Linux"
    "prefix=$(out)"
  ];

  # Online test suite; run with
  # $(nix-build -A sgx-azure-dcap-client.tests.suite)/bin/tests
  passthru.tests.suite = callPackage ./test-suite.nix { };

  meta = {
    description = "Interfaces between SGX SDKs and the Azure Attestation SGX Certification Cache";
    homepage = "https://github.com/microsoft/azure-dcap-client";
    maintainers = with lib.maintainers; [
      phlip9
      veehaitch
    ];
    platforms = [ "x86_64-linux" ];
    license = [ lib.licenses.mit ];
  };
})
