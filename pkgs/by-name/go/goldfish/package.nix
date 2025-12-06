{
  lib,
  stdenv,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  buildPackages,
  windows,

  s7,
  tbox,
  isocline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goldfish";
  version = "17.11.20";

  src = fetchFromGitHub {
    owner = "XmacsLabs";
    repo = "goldfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eRo7H2z+389kQs0X1XX7nN+uVaSkU2Nr+Q98RoCz6uw=";
  };

  nativeBuildInputs = with buildPackages; [
    xmake
    # make xmake happy
    (writers.writeBashBin "git" "exit 0")
    writableTmpDirAsHomeHook
  ];
  buildInputs = [
    s7
    tbox
    isocline
  ]
  ++ lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  env.NIX_LDFLAGS = lib.escapeShellArgs (
    lib.optionals stdenv.hostPlatform.isMinGW [
      "-lpthread"
      "-lws2_32"
    ]
  );

  configurePhase = ''
    runHook preConfigure
    xmake global --network=private
    xmake config -m release --yes -vD \
      --repl=y --ccache=n             \
      --system-deps=y --pin-deps=n    \
    ${lib.optionalString stdenv.hostPlatform.isMinGW ''
      --toolchain=mingw --mingw=${stdenv.cc.outPath}
    ''}
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    xmake build --yes -j $NIX_BUILD_CORES -vD goldfish
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # On MinGW, xmake builds 'goldfish.exe', but expects 'goldfish' for install.
    # Rename for xmake install, then rename back for Windows conventions.
    ${lib.optionalString stdenv.hostPlatform.isMinGW ''
      mv bin/goldfish.exe bin/goldfish
    ''}
    xmake install -vD -o $out goldfish
    ${lib.optionalString stdenv.hostPlatform.isMinGW ''
      mv $out/bin/goldfish $out/bin/goldfish.exe
    ''}

    runHook postInstall
  '';

  meta = {
    description = "R7RS-small scheme implementation based on s7 scheme";
    homepage = "https://gitee.com/XmacsLabs/goldfish";
    license = lib.licenses.asl20;
    mainProgram = "goldfish";
    # Do not use `with lib.platforms`,
    # since the outer environment already has a `windows` variable
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ jinser ];
  };
})
