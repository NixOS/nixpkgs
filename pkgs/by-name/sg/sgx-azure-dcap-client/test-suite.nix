{
  lib,
  sgx-azure-dcap-client,
  gtest,
  makeWrapper,
}:
sgx-azure-dcap-client.overrideAttrs (old: {
  nativeBuildInputs = old.nativeBuildInputs ++ [
    makeWrapper
    gtest
  ];

  patches = (old.patches or [ ]) ++ [
    # Missing `#include <array>`
    ./tests-missing-includes.patch

    # gtest no longer supports c++14. Use c++17.
    ./tests-cpp-version.patch
  ];

  buildFlags = [
    "tests"
  ];

  installPhase = ''
    runHook preInstall

    install -D ./src/Linux/tests "$out/bin/tests"

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/tests" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ sgx-azure-dcap-client ]}"
  '';
})
