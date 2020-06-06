{ stdenv, fetchFromGitHub, systemd }:

stdenv.mkDerivation rec {
  pname = "systembus-notify";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "systembus-notify";
    rev = "v${version}";
    sha256 = "11zq84qfmbyl51d3r6294l2bjhlgwa9bx7d263g9fkqrwsg0si0y";
  };

  buildInputs = [ systemd ];

  installPhase = ''
    runHook preInstall
    install -Dm755 systembus-notify -t $out/bin
    install -Dm644 systembus-notify.desktop -t $out/etc/xdg/autostart
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "System bus notification daemon";
    homepage = "https://github.com/rfjakob/systembus-notify";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
