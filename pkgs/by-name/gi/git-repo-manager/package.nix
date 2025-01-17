{ pkgs
, lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {

  pname = "git-repo-manager";
  version = "0.7.16";

  src = fetchFromGitHub {
    owner = "hakoerber";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v8fgTrvgaYQzVDoxfREdkCR/1Kjv4f4mKlCLxXOjkHk=";
  };

  cargoSha256 = "sha256-3g6bQL+iZS+q38Vahzp/yBSK+n/VYmCaJ+xm3bd3OJQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks; [ CoreServices Security SystemConfiguration ]
    );

  meta = with lib; {
    description = "A git tool to manage worktrees and integrate with GitHub and GitLab";
    homepage = "https://hakoerber.github.io/git-repo-manager";
    license = licenses.gpl3;
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "grm";
  };
}
