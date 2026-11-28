{
  aws-lc,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lucida-downloader";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "jelni";
    repo = "lucida-downloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OALy97PDLonwhk9SGSlrjfr1qSSQ6kxgfpWDWgJhl9Q=";
  };

  passthru.updateScript = nix-update-script { };

  cargoHash = "sha256-ndm66VMnGeIitDKslsIq8C5H3x6bgV6BuG1DYXHeVv8=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ aws-lc ];

  postInstall =
    let
      path = "target/*/release/build/${finalAttrs.pname}-*/out";
    in
    ''
      installShellCompletion \
        --bash ${path}/${finalAttrs.meta.mainProgram}.bash \
        --fish ${path}/${finalAttrs.meta.mainProgram}.fish \
        --zsh ${path}/_${finalAttrs.meta.mainProgram}
    '';

  meta = {
    description = "Multithreaded client for downloading music for free with lucida";
    homepage = "https://github.com/jelni/lucida-downloader";
    license = lib.licenses.agpl3Plus;
    mainProgram = "lucida";
    maintainers = with lib.maintainers; [
      jelni
      surfaceflinger
    ];
  };
})
