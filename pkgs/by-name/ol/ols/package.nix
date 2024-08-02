{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  odin,
  stdenv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "ols";
  version = "0-unstable-2024-08-01";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "9b2428b72de7a82eff46890a16662af5d69921c5";
    hash = "sha256-TYrB13I/qdEuXOtmtvbVRCdH/8r0iLxa/yVI+A9EPcY=";
  };

  postPatch = ''
    patchShebangs build.sh odinfmt.sh
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ odin ];

  buildPhase = ''
    runHook preBuild

    ./build.sh && ./odinfmt.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ols odinfmt -t $out/bin/
    wrapProgram $out/bin/ols --set-default ODIN_ROOT ${odin}/share

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    inherit (odin.meta) platforms;
    description = "Language server for the Odin programming language";
    homepage = "https://github.com/DanielGavin/ols";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      astavie
      znaniye
    ];
    mainProgram = "ols";
  };
}
