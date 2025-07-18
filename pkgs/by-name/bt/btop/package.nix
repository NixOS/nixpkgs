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
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = "btop";
    rev = "v${version}";
    hash = "sha256-4H9UjewJ7UFQtTQYwvHZL3ecPiChpfT6LEZwbdBCIa0=";
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

  # fix build on darwin (see https://github.com/NixOS/nixpkgs/pull/422218#issuecomment-3039181870 and https://github.com/aristocratos/btop/pull/1173)
  cmakeFlags = [
    (lib.cmakeBool "BTOP_LTO" (!stdenv.hostPlatform.isDarwin))
  ];

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
