{ makeSetupHook, dieHook }:
makeSetupHook {
  name = "shorten-perl-shebang-hook";
  propagatedBuildInputs = [ dieHook ];
} ./hook.sh
