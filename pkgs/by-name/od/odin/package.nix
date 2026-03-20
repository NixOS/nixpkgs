{
  lib,
  llvmPackages_18,
  fetchFromGitHub,
  fetchurl,
  makeBinaryWrapper,
  which,
  cmake,
  nix-update-script,
  enableBox2d ? true,
}:

let
  llvmPackages = llvmPackages_18;
  inherit (llvmPackages) stdenv;
  box2dVersion = "3.1.1";
  box2dTarball =
    if enableBox2d then
      fetchurl {
        url = "https://github.com/erincatto/box2d/archive/refs/tags/v${box2dVersion}.tar.gz";
        hash = "sha256-+275FLUPQxLX2SGmAOq8EjGLs8VaC4wLkGCPpEiO8uQ=";
      }
    else
      null;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "odin";
  version = "dev-2026-04";

  src = fetchFromGitHub {
    owner = "odin-lang";
    repo = "Odin";
    tag = finalAttrs.version;
    hash = "sha256-vUQKXyVKZRLzAPeCileAOIfWXvKLrIjYIHXTdMGnG3k=";
  };

  patches = [
    ./darwin-remove-impure-links.patch
    # The default behavior is to use the statically linked Raylib libraries,
    # but GLFW still attempts to load Xlib at runtime, which won't normally be
    # available on Nix based systems. Instead, use the "system" Raylib version,
    # which can be provided by a pure Nix expression, for example in a shell.
    ./system-raylib.patch
    ./box2d-no-network.patch
  ];

  postPatch = ''
    # Odin is still using 'arm64-apple-macos' as the target name on
    # aarch64-darwin architectures. This results in a warning whenever the
    # Odin compiler runs a build. Replacing the target in the Odin compiler
    # removes the nix warning when the Odin compiler is ran on aarch64-darwin.
    substituteInPlace src/build_settings.cpp \
      --replace-fail "arm64-apple-macosx" "arm64-apple-darwin"

    rm -r vendor/raylib/{linux,macos,macos-arm64,wasm,windows}

    patchShebangs --build build_odin.sh
  '';

  env.LLVM_CONFIG = lib.getExe' llvmPackages.llvm.dev "llvm-config";

  dontConfigure = true;

  buildFlags = [ "release" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    which
    cmake
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp odin $out/bin/odin

    mkdir -p $out/share
    cp -r {base,core,vendor,shared} $out/share

    wrapProgram $out/bin/odin \
      --prefix PATH : ${
        lib.makeBinPath (
          with llvmPackages;
          [
            bintools
            llvm
            clang
            lld
          ]
        )
      } \
      --set-default ODIN_ROOT $out/share

    make -C "$out/share/vendor/cgltf/src/"
    make -C "$out/share/vendor/stb/src/"
    make -C "$out/share/vendor/miniaudio/src/"
    if [ "${lib.boolToString enableBox2d}" = "true" ]; then
      BOX2D_TARBALL=${box2dTarball} BOX2D_VERSION=${box2dVersion} bash $out/share/vendor/box2d/build_box2d.sh
    fi

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, concise, readable, pragmatic and open sourced programming language";
    downloadPage = "https://github.com/odin-lang/Odin";
    homepage = "https://odin-lang.org/";
    changelog = "https://github.com/odin-lang/Odin/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "odin";
    maintainers = with lib.maintainers; [
      astavie
      atomicptr
      diniamo
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isMusl;
  };
})
