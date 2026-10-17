{
  lib,
  bash,
  coreutils,
  fetchFromGitHub,
  gawk,
  gnugrep,
  gnused,
  help2man,
  resholve,
  xrandr,
}:

resholve.mkDerivation {
  pname = "mons";
  version = "0.8.2-unstable-2020-03-20";

  src = fetchFromGitHub {
    owner = "Ventto";
    repo = "mons";
    rev = "375bbba3aa700c8b3b33645a7fb70605c8b0ff0c";
    hash = "sha256-lAXhBkhY0oWGZFS6bug+6IK6pUxCp3RlarBnH8TxJac=";
    fetchSubmodules = true;
  };

  /*
    Remove reference to `%LIBDIR%/liblist.sh`. This would be linked to the
    non-resholved of the library in the final derivation.

    Patching out the library check; it's bad on multiple levels:
    1. The check literally breaks if it fails.
       See https://github.com/Ventto/mons/pull/49
    2. It doesn't need to do this; source would fail with a
       sensible message if the script was missing.
    3. resholve can't wrestle with test/[] (at least until
       https://github.com/abathur/resholve/issues/78)
  */
  postPatch = ''
    substituteInPlace mons.sh \
      --replace "lib='%LIBDIR%/liblist.sh'" "" \
      --replace '[ ! -r "$lib" ] && { "$lib: library not found."; exit 1; }' ""
  '';

  solutions = {
    mons = {
      scripts = [
        "bin/mons"
        "lib/libshlist/liblist.sh"
      ];
      interpreter = "${bash}/bin/sh";
      inputs = [
        bash
        coreutils
        gawk
        gnugrep
        gnused
        xrandr
      ];
      fix = {
        "$lib" = [ "lib/libshlist/liblist.sh" ];
        "$XRANDR" = [ "xrandr" ];
      };
      keep = {
        /*
          has a whole slate of *flag variables that it sets to either
          the true or false builtin and then executes...
        */
        "$aFlag" = true;
        "$dFlag" = true;
        "$eFlag" = true;
        "$mFlag" = true;
        "$nFlag" = true;
        "$oFlag" = true;
        "$sFlag" = true;
        "$OFlag" = true;
        "$SFlag" = true;
        "$pFlag" = true;
        "$iFlag" = true;
        "$xFlag" = true;
        "$is_flag" = true;
      };
    };
  };

  nativeBuildInputs = [ help2man ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = {
    description = "POSIX Shell script to quickly manage 2-monitors display";
    homepage = "https://github.com/Ventto/mons.git";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.platforms.unix;
    mainProgram = "mons";
  };
}
