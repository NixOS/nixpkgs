{
  lib,
  stdenv,
  fetchFromGitHub,
  icu,
  pkg-config,
  qubes-vmm-xen,
  patsh,
  qubes-core-qubesdb,
  kmod,
  graphicsmagick,

  withPython ? false,
  python ? null,
}:
let
  inherit (lib) optionalAttrs;

  version = "4.3.4";
  src = fetchFromGitHub {
    owner = "QubesOS";
    repo = "qubes-linux-utils";
    rev = "refs/tags/v${version}";
    hash = "sha256-h1e+M7h3GUkQQKJWYAkhJ/kLPNc+LUIEp8THItmyers=";
  };

  imgconverter = python.pkgs.buildPythonPackage {
    inherit src version;
    pname = "qubes-linux-utils-imgconverter";

    sourceRoot = "${src.name}/imgconverter";

    nativeBuildInputs = [
      pkg-config
    ];

    build-system = [
      python.pkgs.setuptools
    ];

    propagatedBuildInputs = [
      python.pkgs.pilkit
      python.pkgs.numpy
      python.pkgs.pycairo
      graphicsmagick
    ];

    makeFlags = [ "DESTDIR=$(out)" "LIBDIR=/lib" "PYTHON_PREFIX_ARG=--prefix=." ];

    pythonImportsCheck = ["qubesimgconverter"];
  };
in
stdenv.mkDerivation {
  inherit version src;
  pname = "qubes-linux-utils";

  # imgconverter is built in separate derivation
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "\$(MAKE) -C imgconverter all" "" \
      --replace-fail "\$(MAKE) -C imgconverter install" ""
    substituteInPlace qmemman/*.service \
      --replace-fail "ExecStart=/usr/sbin/meminfo-writer" "ExecStart=$out/bin/meminfo-writer"
  '';

  nativeBuildInputs = [
    pkg-config
    patsh
  ];

  buildInputs = [
    icu.dev
    qubes-vmm-xen.dev

    qubes-core-qubesdb
    kmod
  ];

  postInstall = ''
    mv $out/usr/lib/systemd $out/lib/
    rm -d $out/usr/{lib,}

    substituteInPlace $out/lib/udev/rules.d/99-qubes-{usb,block}.rules \
      --replace-fail '/usr/lib/qubes/' "$out/libexec/qubes/"

    for hook in block-add-change block-remove usb-add-change usb-remove; do
      substituteInPlace $out/libexec/qubes/udev-$hook \
        --replace-quiet "/sbin/modprobe" "/bin/modprobe"
      patsh -f $out/libexec/qubes/udev-$hook -s ${builtins.storeDir}
    done
  '';

  makeFlags = [
    "DESTDIR=$(out)" "LIBDIR=/lib" "SCRIPTSDIR=/libexec/qubes"
    "SYSLIBDIR=/lib" "INCLUDEDIR=/include" "SBINDIR=/bin"
    "CFLAGS=-DUSE_XENSTORE_H"
  ];

  passthru = optionalAttrs withPython {
    inherit imgconverter;
  };
}
