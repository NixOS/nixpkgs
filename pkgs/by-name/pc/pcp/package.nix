# TODO:
# - split each PMDA into its own package, into a set `pcpPackages`
# - package qt applets separately
# - fix darwin libpcp not found error

{
  fetchFromGitHub,
  stdenv,
  lib,

  # Build inputs
  autoreconfHook,
  pkg-config,
  bison,
  flex,

  # Used at runtime in shell scripts
  which,
  gawk,
  gnused,

  # Secure sockets
  openssl,
  cyrus_sasl,

  # Web
  libuv,
  zlib,

  # Curses -- atop
  readline,
  ncurses,

  # Linux PMDAs and support
  avahi, # zeroconf
  libbpf,
  libelf,
  clang,
  libllvm,
  bpftrace,
  libpfm,
  systemd,
  bpftools,

  # Darwin PMDAs and support
  fixDarwinDylibNames,
  apple-sdk_14,
  cctools,
  clang_20,

  # Python PMDAs, API, dstat, pcp ps, etc.
  withPython ? true,
  python3,
  makeWrapper,

  # Perl PMDAs
  withPerl ? false,
  perl,

  # pmchart, pmgadgets, etc
  withQt ? true,
  qtPackages ? kdePackages,
  kdePackages,

  nixosTests,
}:

let
  inherit (stdenv.hostPlatform) isDarwin isLinux;
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;

  libc = if isDarwin then "/usr/lib/libSystem.B.dylib" else "${stdenv.cc.libc}/lib/libc.so.6";

  pythonDeps = scopedPkgs: with scopedPkgs; [
    # To build Python API
    setuptools

    openpyxl # pcp2xlsx
    pyarrow # pcp2arrow
    setuptools

    requests # InfluxDB support
    six # json
    jsonpointer # json
    libvirt # libvirt
    lxml # libvirt
    psycopg2 # postgresql
    pymongo # mongodb
  ]
  ++ lib.optionals isLinux [
    bcc # bcc TODO -- nixpkgs package doesn't have the library?
    rtslib-fb # LIO
  ]
  # mssql (SQL Server) PMDA -- Upgrade script looks for perl
  ++ lib.optional withPerl pyodbc;

  perlDeps = scopedPkgs: with scopedPkgs; [
    NetSNMP # SNMP
    DBI # oracle, mysql
    DBDmysql # mysql
    LWP # nginx, activemg
  ];

  wrappedPython = python3.withPackages pythonDeps;
  wrappedPerl = perl.withPackages perlDeps;

  # Maps the name of a PCP Qt program to a shell expression for its path.
  getGuiExe = name: if isDarwin
    then "$out/Applications/${name}.app/Contents/MacOS/${name}"
    else "$out/bin/${name}";

  # List of all Qt programs in PCP.
  guiExes = lib.map getGuiExe [
    "pmchart"
    "pmview"
    "pmquery"
    "pmtime"
    "pmdumptext"
  ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "pcp";
  version = "7.0.2";

  outputs = [
    # TODO: cycle detected on Darwin, references 'dev' from 'out'
    # "doc"
    # "man"
    "out"
    # "dev"
  ];

  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    tag = finalAttrs.version;
    hash = "sha256-OqeOblvYSGxj7JKAdFQZa+f2j/qAk2D3M9cw/Fy2oeE=";
  };

  patches = [
    ./patches/0001-Detect-NixOS-and-build-manpages-on-it.patch
    ./patches/0002-Move-pmlogctl-lockfile-to-run-pcp.patch
    ./patches/0003-Install-files-under-var-and-etc-in-out.patch
    ./patches/0004-Replace-find_library-with-variables-for-library-path.patch

    # pmview has been disabled by default upstream, these patches reenable it
    # note that pmview requires SoQt, which is Qt5-only
    ./patches/0005-Find-SoQt-using-pkg-config.patch
    ./patches/0006-pmview-install-desktop-files.patch

    # Fixes for building on macOS
    ./patches/0007-Handle-modern-macOS.patch
    ./patches/0008-Install-macOS-applications-to-bin-dir.patch
  ];

  # Remove a few hardcoded references to FHS paths in the build and install process
  postPatch = ''
    # Remove vendored bpftool
    rm -rf vendor/{github.com/libbpf/bpftool,GNUmakefile}

    substituteInPlace GNUmakefile \
      --replace-fail "/usr/lib/tmpfiles.d" "$out/lib/tmpfiles.d" \
      --replace-fail " vendor" ""

    ${lib.optionalString isLinux ''
      substituteInPlace src/include/builddefs.in \
        --replace-fail "BPFTOOL =" "BPFTOOL = ${lib.getExe' bpftools "bpftool"} #"
    ''}

    # Replace `/var/tmp` with `/tmp` throughout build scripts
    substituteInPlace scripts/* src/pmdas/*/mk.rewrite \
      src/pmdas/linux/add_{snmp,netstat}_field src/libpcp/src/check-errorcodes \
      --replace-quiet "tmp=/var/tmp" "tmp=/tmp"

    ${lib.optionalString withPython ''
      # Replace Python C library placeholders with their full paths
      substituteInPlace src/python/pcp/{mmv,pmapi,pmda,pmgui,pmi}.py \
        --subst-var-by c "${libc}" \
        --subst-var-by pcp "$out/lib/libpcp${libExt}" \
        --subst-var-by pcp_mmv "$out/lib/libpcp_mmv${libExt}" \
        --subst-var-by pcp_pmda "$out/lib/libpcp_pmda${libExt}" \
        --subst-var-by pcp_gui "$out/lib/libpcp_gui${libExt}" \
        --subst-var-by pcp_import "$out/lib/libpcp_import${libExt}"
    ''}
  '';

  preConfigure = ''
    export AR="$(which ar)"
    ${lib.optionalString isLinux ''
      export SYSTEMD_TMPFILESDIR="$out/lib/tmpfiles.d"
      export SYSTEMD_SYSUSERSDIR="$out/lib/sysusers.d"
      export SYSTEMD_SYSTEMUNITDIR="$out/lib/systemd/system"
    ''}
  '';

  configureFlags = [
    # By default it tries to find gmake
    "--with-make=make"

    # By default these are subdirectories of prefix (aka $out). Patch #0003
    # makes them install in $out, while keeping code references as the runtime
    # directories
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  nativeBuildInputs = [
    (autoreconfHook.override (lib.optionalAttrs isDarwin { libtool = cctools; }))
    pkg-config
    bison
    flex
  ]
  ++ lib.optionals isLinux [
    clang # bpf
    libllvm # bpf -- for llvm-strip command
  ]
  ++ lib.optionals isDarwin [
    fixDarwinDylibNames
    # TODO: drop when default clang is updated
    # Newer clang needed to avoid compiler crash (!)
    # https://github.com/llvm/llvm-project/issues/153514
    clang_20
  ]
  ++ lib.optional withPython makeWrapper
  ++ lib.optional withQt qtPackages.wrapQtAppsHook;

  # needed to compile BPF
  hardeningDisable = lib.optional isLinux "zerocallusedregs";

  buildInputs = builtins.concatLists [
    [
      which
      gawk
      gnused

      openssl
      cyrus_sasl

      readline
      ncurses

      libuv
      zlib

      # TODO: postfix? -- needs qshape
    ]

    # TODO: drop when default SDK is updated
    # Newer SDK needed for macOS NFS changes (13+) and Qt6 (14+)
    (lib.optional isDarwin apple-sdk_14)

    (lib.optionals isLinux [
      avahi

      libbpf # bpf
      libelf # bpf
      bpftrace # bpftrace
      libpfm # perfevent
      systemd # systemd
    ])

    (lib.optional withPython wrappedPython)
    (lib.optional withPerl wrappedPerl)

    # pmchart, pmgadgets, pmview, etc
    (lib.optionals withQt (with qtPackages; [
      qtbase
      qtsvg
      qt3d
    ]))
  ];

  makeFlags = lib.optional isDarwin "LDFLAGS=-Wl,-install_name,$(out)/lib/libpcp.dylib";

  # Environment variables for installation -- see `install-sh` script for docs.
  # The `DIST_TMPFILES` option in particular generates a `tmpfiles.d` file that
  # automatically sets up the structure of `/var/lib/pcp`.
  preInstall = ''
    export NO_CHOWN=true
    ${lib.optionalString isLinux ''
      export DIST_TMPFILES="$out/lib/tmpfiles.d/pcp.conf"
    ''}
  '';

  # Only wrap necessary binaries
  dontWrapQtApps = true;

  postFixup = ''
    ${lib.optionalString withPython ''
      wrapProgram $out/bin/pmpython \
        --prefix PYTHONPATH : "$out/${python3.sitePackages}"
    ''}

    ${lib.optionalString withQt ''
      # Wrap Qt apps.
      ${lib.concatMapStringsSep "\n" (path: ''
        if [ -x "${path}" ]; then
          wrapQtApp "${path}"
        fi
      '') guiExes}

      ${lib.optionalString (!isDarwin) ''
        # Symlink the app icon directory for `.desktop` files.
        mkdir -p "$out/share/icons/hicolor/48x48"
        ln -s "$out/share/pcp-gui/pixmaps" "$out/share/icons/hicolor/48x48/apps"
      ''}
    ''}

    ${lib.optionalString false ''
      # Build a list of arguments to `install_name_tool` that change references
      # to all libraries in `$out/lib` to be the full path.
      args=""
      for lib in "$out"/lib/*.dylib; do
        args="$args -change $(basename "$lib") $(realpath "$lib")"
      done
      # args="-add_rpath $out/lib"
      # for lib in "$out"/lib/libpcp*.dylib; do
      #   lib="$(basename "$lib")"
      #   args="$args -change "$lib" "@rpath/$lib""
      # done

      echo "args: $args"

      # Find all executables, that aren't in /var, and that have lines in the
      # output of `otool -L $file` that DON'T start with / or @ (so basically
      # all broken files), and run `install_name_tool` for each one, using the
      # previously built arguments.
      find "$out/" -type f -executable \
        -not -path '*var/lib/pcp*' \
        -exec sh -c "otool -L '{}' | grep -q $'^\t[^/@]'" \; -print0 | \
      xargs -0 -I'{}' sh -c "install_name_tool $args '{}' || true"
    ''}
  '';

  passthru = {
    tests = { inherit (nixosTests) pcp; };
    interpreters = lib.listToAttrs (lib.concatLists [
      (lib.optional withPython (lib.nameValuePair "python" wrappedPython))
      (lib.optional withPerl (lib.nameValuePair "perl" wrappedPerl))
    ]);
  };

  meta = {
    description = "System performance analysis toolkit";
    mainProgram = "pcp";
    homepage = "https://pcp.io";
    changelog = "https://github.com/performancecopilot/pcp/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ andre4ik3 ];
  };
})
