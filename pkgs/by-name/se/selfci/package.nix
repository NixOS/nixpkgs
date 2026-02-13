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
  version = "0.5.0";

  cargoHash = "sha256-zgDbf0po0YJCRo4GyVce2YSzoFjBTWsKX86/aH3uZlY=";

  src = fetchFromRadicle {
    seed = "radicle.dpc.pw";
    repo = "z2tDzYbAXxTQEKTGFVwiJPajkbeDU";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Q9Enq02uJbcpr7pohh+uiGNus++TkUxCvO4KwX8fkk=";
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
