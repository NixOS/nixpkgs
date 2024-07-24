{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "font-lock-plus";
  ename = "font-lock+";
  version = "208-unstable-2018-01-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "font-lock-plus";
    rev = "f2c1ddcd4c9d581bd32be88fad026b49f98b6541";
    hash = "sha256-lFmdVMXIIXZ9ZohAJw5rhxpTv017qIyzmpuKOWDdeJ4=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/emacsmirror/font-lock-plus";
    description = "Enhancements to standard library font-lock.el";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
