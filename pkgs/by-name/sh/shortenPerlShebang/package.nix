{
  lib,
  makeSetupHook,
  dieHook,
}:

makeSetupHook {
  name = "shorten-perl-shebang-hook";
  propagatedBuildInputs = [ dieHook ];
  meta.license = lib.licenses.mit;
} ./shorten-perl-shebang.sh
