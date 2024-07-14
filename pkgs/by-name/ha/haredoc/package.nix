{
  lib,
  stdenv,
  scdoc,
  hare,
  hareHook,
}:
stdenv.mkDerivation {
  pname = "haredoc";
  outputs = [
    "out"
    "man"
  ];
  inherit (hare) version src;

  nativeBuildInputs = [
    scdoc
    hareHook
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  buildPhase = ''
    runHook preBuild

    hare build -o haredoc ./cmd/haredoc
    scdoc <docs/haredoc.1.scd >haredoc.1
    scdoc <docs/haredoc.5.scd >haredoc.5

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm0755 ./haredoc $out/bin/haredoc
    install -Dm0644 ./haredoc.1 $out/share/man/man1/haredoc.1
    install -Dm0644 ./haredoc.5 $out/share/man/man5/haredoc.5

    runHook postInstall
  '';

  meta = {
    homepage = "https://harelang.org/";
    description = "Hare's documentation tool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onemoresuza ];
    mainProgram = "haredoc";
    inherit (hareHook.meta) platforms badPlatforms;
  };
}
