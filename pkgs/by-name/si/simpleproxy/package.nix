{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simpleproxy";
  version = "3.6";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vzaliva";
    repo = "simpleproxy";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-O4PncEm8LZaJDN28kwsSvCEewr+k0EAyHMu3U+JYyQQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/vzaliva/simpleproxy";
    description = "Simple TCP proxy";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.montag451 ];
    mainProgram = "simpleproxy";
  };
})
