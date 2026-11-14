{
  lib,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "grc";
  version = "1.13";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "grc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1KL9koGF+facsT2+7i/sXdYeolYcRAVNOkkRRCBCEMA=";
  };

  postPatch = ''
    for f in grc grcat; do
      substituteInPlace $f \
        --replace /usr/local/ $out/
    done

    # Support for absolute store paths.
    substituteInPlace grc.conf \
      --replace "^([/\w\.]+\/)" "^([/\w\.\-]+\/)"
  '';

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    ./install.sh "$out" "$out"
    installShellCompletion --zsh --name _grc _grc

    runHook postInstall
  '';

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "http://kassiopeia.juls.savba.sk/~garabik/software/grc.html";
    description = "Generic text colouriser";
    longDescription = ''
      Generic Colouriser is yet another colouriser (written in Python) for
      beautifying your logfiles or output of commands.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
    ];
    platforms = lib.platforms.unix;
    mainProgram = "grc";
  };
})
