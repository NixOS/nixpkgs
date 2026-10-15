{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genact";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "genact";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hz+DZCoZzi4ZtGUQfQJ5f6sGqgbB32bIIdxTE2TeWrY=";
  };

  cargoHash = "sha256-1Ju44DKNFb2EhDBuwJUUPKBXMNJEHZ3Qrb4yQBXca+I=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/genact --print-manpage > genact.1
    installManPage genact.1

    installShellCompletion --cmd genact \
      --bash <($out/bin/genact --print-completions bash) \
      --fish <($out/bin/genact --print-completions fish) \
      --zsh <($out/bin/genact --print-completions zsh)
  '';

  meta = {
    description = "Nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.novalkun ];
    mainProgram = "genact";
  };
})
