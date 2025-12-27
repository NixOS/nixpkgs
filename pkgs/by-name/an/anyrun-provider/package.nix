{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "anyrun-provider";
  version = "25.12.0";

  src = fetchFromGitHub {
    owner = "anyrun-org";
    repo = "anyrun-provider";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4rN2vWicM6Pn6eTo3Nu7IB5isbkc9u4arNMnY2+S8iM=";
  };

  cargoHash = "sha256-xd1FnYsIjWuAYGfqTdRhzje3ALis5VaHIKeImlAjVVI=";

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple program to load Anyrun plugins and interact with them";
    homepage = "https://github.com/anyrun-org/anyrun-provider";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      khaneliman
      NotAShelf
    ];
    platforms = lib.platforms.linux;
  };
})
