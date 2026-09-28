{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nmap,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lazynmap";
  version = "0.1.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ruiiiijiiiiang";
    repo = "lazynmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gMD3t3lh2c9+l1ZhtWC+RJccLeMrcUpMKIEw5gD9phY=";
  };

  cargoHash = "sha256-7MDMwkswqk7L8C+Rz3J8G/lygUCbAOf/sSN95OQuB3o=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/lazynmap --prefix PATH : ${lib.makeBinPath [ nmap ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to build complex nmap commands with a TUI";
    homepage = "https://github.com/ruiiiijiiiiang/lazynmap";
    changelog = "https://github.com/ruiiiijiiiiang/lazynmap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lazynmap";
  };
})
