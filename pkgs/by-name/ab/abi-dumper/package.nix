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
  version = "1.2";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "abi-dumper";
    rev = version;
    sha256 = "1i00rfnddrrb9lb1l6ib19g3a76pyasl9lb7rqz2p998gav1gjp2";
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

  meta = with lib; {
    homepage = "https://github.com/lvc/abi-dumper";
    description = "Dump ABI of an ELF object containing DWARF debug info";
    mainProgram = "abi-dumper";
    license = licenses.lgpl21;
    maintainers = [ maintainers.bhipple ];
    platforms = platforms.all;
  };
}
