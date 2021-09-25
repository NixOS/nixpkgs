{ lib, stdenv, fetchFromGitHub, systemd, libnotify, pkg-config }:

stdenv.mkDerivation rec {
  pname = "psi-notify";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = version;
    sha256 = "0hn37plim1smmlrjjmz8kybyms8pz3wxcgf8vmqjrsqi6bfcym7g";
  };

  buildInputs = [ systemd libnotify ];
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    runHook preInstall

    install -D psi-notify $out/bin/psi-notify
    substituteInPlace psi-notify.service --replace psi-notify $out/bin/psi-notify
    install -D psi-notify.service $out/share/systemd/user/psi-notify.service

    runHook postInstall
  '';

  meta = with lib; {
    description = "Alert on system resource saturation";
    longDescription = ''
      psi-notify can alert you when resources on your machine are becoming
      oversaturated, and allow you to take action before your system slows to a
      crawl.
    '';
    license = licenses.mit;
    homepage = "https://github.com/cdown/psi-notify";
    platforms = platforms.linux;
    maintainers = with maintainers; [ eduarrrd ];
  };
}
