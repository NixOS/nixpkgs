{ lib, stdenv, fetchurl, cmake, pkg-config, python3, libX11, libXext, libXinerama, libXrandr, libXft, libXrender, libXdmcp, libXfixes, freetype, asciidoc
, xdotool, xorgserver, xsetroot, xterm, runtimeShell
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
    "test_title_different_letters_are_drawn" # font problems
    "test_completable_commands" # font problems
    "test_autostart" # $PATH problems
    "test_wmexec_to_other" # timeouts in sandbox
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
