{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "straight";
  version = "0-unstable-2025-11-21";

  src = fetchFromGitHub {
    owner = "radian-software";
    repo = "straight.el";
    rev = "4b6289f42a4da0c1bae694ba918b43c72daf0330";
    hash = "sha256-FlGo+Nl6n+xSwQSIrMHJa7tu+MjLG2Ldxf7poJCz4Nc=";
  };

  nativeBuildInputs = [ git ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/radian-software/straight.el";
    description = "Next-generation, purely functional package manager for the Emacs hacker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ abhisheksingh0x558 ];
  };
}
