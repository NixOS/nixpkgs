{ lib
, stdenv
, fetchFromGitLab
, libuv
, coreutils-full
, pkg-config
, gnugrep
, gnused
}:

stdenv.mkDerivation rec {
  pname = "dps8m";
  version = "3.0.1";

  src = fetchFromGitLab {
    owner = "dps8m";
    repo = "dps8m";
    rev = "R${version}";
    hash = "sha256-YCDeHryxXZXOXqUXkbWwH7Vna+ljzydFXPeo2et87x8=";
    fetchSubmodules = true;
  };

  env = {
    ENV = "${coreutils-full}/bin/env";
    GREP = "${gnugrep}/bin/grep";
    SED = "${gnused}/bin/sed";
    PREFIX = placeholder "out";
  };

  nativeBuildInputs = [
    coreutils-full
    pkg-config
  ];

  buildInputs = [
    libuv
  ];

  meta = with lib; {
    description = "DPS8M: GE / Honeywell / Bull DPS‑8/M mainframe simulator";
    homepage = "https://gitlab.com/dps8m/dps8m";
    changelog = "https://gitlab.com/dps8m/dps8m/-/wikis/DPS8M-${src.rev}-Release-Notes";
    license = licenses.icu;
    maintainers = with maintainers; [ matthewcroughan sarcasticadmin ];
    mainProgram = "dps8m";
    platforms = platforms.all;
  };
}
