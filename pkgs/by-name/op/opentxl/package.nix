{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opentxl";
  version = "11.3.7";

  # The code generation part of the upstream build system relies on an x86-only binary,
  # so the generated code is fetched from the GitHub release instead
  src = fetchurl {
    url = "https://github.com/CordyJ/OpenTxl/releases/download/v${finalAttrs.version}/OpenTxl-${finalAttrs.version}-csrc.tar.gz";
    hash = "sha256-qIvxQqo1yCVJImjUvNNinzhoywVgaq9s0E+Ab+QStc0=";
  };

  # Using -std=gnu89 to prevent errors that occur with default args
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-int-conversion";

  postPatch = ''
    # Replace hardcoded FHS paths in various files
    find . -type f -exec sed -i \
      -e 's#/bin/mv#mv#g' \
      -e 's#/bin/rm#rm#g' \
      -e "s#/usr/local/bin#$out/bin#g" \
      -e "s#/usr/local/lib/txl#$out/lib#g" \
      {} +

    # Replace hardcoded gcc references
    substituteInPlace scripts/unix/{txlc,txl2c} \
      --replace-fail gcc '${stdenv.cc}/bin/cc'
  '';

  preBuild = ''
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
    platforms = lib.platforms.unix;
    homepage = "https://github.com/CordyJ/OpenTxl";
    downloadPage = "https://github.com/CordyJ/OpenTxl/releases";
    changelog = "https://github.com/CordyJ/OpenTxl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
