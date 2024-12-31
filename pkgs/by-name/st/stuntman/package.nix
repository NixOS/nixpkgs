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
    sha256 = "1gcx4zj44f0viddnn5klkmq0dgd29av5p06iyf9f1va4a3lk0cbg";
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

  meta = with lib; {
    description = "STUNTMAN - an open source STUN server and client";
    homepage = "https://www.stunprotocol.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mattchrist ];
    platforms = platforms.unix;
  };
}
