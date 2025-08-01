{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  replaceVars,
}:

stdenv.mkDerivation rec {
  pname = "libelfin";
  version = "0.3-unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "aclements";
    repo = "libelfin";
    rev = "e0172767b79b76373044118ef0272b49b02a0894";
    hash = "sha256-xb5/DM2XOFM/w71OwRC/sCRqOSQvxVL1SS2zj2+dD/U=";
  };

  patches = [
    (replaceVars ./0001-Don-t-detect-package-version-with-Git.patch {
      inherit version;
    })
  ];

  nativeBuildInputs = [ python3 ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/aclements/libelfin/";
    license = lib.licenses.mit;
    description = "C++11 ELF/DWARF parser";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
