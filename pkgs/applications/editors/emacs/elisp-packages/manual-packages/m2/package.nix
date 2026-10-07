{
  lib,
  melpaBuild,
  fetchFromGitHub,
  macaulay2,
}:
melpaBuild {
  pname = "m2";
  ename = "M2";

  version = "1.26.6";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2-emacs";
    rev = "ae882ab04da19f62c62462ef9604251a0b30a9f5";
    hash = "sha256-8qnPzLR616Oypb6YGUm1cVj8jd1QDdeajHkVaTaEnX4=";
  };

  postPatch = ''
    substituteInPlace M2.el \
      --replace-fail 'defcustom M2-exe "M2"' 'defcustom M2-exe "${lib.getExe macaulay2}"'
  '';

  meta = {
    inherit (macaulay2.meta) maintainers platforms;
    description = "Major mode for editing Macaulay2 source code";
    homepage = "https://github.com/Macaulay2/M2-emacs";
    license = lib.licenses.gpl3Plus;
  };
}
