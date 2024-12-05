{ lib, stdenv, fetchFromGitHub, gitUpdater, pkg-config, autoreconfHook
, libX11, pam, libgcrypt, libXrender, imlib2 }:

stdenv.mkDerivation rec {
  pname = "alock";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "Arkq";
    repo = "alock";
    rev = "refs/tags/v${version}";
    hash = "sha256-xfPhsXZrTlEqea75SvacDfjM9o21MTudrqfNN9xtdcg=";
  };

  PAM_DEFAULT_SERVICE = "login";

  configureFlags = [
    "--enable-pam"
    "--enable-hash"
    "--enable-xrender"
    "--enable-imlib2"
  ];

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    libX11
    pam libgcrypt libXrender imlib2
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "\\.";
  };

  meta = with lib; {
    homepage = "https://github.com/Arkq/alock";
    description = "Simple screen lock application for X server";
    mainProgram = "alock";
    longDescription = ''
      alock locks the X server until the user enters a password
      via the keyboard. If the authentication was successful
      the X server is unlocked and the user can continue to work.

      alock does not provide any fancy animations like xlock or
      xscreensaver and never will. It's just for locking the current
      X session.
    '';
    platforms = platforms.linux;
    maintainers = with maintainers; [ ftrvxmtrx chris-martin ];
    license = licenses.mit;
  };
}
