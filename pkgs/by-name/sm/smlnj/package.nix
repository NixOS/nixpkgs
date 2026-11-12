{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchurl,
  automake,
  autoconf,
  cmake,
  coreutils,
  gnugrep,
  gnused,
  gawk,
  versionCheckHook,
  bashInteractive,
}:
let
  version = "2026.3";
  src = fetchFromGitHub {
    owner = "smlnj";
    repo = "smlnj";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-DnKvuo+35P8npuc9hwN+eBWsOBVfTxL4mk4mzcYwBtk=";
  };

  llvm = callPackage ./llvm.nix { inherit src version; };

  bootFile =
    if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isx86_64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.amd64-unix.tgz";
        hash = "sha256-TaW+EBUPZJx5fI/rZD/RD251bS2mWd++r24SwAARopQ=";
      }
    else if stdenv.hostPlatform.isUnix && stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/boot.arm64-unix.tgz";
        hash = "sha256-54JTOkRyD3qojwH5L1hxiC/ECmzVA9OHAvb6ABZjW7o=";
      }
    else
      throw "Unsupported host platform: ${stdenv.hostPlatform.config}";

in
stdenv.mkDerivation {
  pname = "smlnj";
  inherit src version;

  nativeBuildInputs = [
    autoconf
    automake
    cmake
  ];

  __structuredAttrs = true;
  strictDeps = true;

  dontUseCmakeConfigure = true;

  postPatch = ''
    substituteInPlace config/_ml-build \
      --replace-fail '#!@SHELL@' '#!${lib.getExe bashInteractive}'
  '';

  buildPhase = ''
    runHook preBuild

    unpackFile ${bootFile}
    mkdir -pv $out/bin $out/lib bin lib
    ln -s ${llvm}/bin/llvm-config     bin/llvm-config
    ln -s ${llvm}/bin/llvm-config     $out/bin/llvm-config
    ln -s ${llvm}/lib/libCFGCodeGen.a lib/libCFGCodeGen.a
    ln -s ${llvm}/lib/libCFGCodeGen.a $out/lib/libCFGCodeGen.a

    ./build.sh -install $out

    rm $out/bin/llvm-config $out/lib/libCFGCodeGen.a $out/bin/heap2exec

    runHook postBuild
  '';

  postInstall = ''
    substituteInPlace $out/bin/.run-sml \
      --replace-fail basename ${lib.getExe' coreutils "basename"} \
      --replace-fail grep ${lib.getExe gnugrep} \
      --replace-fail sed ${lib.getExe gnused}
    substituteInPlace $out/bin/ml-build \
      --replace-fail basename ${lib.getExe' coreutils "basename"} \
      --replace-fail cat ${lib.getExe' coreutils "cat"}
    substituteInPlace $out/bin/ml-makedepend \
      --replace-fail rm ${lib.getExe' coreutils "rm"} \
      --replace-fail cat ${lib.getExe' coreutils "cat"} \
      --replace-fail awk ${lib.getExe gawk}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "@SMLversion";
  doInstallCheck = true;

  passthru.llvm = llvm;

  meta = {
    description = "Standard ML of New Jersey, a Standard ML compiler";
    homepage = "https://smlnj.org";
    downloadPage = "https://smlnj.org/dist/working/${version}/install.html";
    changelog = "https://smlnj.org/dist/working/${version}/README.html";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = [ lib.maintainers.skyesoss ];
    mainProgram = "sml";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    broken = !(stdenv.buildPlatform.canExecute stdenv.hostPlatform);
  };
}
