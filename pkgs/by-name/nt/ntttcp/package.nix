{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ntttcp";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "ntttcp-for-linux";
    rev = finalAttrs.version;
    sha256 = "sha256-6O7qSrR6EFr7k9lHQHGs/scZxJJ5DBNDxlSL5hzlRf4=";
  };

  preBuild = "cd src";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ntttcp $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Linux network throughput multiple-thread benchmark tool";
    homepage = "https://github.com/microsoft/ntttcp-for-linux";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "ntttcp";
  };
})
