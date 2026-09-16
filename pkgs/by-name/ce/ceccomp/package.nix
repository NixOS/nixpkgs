{
  withLocales ? true,
  withDocs ? true,

  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libseccomp,
  python3,
  flock,
  asciidoctor,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ceccomp";
  version = "3.5";

  src = fetchFromGitHub {
    owner = "dbgbgtf1";
    repo = "Ceccomp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TVRYWRkrXlSgGXL2KtFsFx26ncf77QE+edZvv2HtVkg=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libseccomp
    python3
    flock
  ]
  ++ lib.optionals withDocs [
    asciidoctor
  ]
  ++ lib.optionals withLocales [
    gettext
  ];

  configureFlags = [
    "--prefix=$out"
    "--packager=Nix"
  ]
  ++ lib.optionals (!withDocs) [ "--without-doc" ]
  ++ lib.optionals (!withLocales) [ "--without-i18n" ];

  configurePhase = ''
    runHook preConfigure

    python ./configure ${lib.concatStringsSep " " finalAttrs.configureFlags}

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A tool to analyze seccomp filters like `seccomp-tools` but in C";
    homepage = "https://github.com/dbgbgtf1/Ceccomp";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      tesuji
      RocketDev
    ];
    platforms = lib.platforms.linux;
    mainProgram = "ceccomp";
  };
})
