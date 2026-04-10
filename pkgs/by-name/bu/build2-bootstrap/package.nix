{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  fixDarwinDylibNames,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "build2-bootstrap";
  version = "0.17.0";
  src = fetchurl {
    url = "https://download.build2.org/${finalAttrs.version}/build2-toolchain-${finalAttrs.version}.tar.xz";
    hash = "sha256-NyKonqht90JTnQ+Ru0Qp/Ua79mhVOjUHgKY0EbZIv10=";
  };
  patches = [
    # Pick up sysdirs from NIX_LDFLAGS
    ./nix-ldflags-sysdirs.patch
  ];

  sourceRoot = "build2-toolchain-${finalAttrs.version}/build2";
  makefile = "bootstrap.gmake";
  enableParallelBuilding = true;

  setupHook = ./setup-hook.sh;

  strictDeps = true;

  propagatedBuildInputs = lib.optionals stdenv.targetPlatform.isDarwin [
    fixDarwinDylibNames

    # Build2 needs to use lld on Darwin because it creates thin archives when it detects `llvm-ar`,
    # which ld64 does not support.
    (lib.getBin buildPackages.llvmPackages.lld)
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    build2/b-boot --version
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -D build2/b-boot $out/bin/b
    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/nix-support/setup-hook \
      --subst-var-by isTargetDarwin '${toString stdenv.targetPlatform.isDarwin}'
  '';

  passthru = {
    configSharedStatic =
      enableShared: enableStatic:
      if enableShared && enableStatic then
        "both"
      else if enableShared then
        "shared"
      else if enableStatic then
        "static"
      else
        throw "neither shared nor static libraries requested";
  };

  meta = {
    homepage = "https://www.build2.org/";
    description = "Bootstrap for the 'build2' package, you most likely want to use that one";
    license = lib.licenses.mit;
    changelog = "https://git.build2.org/cgit/build2/tree/NEWS";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      hiro98
      r-burns
    ];
  };
})
