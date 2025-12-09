{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.16";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-/94ynxbH06JFzx3TZDRxvx9inbP+xiOVOqRxpopocjE=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-d6m4HFhTUzMMCNpv3WxoPGTF8Erqi0980w+MA2PoZ9w=";

  ldflags = [
    "-w"
    "-s"
  ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

  meta = with lib; {
    description = "Unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = licenses.mit;
    maintainers = with maintainers; [ ltstf1re ];
    mainProgram = "crawley";
  };
}
