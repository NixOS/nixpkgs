{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  coreutils,
}:

stdenv.mkDerivation {
  version = "1.2.2";
  pname = "light";

  src = fetchFromGitLab {
    owner = "dpeukert";
    repo = "light";
    rev = "2a54078cbe3814105ee4f565f451b1b5947fbde0";
    hash = "sha256-OmHdVJvBcBjJiPs45JqOHxFoJYvKIEIpt9pFhBz74Kg=";
  };

  configureFlags = [ "--with-udev" ];

  nativeBuildInputs = [ autoreconfHook ];

  patches = [
    ./0001-define-light-loglevel-as-extern.patch
  ];

  # ensure udev rules can find the commands used
  postPatch = ''
    substituteInPlace 90-backlight.rules \
      --replace-fail '/bin/chgrp' '${coreutils}/bin/chgrp' \
      --replace-fail '/bin/chmod' '${coreutils}/bin/chmod'
  '';

  meta = {
    description = "GNU/Linux application to control backlights";
    homepage = "https://gitlab.com/dpeukert/light";
    license = lib.licenses.gpl3Only;
    mainProgram = "light";
    maintainers = with lib.maintainers; [
      puffnfresh
      dtzWill
    ];
    platforms = lib.platforms.linux;
  };
}
