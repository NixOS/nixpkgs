{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  nix-update-script,
  python3,
  ttfautohint,
  replaceVarsWith,
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
    hash = "sha256-IoEeSB22rJh2J3EDD4T6uX65PhhnlllKBBKtRHLQP8I=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # use a vendored version of update-version.sh that is simplified, and doesn't require reading info from .git/
  # comment is from upstream script for reference

  postPatch =
    let
      update-version = replaceVarsWith {
        src = ./update-version.sh;
        replacements = {
          major = lib.versions.major finalAttrs.version;
          minor = lib.versions.minor finalAttrs.version;
          # this isn't the hash upstream would use, but we don't want to use fetchDotGit so let's just use a different hash
          hash = lib.replaceString "sha256-" "" finalAttrs.src.hash;
        };
        isExecutable = true;
      };
    in
    ''
      cp -f ${update-version} tools/update-version.sh
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
