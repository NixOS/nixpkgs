{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  gcc,
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

  postPatch = ''
    # Replace hardcoded /bin/rm in various files
    find . -type f -exec sed -i 's#/bin/rm#rm#g' {} +
  '';

  buildPhase = ''
    make csrc
    cd csrc
    # Using -std=gnu89 to prevent errors that occur with default args
    make CC='gcc -std=gnu89 -w -Wno-error=int-conversion'
  '';

  checkPhase = ''
    cd test
    make
    cd -
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp bin/* $out/bin/
    cp lib/* $out/lib/
  '';

  passthru.tests.factorial = callPackage ./factorial-test.nix { opentxl = finalAttrs.finalPackage; };

  meta = with lib; {
    description = "Open-source compiler for the Txl language";
    mainProgram = "txl";
    platforms = platforms.all;
    homepage = "https://github.com/CordyJ/OpenTxl";
    downloadPage = "https://github.com/CordyJ/OpenTxl/releases";
    changelog = "https://github.com/CordyJ/OpenTxl/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ MysteryBlokHed ];
  };
})
