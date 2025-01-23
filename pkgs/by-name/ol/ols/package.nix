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
  version = "0-unstable-2024-12-28";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "fded19fc8ede748d31b67686941fbe33a8f77214";
    hash = "sha256-KuzYkCwcQ11vLaQ3Au+2sEADe4knWu/HAls7Qe0cr2A=";
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
    ];
    mainProgram = "ols";
  };
}
