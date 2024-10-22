{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myrescue";
  version = "0.9.8";

  src = fetchurl {
    url = "mirror://sourceforge/project/myrescue/myrescue/myrescue-${finalAttrs.version}/myrescue-${finalAttrs.version}.tar.gz";
    hash = "sha256-tO9gkDpEtmySatzV2Ktw3eq5SybCUGAUmKXiSxnkwdc=";
  };

  nativeBuildInputs = [ installShellFiles ];

  sourceRoot = "./src";

  patches = [
    ./0001-darwin-build-fixes.patch
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 myrescue myrescue-bitmap2ppm myrescue-stat -t $out/bin
    installManPage ../doc/myrescue.1
    runHook postInstall
  '';

  meta = with lib; {
    description = "Hard disk recovery tool that reads undamaged regions first";
    mainProgram = "myrescue";
    homepage = "https://myrescue.sourceforge.net";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
})
