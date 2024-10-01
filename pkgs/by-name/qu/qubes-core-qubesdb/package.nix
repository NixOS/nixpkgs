{
  lib,
  stdenv,
  fetchFromGitHub,
  qubes-core-vchan-xen,
  pkg-config,
  systemd,
  withPython ? false,
  python ? null,
}:
let
  inherit (lib) optionalString optionals optional optionalAttrs;

  version = "4.2.6";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-core-qubesdb";
    rev = "refs/tags/v${version}";
    hash = "sha256-vPv74tBD7elYNqpgKLFKAanMH8D18OdDj0xhmw8aWwM=";
  };

  daemon = stdenv.mkDerivation {
    inherit src version;
    pname = "qubes-core-qubesdb-daemon";

    sourceRoot = "${src.name}/daemon";

    postPatch = ''
      # vchan module needs to be loaded using system-specific means.
      substituteInPlace qubes-db.service \
        --replace-fail " fedora-loadmodules.service" ""
      substituteInPlace *.service \
        --replace-fail "ExecStart=/usr/sbin/qubesdb-daemon" "ExecStart=$out/bin/qubesdb-daemon"
    '';

    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      qubes-core-vchan-xen
      systemd.dev
    ];

    postInstall = ''
      install -D -m0444 -t $out/lib/systemd/system *.service
    '';

    makeFlags = [ "DESTDIR=$(out)" "SBINDIR=/bin" "LIBDIR=/lib" ];

    inherit meta;
  };

  pythonModule = python.pkgs.buildPythonPackage {
    inherit src version;
    pname = "qubes-core-qubesdb-daemon-python";

    sourceRoot = "${src.name}/python";

    nativeBuildInputs = [
      pkg-config
    ];

    build-system = [
      python.pkgs.setuptools
    ];

    buildInputs = [
      client
    ];

    makeFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" "PYTHON_PREFIX_ARG=--prefix=." ];

    pythonImportsCheck = ["qubesdb"];

    inherit meta;
  };

  client = stdenv.mkDerivation {
    inherit src version;
    pname = "qubes-core-qubesdb-client";

    sourceRoot = "${src.name}/client";

    patches = [
      ./0001-fix-cmd-name-parsing.patch
    ];

    # binaries in client take around 20K of space, not worth splitting those.
    postInstall = ''
      make -C ../include install $makeFlags
    '';

    nativeBuildInputs = [
      pkg-config
    ] ++ optionals withPython [
      python
      python.pkgs.setuptools
    ];

    buildInputs = [
      qubes-core-vchan-xen
    ];

    makeFlags = [ "DESTDIR=$(out)" "BINDIR=/bin" "LIBDIR=/lib" "INCLUDEDIR=/include" ];

    inherit meta;
  };

  meta = {
    description = "Qubes VM configuration interface.";
    homepage = "https://qubes-os.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ lach sigmasquadron ];
    # daemon can also work on windows, ignoring for now.
    platforms = lib.platforms.linux;
  };
in client.overrideAttrs {
  passthru = {
    inherit daemon;
  } // optionalAttrs withPython {
    inherit pythonModule;
  };
}
