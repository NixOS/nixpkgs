{
  lib,
  fetchFromRadicle,
  nix-update-script,
  rustPlatform,
  git,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "selfci";
  version = "0-unstable-2026-01-17";

  src = fetchFromRadicle {
    seed = "radicle.dpc.pw";
    repo = "z2tDzYbAXxTQEKTGFVwiJPajkbeDU";
    rev = "83e693dada851ce0da32713869d3da02c52ed257";
    hash = "sha256-f0BfHvIQnhhiPie3a+9MeEGzZ+/KcgrbKBneu8Jo+xs=";
  };

  cargoHash = "sha256-Z3f35HIZiNeKeDNFPUVkFvL2OpMWzqRvxOL5/hUEzJw=";

  nativeBuildInputs = [
    makeWrapper
  ];

  patches = [
    ./Cargo.toml.patch
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram "$out"/bin/selfci \
    --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic local-first Unix-philosophy-abiding CI";
    homepage = finalAttrs.src.homeUrl;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dvn0
    ];
    mainProgram = "selfci";
  };
})
