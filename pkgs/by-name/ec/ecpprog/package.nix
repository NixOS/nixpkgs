{
  stdenv,
  lib,
  fetchFromGitHub,
  libftdi1,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecpprog";
  version = "0-unstable-2024-11-07";

  src = fetchFromGitHub {
    owner = "gregdavill";
    repo = "ecpprog";
    rev = "1931c3e121f682536a9d80ca1ce1b651c11aef76";
    hash = "sha256-f7VYcEJe3q/rvDtCTaCvVhvxOIb7swEhAd3+035u/DQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/ecpprog";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libftdi1 ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  # check whether the executable is functional at all
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/ecpprog --help
  '';

  meta = {
    description = "Driver for FTDI based JTAG probes to program Lattice ECP5/Nexus FPGAs";
    homepage = "https://github.com/gregdavill/ecpprog";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    mainProgram = "ecpprog";
    maintainers = [ lib.maintainers.daanrs ];
  };
})
