{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "genact";
    rev = "v${version}";
    sha256 = "sha256-Rn9kJWutWKPj9cLu2ZJKITmC+I8/ikhCAoIp00Yg6ZA=";
  };

  cargoHash = "sha256-Ttg9stfiIYCXk35+GWdGOzQrM/aYZPZK+e9y+zw1ZXQ=";

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
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "genact";
  };
}
