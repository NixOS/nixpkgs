{ lib, testers }:
lib.recurseIntoAttrs {
  shellcheck = testers.shellcheck {
    name = "sourceGuard";
    src = ./source-guard.bash;
  };
  shfmt = testers.shfmt {
    name = "sourceGuard";
    src = ./source-guard.bash;
  };
}
