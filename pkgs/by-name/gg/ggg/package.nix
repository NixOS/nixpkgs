{
  lib,
  stdenv,
  fetchFromCodeberg,
  bash,
  coreutils,
  guile,
  imagemagick,
  makeWrapper,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ggg";
  version = "0.16.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "ggg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aE7647oG8sTqcG/4gZ4VLqDyhof5NAB11oEKmTewZfU=";
  };

  nativeBuildInputs = [
    guile
    makeWrapper
  ];

  buildInputs = [
    bash
    coreutils
    guile
    imagemagick
    util-linux
  ];

  # The compiled modules are Guile bytecode, not ELF objects.
  dontPatchELF = true;
  dontStrip = true;

  doCheck = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p ccache/ggg

    find src/ggg -name '*.scm' -print0 | while IFS= read -r -d "" scm_file; do
      rel_path="''${scm_file#src/}"
      go_file="ccache/''${rel_path%.scm}.go"
      mkdir -p "$(dirname "$go_file")"
      guild compile -L src -o "$go_file" "$scm_file"
    done

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    guile -L ./src ./test/ggg-tests.scm

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    siteDir="$out/share/guile/site/3.0"
    ccacheDir="$out/lib/guile/3.0/site-ccache"

    install -Dm755 scripts/ggg "$out/bin/ggg"

    install -d "$siteDir/ggg" "$ccacheDir/ggg"
    install -m644 src/ggg/*.scm "$siteDir/ggg/"
    cp -r ccache/ggg/. "$ccacheDir/ggg/"

    # scripts/ggg resolves its Guile modules and resources from its own prefix,
    # so they have to keep the layout the launcher expects.
    install -d "$out/share/ggg/resources/logos"
    install -m644 resources/help.txt "$out/share/ggg/resources/"
    cp -r resources/logos/. "$out/share/ggg/resources/logos/"

    wrapProgram "$out/bin/ggg" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          guile
          imagemagick
          util-linux
        ]
      } \
      --prefix GUILE_LOAD_PATH : "$siteDir" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$ccacheDir"

    runHook postInstall
  '';

  meta = {
    description = "SVG badge and glyph generator written in Guile Scheme";
    homepage = "https://codeberg.org/jjba23/ggg";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ jjba23 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "ggg";
  };
})
