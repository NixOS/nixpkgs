{
  lib,
  stdenv,
  fetchFromGitHub,
  ctags,
  perl,
  elfutils,
  vtable-dumper,
}:

stdenv.mkDerivation rec {
  pname = "abi-dumper";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "abi-dumper";
    tag = version;
    sha256 = "sha256-BefDMeKHx4MNU6SyX5UpQnwdI+zqap7zunsgdWG/2xc=";
  };

  patchPhase = ''
    substituteInPlace abi-dumper.pl \
      --replace eu-readelf ${elfutils}/bin/eu-readelf \
      --replace vtable-dumper ${vtable-dumper}/bin/vtable-dumper \
      --replace '"ctags"' '"${ctags}/bin/ctags"'
  '';

  buildInputs = [
    elfutils
    ctags
    perl
    vtable-dumper
  ];

  preBuild = "mkdir -p $out";
  makeFlags = [ "prefix=$(out)" ];

  meta = {
    homepage = "https://github.com/lvc/abi-dumper";
    description = "Dump ABI of an ELF object containing DWARF debug info";
    mainProgram = "abi-dumper";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
}
