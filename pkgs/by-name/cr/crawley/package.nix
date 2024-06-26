{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-chnnWFE+teq3cjWmwwZ/Ql3KoY2b4wsLL8/5TWxX1fM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-byEb5CKi/zBjdvdkUdJeLbuZKf6o3z08r+XRkcGxvDs=";

  ldflags = [ "-w" "-s" ];

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
