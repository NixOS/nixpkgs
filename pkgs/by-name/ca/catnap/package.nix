{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  nixosTests,
  installShellFiles,
  writableTmpDirAsHomeHook,

  nim,
  curl,
  gzip,
  gitMinimal,
  viu,
  figlet,
  pcre2,
  usbutils,
  pciutils,
}:
# buildNimPackage doesn't work because there is no .nimble file
stdenv.mkDerivation (finalAttrs: {
  pname = "catnap";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "iinsertNameHere";
    repo = "catnap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/bZPrM+HpIcRPlUStDIBaU8ls9+S5g6XBSev4n00hw=";
  };

  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    cp ${./fallback-config.patch} fallback-config.patch
    substituteInPlace fallback-config.patch \
      --replace-fail '@out@' "$out"
    patch -p1 < ./fallback-config.patch
  '';

  nativeBuildInputs = [
    gzip
    nim
    gitMinimal
    makeWrapper
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  runtimeDependencies = [
    pcre2
    usbutils
    figlet
    viu
    curl
    pciutils
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/bin $out/share $testsout
    nim release
    cp bin/catnap $out/bin
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    installManPage docs/catnap.1 docs/catnap.5
    wrapProgram $out/bin/catnap \
      --set PATH ${lib.makeBinPath finalAttrs.runtimeDependencies}
    cp -r config $out/share
    sed -i "s|./../bin/catnap|$out/bin/catnap|g" scripts/test-commandline-args.sh
    sed -i "s|../config|$out/share/config|g" scripts/test-commandline-args.sh
    sed -i "s|./test_config.toml|$testsout/scripts/test_config.toml|g" scripts/test-commandline-args.sh
    cp -R scripts $testsout
    runHook postInstall
  '';

  outputs = [
    "out"
    "testsout"
  ];

  # Tests don't run inside the sandbox they need a nixos system
  doCheck = false; # false is the default
  passthru.tests.nixosTest = nixosTests.catnap;

  meta = {
    description = "A highly customizable systemfetch written in nim";
    homepage = "https://github.com/iinsertNameHere/catnap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "catnap";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
