{
  lib,
  stdenv,
  fetchFromGitea,
  guile,
  pkg-config,
  guile-srfi-145,
  guile-srfi-180,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-json-rpc";
  version = "0.4.5a";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rgherdt";
    repo = "scheme-json-rpc";
    tag = finalAttrs.version;
    hash = "sha256-sTJxPxHKovMOxfu5jM/6EpB9RFpG+9E3388xeE2Fpgw=";
  };

  strictDeps = true;

  propagatedBuildInputs = [
    guile-srfi-145
    guile-srfi-180
  ];

  nativeBuildInputs = [
    pkg-config
    guile
  ];

  buildInputs = [
    guile
  ];

  env.GUILE_AUTO_COMPILE = "0";

  preConfigure = ''
    cd guile
  '';

  meta = {
    description = "A JSON-RPC implementation for Scheme";
    homepage = "https://codeberg.org/rgherdt/scheme-json-rpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightpp ];
    platforms = guile.meta.platforms;
  };
})
