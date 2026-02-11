{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  nix-update-script,
  turingplus,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentxl";
  version = "11.3.7";

  src = fetchFromGitHub {
    owner = "CordyJ";
    repo = "OpenTxl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gh0OEZ5pGhbxDIKYuBLdzUV7Ezn+7elm146ccpJ5bn8=";
  };

  nativeBuildInputs = [ turingplus ];

  # Using -std=gnu89 to prevent errors that occur with default args
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-int-conversion";

  postPatch = ''
    # Replace hardcoded /bin/rm in various files
    find . -type f -exec sed -i 's#/bin/rm#rm#g' {} +

    # Replace hardcoded gcc references
    substituteInPlace src/scripts/c/unix/{txlc,txl2c} \
      --replace-fail gcc '${stdenv.cc}/bin/cc'

    # Replace hardcoded FHS paths
    substituteInPlace src/scripts/c/unix/* src/scripts/t/* \
      --replace-fail '/usr/local/bin' "$out/bin" \
      --replace-fail '/usr/local/lib/txl' "$out/lib"
  '';

  # Generate source files and enter directory
  preBuild = ''
    make csrc
    cd csrc
    makeFlagsArray+=(
      CC="$CC"
      LD="$CC"
    )
  '';

  checkFlags = [ "-C test" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/* $out/bin/
    cp lib/* $out/lib/

    runHook postInstall
  '';

  passthru.tests.factorial = callPackage ./factorial-test.nix { opentxl = finalAttrs.finalPackage; };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source compiler for the Txl language";
    mainProgram = "txl";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    homepage = "https://github.com/CordyJ/OpenTxl";
    downloadPage = "https://github.com/CordyJ/OpenTxl/releases";
    changelog = "https://github.com/CordyJ/OpenTxl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
