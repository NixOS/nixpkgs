{ lib, stdenv, fetchFromGitHub, installShellFiles, rustPlatform, pkg-config, openssl, darwin }:

with rustPlatform;

buildRustPackage rec {
  pname = "git-ignore";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bfr+4zDi6QqirlqccW1jU95eb4q82ZFG9LtT2mCPYLc=";
  };

  cargoSha256 = "sha256-ehEUI4M2IxqS6QhyqOncwP+w6IGbIlSFNIP/FEVH/JI=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  postInstall = ''
    installManPage assets/git-ignore.1
    # There's also .elv and .ps1 completion files but I don't know where to install those
    installShellCompletion assets/git-ignore.{bash,fish} --zsh assets/_git-ignore
  '';

  meta = with lib; {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = "https://github.com/sondr3/git-ignore";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
