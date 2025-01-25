{
  stdenv,
  elvish,
  replaceVars,
}:

stdenv.mkDerivation {
  pname = "elvish-simple-test";
  inherit (elvish) version;

  nativeBuildInputs = [ elvish ];

  dontInstall = true;

  buildCommand = ''
    elvish ${
      replaceVars ./expect-version.elv {
        inherit (elvish) version;
      }
    }

    touch $out
  '';

  meta.timeout = 10;
}
