{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  bash,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fdroidpublisher";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "by-architect";
    repo = "FdroidPublisher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qLgSl6SLL31g5G0HObOxfYZGy1zPkENoJVmUtWF7lZ0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    export DESTDIR= PREFIX=$out
    install -Dm755 fdroidPublisher "$DESTDIR$PREFIX/bin/fdroidPublisher"

    runHook postInstall
  '';

  buildInputs = [
    bash
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Make publishing easier to fdroid";
    homepage = "https://github.com/by-architect/FdroidPublisher";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ by-architect ];
    mainProgram = "fdroidPublisher";
    platforms = lib.platforms.unix;
  };
})
