{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  cmake,
  glib,
  makeWrapper,
  pkg-config,
  rustPlatform,
  rustc,
  util-linux,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shadow";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "shadow";
    repo = "shadow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kgWvrnpWUJ5OWy2+luju8SHDRcveVbdfCKntDgxVj0o=";
  };

  __structuredAttrs = true;

  cargoRoot = "src";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-haoVNmm0uW7LOTSj8/ryWaZ9nmRNA2G5QKv9cOKEjcs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cargo
    cmake
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
  ];

  buildInputs = [ glib ];

  cmakeFlags = [
    (lib.cmakeBool "SHADOW_TEST" false)
  ];

  postPatch = ''
    substituteInPlace src/main/utility/mod.rs \
      --replace-fail "/lib64/ld-linux-x86-64.so.2" "${stdenv.cc.bintools.dynamicLinker}"
  '';

  # Upstream drives Rust through CMake `ExternalProject_Add(... BUILD_ALWAYS 1)`.
  # In a normal developer checkout that is a reasonable tradeoff, since repeated
  # local builds can otherwise pick up stale Rust artifacts. In Nix each build
  # already happens in a fresh, one-shot environment, so rebuilding during
  # `make install` only adds cost. Running `cmake --install .` executes the
  # generated install script directly, reusing the artifacts that were already
  # built in `buildPhase` without re-triggering the build graph.
  installPhase = ''
    runHook preInstall
    cmake --install .
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/shadow \
      --prefix PATH : ${lib.makeBinPath [ util-linux ]}
  '';

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Discrete-event network simulator that runs real application code";
    homepage = "https://shadow.github.io/";
    changelog = "https://github.com/shadow/shadow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "shadow";
    maintainers = with lib.maintainers; [ starius ];
    platforms = [ "x86_64-linux" ];
  };
})
