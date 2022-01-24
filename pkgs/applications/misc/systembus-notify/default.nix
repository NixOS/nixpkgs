{ lib, stdenv, fetchFromGitHub, systemd }:

stdenv.mkDerivation rec {
  pname = "systembus-notify";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "systembus-notify";
    rev = "v${version}";
    sha256 = "1pdn45rfpwhrf20hs87qmk2j8sr7ab8161f81019wnypnb1q2fsv";
  };

  buildInputs = [ systemd ];

  installPhase = ''
    runHook preInstall
    install -Dm755 systembus-notify -t $out/bin
    install -Dm644 systembus-notify.desktop -t $out/etc/xdg/autostart
    runHook postInstall
  '';

  meta = with lib; {
    description = "System bus notification daemon";
    homepage = "https://github.com/rfjakob/systembus-notify";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [];
  };
}
