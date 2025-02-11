{
  melpaBuild,
  fetchFromGitHub,
  git,
  unstableGitUpdater,
  lib,
}:

melpaBuild {
  pname = "elpaca";
  version = "0-unstable-2025-02-07";

  src = fetchFromGitHub {
    owner = "progfolio";
    repo = "elpaca";
    rev = "9cd26d91193fea631c25484109d04c54ad8f0188";
    hash = "sha256-Mr5uBXvtFfBnrMqnnsgStHvmcyzqpHKdovvH3xb6RBE=";
  };

  nativeBuildInputs = [ git ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/progfolio/elpaca";
    description = "Elisp package manager";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ abhisheksingh0x558 ];
  };
}
