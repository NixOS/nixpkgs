{
  lib,
  stdenv,
  fetchFromCodeberg,
  guile,
  makeWrapper,
  bash,
  coreutils,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iter-vitae";
  version = "1.0.1";

  src = fetchFromCodeberg {
    owner = "jjba23";
    repo = "iter-vitae";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wQQXPmAC+naEhgljxJcXt9j6gojoMy/YMEzcK7HYBTQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    guile
    makeWrapper
  ];
  buildInputs = [
    guile
  ];

  buildPhase = ''
    runHook preBuild

    siteDir=$out/${guile.siteDir}
    install -d "$siteDir"
    cp -R src/. "$siteDir"/

    export GUILE_AUTO_COMPILE=0
    export GUILE_LOAD_PATH="$siteDir''${GUILE_LOAD_PATH:+:$GUILE_LOAD_PATH}"

    find src -name '*.scm' | while IFS= read -r file; do
      rel="''${file#src/}"
      guild compile -o "$siteDir/''${rel%.scm}.go" "$file"
    done

    runHook postBuild
  '';

  installPhase = ''
        runHook preInstall
    install -Dm755 scripts/iter-vitae $out/bin/iter-vitae
    install -Dm644 resources/help.txt $out/share/resources/help.txt
    install -Dm644 resources/css/*.css -t $out/share/resources/css/
        runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/iter-vitae \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          util-linux
          guile
        ]
      } \
      --prefix GUILE_LOAD_PATH : "$out/${guile.siteDir}" \
      --prefix GUILE_LOAD_COMPILED_PATH : "$out/${guile.siteDir}"
  '';

  guileImportsCheck = [
    "iter-vitae main"
  ];

  meta = {
    homepage = "https://codeberg.org/jjba23/iter-vitae";
    description = "Resume and curriculum vitae generator written in GNU Guile";
    license = lib.licenses.agpl3Plus;
    mainProgram = "iter-vitae";
    maintainers = [ lib.maintainers.jjba23 ];
    platforms = guile.meta.platforms;
  };
})
