{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-sLeQl0/FY0NBfyhIyjcFqvI5JA1GSAfe7s2XrOjLZEY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-fOy4jYF01MoWFS/SecXhlO2+BTYzR5eRm55rp+YNUuU=";

  ldflags = [ "-w" "-s" ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

  meta = with lib; {
    description = "The unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = licenses.mit;
    maintainers = with maintainers; [ ltstf1re ];
    mainProgram = "crawley";
  };
}
