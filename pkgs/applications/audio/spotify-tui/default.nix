{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, pkg-config, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "082y5m2vglzx9kdc2088zynz0njcnljnb0y170igmlsxq9wkrgg2";
  };

  cargoSha256 = "100c7x603qyhav3p24clwfal4ngh0258x9lqsi84kcj4wq2f3i8f";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config python3 ];
  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ openssl libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Security ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/spt --completions $shell > spt.$shell
      installShellCompletion spt.$shell
    done
  '';

  meta = with lib; {
    description = "Spotify for the terminal written in Rust";
    homepage = "https://github.com/Rigellute/spotify-tui";
    changelog = "https://github.com/Rigellute/spotify-tui/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jwijenbergh ];
  };
}
