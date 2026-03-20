{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  nix-update-script,
  runtimeShellPackage,
}:
let
  osOption =
    platform:
    if platform.isDarwin then
      "Darwin"
    else if platform.isCygwin then
      "CYGWIN"
    else if platform.isWindows then
      "MSYS"
    else
      "Linux";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opentxl";
  version = "11.3.7";
  strictDeps = true;

  # The code generation part of the upstream build system relies on an x86-only binary,
  # so the generated code is fetched from the GitHub release instead
  src = fetchurl {
    url = "https://github.com/CordyJ/OpenTxl/releases/download/v${finalAttrs.version}/OpenTxl-${finalAttrs.version}-csrc.tar.gz";
    hash = "sha256-qIvxQqo1yCVJImjUvNNinzhoywVgaq9s0E+Ab+QStc0=";
  };

  # Required for patchShebangs to find the right shell for runtime scripts.
  # Optional check is to make sure that it is not added on platforms
  # that can't run a POSIX shell (e.g. MinGW)
  buildInputs = lib.optional (lib.meta.availableOn stdenv.hostPlatform runtimeShellPackage) runtimeShellPackage;

  # Using -std=gnu89 to prevent errors that occur with default args
  env.NIX_CFLAGS_COMPILE = "-std=gnu89 -Wno-int-conversion";

  patches = [
    ./fix-cross.patch
  ];

  postPatch = ''
    # Replace hardcoded FHS paths in various files
    find . -type f -exec sed -i \
      -e 's#/bin/mv#mv#g' \
      -e 's#/bin/rm#rm#g' \
      -e "s#/usr/local/bin#$out/bin#g" \
      -e "s#/usr/local/lib/txl#$out/lib#g" \
      {} +
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
    "STRIP=${stdenv.cc.targetPrefix}strip"
    "EXE=${stdenv.hostPlatform.extensions.executable}"
    "OS=${osOption stdenv.hostPlatform}"
  ];

  checkFlags = [ "-C test" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/* $out/bin/
    cp lib/* $out/lib/

    runHook postInstall
  '';

  passthru = {
    inherit osOption;
    tests.factorial = callPackage ./factorial-test.nix { opentxl = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open-source compiler for the Txl language";
    mainProgram = "txl";
    homepage = "https://github.com/CordyJ/OpenTxl";
    downloadPage = "https://github.com/CordyJ/OpenTxl/releases";
    changelog = "https://github.com/CordyJ/OpenTxl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
})
