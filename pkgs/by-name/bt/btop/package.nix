{
  lib,
  fetchpatch,
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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qXdIk5Mp4Cxy0//e3SwevreK8VcJwz2vUGSX7nrFvxI=";
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

  patches = [
    # https://github.com/aristocratos/btop/issues/1138
    (fetchpatch {
      url = "https://github.com/aristocratos/btop/commit/c3b225f536a263eb6d35708b1057dd4a6f1524a5.patch";
      sha256 = "sha256-I05stm1mkiBpdNIUzL7cwG3kwcKJSHB7FEtnXxKyazQ=";
    })
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

  meta = with lib; {
    description = "Monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      khaneliman
      rmcgibbo
    ];
    mainProgram = "btop";
  };
}
