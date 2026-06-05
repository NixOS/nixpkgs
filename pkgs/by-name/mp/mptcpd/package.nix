{
  autoreconfHook,
  autoconf-archive,
  doxygen,
  ell,
  fetchFromGitHub,
  fontconfig,
  graphviz,
  lib,
  pandoc,
  perl,
  pkg-config,
  stdenv,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mptcpd";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcpd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gPXtYmCLJ8eL6VfCi3kpDA7lNn38WB6J4FXefdu2D7M=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    doxygen
    graphviz
    pandoc
    perl
    pkg-config
  ];

  # ref. https://github.com/multipath-tcp/mptcpd/blob/main/README.md#bootstrapping
  preConfigure = "./bootstrap";

  # fix: 'To avoid this warning please remove this line from your configuration file or upgrade it using "doxygen -u"'
  postConfigure = "doxygen -u";

  configureFlags = [
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  # fix: 'Fontconfig error: Cannot load default config file: No such file: (null)'
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  buildInputs = [
    ell
    systemd
  ];

  # fix: 'Fontconfig error: No writable cache directories'
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  # build and install doc
  postBuild = "make doxygen-doc";
  postInstall = "mv doc $doc";

  doCheck = true;

  meta = {
    description = "Daemon for Linux that performs Multipath TCP path management related operations in the user space";
    homepage = "https://github.com/multipath-tcp/mptcpd";
    changelog = "https://github.com/multipath-tcp/mptcpd/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "mptcpize";
    platforms = lib.platforms.linux;
  };
})
