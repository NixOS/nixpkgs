{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  installShellFiles,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btrfs-heatmap";
  version = "9";

  src = fetchFromGitHub {
    owner = "knorrie";
    repo = "btrfs-heatmap";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-yCkuZqWwxrs2eS7EXY6pAOVVVSq7dAMxJtf581gX8vg=";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [
    python3.pkgs.wrapPython
    installShellFiles
    makeBinaryWrapper
  ];

  outputs = [
    "out"
    "man"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm 0755 btrfs-heatmap $out/libexec/btrfs-heatmap
    installManPage man/btrfs-heatmap.1

    buildPythonPath ${python3.pkgs.btrfs}
    patchPythonScript $out/libexec/btrfs-heatmap

    runHook postInstall
  '';

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  postFixup = ''
    makeBinaryWrapper $out/libexec/btrfs-heatmap $out/bin/btrfs-heatmap
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize the layout of a mounted btrfs";
    mainProgram = "btrfs-heatmap";
    homepage = "https://github.com/knorrie/btrfs-heatmap";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
  };
})
