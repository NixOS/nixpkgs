{
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  makeWrapper,
  nodejs,
  guile,
  guile-websocket,
  guile-fibers,
  guile-gnutls,
  pkg-config,
  texinfo,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-hoot";
  version = "0.8.0";

  src = fetchFromCodeberg {
    owner = "spritely";
    repo = "hoot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b372dMUsDTa+hYrOwvj+/YcwVP52BCJxwSGRaqSSWZs=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
    guile
    pkg-config
    texinfo
    nodejs
  ];
  propagatedBuildInputs = [
    guile-fibers
    guile-websocket
    guile-gnutls
  ];

  postInstall =
    let
      libs = [ "$out" ] ++ finalAttrs.propagatedBuildInputs;
    in
    ''
      cp ./repl/repl.js $out/share/guile-hoot/0.8.0/repl/repl.js
      wrapProgram $out/bin/hoot \
        --prefix GUILE_LOAD_PATH : ${lib.makeSearchPath guile.siteDir libs} \
        --prefix GUILE_LOAD_COMPILED_PATH : ${lib.makeSearchPath guile.siteCcacheDir libs}
    '';

  buildInputs = [
    guile
  ];
  strictDeps = true;

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scheme to WebAssembly compiler backend for GNU Guile and a general purpose WASM toolchain";
    homepage = "https://codeberg.org/spritely/hoot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jinser ];
    platforms = lib.platforms.unix;
    mainProgram = "hoot";
  };
})
