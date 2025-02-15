{
  lib,
  rustPlatform,
  makeWrapper,
  stdenv,
  darwin,
  callPackage,

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
  sources = (lib.importJSON ./sources.json).pins;
in
rustPlatform.buildRustPackage rec {
  pname = "npins";
  version = src.version;
  src = passthru.mkSource sources.npins;

  useFetchCargoVendor = true;
  cargoHash = "sha256-RUtWpZYaydXzF7gcROiIr04K7+Usq9iHAQwnv3ELqLI=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Security
      SystemConfiguration
    ]
  );
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

  passthru.mkSource = callPackage ./source.nix { };
}
