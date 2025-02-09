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
  version = "0.4.4";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
    hash = "sha256-cic2J1xm/DbZP/qL5jWE7H9x38QAVPwUGpaWEwGTdDk=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  nativeCheckInputs = [ git dart-sass ];

  vendorHash = "sha256-Cllujomvlf3u3MjIhoh2BpDD3Tfo6kIbJsoPInIUaPI";

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
