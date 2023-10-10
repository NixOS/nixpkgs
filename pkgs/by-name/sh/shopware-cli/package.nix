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
  version = "0.3.5";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    rev = version;
    hash = "sha256-xjeko2aFnz3vjQqqn/VimYGg9lZaz5trDX5HC8a+XgE=";
  };

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  nativeCheckInputs = [ git dart-sass ];

  vendorHash = "sha256-QZ/zU67oUW75T8DOzjQwmEAr6gjIg/6ZO4Vm/47Lc40=";

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
