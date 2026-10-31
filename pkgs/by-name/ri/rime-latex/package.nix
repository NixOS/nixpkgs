{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rime-latex";
  version = "0-unstable-2025-04-04";

  src = fetchFromGitHub {
    owner = "shenlebantongying";
    repo = "rime_latex";
    rev = "858f2abc645f0e459e468e98122470ce20b16b30";
    hash = "sha256-i8Rgze+tQhbE+nl+JSj09ILXeUvf6MOS9Eqsuqis1n0=";
  };

  installPhase = ''
    runHook preInstall

    rm -rf README.md .git* LICENSE .script

    mkdir -p $out/share
    cp -r . $out/share/rime-data

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Typing LaTeX math symbols in RIME";
    longDescription = ''
      Typing LaTeX math symbols in RIME.

      Add those lines to `default.custom.yaml`:

      ```yaml
      patch:
        schema_list:
          - schema: latex
      ```

      Press `\` key then input latex symbol's name: `\lambda` will automatically become `λ`.
    '';
    homepage = "https://github.com/shenlebantongying/rime_latex";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.all;
  };
})
