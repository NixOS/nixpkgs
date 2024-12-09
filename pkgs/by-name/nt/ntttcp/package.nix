{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ntttcp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ntttcp-for-linux";
    rev = version;
    sha256 = "sha256-6O7qSrR6EFr7k9lHQHGs/scZxJJ5DBNDxlSL5hzlRf4=";
  };

  preBuild = "cd src";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ntttcp $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux network throughput multiple-thread benchmark tool";
    homepage = "https://github.com/microsoft/ntttcp-for-linux";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "ntttcp";
  };
}
