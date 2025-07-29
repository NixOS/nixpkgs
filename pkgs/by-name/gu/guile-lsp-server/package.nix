{
  lib,
  guile,
  stdenv,
  fetchFromGitea,
  pkg-config,
  bash,
  makeWrapper,
  guile-json-rpc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "guile-lsp-server";
  version = "0.4.8";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "rgherdt";
    repo = "scheme-lsp-server";
    tag = finalAttrs.version;
    hash = "sha256-x0BqN2JM1eVmaHp+F4N8OsotqL8hlWNIE2rmCq9Qn+w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    guile
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    guile-json-rpc
  ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  preConfigure = ''
    cd guile
  '';

  postInstall = ''
    wrapProgram $out/bin/guile-lsp-server \
      --prefix PATH : ${
        lib.makeBinPath [
          guile
          bash
        ]
      } \
      --set GUILE_AUTO_COMPILE 0 \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}:$GUILE_LOAD_PATH" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteCcacheDir}:$GUILE_LOAD_COMPILED_PATH" \
      --argv0 $out/bin/guile-lsp-server
  '';

  meta = {
    homepage = "https://codeberg.org/rgherdt/scheme-lsp-server";
    description = "LSP server for Guile";
    mainProgram = "guile-lsp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ knightpp ];
    platforms = guile.meta.platforms;
  };
})
