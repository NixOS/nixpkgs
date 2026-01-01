{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libopus,
  libogg,
  gmp,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "seren";
  version = "0.0.21";

  buildInputs = [
    alsa-lib
    libopus
    libogg
    gmp
    ncurses
  ];

  src = fetchurl {
    url = "http://holdenc.altervista.org/seren/downloads/${pname}-${version}.tar.gz";
    sha256 = "sha256-adI365McrJkvTexvnWjMzpHcJkLY3S/uWfE8u4yuqho=";
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Simple ncurses VoIP program based on the Opus codec";
    mainProgram = "seren";
    longDescription = ''
      Seren is a simple VoIP program based on the Opus codec
      that allows you to create a voice conference from the terminal, with up to 10
      participants, without having to register accounts, exchange emails, or add
      people to contact lists. All you need to join an existing conference is the
      host name or IP address of one of the participants.
    '';
    homepage = "http://holdenc.altervista.org/seren/";
    changelog = "http://holdenc.altervista.org/seren/";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      matthewcroughan
      nixinator
    ];
    platforms = lib.platforms.linux;
=======
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      matthewcroughan
      nixinator
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
