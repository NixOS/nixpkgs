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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "sha256-5h4epV3RORZiynW1fkFLImqPunC3PZ/YzLiSrzescww=";
  };

  cargoSha256 = "sha256-4dPTcrT8Gx3WfT0sauqnCSmcGE9LrgIqgHrY5l503ZA=";

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
