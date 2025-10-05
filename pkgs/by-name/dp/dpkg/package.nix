{
  lib,
  stdenv,
  fetchgit,
  perl,
  gnutar,
  zlib,
  bzip2,
  xz,
  zstd,
  libmd,
  makeWrapper,
  coreutils,
  autoreconfHook,
  pkg-config,
  diffutils,
  versionCheckHook,
  glibc ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dpkg";
  version = "1.22.21";

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/dpkg";
    tag = "applied/${finalAttrs.version}";
    leaveDotGit = true;
    # Fix filename conflict on case-insensitive filesystems
    postFetch = ''
      pushd $out
      git checkout HEAD -- scripts/t/Dpkg_BuildTree.t
      mv scripts/t/Dpkg_BuildTree.t scripts/t/Dpkg_BuildTreeC.t
      substituteInPlace scripts/Makefile.am --replace-fail t/Dpkg_BuildTree.t t/Dpkg_BuildTreeC.t
      substituteInPlace scripts/Makefile.in --replace-fail t/Dpkg_BuildTree.t t/Dpkg_BuildTreeC.t
      git checkout HEAD -- scripts/t/dpkg_buildtree.t
      rm -rf .git
      popd
    '';
    hash = "sha256-LK6nOPewjRyKyHdwJgmLILoZ6sEfJzRtC7pIeWz01lA=";
  };

  configureFlags = [
    "--disable-dselect"
    "--disable-start-stop-daemon"
    "--with-admindir=/var/lib/dpkg"
    "PERL_LIBDIR=$(out)/${perl.libPrefix}"
    "TAR=${gnutar}/bin/tar"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "--disable-linker-optimisations";

  enableParallelBuilding = true;

  preConfigure = ''
    # Nice: dpkg has a circular dependency on itself. Its configure
    # script calls scripts/dpkg-architecture, which calls "dpkg" in
    # $PATH. It doesn't actually use its result, but fails if it
    # isn't present, so make a dummy available.
    touch $TMPDIR/dpkg
    chmod +x $TMPDIR/dpkg
    PATH=$TMPDIR:$PATH

    for i in $(find . -name Makefile.in); do
      substituteInPlace $i --replace-quiet "install-data-local:" "disabled:" ;
    done

    # Skip check broken when cross-compiling.
    substituteInPlace configure \
      --replace-fail 'as_fn_error $? "cannot find a GNU tar program"' "#"
  '';

  postPatch = ''
    patchShebangs --host .

    # Dpkg commands sometimes calls out to shell commands
    substituteInPlace lib/dpkg/dpkg.h \
       --replace-fail '"dpkg-deb"' \"$out/bin/dpkg-deb\" \
       --replace-fail '"dpkg-split"' \"$out/bin/dpkg-split\" \
       --replace-fail '"dpkg-query"' \"$out/bin/dpkg-query\" \
       --replace-fail '"dpkg-divert"' \"$out/bin/dpkg-divert\" \
       --replace-fail '"dpkg-statoverride"' \"$out/bin/dpkg-statoverride\" \
       --replace-fail '"dpkg-trigger"' \"$out/bin/dpkg-trigger\" \
       --replace-fail '"dpkg"' \"$out/bin/dpkg\" \
       --replace-fail '"debsig-verify"' \"$out/bin/debsig-verify\" \
       --replace-fail '"rm"' \"${coreutils}/bin/rm\" \
       --replace-fail '"cat"' \"${coreutils}/bin/cat\" \
       --replace-fail '"diff"' \"${diffutils}/bin/diff\"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # realpath("/var/lib/dpkg", NULL) gives EPERM on sandboxed darwin instead of the expected ENOENT,
    # which makes some tests fail.
    sed -i '/opts normalize/a AT_SKIP_IF([true])' src/at/chdir.at
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace src/main/help.c \
       --replace-fail '"ldconfig"' \"${glibc.bin}/bin/ldconfig\"
  '';

  buildInputs = [
    perl
    zlib
    bzip2
    xz
    zstd
    libmd
  ];
  nativeBuildInputs = [
    makeWrapper
    perl
    autoreconfHook
    pkg-config
  ];

  postInstall = ''
    for i in $out/bin/*; do
      if head -n 1 $i | grep -q perl; then
        substituteInPlace $i --replace-fail \
          "${perl}/bin/perl" "${perl}/bin/perl -I $out/${perl.libPrefix}"
      fi
    done

    mkdir -p $out/etc/dpkg
    cp -r scripts/t/origins $out/etc/dpkg
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Debian package manager";
    homepage = "https://wiki.debian.org/Teams/Dpkg";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ siriobalmelli ];
    mainProgram = "dpkg";
  };
})
