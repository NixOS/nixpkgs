{ lib
, stdenv
, haunt
}:

stdenv.mkDerivation {
  pname = "haunt-test-version";
  inherit (haunt) version;

  nativeBuildInputs = [ haunt ];

  dontInstall = true;

  buildCommand = ''
    haunt --version

    touch $out
  '';

  meta.timeout = 10;
}
