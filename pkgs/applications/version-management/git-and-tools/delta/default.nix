{ stdenv, lib, fetchFromGitHub, rustPlatform, installShellFiles, DiskArbitration
, Foundation, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "sha256-LABadIux5YId62+t8qXJvBTvB5Beu4u4D0HebNJibxY=";
  };

  cargoSha256 = "sha256-W2OBvVFCaykT/GRIUASsyNlkOk2Bp8yufoMXPX4oryA=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    DiskArbitration
    Foundation
    libiconv
    Security
  ];

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
