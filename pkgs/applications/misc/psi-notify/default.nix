{ lib, stdenv, fetchFromGitHub, systemd, libnotify, pkg-config }:

stdenv.mkDerivation rec {
  pname = "psi-notify";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "cdown";
    repo = pname;
    rev = version;
    sha256 = "sha256-GhGiSI5r0Ki6+MYNa5jCDyYZEW5R9LDNZ/S8K+6L0jo=";
  };

  buildInputs = [ systemd libnotify ];
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    runHook preInstall

    install -D psi-notify $out/bin/psi-notify
    substituteInPlace psi-notify.service --replace psi-notify $out/bin/psi-notify
    install -D psi-notify.service $out/lib/systemd/user/psi-notify.service

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
