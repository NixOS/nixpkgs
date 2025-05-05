{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,

  # runtime dependencies
  nix, # for nix-prefetch-url
  nix-prefetch-git,
  git, # for git ls-remote
}:

let
  runtimePath = lib.makeBinPath [
    nix
    nix-prefetch-git
    git
  ];
in
rustPlatform.buildRustPackage rec {
  pname = "npins";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = version;
    sha256 = "sha256-nTm6IqCHNFQLU7WR7dJRP7ktBctpE/O2LHbUV25roJA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HnX7dkWLxa3DARXG8y9OVBRwvwgxwRIs4mWK3VNblG0=";

  nativeBuildInputs = [ makeWrapper ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
  '';

  meta = with lib; {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = licenses.eupl12;
    maintainers = with maintainers; [ piegames ];
  };
}
