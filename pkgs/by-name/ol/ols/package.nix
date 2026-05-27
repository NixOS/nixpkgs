{
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  odin,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ols";
  version = "dev-2026-05";

  src = fetchFromGitHub {
    owner = "DanielGavin";
    repo = "ols";
    tag = finalAttrs.version;
    hash = "sha256-9tQVyauvXGTkKnQUSYKAhjL5ZZbhglqdcxdcs27P2k4=";
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

  meta = {
    inherit (odin.meta) platforms;
    description = "Language server for the Odin programming language";
    homepage = "https://github.com/DanielGavin/ols";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      astavie
      atomicptr
    ];
    mainProgram = "ols";
  };
})
