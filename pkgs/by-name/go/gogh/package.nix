{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  ncurses,
  bashNonInteractive,
  python3,
  rustpython,
  nix-update-script,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      ruamel-yaml
      unidecode
      pyyaml
      tomli
      tomli-w
      configobj
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gogh";
  version = "361";

  src = fetchFromGitHub {
    owner = "Gogh-Co";
    repo = "Gogh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kzJiI1w8CYVYMcHo8mMqLseyFsU/PekjMkkk0gG+RH4=";
  };

  postPatch = ''
    # Remove the `SCRIPT_PATH` variable definition from `gogh.sh`,
    # see `makeWrapperArgs`: `--set SCRIPT_PATH "$out/lib"` in `postInstall`
    sed -i '/^SCRIPT_PATH=/d' gogh.sh

    patchShebangs .

    substituteInPlace {gogh.sh,installs/*.sh} \
      --replace-fail 'bash ' '${lib.getExe bashNonInteractive} '

    substituteInPlace apply-colors.sh \
      --replace-fail 'python3' '${lib.getExe' rustpython "rustpython"}'
  '';

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/lib
    cp --recursive {*.py,apply-colors.sh,installs,themes} $out/lib
    install -Dm755 gogh.sh $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --set SCRIPT_PATH "$out/lib" \
      --prefix PATH : "${lib.getBin bashNonInteractive}/bin" \
      --prefix PATH : "${lib.getBin rustpython}/bin" \
      --prefix PATH : "${lib.getBin ncurses}/bin" \
      --prefix PATH : "${pythonEnv}/bin" \
      --prefix PYTHONPATH : "${pythonEnv}/${pythonEnv.sitePackages}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Collection of color schemes for terminal emulators";
    longDescription = ''
      Gogh is a collection of color schemes for various terminal
      emulators, including Gnome Terminal, Pantheon Terminal, Tilix
      and XFCE4 Terminal. These schemes are designed to make your
      terminal more visually appealing and improve your productivity
      by providing a better contrast and color differentiation. (This
      fork of Gogh includes a color scheme named "Vaombe".)

      The inspiration for Gogh came from the clean and minimalistic
      design of Elementary OS, but the project has since grown to
      include a variety of unique and beautiful options. Not only does
      Gogh work on Linux systems, but it's also compatible with iTerm
      on macOS, providing a consistent and visually appealing
      experience across platforms.
    '';
    homepage = "https://github.com/Gogh-Co/Gogh";
    changelog = "https://github.com/Gogh-Co/Gogh/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gogh";
    platforms = lib.platforms.all;
  };
})
