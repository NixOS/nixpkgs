{
  lib,
  stdenv,
  fetchFromGitHub,

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
  ];
  buildInputs = [
    s7
    tbox
    isocline
  ]
  ++ lib.optional stdenv.hostPlatform.isMinGW windows.pthreads;

  env.NIX_LDFLAGS = toString (
    lib.optionals stdenv.hostPlatform.isMinGW [
      "-lpthread"
      "-lws2_32"
    ]
  );

  configurePhase = ''
    runHook preConfigure
    export HOME=$(mktemp -d)
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

    # workaround for xmake cannot use system deps
    # when cross platform was set
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
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    maintainers = with lib.maintainers; [ jinser ];
  };
})
