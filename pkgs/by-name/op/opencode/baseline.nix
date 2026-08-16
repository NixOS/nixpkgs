{
  lib,
  stdenv,
  fetchurl,
  patchelf,
  makeBinaryWrapper,
  ripgrep,
  glibc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.18.18";

  src = fetchurl {
    url = "https://github.com/anomalyco/opencode/releases/download/v${finalAttrs.version}/opencode-linux-x64-baseline.tar.gz";
    hash = "sha256-BZFGVYVMHatI8NUqivj3SWfk4m2vh9/mU09X55moU9c=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  # The upstream tarball has a single `opencode` file at the archive root
  # (no subdir). With sourceRoot left as the default, the unpacker rejects
  # tarballs that don't produce any directories under it.
  sourceRoot = ".";

  nativeBuildInputs = [
    patchelf
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    # The upstream tarball extracts to a single `opencode` file at the root
    # (no subdir). Install to $out/libexec/opencode so the wrapper below can
    # safely create $out/bin/opencode without colliding.
    install -Dm755 opencode $out/libexec/opencode

    # patchelf --no-sort avoids autoPatchelf's program-header expansion, which
    # corrupts Bun-compiled binaries (observed by the libexec binary
    # reporting Bun's version instead of opencode's own after autoPatchelf).
    patchelf --no-sort --set-interpreter "${lib.getLib glibc}/lib/ld-linux-x86-64.so.2" $out/libexec/opencode

    # Shell wrapper so makeBinaryWrapper's ELF-vs-script heuristics don't
    # fight us; also keeps ripgrep on PATH (opencode shells out to `rg`).
    makeWrapper $out/libexec/opencode $out/bin/opencode \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    runHook postInstall
  '';

  passthru.updateScript = [
    "nix-update"
    "--flake"
    "opencode"
  ];

  meta = {
    description = "AI coding agent built for the terminal (pre-Haswell baseline x86_64 build)";
    homepage = "https://github.com/anomalyco/opencode";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "opencode";
  };
})
