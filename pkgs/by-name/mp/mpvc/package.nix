{
  lib,
  fetchFromGitHub,
  makeWrapper,
  socat,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpvc";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "lwilletts";
    repo = "mpvc";
    rev = finalAttrs.version;
    hash = "sha256-wPETEG0BtNBEj3ZyP70byLzIP+NMUKbnjQ+kdvrvK3s=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ socat ];

  makeFlags = [ "PREFIX=$(out)" ];

  installFlags = [ "PREFIX=$(out)" ];

  strictDeps = true;

  postInstall = ''
    wrapProgram $out/bin/mpvc --prefix PATH : "${lib.getBin socat}/"
  '';

  meta = {
    homepage = "https://github.com/lwilletts/mpvc";
    description = "Mpc-like control interface for mpv";
    license = lib.licenses.mit;
    mainProgram = "mpvc";
    maintainers = with lib.maintainers; [ neeasade ];
    platforms = lib.platforms.linux;
  };
})
