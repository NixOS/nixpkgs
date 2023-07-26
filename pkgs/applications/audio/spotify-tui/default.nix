{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, installShellFiles
, pkg-config
, openssl
, python3
, libxcb
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    hash = "sha256-L5gg6tjQuYoAC89XfKE38KCFONwSAwfNoFEUPH4jNAI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals stdenv.isLinux [ pkg-config python3 ];
  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ openssl libxcb ]
    ++ lib.optionals stdenv.isDarwin [ AppKit Security ];

  postPatch = ''
    # update Cargo.lock to fix build
    ln -sf ${./Cargo.lock} Cargo.lock

    # Add patch adding the collection variant to rspotify used by spotify-tu
    # This fixes the issue of getting an error when playing liked songs
    # see https://github.com/NixOS/nixpkgs/pull/170915
    patch -p1 -d $cargoDepsCopy/rspotify-0.10.0 < ${./0001-Add-Collection-SearchType.patch}
  '';

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
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ jwijenbergh ];
    mainProgram = "spt";
  };
}
