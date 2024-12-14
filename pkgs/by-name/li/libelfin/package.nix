{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  substituteAll,
}:

stdenv.mkDerivation rec {
  pname = "libelfin";
  version = "unstable-2018-08-25";

  src = fetchFromGitHub {
    owner = "aclements";
    repo = pname;
    rev = "ac45a094fadba77ad840063fb7aab82571546be0";
    sha256 = "143x680c6hsy51kngs04ypg4ql3lp498llcwj4lh1v0qp5qvjhyz";
  };

  patches = [
    (substituteAll {
      src = ./0001-Don-t-detect-package-version-with-Git.patch;
      inherit version;
    })
  ];

  nativeBuildInputs = [ python3 ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://github.com/aclements/libelfin/";
    license = licenses.mit;
    description = "C++11 ELF/DWARF parser";
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
