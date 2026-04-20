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
  runCommand,
  coreutils,
  util-linux,
}:

let
  inherit (python3Packages) python setuptools;
  sensible-editor = writeShellScript "sensible-editor" ''
    exec ''${EDITOR-${nano}/bin/nano} "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "debian-devscripts";
  version = "2.26.7";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "devscripts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9qr5NC2Mu/TlO3cJ4qxItU6l7XazgWuziVfRFpM9xA=";
  };

  patches = [
    (fetchpatch {
      name = "hardening-check-obey-binutils-env-vars.patch";
      url = "https://github.com/Debian/devscripts/pull/2/commits/c6a018e0ef50a1b0cb4962a2f96dae7c6f21f1d4.patch";
      hash = "sha256-UpS239JiAM1IYxNuJLdILq2h0xlR5t0Tzhj47xiMHww=";
    })
    # Write to stdout and exit 0 for --help, --version
    # https://salsa.debian.org/debian/devscripts/-/merge_requests/637
    (fetchpatch {
      url = "https://salsa.debian.org/debian/devscripts/-/commit/dbb258ea17749e2d102d4d181fe2709bda5584e7.patch";
      hash = "sha256-+/E1UhxKk4PYD1bO1kI0qjfBpcMoFbo3xiY45IQ/FWU=";
    })
  ];

  postPatch = ''
    substituteInPlace scripts/annotate-output.sh \
      --replace-fail '/usr/bin/printf' '${lib.getExe' coreutils "printf"}'
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
    python3Packages.wrapPython
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
    StringShellQuote
    YAMLLibYAML
  ]);

  pythonPath = with python3Packages; [
    junit-xml
    magic
    python-apt
    python-debian
    requests
    unidiff
  ];

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

  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"
    patchPythonScript "$out/bin/deb-check-file-conflicts"
    patchPythonScript "$out/bin/deb-janitor"
    patchPythonScript "$out/bin/debbisect"
    patchPythonScript "$out/bin/debdiff-apply"
    patchPythonScript "$out/bin/debftbfs"
    patchPythonScript "$out/bin/debootsnap"
    patchPythonScript "$out/bin/reproducible-check"
    patchPythonScript "$out/bin/sadt"
    patchPythonScript "$out/bin/suspicious-source"
    patchPythonScript "$out/bin/wrap-and-sort"
    sed -re 's@(^|[ !`"])/bin/bash@\1${stdenv.shell}@g' -i "$out/bin"/*
    ln -s debchange $out/bin/dch
    ln -s deb2apptainer $out/bin/deb2singularity
    ln -s pts-subscribe $out/bin/pts-unsubscribe
    mv "$out/bin" "$out/.bin-wrapped"
    for i in "$out/.bin-wrapped"/*; do
      makeWrapper "$i" "$out/bin/''${i#$out/.bin-wrapped/}" \
        --prefix PERL5LIB : "$PERL5LIB" \
        --prefix PERL5LIB : "$out/share/devscripts" \
        --prefix PATH : "${curl}/bin:${dpkg}/bin:${gnupg}/bin:${util-linux}/bin"
    done
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  passthru.tests.helpVersion =
    runCommand "debian-devscripts-test-help-version"
      {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      }
      ''
        export HOME=/tmp

        for cmd in ${finalAttrs.finalPackage}/bin/*; do
            echo "Running $cmd"

            case "''${cmd##*/}" in

            # Fails with an error from python-apt
            debootsnap | \
            mk-origtargz | \
            reproducible-check)
                ! output=$("$cmd" --help 2>&1)
                case "$output" in
                *'
        apt_pkg.Error: E:Unable to determine a suitable packaging system type')
                    ;;
                *)
                    "$cmd" --help
                    ;;
                esac
                ! "$cmd" --version
                ;;

            # Supports neither -h, --help, nor --version
            add-patch | \
            archpath | \
            debrsign | \
            dscextract | \
            edit-patch | \
            list-unreleased | \
            namecheck | \
            salsa | \
            svnpath)
                ! "$cmd" -h
                ! "$cmd" --help
                ! "$cmd" --version
                ;;

            # Supports -h but neither --help nor --version
            deb2apptainer | \
            deb2docker | \
            deb2singularity)
               "$cmd" -h
               ! "$cmd" --help
               ! "$cmd" --version
               ;;

            # Supports --help but not --version
            annotate-output | \
            dd-list | \
            deb-check-file-conflicts | \
            deb-janitor | \
            debbisect | \
            debcheckout | \
            debdiff-apply | \
            debftbfs | \
            debrebuild | \
            debrepro | \
            hardening-check | \
            ltnu | \
            origtargz | \
            sadt | \
            suspicious-source | \
            who-permits-upload | \
            wrap-and-sort)
                "$cmd" --help
                ! "$cmd" --version
                ;;

            # Everything else supports --help and --version
            *)
                "$cmd" --help
                output=$("$cmd" --version)
                case "$output" in
                *'version ${finalAttrs.version}
        '* | *'version ${finalAttrs.version}.
        '* | *'version
        ${finalAttrs.version} '* | *'v. ${finalAttrs.version}
        '* | *'devscripts ${finalAttrs.version}.'* | *'(devscripts ${finalAttrs.version})'*)
                    ;;
                *)
                    echo "$cmd --version did not output the expected version ${finalAttrs.version}:" >&2
                    "$cmd" --version
                    false
                esac
                ;;

            esac
        done

        : >"$out"
      '';

  meta = {
    description = "Debian package maintenance scripts";
    license = lib.licenses.free; # Mix of public domain, Artistic+GPL, GPL1+, GPL2+, GPL3+, and GPL2-only... TODO
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
  };
})
