{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "20240729";
  pname = "m4ri";

  src = fetchFromGitHub {
    owner = "malb";
    repo = "m4ri";
    # 20240729 has a broken m4ri.pc file, fixed in the next commit.
    # TODO: remove if on update
    rev =
      if version == "20240729" then "775189bfea96ffaeab460513413fcf4fbcd64392" else "release-${version}";
    hash = "sha256-untwo0go8O8zNO0EyZ4n/n7mngSXLr3Z/FSkXA8ptnU=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = lib.licenses.gpl2Plus;
    maintainers = lib.teams.sage.members;
    platforms = lib.platforms.unix;
  };
}
