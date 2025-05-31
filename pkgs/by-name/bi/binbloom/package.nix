{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "binbloom";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "quarkslab";
    repo = "binbloom";
    rev = "v${version}";
    hash = "sha256-ox4o9RPtqMsme//8dVatNUo+mA/6dM9eI/T5lsuSAus=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Raw binary firmware analysis software";
    mainProgram = "binbloom";
    homepage = "https://github.com/quarkslab/binbloom";
    license = licenses.asl20;
    maintainers = with maintainers; [ erdnaxe ];
    platforms = platforms.linux;
  };
}
