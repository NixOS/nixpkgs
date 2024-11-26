{
  systemd,
  stdenv,
  makeWrapper,
  binutils-unwrapped,
  sbsigntool,
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lanzaboote-tool";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "lanzaboote";
    rev = "v${version}";
    hash = "sha256-Fb5TeRTdvUlo/5Yi2d+FC8a6KoRLk2h1VE0/peMhWPs=";
  };

  sourceRoot = "${src.name}/rust/tool";
  cargoHash = "sha256-g4WzqfH6DZVUuNb0jV3MFdm3h7zy2bQ6d3agrXesWgc=";

  env.TEST_SYSTEMD = systemd;
  doCheck = lib.meta.availableOn stdenv.hostPlatform systemd;

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    # Clean PATH to only contain what we need to do objcopy.
    # This is still an unwrapped lanzaboote tool lacking of the
    # UEFI stub location.
    mv $out/bin/lzbt $out/bin/lzbt-unwrapped
    wrapProgram $out/bin/lzbt-unwrapped \
      --set PATH ${
        lib.makeBinPath [
          binutils-unwrapped
          sbsigntool
        ]
      }
  '';

  nativeCheckInputs = [
    binutils-unwrapped
    sbsigntool
  ];

  meta = with lib; {
    description = "Lanzaboote UEFI tooling for SecureBoot enablement on NixOS systems";
    homepage = "https://github.com/nix-community/lanzaboote";
    license = licenses.gpl3Only;
    mainProgram = "lzbt";
    maintainers = with maintainers; [
      raitobezarius
      nikstur
    ];
    # Broken on aarch64-linux and any other architecture for now.
    # Wait for 0.4.0.
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
