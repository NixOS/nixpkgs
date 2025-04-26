{
  lib,
  python312,
  linkFarm,
  writeShellScriptBin,
  writeTextFile,
  fetchFromGitHub,
  stdenv,
  basePath ? "/var/lib/comfyui",
  customNodes ? [ ],
}:

let
  modelsPath = "${basePath}/models";
  inputPath = "${basePath}/input";
  outputPath = "${basePath}/output";
  tempPath = "${basePath}/temp";
  userPath = "${basePath}/user";
  config-data = {
    comfyui = {
      base_path = modelsPath;
      checkpoints = "${modelsPath}/checkpoints";
      clip = "${modelsPath}/clip";
      clip_vision = "${modelsPath}/clip_vision";
      configs = "${modelsPath}/configs";
      controlnet = "${modelsPath}/controlnet";
      diffusion_models = "${modelsPath}/diffusion_models";
      embeddings = "${modelsPath}/embeddings";
      loras = "${modelsPath}/loras";
      style_models = "${modelsPath}/style_models";
      text_encoders = "${modelsPath}/text_encoders";
      upscale_models = "${modelsPath}/upscale_models";
      vae = "${modelsPath}/vae";
      vae_approx = "${modelsPath}/vae_approx";
    };
  };

  modelPathsFile = writeTextFile {
    name = "extra_model_paths.yaml";
    text = lib.generators.toYAML { } config-data;
  };

  pythonEnv = (
    python312.withPackages (
      ps:
      with ps;
      [
        comfyui-frontend-package
        comfyui-workflow-templates
        torch
        torchsde
        torchvision
        torchaudio
        numpy
        einops
        transformers
        tokenizers
        sentencepiece
        safetensors
        aiohttp
        yarl
        pyyaml
        pillow
        scipy
        tqdm
        psutil

        kornia
        spandrel
        av
        pydantic
      ]
      ++ (builtins.concatMap (node: node.dependencies) customNodes)
    )
  );

  executable = writeShellScriptBin "comfyui" ''
    cd $out && \
    ${pythonEnv}/bin/python comfyui \
      --input-directory ${inputPath} \
      --output-directory ${outputPath} \
      --extra-model-paths-config ${modelPathsFile} \
      --temp-directory ${tempPath} \
      "$@"
  '';

  customNodesCollection = (
    linkFarm "comfyui-custom-nodes" (
      builtins.map (pkg: {
        name = pkg.pname;
        path = pkg;
      }) customNodes
    )
  );
in
stdenv.mkDerivation rec {
  pname = "comfyui";
  version = "0-unstable-2025-04-26";

  src = fetchFromGitHub {
    owner = "comfyanonymous";
    repo = "ComfyUI";
    rev = "b685b8a4e098237919adae580eb29e8d861b738f";
    hash = "sha256-OtTvyqiz2Ba7HViW2MxC1hFulSWPuQaCADeQflr80Ik=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/
    # These copies everything over but test/ci/github directories.  But it's not
    # very future-proof.  This can lead to errors such as "ModuleNotFoundError:
    # No module named 'app'" when new directories get added (which has happened
    # at least once).  Investigate if we can just copy everything.
    cp -r $src/app $out/
    cp -r $src/api_server $out/
    cp -r $src/comfy $out/
    cp -r $src/comfy_api_nodes $out/
    cp -r $src/comfy_extras $out/
    cp -r $src/comfy_execution $out/
    cp -r $src/utils $out/
    cp $src/*.py $out/
    mv $out/main.py $out/comfyui
    cp ${modelPathsFile} $out/extra_model_paths.yaml
    ln -s ${inputPath} $out/input
    ln -s ${outputPath} $out/output
    mkdir -p $out/${tempPath}
    ln -snf ${customNodesCollection} $out/custom_nodes
    cp ${executable}/bin/comfyui $out/bin/comfyui
    substituteInPlace $out/bin/comfyui --replace "\$out" "$out"
    substituteInPlace $out/folder_paths.py \
      --replace 'os.path.join(base_path, "temp")' '"${tempPath}"' \
      --replace 'os.path.join(base_path, "user")' '"${userPath}"'

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/comfyanonymous/ComfyUI";
    description = "The most powerful and modular stable diffusion GUI with a graph/nodes interface.";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ scd31 ];
  };
}
