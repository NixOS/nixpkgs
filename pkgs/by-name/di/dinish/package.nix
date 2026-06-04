{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  git,
  nix-update-script,
  python3,
  ttfautohint,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dinish";
  version = "4.007";

  outputs = [
    "out"
    "webfont"
  ];

  src = fetchFromGitHub {
    owner = "playbeing";
    repo = "dinish";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3kJlE7qCLoCtSZo4s7WgxTnj+H08UbVetGlDzb8xrEw=";
    leaveDotGit = true;
    fetchTags = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    patchShebangs tools
    substituteInPlace Makefile \
      --replace-fail 'build: sync_features $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S) docs zips install_ofl' \
      'build: sync_features $(OTFS) $(TTFS) $(WOFFS) $(WOFF2S) docs'
  '';

  preInstall = ''
    rm -r ofl
  '';
  installPhase = ''
    runHook preInstall
    runHook postInstall
  '';

  nativeBuildInputs = [
    installFonts
    git
    (python3.withPackages (
      ps: with ps; [
        fontmake
        gftools
      ]
    ))
    ttfautohint
  ];
  dontUseNinjaBuild = true;

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/playbeing/dinish";
    changelog = "https://github.com/playbeing/dinish/blob/v${finalAttrs.version}/FONTLOG.txt";
    description = "Modern computer font inspired by DIN 1451";
    longDescription = "DINish is one of many modern computer fonts that were inspired by the lettering of the German Autobahn road signs. It is professionally designed, and usable for body text and captions, even spreadsheets. Its unadorned style is easy to read, and although it is close to a century old maintains a fresh look.";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vji ];
  };
})
