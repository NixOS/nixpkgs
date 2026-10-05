{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  addDriverRunpath,
  makeWrapper,
  ocl-icd,
  vulkan-loader,
}:

let
  inherit (stdenv.hostPlatform.uname) processor;
  version = "7.0.0";
  sources = {
    "x86_64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-Linux.tar.gz";
      hash = "sha256-lhoArArEMv+mh0dk6GxZ0uCY//ZbWzmLuTgb9/xGyBs=";
    };
    "aarch64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-LinuxARMPreview.tar.gz";
      hash = "sha256-R2/o8XatHnZZr6fKuKW4jMx442ulLfiUe6K2D1zey5w=";
    };
    "riscv64-linux" = {
      url = "https://cdn.geekbench.com/Geekbench-${version}-LinuxRISCVPreview.tar.gz";
      hash = "sha256-AKESobr64A9bgMIb12ej2k+t6c2cEO9BBwv0uGHcBRw=";
    };
  };
  geekbench_avx2 = lib.optionalString stdenv.hostPlatform.isx86_64 "geekbench_avx2";
in
stdenv.mkDerivation {
  inherit version;
  pname = "geekbench";

  __structuredAttrs = true;

  src = fetchurl (
    sources.${stdenv.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")
  );
  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r geekbench.plxr geekbench-workload.plxr geekbench7 geekbench_${processor} ${geekbench_avx2} $out/bin

    for f in geekbench7 geekbench_${processor} ${geekbench_avx2} ; do
      wrapProgram $out/bin/$f \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            addDriverRunpath.driverLink
            ocl-icd
            vulkan-loader
          ]
        }"
    done

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform benchmark";
    homepage = "https://geekbench.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      michalrus
      asininemonkey
    ];
    platforms = builtins.attrNames sources;
    mainProgram = "geekbench7";
  };
}
