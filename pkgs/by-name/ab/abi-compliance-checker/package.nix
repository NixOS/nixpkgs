{
  lib,
  stdenv,
  fetchFromGitHub,
  ctags,
  perl,
  binutils,
  abi-dumper,
}:

stdenv.mkDerivation rec {
  pname = "abi-compliance-checker";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "abi-compliance-checker";
    rev = version;
    hash = "sha256-Mk7mr4QFsKlKV6d2hDNS0OyUIGtKUkGdHkgmZ4VMLrg=";
  };

  buildInputs = [
    binutils
    ctags
    perl
  ];
  propagatedBuildInputs = [ abi-dumper ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    homepage = "https://lvc.github.io/abi-compliance-checker";
    description = "Tool for checking backward API/ABI compatibility of a C/C++ library";
    mainProgram = "abi-compliance-checker";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bhipple ];
    platforms = lib.platforms.all;
  };
}
