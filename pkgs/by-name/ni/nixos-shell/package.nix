{
  lib,
  stdenv,
  nix,
  jq,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "nixos-shell";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    rev = version;
    sha256 = "sha256-plRKXQqww7easx0wgGKAkOJH1TW/PeeB20dq9XUN8J4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/nixos-shell \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          jq
        ]
      }
  '';

  installFlags = [ "PREFIX=${placeholder "out"}" ];

<<<<<<< HEAD
  meta = {
    description = "Spawns lightweight nixos vms in a shell";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Spawns lightweight nixos vms in a shell";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "nixos-shell";
  };
}
