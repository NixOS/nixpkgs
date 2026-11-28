{
  lib,
  makeSetupHook,
  dieHook,
}:

makeSetupHook {
  name = "shorten-perl-shebang-hook";
  propagatedBuildInputs = [ dieHook ];
  meta = {
    license = lib.licenses.mit;
    problems.deprecated.message = "shortenPerlShebang is a no-op; remove it from nativeBuildInputs and drop any calls to the shortenPerlShebang function.";
  };
} ./shorten-perl-shebang.sh
