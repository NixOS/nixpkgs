{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  asciidoc,
  xmlto,
  liburcu,
  numactl,
  python3,
  testers,
  nix-update-script,
}:

# NOTE:
#   ./configure ...
#   [...]
#   LTTng-UST will be built with the following options:
#
#   Java support (JNI): Disabled
#   sdt.h integration:  Disabled
#   [...]
#
# Debian builds with std.h (systemtap).

stdenv.mkDerivation (finalAttrs: {
  pname = "lttng-ust";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "lttng";
    repo = "lttng-ust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9WZDjOGfflEc6BUUO3W70KeLcZnTaePkF8eg8Ns/lQc=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "devdoc"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
    xmlto
  ];

  propagatedBuildInputs = [ liburcu ];

  buildInputs = [
    numactl
    python3
  ];

  postPatch = ''
    # to build the manpages, xmlto uses xmllint which tries to fetch a dtd schema
    # from the internet - just don't validate to work around this
    substituteInPlace doc/man/Makefile.am \
      --replace-fail '$(XMLTO)' '$(XMLTO) --skip-validation'
  '';

  preConfigure = ''
    patchShebangs .
  '';

  configureFlags = [ "--disable-examples" ];

  doCheck = true;

  strictDeps = true;

  enableParallelBuilding = true;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(.+)"
      ];
    };
  };

  meta = {
    description = "LTTng Userspace Tracer libraries";
    mainProgram = "lttng-gen-tp";
    homepage = "https://lttng.org/";
    changelog = "https://github.com/lttng/lttng-ust/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
      mit
    ];
    platforms = lib.intersectLists lib.platforms.linux liburcu.meta.platforms;
    pkgConfigModules = [
      "lttng-ust-ctl"
      "lttng-ust"
    ];
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
