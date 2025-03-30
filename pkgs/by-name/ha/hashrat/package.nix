{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hashrat";
  version = "1.25";

  src = fetchFromGitHub {
    owner = "ColumPaget";
    repo = "Hashrat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nGaOVvy8caySohCGyGdnxXsv2DuqFPRi4JJLlZy+q8o=";
  };

  configureFlags = [ "--enable-xattr" ];

  makeFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line hash-generation utility";
    mainProgram = "hashrat";
    longDescription = ''
      Hashing tool supporting md5,sha1,sha256,sha512,whirlpool,jh and hmac versions of these.
      Includes recursive file hashing and other features.
    '';
    homepage = "https://github.com/ColumPaget/Hashrat";
    changelog = "https://github.com/ColumPaget/Hashrat/blob/v${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zendo ];
  };
})
