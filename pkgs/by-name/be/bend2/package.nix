{
  lib,
  stdenvNoCC,
  fetchurl,
  bun,
  llvmPackages,
  makeWrapper,
  symlinkJoin,
  versionCheckHook,
  config,
  cudaSupport ? config.cudaSupport,
  cudaPackages,
  addDriverRunpath,
  apple-sdk_15,
  writeShellScript,
  curl,
  jq,
  nix-update,
}:

let
  # bend -o wants one CUDA root with include/ and lib/, as /usr/local/cuda
  cuda = symlinkJoin {
    name = "bend2-cuda";
    paths = with cudaPackages; [
      cuda_cudart
      cuda_nvrtc.include
      cuda_nvrtc.lib
    ];
  };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bend2";
  version = "2.0.5";

  src = fetchurl {
    url = "https://bend-lang.com/dl/${finalAttrs.version}.tar.gz";
    hash = "sha256-TbcOd84bECfx0OFd7gJZIfp5SptBWt1DUOx8ZKzyd1s=";
  };

  sourceRoot = ".";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  makeWrapperArgs = [
    "--add-flags"
    "${placeholder "out"}/share/bend2/bend2/main.ts"
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ llvmPackages.clang ])
  ]
  ++ lib.optionals cudaSupport [
    "--set-default"
    "CUDA_HOME"
    "${cuda}"
    "--prefix"
    "LIBRARY_PATH"
    ":"
    "${addDriverRunpath.driverLink}/lib"
  ]
  # the Metal lane of `bend -o` uses MTLCompileOptions.mathMode, a macOS 15
  # API: the clang wrapper takes its SDK from DEVELOPER_DIR and makes an
  # unguarded use past the deployment target an error, so both move to 15
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    "--set"
    "DEVELOPER_DIR"
    "${apple-sdk_15}"
    "--set"
    "MACOSX_DEPLOYMENT_TARGET"
    "15.0"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bend2 $out/bin
    cp -r bend2 guide $out/share/bend2/
    makeWrapper ${lib.getExe bun} $out/bin/bend "''${makeWrapperArgs[@]}"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # upstream tags no releases; its manifest names the latest one
  passthru.updateScript = writeShellScript "update-bend2" ''
    set -euo pipefail
    version=$(${lib.getExe curl} -fsSL https://bend-lang.com/dl/latest.json | ${lib.getExe jq} -r .ver)
    ${lib.getExe nix-update} bend2 --version "$version"
  '';

  meta = {
    description = "Dependently typed, affine language that verifies proofs and runs on CPU threads and GPUs";
    homepage = "https://bend-lang.com";
    license = lib.licenses.asl20;
    mainProgram = "bend";
    maintainers = with lib.maintainers; [ reu ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
