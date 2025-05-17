{
  lib,
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  khronos-ocl-icd-loader,
  libgcc,
}:

stdenvNoCC.mkDerivation rec {
  pname = "geekbench-ai";
  version = "1.1.0";

  src = fetchzip {
    url = "https://cdn.geekbench.com/GeekbenchAI-1.1.0-Linux.tar.gz";
    hash = "sha256-0WwdisukTrKjGgmxJAs324vtwhyJ1oxFhWpd+GQ1CGA=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    khronos-ocl-icd-loader
    libgcc.lib
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    for file in $(find . -type f); do
      if [[ $file == *".so"* ]]; then
        cp $file $out/lib
      else
        cp $file $out/bin
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Cross-platform AI benchmark using real-world machine learning tasks to evaluate AI workload performance";
    homepage = "https://www.geekbench.com/ai/";
    mainProgram = "banff";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
