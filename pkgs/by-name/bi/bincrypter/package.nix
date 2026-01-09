{
  lib,
  fetchFromGitHub,
  stdenv,
  perl,
  openssl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bincrypter";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "bincrypter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-5xymjIHgYm0d3vpdNVpagq0tnUV2HlLV2DdcCXSso+Y=";
  };

  buildInputs = [
    perl
    openssl
  ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    cp bincrypter.sh $out/bin/bincrypter

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/bincrypter \
      --prefix PATH : ${
        lib.makeBinPath [
          perl
          openssl
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
})
