{
  lib,
  fetchFromRadicle,
  nix-update-script,
  rustPlatform,
  git,
  makeWrapper,
  cargoHash ? "sha256-4fCQCEgT9uDnPx9YkShcwHQdgfOMr09IENb65mxJjPo=",
  hash ? "sha256-XiJ2BqkNfapqP7j4+cdaEbBgdG6joc6KbgXqNlLpR1Y=",
  version ? "0.4.0",
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "selfci";
  inherit cargoHash version;

  src = fetchFromRadicle {
    seed = "radicle.dpc.pw";
    repo = "z2tDzYbAXxTQEKTGFVwiJPajkbeDU";
    tag = "v${version}";
    inherit hash;
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram "$out"/bin/selfci \
    --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimalistic local-first Unix-philosophy-abiding CI";
    homepage = "https://app.radicle.xyz/nodes/radicle.dpc.pw/rad%3Az2tDzYbAXxTQEKTGFVwiJPajkbeDU";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      dvn0
    ];
    mainProgram = "selfci";
  };
})
