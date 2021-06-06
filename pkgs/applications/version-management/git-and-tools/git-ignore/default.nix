{ lib, stdenv, fetchFromGitHub, installShellFiles, rustPlatform, pkg-config, openssl, darwin }:

with rustPlatform;

buildRustPackage rec {
  pname = "git-ignore";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "sondr3";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bKIBPqGKiS3ey8vH2F4EoleV1H2PTOp+71d/YW3jkT0=";
  };

  cargoSha256 = "sha256-7jPNVBf5DYtE8nsh7LIywMCjU7ODZ3qFsmBie2mZ3h8=";

  nativeBuildInputs = [ pkg-config installShellFiles ];
  buildInputs = [ openssl ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  outputs = [ "out" "man" ];
  preFixup = ''
    installManPage $releaseDir/build/git-ignore-*/out/git-ignore.1
  '';

  meta = with lib; {
    description = "Quickly and easily fetch .gitignore templates from gitignore.io";
    homepage = "https://github.com/sondr3/git-ignore";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.sondr3 ];
  };
}
