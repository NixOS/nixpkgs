{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation {
  pname = "msr-tools";
  version = "1.3-unstable-2022-08-05";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "msr-tools";
    rev = "7d78c80d66463ac598bcc8bf1dc260418788dfda";
    hash = "sha256-p+bfS1Fsz9MqPLmiVD8d+93oeUxxU2raKdRY7pThlzk=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Tools to read/write from/to MSR CPU registers on Linux";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
