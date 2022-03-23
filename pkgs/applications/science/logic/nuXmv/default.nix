{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "nuXmv";
  version = "2.0.0";

  src = fetchurl {
    url = "https://es-static.fbk.eu/tools/nuxmv/downloads/nuXmv-${version}-linux64.tar.gz";
    sha256 = "0nndrw994clf8lnlcfzdf1mf00vif3fvd4xsiwcjpbyk12091zqr";
  };

  installPhase= ''
    runHook preInstall
    install -Dm755 -t $out/bin ./bin/nuXmv
    runHook postInstall
  '';

  meta = with lib; {
    description = "Symbolic model checker for analysis of finite and infinite state systems";
    homepage = "https://nuxmv.fbk.eu/pmwiki.php";
    license = licenses.unfree;
    maintainers = with maintainers; [ siraben ];
    platforms = [ "x86_64-linux" ];
  };
}
