{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, libiconv
, libmpdclient
, meson
, ninja
, pkg-config
, sphinx
}:

stdenv.mkDerivation rec {
  pname = "mpc";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2FjYBfak0IjibuU+CNQ0y9Ei8hTZhynS/BK2DNerhVw=";
  };

  buildInputs = [
    libmpdclient
  ]
  ++ lib.optionals stdenv.isDarwin [ libiconv ];

  nativeBuildInputs = [
    installShellFiles
    meson
    ninja
    pkg-config
    sphinx
  ];

  postInstall = ''
    installShellCompletion --cmd mpc --bash $out/share/doc/mpc/contrib/mpc-completion.bash
  '';

  postFixup = ''
    rm $out/share/doc/mpc/contrib/mpc-completion.bash
  '';

  meta = with lib; {
    homepage = "https://www.musicpd.org/clients/mpc/";
    description = "A minimalist command line interface to MPD";
    changelog = "https://raw.githubusercontent.com/MusicPlayerDaemon/mpc/v${version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
