{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "sha256-coxETvB/uKTgg5VFlvcFmbNj95paDWkpq0zUIeR9//8=";
  };

  cargoSha256 = "sha256-V6px+OGe9vHg/OgiEbT+TG1PmUIgWPVuv+AD176W0Bo=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation libiconv Security ];

  postInstall = ''
    installShellCompletion --bash --name delta.bash etc/completion/completion.bash
    installShellCompletion --zsh --name _delta etc/completion/completion.zsh
  '';

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 ];
  };
}
