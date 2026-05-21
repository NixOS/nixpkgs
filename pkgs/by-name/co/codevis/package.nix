{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codevis";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LZ6NsoyEPUvgcVdbG7U2Vzuz/TLLraScvW97PocUNpU=";
  };

  cargoHash = "sha256-BIUzuV7q/5GSAmjRfdL71dWC7TjBVaSL8UyWpTF2AxM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "Tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
    changelog = "https://github.com/sloganking/codevis/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "codevis";
  };
})
