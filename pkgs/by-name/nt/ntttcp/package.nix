{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/microsoft/ntttcp-for-linux/commit/e18597c05e3d4b439849ce0e149cb701ff5a36c2.patch";
      hash = "sha256-FOgjKseMDL1O1f+lgmmreGus4YRTZMwIJinh/7MT2Xk=";
    })
  ];

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
