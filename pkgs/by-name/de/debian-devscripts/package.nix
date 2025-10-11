{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  xz,
  dpkg,
  libxslt,
  docbook_xsl,
  makeWrapper,
  writeShellScript,
  python3Packages,
  perlPackages,
  curl,
  gnupg,
  diffutils,
  nano,
  pkg-config,
  bash-completion,
  help2man,
  nix-update-script,
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

let
  inherit (python3Packages) python setuptools;
  sensible-editor = writeShellScript "sensible-editor" ''
    exec ''${EDITOR-${nano}/bin/nano} "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "debian-devscripts";
  version = "2.25.19";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "devscripts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xRWWdM2l1F1Z7U+ThxWvH5wL2ZY+sR8+Jx6h/7mo9dQ=";
  };

  patches = [
    (fetchpatch {
      name = "hardening-check-obey-binutils-env-vars.patch";
      url = "https://github.com/Debian/devscripts/pull/2/commits/c6a018e0ef50a1b0cb4962a2f96dae7c6f21f1d4.patch";
      hash = "sha256-UpS239JiAM1IYxNuJLdILq2h0xlR5t0Tzhj47xiMHww=";
    })
  ];

  postPatch = ''
    substituteInPlace scripts/debrebuild.pl \
      --replace-fail "/usr/bin/perl" "${perlPackages.perl}/bin/perl"
    patchShebangs scripts
  ''
  +
    # Remove man7 target to avoid missing *.7 file error
    ''
      substituteInPlace doc/Makefile \
        --replace-fail " install_man7" ""
    '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    xz
    dpkg
    libxslt
    python
    setuptools
    curl
    gnupg
    diffutils
    bash-completion
    help2man
  ]
  ++ (with perlPackages; [
    perl
    CryptSSLeay
    LWP
    TimeDate
    DBFile
    FileDesktopEntry
    ParseDebControl
    LWPProtocolHttps
    Moo
    FileHomeDir
    IPCRun
    FileDirList
    FileTouch
    IOString
  ]);

  preConfigure = ''
    export PERL5LIB="$PERL5LIB''${PERL5LIB:+:}${dpkg}";
    tgtpy="$out/${python.sitePackages}"
    mkdir -p "$tgtpy"
    export PYTHONPATH="$PYTHONPATH''${PYTHONPATH:+:}$tgtpy"
    find lib po4a scripts -type f -exec sed -r \
      -e "s@/usr/bin/gpg(2|)@${lib.getExe' gnupg "gpg"}@g" \
      -e "s@/usr/(s|)bin/sendmail@${sendmailPath}@g" \
      -e "s@/usr/bin/diff@${lib.getExe' diffutils "diff"}@g" \
      -e "s@/usr/bin/gpgv(2|)@${lib.getExe' gnupg "gpgv"}@g" \
      -e "s@(command -v|/usr/bin/)curl@${lib.getExe curl}@g" \
      -e "s@sensible-editor@${sensible-editor}@g" \
      -e "s@(^|\W)/bin/bash@\1${stdenv.shell}@g" \
      -i {} +
    sed -e "s@/usr/share/sgml/[^ ]*/manpages/docbook.xsl@${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl@" -i scripts/Makefile
    sed -r \
      -e "s@/usr( |$|/)@$out\\1@g" \
      -e "s@/etc( |$|/)@$out/etc\\1@g" \
      -e 's/ translated_manpages//; s/--install-layout=deb//; s@--root="[^ ]*"@--prefix="'"$out"'"@' \
      -i Makefile* */Makefile*
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "COMPL_DIR=/share/bash-completion/completions"
    "PERLMOD_DIR=/share/devscripts"
  ];

  postInstall = ''
    sed -re 's@(^|[ !`"])/bin/bash@\1${stdenv.shell}@g' -i "$out/bin"/*
    for i in "$out/bin"/*; do
      wrapProgram "$i" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PERL5LIB : "$out/share/devscripts" \
        --prefix PYTHONPATH : "$out/${python.sitePackages}" \
        --prefix PATH : "${dpkg}/bin"
    done
    ln -s debchange $out/bin/dch
    ln -s pts-subscribe $out/bin/pts-unsubscribe
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Debian package maintenance scripts";
    license = lib.licenses.free; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
