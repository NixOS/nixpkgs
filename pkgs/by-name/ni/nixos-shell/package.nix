{
  lib,
  stdenv,
  nix,
  jq,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nixos-shell";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixos-shell";
    rev = finalAttrs.version;
    sha256 = "sha256-+HhXol9rBn4j/kcYh90iwvO32zgn+yGnEZa+BfnSuC4=";
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

  meta = {
    description = "Spawns lightweight nixos vms in a shell";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
    mainProgram = "nixos-shell";
  };
})
