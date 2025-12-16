{
  pkgs,
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "bincrypter";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "bincrypter";
    rev = "master";
    sha256 = "sha256-5xymjIHgYm0d3vpdNVpagq0tnUV2HlLV2DdcCXSso+Y=";
  };

  buildInputs = with pkgs; [
    perl
    openssl
  ];

  nativeBuildInputs = with pkgs; [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    cp bincrypter.sh $out/bin/bincrypter

    wrapProgram $out/bin/bincrypter \
      --prefix PATH : ${
        lib.makeBinPath [
          pkgs.perl
          pkgs.openssl
        ]
      }
  '';
  meta = {
    description = "Pack/Encrypt/Obfuscate ELF + SHELL scripts";
    homepage = "https://github.com/hackerschoice/bincrypter";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ sinjin2300 ];
    mainProgram = "bincrypter";
  };
}
