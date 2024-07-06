{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  imagemagick,
  qrencode,
  testQR ? false,
  zbar ? null,
}:
assert testQR -> zbar != false;
stdenvNoCC.mkDerivation {
  pname = "asc-key-to-qr-code-gif";
  version = "0-unstable-2018-06-13";

  src = fetchFromGitHub {
    owner = "yishilin14";
    repo = "asc-key-to-qr-code-gif";
    rev = "5b7b239a0089a5269444cbe8a651c99dd43dce3f";
    sha256 = "0yrc302a2fhbzryb10718ky4fymfcps3lk67ivis1qab5kbp6z8r";
  };

  dontBuild = true;

  postPatch =
    let
      substitutions =
        [
          ''--replace-fail "convert" "${lib.getExe imagemagick}"''
          ''--replace-fail "qrencode" "${lib.getExe qrencode}"''
        ]
        ++ lib.optionals testQR [
          ''--replace-fail "hash zbarimg" "true"'' # hash does not work on NixOS
          ''--replace-fail "$(zbarimg --raw" "$(${zbar}/bin/zbarimg --raw"''
        ];
    in
    ''
      substituteInPlace asc-to-gif.sh ${lib.concatStringsSep " " substitutions}
    '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp asc-to-gif.sh $out/bin/asc-to-gif
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/yishilin14/asc-key-to-qr-code-gif";
    description = "Convert ASCII-armored PGP keys to animated QR code";
    license = lib.licenses.unfree; # program does not have a license
    mainProgram = "asc-to-gif";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      asymmetric
      NotAShelf
    ];
  };
}
