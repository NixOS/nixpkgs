{
  lib,
  rustPlatform,
  fetchFromGitHub,
  zig_0_16,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "herdr-core";
  version = "0.1.11";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "herdrdev";
    repo = "herdr-core";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-TyGs2nayqd41hbWt42VV5dp29pUNPs+xdBE/h9xkLXc=";
  };

  cargoHash = "sha256-5sRwPq8HqFtqfhJNhSoNbvb1onjLkhMMwjMHyaboYwI=";

  zigDeps = zig_0_16.fetchDeps {
    inherit (finalAttrs) pname version;
    src = "${finalAttrs.src}/vendor/ghostty";
    fetchAll = true;
    hash = "sha256-G9xbZ/pyQTDIfzG0h++i70a45zpwyYpZMBZfAnoOQw0=";
  };

  # Bundled Zig runtimes cause overlapping unwind frames when linked with Rust.
  postPatch = ''
    substituteInPlace vendor/ghostty/src/build/GhosttyLibVt.zig \
      --replace-fail 'lib.bundle_compiler_rt = true;' 'lib.bundle_compiler_rt = false;' \
      --replace-fail 'lib.bundle_ubsan_rt = true;' 'lib.bundle_ubsan_rt = false;'
  '';

  env.ZIG = lib.getExe zig_0_16;

  preBuild = ''
    export ZIG_GLOBAL_CACHE_DIR=$(mktemp -d)
    cp -rL ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
    chmod -R u+w "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  # Tests depend on host process state and paths outside the build sandbox.
  doCheck = false;

  postInstall = ''
    ln -s herdr-core $out/bin/hc
    install -Dm644 LICENSE -t $out/share/licenses/herdr-core
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--custom-dep"
      "zigDeps"
    ];
  };

  meta = {
    description = "Persistent terminal and coding agent backend for Herdr";
    homepage = "https://github.com/herdrdev/herdr-core";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ munksgaard ];
    mainProgram = "hc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
