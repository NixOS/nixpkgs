{ lib
, python311
, linkFarm
, writers
, writeTextFile
, fetchFromGitHub
, stdenv
, config
, gpuBackend ? (
  if config.cudaSupport
  then "cuda"
  else if config.rocmSupport
  then "rocm"
  else "none"
)
, modelsPath ? "/var/lib/comfyui/models"
, inputPath ? "/var/lib/comfyui/input"
, outputPath ? "/var/lib/comfyui/output"
, customNodes ? []
}:

let
  modelPathsFile = writeTextFile {
    name = "model_paths.yaml";
    text = (lib.generators.toYAML {} {
      comfyui = {
        base_path = modelsPath;
        checkpoints = "${modelsPath}/checkpoints";
        clip = "${modelsPath}/clip";
        clip_vision = "${modelsPath}/clip_vision";
        configs = "${modelsPath}/configs";
        controlnet = "${modelsPath}/controlnet";
        embeddings = "${modelsPath}/embeddings";
        loras = "${modelsPath}/loras";
        upscale_models= "${modelsPath}/upscale_models";
        vae = "${modelsPath}/vae";
        vae_approx = "${modelsPath}/vae_approx";
      };
    });
  };

  pythonEnv = (python311.withPackages (ps: with ps; [
    (
      if gpuBackend == "cuda"
      then torchWithCuda
      else if gpuBackend == "rocm"
      then torchWithRocm
      else torch
    )
    torchsde
    torchvision
    torchaudio
    transformers
    safetensors
    accelerate
    aiohttp
    einops
    pyyaml
    pillow
    scipy
    psutil
    tqdm
  ] ++ (builtins.concatMap (node: node.dependencies) customNodes)));

  executable = writers.writeDashBin "comfyui" ''
    cd $out && ${pythonEnv}/bin/python comfyui "$@"
  '';

  customNodesCollection = (
    linkFarm "comfyui-custom-nodes" (builtins.map (pkg: { name = pkg.pname; path = pkg; }) customNodes)
  );
in stdenv.mkDerivation rec {
  pname = "comfyui";
  version = "unstable-2023-11-19";

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "d9d8702d8dd2337c64610633f5df2dcd402379a8";
    hash = "sha256-icfy14uNqVoaxR8Rqw1d5+k0p3WQYzcGegrgNxt/nOc=";
  };

  installPhase = ''
    runHook preInstall
    echo "Preparing bin folder"
    mkdir -p $out/bin/
    echo "Copying comfyui files"
    cp -r $src/comfy $out/
    cp -r $src/comfy_extras $out/
    cp -r $src/web $out/
    cp -r $src/*.py $out/
    mv $out/main.py $out/comfyui
    echo "Copying ${modelPathsFile} to $out"
    cp ${modelPathsFile} $out/extra_model_paths.yaml
    echo "Setting up input and output folders"
    ln -s ${inputPath} $out/input
    ln -s ${outputPath} $out/output
    echo "Setting up custom nodes"
    ln -s ${customNodesCollection} $out/custom_nodes
    echo "Copying executable script"
    cp ${executable}/bin/comfyui $out/bin/comfyui
    substituteInPlace $out/bin/comfyui --replace "\$out" "$out"
    echo "Patching python code..."
    substituteInPlace $out/folder_paths.py --replace "if not os.path.exists(input_directory):" "if False:"
    substituteInPlace $out/nodes.py --replace "os.listdir(custom_node_path)" "os.listdir(os.path.realpath(custom_node_path))"
    substituteInPlace $out/nodes.py --replace "os.listdir(input_dir)" "os.listdir(os.path.realpath(input_dir))"
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    description = "The most powerful and modular stable diffusion GUI with a graph/nodes interface.";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ fazo96 ];
  };
}
