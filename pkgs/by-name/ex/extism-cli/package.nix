{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-VxQ8qj/prGecssbggSKhj0vkZ75/GD73u/g21hUVkSs=";
  };

  vendorHash = "sha256-51/fzq2j55GHmEx2twb0DSi0AmBS4DbViZzo1c5Xn1M=";

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

  meta = {
    description = "Extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = lib.platforms.all;
  };
}
