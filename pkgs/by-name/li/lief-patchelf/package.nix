{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  rustPlatform,
  installShellFiles,
  versionCheckHook,
}:

let
  version = "0.17.6";

  # lief-ffi downloads this at build time via lief-build, we prefetch
  # it and point LIEF_RUST_PRECOMPILED at the result.
  # https://github.com/lief-project/LIEF/blob/d336834b11521ad1a93694f9f8f008149444f7c3/doc/sphinx/api/rust/index.rst#precompiled-ffi-bindings
  lief-rs = fetchzip {
    url = "https://github.com/lief-project/LIEF/releases/download/${version}/LIEF-rs-${stdenv.hostPlatform.rust.rustcTarget}.zip";
    hash =
      {
        x86_64-linux = "sha256-zrSYfuIwlcmJ7dvRHq7ybyYKsBpiDMM8NG+0e1cFqS0=";
        aarch64-linux = "sha256-bpGlvPry9exMNMKzWkz8VUpFqxIZnLvJFKy49HW1uME=";
        x86_64-darwin = "sha256-Kb5R42SMelP6ShC5QuN7nRSvkndgUgxyL6EiBY4Jr+s=";
        aarch64-darwin = "sha256-EjU2I4iNSLB8oP3VKEZHrkVVTJ3SLXLSHG4wrMlQ6Og=";
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    stripRoot = false;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lief-patchelf";
  inherit version;

  src = fetchFromGitHub {
    owner = "lief-project";
    repo = "LIEF";
    tag = version;
    hash = "sha256-WcWKGIQIGngfzW+VnrZEnRPX2w4syNw+so2aqwSgecw=";
  };

  sourceRoot = "${finalAttrs.src.name}/tools";

  cargoHash = "sha256-Ht1DKFLveye5/qaIYAHZ4cP55nvPqJfpguFr/b/Yheg=";

  env.LIEF_RUST_PRECOMPILED = "${lief-rs}";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lief-patchelf \
      --bash <($out/bin/lief-patchelf --generate bash) \
      --fish <($out/bin/lief-patchelf --generate fish) \
      --zsh <($out/bin/lief-patchelf --generate zsh)

    $out/bin/lief-patchelf --generate-manpage lief-patchelf.1
    installManPage lief-patchelf.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Patchelf based on LIEF";
    homepage = "https://lief.re/doc/latest/tools/lief-patchelf/index.html";
    changelog = "https://github.com/lief-project/LIEF/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ eilvelia ];
    mainProgram = "lief-patchelf";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
