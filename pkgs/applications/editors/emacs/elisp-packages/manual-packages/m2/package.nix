{
  lib,
  melpaBuild,
  fetchFromGitHub,
  macaulay2,
}:
melpaBuild {
  pname = "m2";
  ename = "M2";

  version = "1.26.11";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2-emacs";
    rev = "aeac7105993337648eae572d2f8fbec3d4aeeaca";
    hash = "sha256-qPBwcFfJ3JemhEKUdB7cmbvaQvx8CaFx37Z36aMnFHg=";
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
