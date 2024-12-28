{
  lib,
  fetchFromGitHub,
  makeWrapper,
  jujutsu,
  rustPlatform,
  testers,
  lazyjj,
}:
rustPlatform.buildRustPackage rec {
  pname = "lazyjj";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    rev = "v${version}";
    hash = "sha256-iT6kRzD+w7cb7ZjMt7NfkqwFJOzbt6kxc5vDjI7By84=";
  };

  cargoHash = "sha256-y7yIgM4pIvqsX7LuLU/6P/9oNxsJrg/o/4CqqJ8uitU=";

  postInstall = ''
    wrapProgram $out/bin/lazyjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ jujutsu ];

  passthru.tests.version = testers.testVersion { package = lazyjj; };

  meta = with lib; {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    mainProgram = "lazyjj";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
