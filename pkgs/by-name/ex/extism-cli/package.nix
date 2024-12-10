{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-FAnPyhCc1R6Xk195hTfO16WVtYVB6RPp7Ih7+uyRy2s=";
  };

  vendorHash = "sha256-w8XqHirHfswhlBH/oSrDKLyGdbaiFjQGEZcMH+WVLYo=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "./extism" ];

  doCheck = false; # Tests require network access

  postInstall = ''
    local INSTALL="$out/bin/extism"
    installShellCompletion --cmd extism \
      --bash <($out/bin/extism completion bash) \
      --fish <($out/bin/extism completion fish) \
      --zsh <($out/bin/extism completion zsh)
  '';

  meta = with lib; {
    description = "Extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
