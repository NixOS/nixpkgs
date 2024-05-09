{ lib
, stdenv
, elvish
, substituteAll
}:

stdenv.mkDerivation {
  pname = "elvish-simple-test";
  inherit (elvish) version;

  nativeBuildInputs = [ elvish ];

  dontInstall = true;

  buildCommand = ''
    elvish ${substituteAll {
      src = ./expect-version.elv;
      inherit (elvish) version;
    }}

    touch $out
  '';

  meta.timeout = 10;
}
