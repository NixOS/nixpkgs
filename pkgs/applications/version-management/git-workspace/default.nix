{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libiconv
, Security
, pkg-config
, openssl
, nix-update-script
, testers
, git-workspace
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cAAEbeA7+lnFH5vr+cfOlkhRjZJnIWX7AoKnow68k3I=";
  };

  cargoHash = "sha256-xLsN9yiAo7HP2HpixZ5SUu0Wnv07nL9D8t+JPT6uKb0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv Security ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = git-workspace; };
  };

  meta = with lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ misuzu ];
    mainProgram = "git-workspace";
  };
}
