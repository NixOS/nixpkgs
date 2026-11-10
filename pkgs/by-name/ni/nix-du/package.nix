{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nixVersions,
  nix ? nixVersions.nix_2_34,
  graphviz,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-du";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "symphorien";
    repo = "nix-du";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqsBWdCdLEdkubcVMuZzF425oU2zgsMSPeDElM+zYBE=";
  };

  cargoHash = "sha256-xotbDCuWUeahVsRoOiBdZDC3JpK2a9osbSyVtUyaBrg=";

  doCheck = true;
  nativeCheckInputs = [
    nix
    graphviz
  ];

  buildInputs = [
    nix
  ]
  ++ nix.buildInputs;

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "Tool to determine which gc-roots take space in your nix store";
    homepage = "https://github.com/symphorien/nix-du";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.symphorien ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-du";
    changelog = "https://github.com/symphorien/nix-du/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
