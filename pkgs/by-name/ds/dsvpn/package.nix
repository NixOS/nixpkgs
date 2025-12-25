{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "dsvpn";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dsvpn";
    rev = version;
    sha256 = "sha256-hO1UVyAGZXqSaEJsCo/SQZkvvbfU6FCuOJWhLJ2CGhg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dsvpn

    runHook postInstall
  '';

  meta = {
    description = "Dead Simple VPN";
    homepage = "https://github.com/jedisct1/dsvpn";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "dsvpn";
  };
}
