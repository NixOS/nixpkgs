{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  n8n,
  callPackage,
  symlinkJoin,
  writeShellScriptBin,
  libreoffice,
  # Off by default: LibreOffice takes the closure from ~230MiB to ~2.6GiB, and
  # only the "convert to PDF" operation needs it.
  withLibreOffice ? false,
}:

let
  loProgram = "${libreoffice}/lib/libreoffice/program";

  libreofficeForCarbone = symlinkJoin {
    name = "carbone-libreoffice";
    paths = [
      # The bare soffice.bin exits immediately, it needs the runtime environment the wrapper sets up.
      (writeShellScriptBin "soffice.bin" ''exec ${libreoffice}/bin/soffice "$@"'')
      # libreoffice.unwrapped.python is a plain python3, so bootstrap it to make `import uno` resolve.
      (writeShellScriptBin "python3" ''
        export PYTHONPATH=${loProgram}''${PYTHONPATH:+:$PYTHONPATH}
        export URE_BOOTSTRAP=vnd.sun.star.pathname:${loProgram}/fundamentalrc
        exec ${libreoffice.unwrapped.python}/bin/python3 "$@"
      '')
    ];
  };
in
buildNpmPackage (finalAttrs: {
  pname = "n8n-nodes-carbonejs";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "jreyesr";
    repo = "n8n-nodes-carbonejs";
    tag = "v${finalAttrs.version}";
    hash = lib.fakeHash;
  };

  npmDepsHash = lib.fakeHash;

  # carbone looks for `soffice.bin` and a `python3` beside it in the directories
  # handed to detectLibreOffice(), which is called with none.
  postInstall = lib.optionalString withLibreOffice ''
    substituteInPlace $out/lib/node_modules/n8n-nodes-carbonejs/node_modules/carbone/lib/converter.js \
      --replace-fail "detectLibreOffice();" \
        "detectLibreOffice(['${libreofficeForCarbone}/bin']);"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.pdf-conversion = callPackage ./tests/pdf-conversion.nix { };
  };

  meta = {
    inherit (n8n.meta) platforms;
    description = "n8n community node for rendering Word templates using Carbone.js";
    homepage = "https://github.com/jreyesr/n8n-nodes-carbonejs";
    changelog = "https://github.com/jreyesr/n8n-nodes-carbonejs/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sweenu ];
  };
})
