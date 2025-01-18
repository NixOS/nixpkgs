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

  meta = with lib; {
    description = "Posix Ada Bindings";
    homepage = "https://github.com/adacore/florist";
    license = licenses.mit;
    maintainers = with maintainers; [ lutzberger ];
    platforms = platforms.linux;
  };
}
