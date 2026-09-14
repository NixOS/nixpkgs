{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,

  # runtime dependencies
  nix-prefetch-git,
  nix-prefetch-docker,
  git, # for git ls-remote
}:

let
  runtimePath = lib.makeBinPath [
    nix-prefetch-git
    nix-prefetch-docker
    git
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npins";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "andir";
    repo = "npins";
    tag = finalAttrs.version;
    sha256 = "sha256-toAQj3cO6dhfm6FnK0a0mbj+VBaADCsNZNi1PMuJnFQ=";
  };

  cargoHash = "sha256-Ee/QN1Jro78mzwcRWerpZu8Gsj2mkddHBrKUXGGoIQU=";

  nativeBuildInputs = [ makeWrapper ];

  # (Almost) all tests require internet
  doCheck = false;

  postFixup = ''
    wrapProgram $out/bin/npins --prefix PATH : "${runtimePath}"
  '';

  meta = {
    description = "Simple and convenient dependency pinning for Nix";
    mainProgram = "npins";
    homepage = "https://github.com/andir/npins";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      piegames
      coca
    ];
  };
})
