{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, doxygen
, installShellFiles
, zlib
}:

stdenv.mkDerivation rec {
  pname = "liberasurecode";
  version = "1.6.2";

  outputs = [ "out" "dev" "doc" ];

  src = fetchFromGitHub {
    owner = "openstack";
    repo = pname;
    rev = version;
    sha256 = "sha256-qV7DL/7zrwrYOaPj6iHnChGA6KHFwYKjeaMnrGrTPrQ=";
  };

  postPatch = ''
    substituteInPlace doc/doxygen.cfg.in \
      --replace "GENERATE_MAN           = NO" "GENERATE_MAN           = YES"
  '';

  nativeBuildInputs = [ autoreconfHook doxygen installShellFiles ];

  buildInputs = [ zlib ];

  configureFlags = [ "--enable-doxygen" ];

  postInstall = ''
    # remove useless man pages about directories
    rm doc/man/man*/_*
    installManPage doc/man/man*/*

    moveToOutput share/liberasurecode/ $doc
  '';

  checkTarget = "test";

  meta = with lib; {
    description = "Erasure Code API library written in C with pluggable Erasure Code backends";
    homepage = "https://github.com/openstack/liberasurecode";
    license = licenses.bsd2;
    maintainers = teams.openstack.members;
  };
}
