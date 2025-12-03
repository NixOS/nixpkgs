{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  yasm,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svt-vp9";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "OpenVisualCloud";
    repo = "SVT-VP9";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M7XpHCqTxGgk/UOlMR0jEXist6vGie6abRYLnVvC6sg=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    yasm
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    mainProgram = "SvtVp9EncApp";
    homepage = "https://github.com/OpenVisualCloud/SVT-VP9";
    license = lib.licenses.bsd2Patent;
    maintainers = with lib.maintainers; [
      niklaskorz
    ];
    platforms = [ "x86_64-linux" ];
  };
})
