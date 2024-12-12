{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "sedutil";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "Drive-Trust-Alliance";
    repo = "sedutil";
    rev = version;
    sha256 = "sha256-NG/7aqe48ShHWW5hW8axYWV4+zX0dBE7Wy9q58l0S3E=";
  };

  patches = [
    # Fix for gcc-13 pending upstream inclusion:
    #   https://github.com/Drive-Trust-Alliance/sedutil/pull/425
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/Drive-Trust-Alliance/sedutil/commit/927cd88cad7bea94c2eebecc18f7881f0defaccb.patch";
      hash = "sha256-/Lvn3CQd7pzNhLa7sQY8VwbyJK/jEM5FzLijTQnzXx8=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "DTA sedutil Self encrypting drive software";
    homepage = "https://www.drivetrust.com";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
