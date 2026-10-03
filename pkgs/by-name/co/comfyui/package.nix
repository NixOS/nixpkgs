{
  lib,
  cudaPackages_13_3,
  common-updater-scripts,
  # "cpu" pins the CPU torch flavour; "cuda" substitutes the prebuilt CUDA
  # wheels, which are unfree and Linux-only but avoid a multi-hour torch build
  # against the pinned cudaPackages.
  acceleration ? "cpu",
  extraPackages ? (ps: [ ]),
  fetchFromGitHub,
  gnutar,
  gzip,
  nix-update,
  makeBinaryWrapper,
  python3,
  stdenvNoCC,
  # Deliberately not named `cudaPackages`: callPackage supplies any argument
  # whose name is a top-level attribute, so that spelling would silently
  # resolve to the default cudaPackages (12.9) and this default would never
  # apply.
  # TODO: cuda-bindings has no 13.4 entry yet, so pin the newest 13.x it
  # supports. Bump this to cudaPackages_13 once cuda-bindings gains 13_4.
  torchCudaPackages ? cudaPackages_13_3,
  writeShellApplication,
  yq-go,
}:

let
  # Using overrideScope does not work when using `withPackages appDependencies`
  # and creates a an env without those overrides
  python = python3.override (old: {
    self = python;
    # Compose with the caller's overrides rather than replacing them, so a
    # `python3` passed in from outside (one providing torch-bin, say) survives.
    # The caller runs first and supplies the base package; the CUDA pin below
    # is applied on top of it and stays in effect unless torchCudaPackages is
    # overridden too.
    packageOverrides = lib.composeExtensions (old.packageOverrides or (_: _: { })) (
      final: prev:
      let
        cuda = acceleration == "cuda";
        # Every attribute that takes a cudaPackages has to carry the same value:
        # the prebuilt torchvision/torchaudio resolve `torch-bin` from this set,
        # so an unpinned `torch-bin` would be built against the default
        # cudaPackages (12.9) and fail the cuda-bindings >= 13.0.3 check.
        pin = pkg: pkg.override { cudaPackages = torchCudaPackages; };
        torchPkg = if cuda then prev.torch-bin else prev.torch.override { cudaSupport = false; };
        tritonPkg = if cuda then prev.triton-bin else prev.triton.override { cudaSupport = false; };
      in
      {
        # older cudaPackages are not supported and actively disabled
        # https://github.com/Comfy-Org/ComfyUI/blob/v0.27.0/comfy/quant_ops.py#L25
        torch = pin torchPkg;
        triton = pin tritonPkg;
        torchvision = if cuda then pin prev.torchvision-bin else prev.torchvision;
        torchaudio = if cuda then pin prev.torchaudio-bin else prev.torchaudio;
        # Pinned so that anything resolving `torch-bin` (or the other bin
        # attributes) from this set gets the same cudaPackages; see the `pin`
        # comment above.
        torch-bin = pin prev.torch-bin;
        triton-bin = pin prev.triton-bin;
        torchvision-bin = pin prev.torchvision-bin;
        torchaudio-bin = pin prev.torchaudio-bin;
        # comfy-kitchen needs `torch.cudaPackages` and `torch.cudaCapabilities`,
        # which the prebuilt torch does not expose, so it is built without its
        # CUDA kernels.
        comfy-kitchen = prev.comfy-kitchen.override { cudaSupport = false; };
      }
    );
  });

  appDependencies =
    ps:
    with ps;
    [
      aiohttp
      alembic
      av
      blake3
      comfy-aimdo
      comfy-angle
      comfy-kitchen
      comfyui-embedded-docs
      comfyui-frontend-package
      comfyui-workflow-templates
      einops
      filelock
      kornia
      numpy
      pillow
      psutil
      pydantic
      pydantic-settings
      pyopengl
      pyyaml
      requests
      safetensors
      scipy
      sentencepiece
      simpleeval
      spandrel
      sqlalchemy
      tokenizers
      torch
      torchaudio
      torchsde
      torchvision
      tqdm
      transformers
      yarl
    ]
    ++ (extraPackages ps);

  pythonEnv = python.withPackages appDependencies;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "comfyui";
  version = "0.37.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Comfy-Org";
    repo = "ComfyUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hfpoQsu8xzKHCy2Qqw2BMGsorwizJEuhKXWjUUJzTHs=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  patches = [ ./use-writable-runtime-paths.patch ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/comfyui $out/bin
    cp -r . $out/share/comfyui

    makeBinaryWrapper ${lib.getExe pythonEnv} $out/bin/comfyui \
      --add-flag "$out/share/comfyui/main.py" \
      --unset NIX_PYTHONPATH \
      --unset PYTHONPATH

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    PYTHONPATH=${pythonEnv}/${python.sitePackages} ${lib.getExe python.pkgs.pip} install --break-system-packages --dry-run --no-index -r requirements.txt
    "$out"/bin/comfyui --help
    export XDG_DATA_HOME="$(mktemp -d)"
    "$out"/bin/comfyui --cpu --quick-test-for-ci

    runHook postInstallCheck
  '';

  passthru = {
    inherit python pythonEnv;

    updateScript = lib.getExe (writeShellApplication {
      name = "update-comfyui";
      runtimeInputs = [
        common-updater-scripts
        gnutar
        gzip
        nix-update
        yq-go
      ];
      text = ''
        nix-update comfyui

        src=$(nix-build --no-out-link -A comfyui.src)

        while IFS= read -r requirement; do
          if [[ $requirement =~ ^comfy.+==.+ ]]; then
            pkg=''${requirement%%==*}
            version=''${requirement##*==}

            nix-update "python3Packages.$pkg" --version "$version"

            if [[ $pkg == comfyui-workflow-templates ]]; then
              wtSrc=$(nix-build --no-out-link -A python3Packages.comfyui-workflow-templates.src)

              while IFS= read -r subRequirement; do
                if [[ $subRequirement =~ ^comfyui-workflow-templates-.+==.+ ]]; then
                  subPkg=''${subRequirement%%==*}
                  subVersion=''${subRequirement##*==}

                  nix-update "python3Packages.$subPkg" --version "$subVersion"
                fi
              done < <(
                tar --extract --gzip --to-stdout --file="$wtSrc" --strip-components=1 --wildcards '*/pyproject.toml' \
                  | yq --input-format toml --output-format yaml '.project.dependencies[]'
              )
            fi
          fi
        done < "$src/requirements.txt"
      '';
    });
  };

  meta = {
    description = "Modular diffusion model GUI, API, and backend with graph and nodes interface";
    homepage = "https://github.com/Comfy-Org/ComfyUI";
    changelog = "https://github.com/Comfy-Org/ComfyUI/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "comfyui";
    maintainers = with lib.maintainers; [
      caniko
      knightfemale
      SuperSandro2000
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
