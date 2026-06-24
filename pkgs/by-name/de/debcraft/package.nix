{
  stdenv,
  lib,
  codespell,
  fetchFromGitLab,
  gnumake,
  help2man,
  shellcheck,
}:
let
  version = "0.9.2";
in
stdenv.mkDerivation {
  pname = "debcraft";
  inherit version;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "debcraft";
    tag = "debian/${version}";
    hash = "sha256-U8qWT26qno2zpfdsLqlqZg0SipvHCN6dUjUCjGuyrkY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    help2man
    gnumake
    codespell
    shellcheck
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  # debcraft ships with some scripts it'll execute inside a docker/podman container
  # this'd patch the shebangs of the scripts executed in the container too, breaking them.
  dontPatchShebangs = true;
  doCheck = true;

  preBuild = ''
    # the makefile runs help2man on the script, which needs it to be executable
    # (and the shebang would need to be patched later anyways)
    patchShebangs debcraft.sh
  '';

  preCheck = ''
    # shellcheck fails on src/config-package.inc.sh with this lint, because it wants to source
    # /etc/os-release which doesn't exist in the nix sandbox
    echo 'disable=SC1091' >> .shellcheckrc

    # disable this test, as it clones from the internet.
    : > tests/debcraft-tests.sh
  '';

  postInstall = ''
    # their Makefile installs in DESTDIR/usr for some reason
    mv $out/usr/* $out/
    rm -r $out/usr
  '';

  postFixup = ''
    substituteInPlace $out/bin/debcraft \
      --replace-fail \
        'DEBCRAFT_LIB_DIR="/usr/share/debcraft"' \
        "DEBCRAFT_LIB_DIR=$out/share/debcraft"
  '';

  meta = {
    description = "Easy, fast and secure way to build Debian packages";
    homepage = "https://salsa.debian.org/debian/debcraft";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.gilice ];
    platforms = lib.platforms.unix;
    mainProgram = "debcraft";
  };
}
