{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "binbloom";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "quarkslab";
    repo = "binbloom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ox4o9RPtqMsme//8dVatNUo+mA/6dM9eI/T5lsuSAus=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Raw binary firmware analysis software";
    mainProgram = "binbloom";
    homepage = "https://github.com/quarkslab/binbloom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ erdnaxe ];
    platforms = lib.platforms.linux;
  };
})
