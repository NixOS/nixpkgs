{
  autoreconfHook,
  fetchFromGitHub,
  lib,
  openssl,
  python3,
  stdenv,
}:

let
  pname = "ripe-atlas-software-probe";
  version = "5120";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "RIPE-NCC";
    repo = pname;
    rev = "${version}";
    hash = "sha256-rjhLLeUj6US76/joRVBmYeqKsPVE5KzZGdE4eEilEKI=";
  };

  configureFlags = [
    "--with-probe-type=generic"
    "--disable-chown"
    "--disable-systemd"
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
    python3
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = ''
      RIPE Atlas is a global network of probes that measure Internet connectivity and
      reachability, providing an unprecedented understanding of the state of the
      Internet in real time.

      This project contains the probe code that powers software probes.
    '';
    homepage = "https://github.com/RIPE-NCC/ripe-atlas-software-probe";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ananthb ];
  };
}
