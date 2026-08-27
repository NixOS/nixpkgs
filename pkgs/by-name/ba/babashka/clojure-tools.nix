# This file tracks the Clojure tools version required by babashka.
# See https://github.com/borkdude/deps.clj#deps_clj_tools_version for background.
# The `updateScript` provided in babashka-unwrapped takes care of keeping it in sync, as well.
{
  clojure,
  fetchurl,
}:
clojure.overrideAttrs (previousAttrs: {
  pname = "babashka-clojure-tools";
  version = "1.12.5.1654";

  src = fetchurl {
    url = previousAttrs.src.url;
    hash = "sha256-3IbMVrw3L87we9h/RGk+60thz19ENHiDh4Nk0Dtfs0I=";
  };
})
