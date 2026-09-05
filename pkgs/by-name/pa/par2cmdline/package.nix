{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "par2cmdline";
  version = "1.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Parchive";
    repo = "par2cmdline";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TEWfkjyjqG5cRsVkckIoIo/+/LwhwH1GVivX6Dpvpxw=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/Parchive/par2cmdline";
    description = "PAR 2.0 compatible file verification and repair tool";
    longDescription = ''
      par2cmdline is a program for creating and using PAR2 files to detect
      damage in data files and repair them if necessary. It can be used with
      any kind of file.
    '';
    mainProgram = "par2";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ tallesCoelho ];
    platforms = lib.platforms.all;
  };
})
