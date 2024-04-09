{
  autoreconfHook,
  lib,
  pkg-config,
  stdenv,
  fetchFromGitLab,
  gitUpdater,
  pkg-config,
  systemdMinimal,
  doxygen,
  fig2dev,
  python3,
  inkscape,
  graphviz,
  texlive,
  git,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ethercat";
  version = "1.6.2";

  src = fetchFromGitLab {
    owner = "etherlab.org";
    repo = "ethercat";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-NgRyvNvHy04jr7ieOscBYULRdWJ7YuHbuYbRrSfXYRU=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  separateDebugInfo = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ systemdMinimal ];

  outputs = [
    "bin"
    "dev"
    "doc"
  ];

  configureFlags = [
    # Components
    "--enable-tool=yes"
    "--enable-userlib=yes"
    "--enable-kernel=no"

    "--with-systemdsystemunitdir=$$out/lib/systemd/system"

    # Features
    "--enable-eoe=yes"
    "--enable-cycles=yes"
    "--enable-rtmutex=yes"
    "--enable-hrtimer=yes"
    "--enable-regalias=yes"
    "--enable-refclkop=yes"
    "--enable-tty=no" # Is broken in Kernel 6.6
    "--enable-wildcards"

    # Debugging
    "--enable-debug-if=yes"
    "--enable-debug-ring=yes"
  ];

  passthru.updateScript = gitUpdater { };

  # See: https://gitlab.com/etherlab.org/ethercat/-/blob/6e8119b95563ba955954a68e5e2f4f3f861ac72e/.gitlab-ci.yml#L117
  postPatch = ''
    git show -s --format="\def\revision{%h}\def\gitversion{%(describe)}\def\gittag{%(describe:abbrev=0)}\def\gitauthor{%an}\def\isodate#1-#2-#3x{\day=#3 \month=#2 \year=#1}\isodate %csx" HEAD > documentation/git.tex
  '';

  postInstall = ''
    mkdir -p $doc

    echo "Build Doxygen docs"
    make doc
    cp -r doxygen-output/html $doc/html

    echo "Build Doxygen LaTeX docs"
    make -C doxygen-output/latex
    cp -r doxygen-output/latex/refman.pdf $doc/ethercat_ref.pdf

    echo "Build LateX manual"
    mkdir -p documentation/external
    make -C documentation
    make -C documentation index
    make -C documentation

    cp documentation/*.pdf $doc
  '';

  postFixup = ''
    mv $out/{share,lib,etc} $bin
    find $out
    echo
    find $bin
  '';

  meta = with lib; {
    description = "IgH EtherCAT Master for Linux";
    homepage = "https://etherlab.org/ethercat";
    changelog = "https://gitlab.com/etherlab.org/ethercat/-/blob/${finalAttrs.version}/NEWS";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ stv0g ];
    platforms = platforms.linux;
  };
})
