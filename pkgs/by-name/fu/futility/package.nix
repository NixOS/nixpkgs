{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
}:
stdenv.mkDerivation {
  pname = "futility";
  version = "0-unstable-2022-11-09";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "futility";
    rev = "fbc8d5bbd2cf8ed99c769db40641699968e510d8";
    hash = "sha256-MBCQf8O+Qne30B8qUze+x4jjPDYLIBA1JFhFZaXmwXI=";
  };

  strictDeps = true;

  buildInputs = [ openssl ];

  # Unstream has an install target, but installs futility as `$out/bin`
  # instead of `$out/bin/futility`
  installPhase = ''
    runHook preInstall
    install -Dm555 futility -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/futility";
    description = "Firmware utility for signing ChromeOS images";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "futility";
  };
}
