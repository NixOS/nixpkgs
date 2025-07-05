{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  autoAddDriverRunpath,
  apple-sdk_15,
  versionCheckHook,
  rocmPackages,
  cudaSupport ? config.cudaSupport,
  rocmSupport ? config.rocmSupport,
}:

stdenv.mkDerivation rec {
  pname = "btop";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = "btop";
    rev = "v${version}";
    hash = "sha256-4x2vGmH2dfHZHG+zj2KGsL/pRNIZ8K8sXYRHy0io5IE=";
  };

  nativeBuildInputs =
    [
      cmake
    ]
    ++ lib.optionals cudaSupport [
      autoAddDriverRunpath
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_15
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  postPhases = lib.optionals rocmSupport [ "postPatchelf" ];
  postPatchelf = lib.optionalString rocmSupport ''
    patchelf --add-rpath ${lib.getLib rocmPackages.rocm-smi}/lib $out/bin/btop
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      khaneliman
      rmcgibbo
      ryan4yin
    ];
    mainProgram = "btop";
  };
}
