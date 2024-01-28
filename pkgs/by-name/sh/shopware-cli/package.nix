{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, makeWrapper
, dart-sass
, git
}:

buildGoModule rec {
  pname = "shopware-cli";
  version = "0.4.18";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
    hash = "sha256-LOmGxH/czICSii8AkoXi1cQPL+MErV92iUZtJc2eg64=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  nativeCheckInputs = [ git dart-sass ];

  vendorHash = "sha256-KMNPw2B4fLaOdSIFHBIAKXUtnu0sMwksJg3RUZKLDsE=";

  postInstall = ''
    export HOME="$(mktemp -d)"
    installShellCompletion --cmd shopware-cli \
      --bash <($out/bin/shopware-cli completion bash) \
      --zsh <($out/bin/shopware-cli completion zsh) \
      --fish <($out/bin/shopware-cli completion fish)
  '';

  preFixup = ''
    wrapProgram $out/bin/shopware-cli \
      --prefix PATH : ${lib.makeBinPath [ dart-sass ]}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/FriendsOfShopware/shopware-cli/cmd.version=${version}'"
  ];

  meta = with lib; {
    description = "Command line tool for Shopware 6";
    homepage = "https://github.com/FriendsOfShopware/shopware-cli";
    changelog = "https://github.com/FriendsOfShopware/shopware-cli/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ shyim ];
  };
}
