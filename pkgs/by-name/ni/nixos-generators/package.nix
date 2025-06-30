{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  jq,
  findutils,
  nix,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "nixos-generators";
  version = "1.8.0";
  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixos-generators";
    rev = version;
    sha256 = "sha256-wHmtB5H8AJTUaeGHw+0hsQ6nU4VyvVrP2P4NeCocRzY=";
  };
  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];
  installFlags = [ "PREFIX=$(out)" ];
  postFixup = ''
    wrapProgram $out/bin/nixos-generate \
      --prefix PATH : ${
        lib.makeBinPath [
          jq
          coreutils
          findutils
          nix
        ]
      }
  '';

  meta = with lib; {
    description = "Collection of image builders";
    homepage = "https://github.com/nix-community/nixos-generators";
    license = licenses.mit;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "nixos-generate";
    platforms = platforms.unix;
  };
}
