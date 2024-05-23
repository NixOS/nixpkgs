{
  stdenv,
  lib,
  fetchFromSourcehut,
  hare,
  scdoc,
  nix-update-script,
  makeWrapper,
  bash,
  substituteAll,
}:
let
  arch = stdenv.hostPlatform.uname.processor;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "haredo";
  version = "1.0.5";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "haredo";
    rev = finalAttrs.version;
    hash = "sha256-gpui5FVRw3NKyx0AB/4kqdolrl5vkDudPOgjHc/IE4U=";
  };

  patches = [
    # Use nix store's bash instead of sh. `@bash@/bin/sh` is used, since haredo expects a posix shell.
    (substituteAll {
      src = ./001-use-nix-store-sh.patch;
      inherit bash;
    })
  ];

  nativeBuildInputs = [
    hare
    makeWrapper
    scdoc
  ];

  enableParallelChecking = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  dontConfigure = true;

  preBuild = ''
    HARECACHE="$(mktemp -d)"
    export HARECACHE
    export PREFIX=${builtins.placeholder "out"}
  '';

  buildPhase = ''
    runHook preBuild

    hare build -o bin/haredo -qRa${arch} ./src
    scdoc <doc/haredo.1.scd >doc/haredo.1

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ./bin/haredo ''${enableParallelChecking:+-j$NIX_BUILD_CORES} test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp ./bin/haredo $out/bin
    cp ./doc/haredo.1 $out/share/man/man1

    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple and unix-idiomatic build automator";
    homepage = "https://sr.ht/~autumnull/haredo/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "haredo";
    inherit (hare.meta) platforms badPlatforms;
  };
})
