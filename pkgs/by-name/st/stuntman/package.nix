{
  stdenv,
  lib,
  fetchFromGitHub,
  openssl,
  boost,
}:

stdenv.mkDerivation {
  pname = "stuntman";
  version = "1.2.16";

  src = fetchFromGitHub {
    owner = "jselbie";
    repo = "stunserver";
    rev = "cfadf9c3836d5ae63a682913de24ba085df924f3";
    hash = "sha256-bzEw6VBE7eCS89GAW7ZKor0GcJ10Fmtbixs4QuQnnb0=";
  };

  buildInputs = [
    boost
    openssl
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv stunserver $out/bin/
    mv stunclient $out/bin/

    runHook postInstall
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./stuntestcode

    runHook postCheck
  '';

  meta = {
    description = "Open source STUN server and client";
    homepage = "https://www.stunprotocol.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mattchrist ];
    platforms = lib.platforms.unix;
  };
}
