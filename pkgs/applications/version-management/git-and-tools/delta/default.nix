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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "0g7jg6bxxihplxzq3ixdm24d36xd7xlwpazz8qj040m981cj123i";
  };

  cargoSha256 = "0q73adygyddjyajwwbkrhwss4f8ynxsga5yz4ac5fk5rzmda75rv";

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
    maintainers = with maintainers; [ marsam ma27 zowoq ];
  };
}
