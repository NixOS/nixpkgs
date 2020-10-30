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
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "1ng22g9h1l1v2yav8zh6w4nn6ifv8sfz8566m8155d0cza2iimw6";
  };

  cargoSha256 = "0b3qv1ksk8fmpawih2qrz29wlpj1gvq9hw4yqm7hdk6awl5h8lvv";

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
