{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "crawley";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
    hash = "sha256-hQvmWob5zCM1dh9oIACjIndaus0gYSidrs4QZM5jtEg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-u1y70ydfVG/aH1CVKOUDBmtZgTLlXXrQGt3mfGDibzs=";

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
