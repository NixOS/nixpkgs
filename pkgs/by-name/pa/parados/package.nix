{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:
stdenv.mkDerivation {
  pname = "parados";
  version = "2.26";
  src = fetchFromGitHub {
    owner = "uint23";
    repo = "parados";
    tag = "r1.0";
    hash = "sha256-NcMIW0XLk9f/jz8PUKExls7kOiW0hdnivkGNBwRQyxo=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    description = "Simple home media server for UNIX systems";
    homepage = "https://github.com/uint23/parados";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ricardomaps ];
    mainProgram = "parados";
    platforms = lib.platforms.unix;
  };
}
