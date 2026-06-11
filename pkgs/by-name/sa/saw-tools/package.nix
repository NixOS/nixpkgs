{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  gmp,
  ncurses,
  zlib,
  readline,
  testers,
}:

let
  sources = import ./sources.nix;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "saw-tools";
  version = "1.5";

  src = fetchurl sources.${stdenv.hostPlatform.system};

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gmp
    ncurses
    readline
    stdenv.cc.libc
    zlib
  ];

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ [
      makeWrapper
    ];

  installPhase = ''
    mkdir -p $out/lib $out/share

    mv bin $out/bin
    mv doc $out/share

    wrapProgram "$out/bin/saw" --prefix PATH : "$out/bin/"
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "saw --version";
  };

  meta = {
    description = "Tools for software verification and analysis";
    homepage = "https://tools.galois.com/saw";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.bsd3;
    platforms = lib.attrNames sources;
    maintainers = with lib.maintainers; [
      thoughtpolice
      thelissimus
    ];
    mainProgram = "saw";
  };
})
