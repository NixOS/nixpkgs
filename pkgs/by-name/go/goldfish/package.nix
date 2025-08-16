{
  lib,
  stdenv,
  fetchFromGitHub,
  xmake,
  s7,
  tbox,
  writers,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "goldfish";
  version = "17.11.17";

  src = fetchFromGitHub {
    owner = "XmacsLabs";
    repo = "goldfish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zli5n7SJgs4Kk9LFVi/LqV37YrjWM+2NH2bUwon4U2c=";
  };

  nativeBuildInputs = [
    xmake
    # make xmake happy
    (writers.writeBashBin "git" "exit 0")
  ];
  buildInputs = [
    s7
    tbox
    readline
  ];

  patches = [ ./unpin-deps.patch ];

  configurePhase = ''
    runHook preConfigure
    export HOME=$(mktemp -d)
    xmake global --network=private
    xmake config -m release --verbose --yes --diagnosis
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    xmake build --yes -j $NIX_BUILD_CORES goldfish
    xmake build --yes -j $NIX_BUILD_CORES goldfish_repl
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    xmake install -o $out goldfish
    xmake install -o $out goldfish_repl
    runHook postInstall
  '';

  meta = {
    description = "R7RS-small scheme implementation based on s7 scheme";
    homepage = "https://gitee.com/XmacsLabs/goldfish";
    license = lib.licenses.asl20;
    mainProgram = "goldfish";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jinser ];
  };
})
