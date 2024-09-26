{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "act";
  version = "0.2.66";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-84ssbd0qF0p2x+cFYwYNW4P79KSZqhvF4Zd6wlRhgLo=";
  };

  vendorHash = "sha256-fzGnswfzvKhzs7iYnsiQb1c+TTk9+113uj7ryOAvUJk=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    mainProgram = "act";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne kashw2 ];
  };
}
