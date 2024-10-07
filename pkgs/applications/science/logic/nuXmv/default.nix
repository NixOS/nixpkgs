{ lib, stdenv, fetchurl, gmp, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "nuXmv";
  version = "2.0.0";

  src = fetchurl {
    url = "https://es-static.fbk.eu/tools/nuxmv/downloads/nuXmv-${version}-${if stdenv.hostPlatform.isDarwin then "macosx64" else "linux64"}.tar.gz";
    sha256 = if stdenv.hostPlatform.isDarwin
             then "sha256-48I+FhJUUam1nMCMMM47CwGO82BYsNz0eHDHXBfqO2E="
             else "sha256-Gf+QgAjTrysZj7qTtt1wcQPganDtO0YtRY4ykhLPzVo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ gmp ];
  installPhase= ''
    runHook preInstall
    install -Dm755 -t $out/bin ./bin/nuXmv
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapProgram $out/bin/nuXmv --prefix DYLD_LIBRARY_PATH : ${gmp}/lib
  '';

  meta = with lib; {
    description = "Symbolic model checker for analysis of finite and infinite state systems";
    homepage = "https://nuxmv.fbk.eu/pmwiki.php";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ siraben ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
