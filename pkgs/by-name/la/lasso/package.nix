{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitea,
  writeShellScript,
  glib,
  gobject-introspection,
  gtk-doc,
  libtool,
  libxml2,
  libxslt,
  openssl,
  pkg-config,
  python3,
  xmlsec,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lasso";
  version = "2.9.0";

  src = fetchFromGitea {
    domain = "git.entrouvert.org";
    owner = "entrouvert";
    repo = "lasso";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fDMM9DJBzxz6DX4cNK3DEE28FBT8gCF9C9DQfUNNFaY=";
  };

  postPatch =
    let
      printVersion = writeShellScript "print-version" ''
        echo -n ${lib.escapeShellArg finalAttrs.version}
      '';
    in
    ''
      cp ${printVersion} tools/git-version-gen
    '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk-doc
    libtool
    libxml2
    libxslt
    openssl
    python3.pkgs.six
    xmlsec
    zlib
  ];

  configurePhase = ''
    ./configure --with-pkg-config=$PKG_CONFIG_PATH \
                --disable-perl \
                --prefix=$out
  '';

  meta = {
    homepage = "https://lasso.entrouvert.org/";
    description = "Liberty Alliance Single Sign-On library";
    changelog = "https://git.entrouvert.org/entrouvert/lasso/raw/tag/v${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ womfoo ];
  };
})
