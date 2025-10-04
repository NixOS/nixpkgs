{
  lib,
  stdenv,
  fetchurl,
  linux_latest,
  elfutils,
  python3,
  newt,
  slang,
  asciidoc,
  xmlto,
  makeWrapper,
  docbook_xsl,
  docbook_xml_dtd_45,
  libxslt,
  flex,
  bison,
  pkg-config,
  libunwind,
  binutils-unwrapped,
  libiberty,
  audit,
  libopcodes,
  libpfm,
  libtraceevent,
  openssl,
  systemtap-unwrapped,
  numactl,
  zlib,
  babeltrace,
  withGtk ? false,
  gtk2,
  withZstd ? true,
  zstd,
  withLibcap ? true,
  libcap,
  buildPackages,
}:
let
  d3-flame-graph-templates = stdenv.mkDerivation rec {
    pname = "d3-flame-graph-templates";
    version = "4.1.3";

    src = fetchurl {
      url = "https://registry.npmjs.org/d3-flame-graph/-/d3-flame-graph-${version}.tgz";
      sha256 = "sha256-W5/Vh5jarXUV224aIiTB2TnBFYT3naEIcG2945QjY8Q=";
    };

    installPhase = ''
      install -D -m 0755 -t $out/share/d3-flame-graph/ ./dist/templates/*
    '';
  };
in

stdenv.mkDerivation {
  pname = "perf-linux";
  inherit (linux_latest) version src;

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  postPatch = ''
    # Linux scripts
    patchShebangs scripts
    patchShebangs tools/perf/check-headers.sh
    # perf-specific scripts
    patchShebangs tools/perf/pmu-events
    cd tools/perf

    for x in util/build-id.c util/dso.c; do
      substituteInPlace $x --replace /usr/lib/debug /run/current-system/sw/lib/debug
    done

    substituteInPlace scripts/python/flamegraph.py \
      --replace "/usr/share/d3-flame-graph/d3-flamegraph-base.html" \
      "${d3-flame-graph-templates}/share/d3-flame-graph/d3-flamegraph-base.html"

    patchShebangs pmu-events/jevents.py
  '';

  makeFlags = [
    "prefix=$(out)"
    "WERROR=0"
    "ASCIIDOC8=1"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ]
  ++ lib.optional (!withGtk) "NO_GTK2=1"
  ++ lib.optional (!withZstd) "NO_LIBZSTD=1"
  ++ lib.optional (!withLibcap) "NO_LIBCAP=1";

  hardeningDisable = [ "format" ];

  # perf refers both to newt and slang
  nativeBuildInputs = [
    asciidoc
    xmlto
    docbook_xsl
    docbook_xml_dtd_45
    libxslt
    flex
    bison
    libiberty
    audit
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    elfutils
    newt
    slang
    libtraceevent
    libunwind
    zlib
    openssl
    numactl
    python3
    babeltrace
    libopcodes
    libpfm
    python3.pkgs.setuptools
  ]
  ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform systemtap-unwrapped) systemtap-unwrapped
  ++ lib.optional withGtk gtk2
  ++ lib.optional withZstd zstd
  ++ lib.optional withLibcap libcap;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cpp"
    "-Wno-error=bool-compare"
    "-Wno-error=deprecated-declarations"
    "-Wno-error=stringop-truncation"
  ];

  doCheck = false; # requires "sparse"

  installTargets = [
    "install-tools" # don't install tests, as those depend on perl
    "install-man"
  ];

  # TODO: Add completions based on perf-completion.sh
  postInstall = ''
    # Same as perf. Remove.
    rm -f $out/bin/trace
  '';

  separateDebugInfo = true;

  preFixup = ''
    # Pull in 'objdump' into PATH to make annotations work.
    # The embedded Python interpreter will search PATH to calculate the Python path configuration(Should be fixed by upstream).
    # Add python.interpreter to PATH for now.
    wrapProgram $out/bin/perf \
      --prefix PATH : ${
        lib.makeBinPath [
          binutils-unwrapped
          python3
        ]
      }
  '';

  meta = with lib; {
    homepage = "https://perf.wiki.kernel.org/";
    description = "Linux tools to profile with performance counters";
    mainProgram = "perf";
    maintainers = with maintainers; [ tobim ];
    platforms = platforms.linux;
  };
}
