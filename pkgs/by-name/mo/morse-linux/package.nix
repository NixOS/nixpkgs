{
  lib,
  stdenv,
  fetchFromGitLab,
  alsa-lib,
  pulseaudio,
  pkg-config,
  xmlto,
  docbook_xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "morse";
  version = "2.6";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "morse-classic";
    tag = finalAttrs.version;
    hash = "sha256-wk/Jcp2YWUlecV3OMELD6IWrlj3IC8kh0U4geMxG4fw=";
  };

  buildInputs = [
    alsa-lib
    pulseaudio
  ];

  nativeBuildInputs = [
    pkg-config
    xmlto
    docbook_xsl
  ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail "xmlto" "xmlto --skip-validation"
  '';

  env.NIX_CFLAGS_COMPILE = "-std=gnu99";

  installPhase = ''
    runHook preInstall
    install -Dm755 morse -t "$out/bin/"
    install -Dm755 QSO -t "$out/bin/"
    install -Dm644 morse.1 -t "$out/share/man/man1/"
    install -Dm644 QSO.1 -t "$out/share/man/man1/"
    runHook postInstall
  '';

  meta = {
    description = "Training program about morse-code for aspiring radio hams";
    homepage = "https://gitlab.com/esr/morse-classic";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      matthewcroughan
      sarcasticadmin
    ];
    platforms = lib.platforms.linux;
    mainProgram = "morse";
  };
})
