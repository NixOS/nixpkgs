{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.8";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-Sw9FZVVar8aG0+RO64cYzJ2OZb80cgHw2we+e+BV9QY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-w/TLGJvHVbuv+wrOI+RQnZl3I62QYbqd9W1hcUbz2b0=";

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
