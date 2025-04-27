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
  version = "0-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "011b0bdec303783b6ce2a197957effef480ca50d";
    hash = "sha256-uyAxeUI0tKeAauSpOhuPMaqav5ksaawayiFWidInFUI=";
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
