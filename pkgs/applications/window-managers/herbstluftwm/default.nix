{ lib, stdenv, fetchurl, cmake, pkg-config, python3, libX11, libXext, libXinerama, libXrandr, libXft, libXrender, libXdmcp, libXfixes, freetype, asciidoc
, xdotool, xorgserver, xsetroot, xterm, runtimeShell
, fetchpatch
, nixosTests }:

stdenv.mkDerivation rec {
  pname = "herbstluftwm";
  version = "0.9.5";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
    sha256 = "sha256-stRgCQnlvs5a1jgY37MLsZ/SrJ9ShHsaenStQEBxgQU=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONF_PREFIX=${placeholder "out"}/etc"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  depsBuildBuild = [
    asciidoc
  ];

  buildInputs = [
    libX11
    libXext
    libXinerama
    libXrandr
    libXft
    libXrender
    libXdmcp
    libXfixes
    freetype
  ];

  patches = [
    ./test-path-environment.patch
    # Adjust tests for compatibility with gcc 12 (https://github.com/herbstluftwm/herbstluftwm/issues/1512)
    # Can be removed with the next release (>0.9.5).
    (fetchpatch {
      url = "https://github.com/herbstluftwm/herbstluftwm/commit/8678168c7a3307b1271e94974e062799e745ab40.patch";
      hash = "sha256-uI6ErfDitT2Tw0txx4lMSBn/jjiiyL4Qw6AJa/CTh1E=";
    })
  ];

  postPatch = ''
    patchShebangs doc/gendoc.py

    # fix /etc/xdg/herbstluftwm paths in documentation and scripts
    grep -rlZ /etc/xdg/herbstluftwm share/ doc/ scripts/ | while IFS="" read -r -d "" path; do
      substituteInPlace "$path" --replace /etc/xdg/herbstluftwm $out/etc/xdg/herbstluftwm
    done

    # fix shebang in generated scripts
    substituteInPlace tests/conftest.py --replace "/usr/bin/env bash" ${runtimeShell}
    substituteInPlace tests/test_herbstluftwm.py --replace "/usr/bin/env bash" ${runtimeShell}
  '';

  doCheck = true;

  nativeCheckInputs = [
    (python3.withPackages (ps: with ps; [ ewmh pytest xlib ]))
    xdotool
    xorgserver
    xsetroot
    xterm
    python3.pkgs.pytestCheckHook
  ];

  # make the package's module available
  preCheck = ''
    export PYTHONPATH="$PYTHONPATH:../python"
  '';

  pytestFlagsArray = [ "../tests" ];
  disabledTests = [
    "test_autostart" # $PATH problems
    "test_wmexec_to_other" # timeouts in sandbox
    "test_rules" # timeouts
  ];

  passthru = {
    tests.herbstluftwm = nixosTests.herbstluftwm;
  };

  meta = with lib; {
    description = "A manual tiling window manager for X";
    homepage = "https://herbstluftwm.org/";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ thibautmarty ];
  };
}
