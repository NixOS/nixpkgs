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
  version = "0-unstable-2025-09-19";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "7ff84eb0b24912db1b3f3b0cff323e1728f47b0b";
    hash = "sha256-aKyVZARXFMBa0kbI4yeqPZIFHmPCKUy1WPr33aIHbQI=";
  };

  postPatch = ''
    substituteInPlace build.sh \
      --replace-fail "-microarch:native" ""
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
