{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  autoconf-archive,
  guile,
  texinfo,
  makeWrapper,
  rofi,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "pinentry-rofi";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "plattfot";
    repo = "pinentry-rofi";
    rev = version;
    sha256 = "sha256-GHpVO8FRphVW0+In7TtB39ewwVLU1EHOeVL05pnZdFQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    guile
    pkg-config
    texinfo
    makeWrapper
  ];

  buildInputs = [ guile ];

  # pinentry-rofi wants to call `env rofi` (https://github.com/plattfot/pinentry-rofi/blob/fde8e32b8380512e2ba02961ccc99765575e2c89/pinentry-rofi.scm#L338)
  postInstall = ''
    wrapProgram $out/bin/pinentry-rofi --prefix PATH : ${
      lib.makeBinPath [
        rofi
        coreutils
      ]
    }
  '';

  meta = with lib; {
    description = "Rofi frontend to pinentry";
    homepage = "https://github.com/plattfot/pinentry-rofi";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ seqizz ];
    mainProgram = "pinentry-rofi";
  };
}
