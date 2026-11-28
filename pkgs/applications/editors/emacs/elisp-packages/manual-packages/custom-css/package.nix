{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  melpaBuild,
  emacs,
  pkg-config,
}:

melpaBuild {
  pname = "custom-css";
  version = "0-unstable-2024-01-03";

  src = fetchFromGitHub {
    owner = "florommel";
    repo = "custom-css";
    rev = "dd980c8494bc4244eaff11bef3e2e62ca7aef5f2";
    hash = "sha256-FiWdj++QK9Bov9gfe7KQH8wcD0xctaJzYb43/1XhFj0=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.filter (x: x.pname == "gtk+3") emacs.buildInputs;

  preBuild = ''
    make
  '';

  files = ''
    (:defaults "custom-css-module.so")
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Style Emacs's GTK widgets with custom CSS";
    homepage = "https://github.com/florommel/custom-css";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ judaew ];
  };
}
