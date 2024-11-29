{ lib, stdenv
, binutils-unwrapped-all-targets
}:

stdenv.mkDerivation {
  pname = "libbfd";
  inherit (binutils-unwrapped-all-targets) version;

  dontUnpack = true;
  dontBuild = true;
  dontInstall = true;
  propagatedBuildInputs = [
    binutils-unwrapped-all-targets.dev
    binutils-unwrapped-all-targets.lib
  ];

  passthru = {
    inherit (binutils-unwrapped-all-targets) dev hasPluginAPI;
  };

  meta = with lib; {
    description = "Library for manipulating containers of machine code";
    longDescription = ''
      BFD is a library which provides a single interface to read and write
      object files, executables, archive files, and core files in any format.
      It is associated with GNU Binutils, and elsewhere often distributed with
      it.
    '';
    homepage = "https://www.gnu.org/software/binutils/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ericson2314 ];
    platforms = platforms.unix;
  };
}
