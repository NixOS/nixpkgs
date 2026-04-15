{
  coreutils,
  fetchFromSourcehut,
  file,
  libcaca,
  makeWrapper,
  python3,
  openssl,
  qrencode,
  lib,
  stdenv,
  yubikey-manager,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gen-oath-safe";
  version = "0.11.0";

  src = fetchFromSourcehut {
    owner = "~mcepl";
    repo = "gen-oath-safe";
    tag = finalAttrs.version;
    sha256 = "1914z0jgj7lni0nf3hslkjgkv87mhxdr92cmhmbzhpjgjgr23ydp";
  };
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase =
    let
      path = lib.makeBinPath [
        coreutils
        file
        libcaca.bin
        openssl.bin
        python3
        qrencode
        yubikey-manager
      ];
    in
    ''
      mkdir -p $out/bin
      cp gen-oath-safe $out/bin/
      wrapProgram $out/bin/gen-oath-safe \
        --prefix PATH : ${path}
    '';
  meta = {
    homepage = "https://git.sr.ht/~mcepl/gen-oath-safe";
    description = "Script for generating HOTP/TOTP keys (and QR code)";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.makefu ];
    mainProgram = "gen-oath-safe";
  };

})
