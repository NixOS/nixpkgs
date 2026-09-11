{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
}:

buildGoModule rec {
  pname = "goodhosts";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "goodhosts";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-+KlAJV+CeycQHwxrRI9kMkKlDLs8bS+/QwaYv70LEfU=";
  };

  ldflags = [
    "-s -w -X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/goodhosts
  '';

  vendorHash = "sha256-FsjCpwvehmRm67Tqwld+0vn4IFO6E46SJnLwRjKVAiw=";

  meta = {
    description = "CLI tool for managing hostfiles";
    license = lib.licenses.mit;
    homepage = "https://github.com/goodhosts/cli/tree/main";
    maintainers = with lib.maintainers; [ schinmai-akamai ];
    mainProgram = "goodhosts";
  };
}
