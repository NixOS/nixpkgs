{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "17cmwkha25hwsvnjcp388zd9kwacfq7adjp0sjw59y0vyr1maf22";
  };

  cargoSha256 = "1bji818cmkl0286a4qcnfiwibnqd5q5fvzmzgk5cabrdwaag2ia5";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  postInstall = ''
    installShellCompletion --bash --name delta.bash etc/completion/completion.bash
    installShellCompletion --zsh --name _delta etc/completion/completion.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam zowoq ];
  };
}
