{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsvpn";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jedisct1";
    repo = "dsvpn";
    tag = finalAttrs.version;
    hash = "sha256-o0/m8RrokXp0wjcRjGEOEKmArolrlHODi5+xW/d8HIo=";
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
})
