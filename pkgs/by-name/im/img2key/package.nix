{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "img2key";
  version = "2.0.0x";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Khitboksy";
    repo = "img2key";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D00eDU32/W3uE7SU3ASowZvtm52jS14+Rjd46GwyLHk=";
  };

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  buildPhase = ''
    runHook preBuild
    bun build --compile --target=bun --outfile=img2key ./src/main.ts
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 img2key $out/bin/img2key
    runHook postInstall
  '';

  dontFixup = true;
  dontStrip = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Derive deterministic passwords from images";
    homepage = "https://github.com/Khitboksy/img2key";
    license = lib.licenses.gpl3Only;
    mainProgram = "img2key";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ khitboksy ];
  };
})
