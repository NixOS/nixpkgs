{ stdenv, lib, fetchurl, zlib, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "olvid";
  version = "1.5.0";

  src = fetchurl {
    url = "https://static.olvid.io/linux/${pname}-${version}.tar.gz";
    hash = "sha256-4CkijAlenhht8tyk3nBULaBPE0GBf6DVII699/RmmWI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  # sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    tar xzf olvid-1.5.0.tar.gz -C $out
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.olvid.io";
    description = "Secure french messanger";
    platforms = platforms.linux;
  };
}
