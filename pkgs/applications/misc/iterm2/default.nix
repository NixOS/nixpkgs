{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "iterm2-${version}";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "gnachman";
    repo = "iTerm2";
    rev = "v${version}";
    sha256 = "0ffg9l2jvv503h13nd5rjkn5xrahswcqqwmm052qzd6d0lmqjm93";
  };

  patches = [ ./disable_updates.patch ];
  makeFlagsArray = ["Deployment"];
  installPhase = ''
    mkdir -p "$out/Applications"
    mv "build/Deployment/iTerm2.app" "$out/Applications/iTerm.app"
  '';

  meta = {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.darwin;
  };
}
