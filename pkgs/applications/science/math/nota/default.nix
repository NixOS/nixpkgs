{ mkDerivation, haskellPackages, fetchurl, lib }:

mkDerivation rec {
  pname = "nota";
  version = "1.0";

  # Can't use fetchFromGitLab since codes.kary.us doesn't support https
  src = fetchurl {
    url = "http://codes.kary.us/nota/nota/-/archive/V${version}/nota-V${version}.tar.bz2";
    sha256 = "0bbs6bm9p852hvqadmqs428ir7m65h2prwyma238iirv42pk04v8";
  };

  postUnpack = ''
    export sourceRoot=$sourceRoot/source
  '';

  isLibrary = false;
  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    base
    bytestring
    array
    split
    scientific
    parsec
    ansi-terminal
    regex-compat
    containers
    terminal-size
    numbers
    text
    time
  ];

  description = "The most beautiful command line calculator";
  homepage = "https://kary.us/nota";
  license = lib.licenses.mpl20;
  maintainers = with lib.maintainers; [ dtzWill ];
  mainProgram = "nota";
}
