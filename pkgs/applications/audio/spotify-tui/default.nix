{ lib, stdenv, fetchFromGitHub, fetchCrate, rustPlatform, installShellFiles, pkg-config, openssl, python3, libxcb, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "spotify-tui";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "Rigellute";
    repo = "spotify-tui";
    rev = "v${version}";
    sha256 = "sha256-L5gg6tjQuYoAC89XfKE38KCFONwSAwfNoFEUPH4jNAI=";
  };

  # Use patched rspotify
  cargoPatches = [
    ./Cargo.lock.patch
  ];
  patches = [
    ./Cargo.toml.patch
  ];

  preBuild = let
    rspotify = stdenv.mkDerivation rec {
      pname = "rspotify";
      version = "0.10.0";

      src = fetchCrate {
        inherit pname version;
        sha256 = "sha256-KDtqjVQlMHlhL1xXP3W1YG/YuX9pdCjwW/7g18469Ts=";
      };

      dontBuild = true;
      installPhase = ''
        mkdir $out
        cp -R . $out
      '';

      patches = [
        # add `collection` variant
        ./0001-Add-Collection-SearchType.patch
      ];
    };
  in ''
    ln -s ${rspotify} ./rspotify-${rspotify.version}
  '';

  cargoSha256 = "sha256-S8zuVYcyYvrwggIvlpxNydhoN9kx6xLBwYJSHcbEK40=";

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
    mainProgram = "spt";
  };
}
