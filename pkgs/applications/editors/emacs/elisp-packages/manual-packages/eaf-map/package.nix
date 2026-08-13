{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  # JavaScript dependency
  nodejs,
  fetchNpmDeps,
  npmHooks,
  # Updater
  nix-update-script,
}:

melpaBuild (finalAttrs: {

  pname = "eaf-map";
  version = "0-unstable-2025-07-26";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "eaf-map";
    rev = "8bec6ab7c1194491ffccbeeec45451d8dc6fb405";
    hash = "sha256-rwtC4CAOTNmR8sH6P4mKyON65yNYWMBYImQkBGZH0Qs=";
  };

  env.npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-prxCFrKvC2dG9BgO3LIKDCFzjn9vFegpvuMy4Eg6Ghs=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  postBuild = ''
    npm run build
  '';

  files = ''
    ("*.el"
     "*.py"
     "*.js"
     "src")
  '';

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp/elpa/${finalAttrs.ename}-${finalAttrs.melpaVersion}
    touch node_modules/.nosearch
    cp -r node_modules $LISPDIR/
    cp -r dist $LISPDIR/
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
    eafPythonDeps =
      ps: with ps; [
        numpy
        pycurl
        python-tsp
      ];
  };

  meta = {
    description = "OpenStreetMap application for the EAF";
    homepage = "https://github.com/emacs-eaf/eaf-map";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
