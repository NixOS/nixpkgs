{ lib
, stdenv
, fetchFromGitHub
, fetchCrate
, fetchpatch
, rustPlatform
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

  cargoPatches = [
    # Use patched rspotify
    ./Cargo.lock.patch

    # Needed so that the patch below it applies.
    (fetchpatch {
      name = "update-dirs.patch";
      url = "https://github.com/Rigellute/spotify-tui/commit/3881defc1ed0bcf79df1aef4836b857f64be657c.patch";
      hash = "sha256-OGqiYLFojMwR3RgKbddXxPDiAdzPySnscVVsVmTT7t4=";
    })

    # https://github.com/Rigellute/spotify-tui/pull/990
    (fetchpatch {
      name = "update-socket2-for-rust-1.64.patch";
      url = "https://github.com/Rigellute/spotify-tui/commit/14df9419cf72da13f3b55654686a95647ea9dfea.patch";
      hash = "sha256-craY6UwmHDdxih3nZBdPkNJtQ6wvVgf09Ovqdxi0JZo=";
    })
  ];

  patches = [
    # Use patched rspotify
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

  cargoHash = "sha256-aZJ6Q/rvqrv+wvQw2eKFPnSROhI5vXPvr5pu1hwtZKA=";

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
