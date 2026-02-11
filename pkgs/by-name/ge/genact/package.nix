{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "genact";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "genact";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-D1uecxrRR49EUa2fHm/ieQ4Gp0m5p0ncj5YiINwlvN8=";
  };

  cargoHash = "sha256-lX/bb6RGcsfgfjhK7SwwcY9R7USSEdG5VLK6v2LOvas=";

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
    maintainers = [ ];
    mainProgram = "genact";
  };
})
