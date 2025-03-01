{
  fetchFromSourcehut,
  installShellFiles,
  lib,
  python3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nvd";
  version = "0.2.4";

  src = fetchFromSourcehut {
    owner = "~khumba";
    repo = "nvd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3Fb6MDz4z41at3XpjLVng8NBwUJn/N7QBgU6Cbh0w98=";
  };

  buildInputs = [
    python3
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall
    install -m555 -Dt $out/bin src/nvd
    installManPage src/nvd.1
    runHook postInstall
  '';

  meta = {
    description = "Nix/NixOS package version diff tool";
    homepage = "https://khumba.net/projects/nvd";
    license = lib.licenses.asl20;
    mainProgram = "nvd";
    maintainers = with lib.maintainers; [ khumba ];
    platforms = lib.platforms.all;
  };
})
