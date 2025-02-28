{ lib, testers }:
lib.recurseIntoAttrs {
  shellcheck = testers.shellcheck {
    name = "sourceGuard";
    src = ./sourceGuard.bash;
  };
  shfmt = testers.shfmt {
    name = "sourceGuard";
    src = ./sourceGuard.bash;
  };
  # TODO(@connorbaker): More tests.
}
