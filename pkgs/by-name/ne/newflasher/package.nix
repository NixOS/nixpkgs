{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  expat,
  zlib,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "newflasher";
  version = "61";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "munjeni";
    repo = "newflasher";
    tag = "${finalAttrs.version}";
    hash = "sha256-9qEGFzA5sMn+1MOKNTJeBukurzytksXitgXraPL0KDU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [
    expat
    zlib
  ];

  installPhase = ''
    runHook preInstall
    installBin newflasher
    installManPage newflasher.1
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Flash tool for new Sony flash tool protocol (Xperia XZ Premium and newer)";
    homepage = "https://github.com/munjeni/newflasher";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
