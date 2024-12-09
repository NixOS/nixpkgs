{ lib, stdenv, fetchFromGitHub, zlib, util-linux }:

stdenv.mkDerivation rec {
  pname = "pigz";
  version = "2.8";

  src = fetchFromGitHub {
      owner = "madler";
      repo = pname;
      rev = "refs/tags/v${version}";
      sha256 = "sha256-PzdxyO4mCg2jE/oBk1MH+NUdWM95wIIIbncBg71BkmQ=";
  };

  enableParallelBuilding = true;

  buildInputs = [ zlib ] ++ lib.optional stdenv.hostPlatform.isLinux util-linux;

  makeFlags = [ "CC=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc" ];

  doCheck = stdenv.hostPlatform.isLinux;
  checkTarget = "tests";
  installPhase = ''
    runHook preInstall

    install -Dm755 pigz "$out/bin/pigz"
    ln -s pigz "$out/bin/unpigz"
    install -Dm755 pigz.1 "$out/share/man/man1/pigz.1"
    ln -s pigz.1 "$out/share/man/man1/unpigz.1"
    install -Dm755 pigz.pdf "$out/share/doc/pigz/pigz.pdf"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.zlib.net/pigz/";
    description = "Parallel implementation of gzip for multi-core machines";
    maintainers = [ ];
    license = licenses.zlib;
    platforms = platforms.unix;
  };
}
