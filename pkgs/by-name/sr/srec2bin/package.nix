{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "srec2bin";
  version = "1.51";

  src = fetchFromGitHub {
    owner = "srec2bin";
    repo = "srec";
    tag = "V${finalAttrs.version}";
    hash = "sha256-akExYUp59Y0XA/MWif+/agz7DcsY/8Y6UI7jt/qMdwk=";
  };

  patches = [ ./package.patch ]; # upstream builds for windows

  meta = with lib; {
    description = "Tool for converting Motorola S-Record file into a binary image";
    homepage = "https://github.com/srec2bin/srec";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ KSJ2000 ];
    mainProgram = "srec2bin";
  };
})
