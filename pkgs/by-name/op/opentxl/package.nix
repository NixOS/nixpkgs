{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  turingplus,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentxl";
  version = "11.3.6";

  src = fetchFromGitHub {
    owner = "CordyJ";
    repo = "OpenTxl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dLn8UVO9Wx/1Ubiy2issLDchqSNMhqrWGA0DvCekRV8=";
  };

  nativeBuildInputs = [
    turingplus
  ];

  # Using -std=gnu89 to prevent errors that occur with default args
  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    # Replace hardcoded /bin/rm in various files
    find . -type f -exec sed -i 's#/bin/rm#rm#g' {} +
  '';

  buildPhase = ''
    runHook preBuild

    make csrc
    cd csrc
    make

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    make -j$NIX_BUILD_CORES -C test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/* $out/bin/
    cp lib/* $out/lib/

    runHook postInstall
  '';

  passthru.tests.factorial = callPackage ./factorial-test.nix { opentxl = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Open-source compiler for the Txl language";
    mainProgram = "txl";
    platforms = [ "x86_64-linux" ];
    homepage = "https://github.com/CordyJ/OpenTxl";
    downloadPage = "https://github.com/CordyJ/OpenTxl/releases";
    changelog = "https://github.com/CordyJ/OpenTxl/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ MysteryBlokHed ];
  };
})
