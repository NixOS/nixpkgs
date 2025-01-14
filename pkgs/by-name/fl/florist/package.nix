{
  stdenv,
  gnat13,
  gnat13Packages,
  fetchFromGitHub,
  lib,
}:

stdenv.mkDerivation rec {
  name = "florist";
  version = "24.2";

  src = fetchFromGitHub {
    owner = "adacore";
    repo = "florist";
    rev = "refs/heads/${version}";
    hash = "sha256-EFGmcQfWpxEWfsAoQrHegTlizl6siE8obKx+fCpVwUQ=";
  };

  configureFlags = [ "--enable-shared" ];

  nativeBuildInputs = [
    gnat13
    gnat13Packages.gprbuild
  ];

  meta = {
    description = "Posix Ada Bindings";
    homepage = "https://github.com/adacore/florist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lutzberger ];
    platforms = lib.platforms.linux;
  };
}
