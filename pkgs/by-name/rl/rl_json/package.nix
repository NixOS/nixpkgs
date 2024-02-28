{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, tcl
}:

stdenv.mkDerivation rec {
  pname = "rl_json";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "RubyLane";
    repo = "rl_json";
    rev = version;
    hash = "sha256-7xjZQ8F8czrkr7p2Xg1xAZRCsDpiWXHXVxPhG0f9PNg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoreconfHook
    tcl.tclPackageHook
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--libdir=${placeholder "out"}/lib"
    "--includedir=${placeholder "out"}/include"
    "--datarootdir=${placeholder "out"}/share"
  ];

  meta = {
    homepage = "https://github.com/RubyLane/rl_json";
    description = "Tcl extension for fast json manipulation";
    license = lib.licenses.tcltk;
    longDescription = ''
      Extends Tcl with a json value type and a command to manipulate json values
      directly. Similar in spirit to how the dict command manipulates dictionary
      values, and comparable in speed.
    '';
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
