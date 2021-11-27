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
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "sha256-aiWVaqwJGjLyv/ZJU4g1KuBC9zbnBEc/vdNADGPKgxo=";
  };

  cargoSha256 = "sha256-lp9XzZQZJpjhsanZMky3RwkjM7ICq7dSb4PHdstwMxQ=";

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
