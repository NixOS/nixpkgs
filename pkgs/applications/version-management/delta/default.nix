{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
, DiskArbitration
, Foundation
, libiconv
, Security
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.16.4";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    hash = "sha256-lIOJPDnSwyPVhmBUPCiWtpNNxXGRKVruidBKIF9tFvo=";
  };

  cargoHash = "sha256-7+SwJ64PJvBi0YOeYcfqsN2f5ehj/t7XhniWd4jWJnM=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation libiconv Security ];

  nativeCheckInputs = [ git ];

  postInstall = ''
    installShellCompletion --bash --name delta.bash etc/completion/completion.bash
    installShellCompletion --zsh --name _delta etc/completion/completion.zsh
    installShellCompletion --fish --name delta.fish etc/completion/completion.fish
  '';

  checkFlags = lib.optionals stdenv.isDarwin [
    "--skip=test_diff_same_non_empty_file"
  ];

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam zowoq SuperSandro2000 ];
  };
}
