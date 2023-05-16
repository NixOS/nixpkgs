{stdenvNoCC, darcs, cacert, lib}:

lib.makeOverridable (
{ url
, rev ? null
, context ? null
<<<<<<< HEAD
=======
, md5 ? ""
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sha256 ? ""
, name ? "fetchdarcs"
}:

<<<<<<< HEAD
=======
if md5 != "" then
  throw "fetchdarcs does not support md5 anymore, please use sha256"
else
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
stdenvNoCC.mkDerivation {
  builder = ./builder.sh;
  nativeBuildInputs = [cacert darcs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev context name;
}
)
