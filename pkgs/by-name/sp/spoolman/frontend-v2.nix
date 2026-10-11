{
  buildNpmPackage,
  callPackage,
  fetchurl,
}:
let
  common = callPackage ./common.nix { };
  messageFormatPlugin = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4.4.4/dist/index.js";
    hash = "sha256-siz2DrKLPIw84ftjAGEaBVLxLQ2ZXTfE3SyW462AxkU=";
  };
  functionMatcherPlugin = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2.2.9/dist/index.js";
    hash = "sha256-hYYvYwV5O1a/2a/lNosJbmP7Kuqzi3eZwFFRe+NJnAs=";
  };
  i18nextPlugin = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-i18next@6.2.4/dist/index.js";
    hash = "sha256-M0aMIHfS2AZb3zpAykuUrslGgYB0CRrLTx2dOdRrvwg=";
  };
in

buildNpmPackage {
  pname = "spoolman-frontend-v2";

  inherit (common) version;

  src = "${common.src}/client_v2";

  npmDepsHash = "sha256-DYUwz3rOdnah3EUBM7dciCdEsRlZG9ijoHiPWLIdRuc=";

  postPatch = ''
    substituteInPlace project.inlang/settings.json \
      --replace-fail "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js" "${messageFormatPlugin}" \
      --replace-fail "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js" "${functionMatcherPlugin}" \
      --replace-fail "https://cdn.jsdelivr.net/npm/@inlang/plugin-i18next@latest/dist/index.js" "${i18nextPlugin}"
  '';

  installPhase = "cp -r build $out";

  meta = common.meta // {
    description = "Spoolman Svelte frontend";
  };
}
