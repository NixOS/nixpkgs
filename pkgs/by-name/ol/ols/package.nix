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
  version = "0-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    rev = "9f7ba16c9c9afeb49f2a8b1729141afe5011bc88";
    hash = "sha256-f0A6KzKT05rthQT8zfjx/UIM43BUxqT6VdYj6pHA6eU=";
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
