# This file tracks the Clojure tools version required by babashka.
# See https://github.com/borkdude/deps.clj#deps_clj_tools_version for background.
# The `updateScript` provided in babashka-unwrapped takes care of keeping it in sync, as well.
{
  clojure,
  fetchurl,
}:
clojure.overrideAttrs (previousAttrs: {
  pname = "babashka-clojure-tools";
  version = "1.12.5.1664";

  src = fetchurl {
    url = previousAttrs.src.url;
    hash = "sha256-d91oaJSAdK3Mk+g6eW+OjxWhqSvLG5AC1xX9IhDkdvM=";
  };
})
