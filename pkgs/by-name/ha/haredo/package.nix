{ lib
, fetchFromSourcehut
, stdenv
, scdoc
, nix-update-script
, makeWrapper
, bash
, buildHarePackage
}:
buildHarePackage (finalAttrs: {
  pname = "haredo";
  version = "1.0.5";

  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~autumnull";
    repo = "haredo";
    rev = finalAttrs.version;
    hash = "sha256-gpui5FVRw3NKyx0AB/4kqdolrl5vkDudPOgjHc/IE4U=";
  };

  nativeBuildInputs = [
    makeWrapper
    scdoc
  ];

  enableParallelChecking = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    hare build -o ./bin/haredo $HAREFLAGS src
    scdoc <./doc/haredo.1.scd >./doc/haredo.1

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    ./bin/haredo ''${enableParallelChecking:+-j$NIX_BUILD_CORES} test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 ./bin/haredo $out/bin/haredo
    install -Dm0644 ./doc/haredo.1 $out/share/man/man1/haredo.1

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/haredo \
      --prefix PATH : "${lib.makeBinPath [bash]}"
  '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple and unix-idiomatic build automator";
    homepage = "https://sr.ht/~autumnull/haredo/";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "haredo";
  };
})
