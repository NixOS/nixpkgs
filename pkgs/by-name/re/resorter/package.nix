{
  lib,
  fetchFromGitHub,
  rPackages,
  rWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "resorter";
  version = "0-unstable-2023-07-14";

  src = fetchFromGitHub {
    owner = "hiAndrewQuinn";
    repo = "resorter";
    rev = "81f8922d41d062794e1563a468cb5ca78680436b";
    hash = "sha256-oC1atQNxwXcsTjom/SCBUsLhHJJEBwqKh0BN9/mvRTU=";
  };

  buildInputs = [
    (rWrapper.override {
      packages = with rPackages; [
        BradleyTerry2
        argparser
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin/
    cp -v resorter.r $out/bin/resorter

    runHook postInstall
  '';

  meta = {
    description = "Tool to sort a list of items based on pairwise comparisons";
    homepage = "https://github.com/hiAndrewQuinn/resorter";
    license = with lib.licenses; [ cc0 ];
    mainProgram = "resorter";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
