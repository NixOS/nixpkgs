{
  stdenv,
  lib,
  fetchFromGitLab,
  help2man,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "debcraft";
  version = "0.9.2";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "debcraft";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-U8qWT26qno2zpfdsLqlqZg0SipvHCN6dUjUCjGuyrkY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ help2man ];
  makeFlags = [ "DESTDIR=$(out)" ];

  # debcraft ships with some scripts it'll execute inside a docker/podman container
  # this'd patch the shebangs of the scripts executed in the container too, breaking them.
  dontPatchShebangs = true;

  postPatch = ''
    substituteInPlace debcraft.sh --replace-fail \
      'DEBCRAFT_LIB_DIR="/usr/share/debcraft"' \
      "DEBCRAFT_LIB_DIR=\"$out/share/debcraft\""

    # their Makefile installs in DESTDIR/usr for some reason
    substituteInPlace Makefile --replace-fail '$(DESTDIR)/usr' '$(DESTDIR)'
  '';

  preBuild = ''
    # the makefile runs help2man on the script, which needs it to be executable
    # (and the shebang would need to be patched later anyways)
    patchShebangs debcraft.sh
  '';

  meta = {
    description = "Easy, fast and secure way to build Debian packages";
    homepage = "https://salsa.debian.org/debian/debcraft";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.gilice ];
    platforms = lib.platforms.unix;
    mainProgram = "debcraft";
  };
})
