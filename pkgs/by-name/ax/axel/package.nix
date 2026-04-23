{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  gettext,
  openssl,
  txt2man,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "axel";
  version = "2.17.14";

  src = fetchFromGitHub {
    owner = "axel-download-accelerator";
    repo = "axel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5GUna5k8GhAx1Xe8n9IvXT7IO6gksxCLh+sMANlxTBM=";
  };

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "AM_GNU_GETTEXT_VERSION([0.11.1])" "AM_GNU_GETTEXT_VERSION([0.12])"
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    autoconf-archive
    txt2man
  ];

  buildInputs = [
    gettext
    openssl
  ];

  installFlags = [ "ETCDIR=${placeholder "out"}/etc" ];

  postInstall = ''
    mkdir -p $out/share/doc
    cp doc/axelrc.example $out/share/doc/axelrc.example
  '';

  meta = {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = "https://github.com/axel-download-accelerator/axel";
    maintainers = with lib.maintainers; [ pSub ];
    platforms = with lib.platforms; unix;
    license = lib.licenses.gpl2Plus;
    mainProgram = "axel";
  };
})
