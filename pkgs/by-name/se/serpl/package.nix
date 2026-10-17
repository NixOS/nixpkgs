{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  ast-grep,
  ripgrep,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "serpl";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "yassinebridi";
    repo = "serpl";
    rev = finalAttrs.version;
    hash = "sha256-M9hIHQfzrPjSSAPIfHbgaWzSz1yPaMIEabR33HjLHEU=";
  };

  buildFeatures = [ "ast_grep" ];

  nativeBuildInputs = [ makeWrapper ];

  cargoHash = "sha256-9ZmBDMrChz4ZxthcFY25ldXpTFjnvaTp+taWdnHYNo8=";

  postFixup = ''
    # Serpl needs ripgrep to function properly.
    wrapProgram $out/bin/serpl \
      --prefix PATH : "${
        lib.strings.makeBinPath [
          ripgrep
          ast-grep
        ]
      }"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/serpl";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple terminal UI for search and replace, ala VS Code";
    homepage = "https://github.com/yassinebridi/serpl.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "serpl";
  };
})
