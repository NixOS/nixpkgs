{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3,
  brother-pe-cli,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "inkscape-brother-pe";
  version = "0.1.2";

  src = fetchFromGitLab {
    owner = "dlarochette";
    repo = "brother-pe-inkstitch";
    tag = finalAttrs.version;
    hash = "sha256-NMtgk15GFAhyr5oudRe2S4VFbW5Rh1LxdSglTrR+8W4=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # brother-pe by store path; BROTHER_PE_BIN still takes precedence.
  postPatch = ''
    substituteInPlace extension/brother_pe_card.py \
      --replace-fail 'shutil.which("brother-pe")' '"${lib.getExe brother-pe-cli}"'
  '';

  dontBuild = true;

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  doCheck = true;

  nativeCheckInputs = [ (python3.withPackages (ps: [ ps.inkex ])) ];

  checkPhase = ''
    runHook preCheck
    HOME=$TMPDIR python3 tests/test_extension.py ${lib.getExe brother-pe-cli}
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Inkscape extension to write Ink/Stitch designs to Brother embroidery cards";
    longDescription = ''
      Extensions > Brother PE exports the current document to PES with
      Ink/Stitch, then writes it to a Brother embroidery memory card with the
      USB card writer (04f9:2100), adds it to the designs already on the card,
      composes a card image or saves the PES file. Use it together with
      inkscape-extensions.inkstitch.
    '';
    homepage = "https://gitlab.com/dlarochette/brother-pe-inkstitch";
    changelog = "https://gitlab.com/dlarochette/brother-pe-inkstitch/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dlarochette ];
    platforms = lib.platforms.linux;
  };
})
