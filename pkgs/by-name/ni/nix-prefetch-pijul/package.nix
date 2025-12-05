{
  lib,
  stdenv,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  gawk,
  pijul,
  cacert,
  jq,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-prefetch-pijul";
  version = "1.0.0";

  strictDeps = true;
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  dontUnpack = true;

  installPhase = ''
    install -vD ${./nix-prefetch-pijul.sh} $out/bin/$pname;
    wrapProgram $out/bin/$pname --prefix PATH : ${
      lib.makeBinPath [
        gawk
        pijul
        cacert
        jq
        coreutils
        gnused
      ]
    } --set HOME /homeless-shelter
  '';

  preferLocalBuild = true;

  meta = {
    description = "Script used to obtain source hashes for fetchpijul";
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "nix-prefetch-pijul";
  };
})
