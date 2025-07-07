{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ncurses,
  python3,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "gogh";
  version = "361";

  src = fetchFromGitHub {
    owner = "Gogh-Co";
    repo = "Gogh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kzJiI1w8CYVYMcHo8mMqLseyFsU/PekjMkkk0gG+RH4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/
    cp gogh.sh $out/bin/${finalAttrs.meta.mainProgram}
    cp *.py $out/bin/
    cp apply-colors.sh $out/bin/
    cp -r installs themes $out/bin/
    wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PYTHONPATH : "${pythonEnv}/${pythonEnv.sitePackages}" \
      --prefix PATH : "${pythonEnv}/bin"

    runHook postInstall
  '';

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ ncurses ];

  meta = {
    description = "Collection of color schemes for various terminal emulators";
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
    changelog = "https://github.com/Gogh-Co/Gogh/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "gogh";
    platforms = lib.platforms.all;
  };
})
