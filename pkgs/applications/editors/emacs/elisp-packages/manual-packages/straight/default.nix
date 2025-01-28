{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "straight";
  version = "0-unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "radian-software";
    repo = "straight.el";
    rev = "33fb4695066781c634ff1c3c81ba96e880deccf7";
    hash = "sha256-3NPVLTn0ka0RvSLXW9gDKam3xajp62/mLupc8uyatzo=";
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
