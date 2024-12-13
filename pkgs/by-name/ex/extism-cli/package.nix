{
  lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "extism-cli";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "extism";
    repo = "cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-txwpFc1FQlZLAxbpO92Ei7z3vhXBrpdIJHAqnrKp9Bg=";
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

  meta = with lib; {
    description = "Extism CLI is used to manage Extism installations";
    homepage = "https://github.com/extism/cli";
    license = licenses.bsd3;
    maintainers = with maintainers; [ zshipko ];
    mainProgram = "extism";
    platforms = platforms.all;
  };
}
