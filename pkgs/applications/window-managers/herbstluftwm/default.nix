{ lib, stdenv, fetchurl, cmake, pkg-config, python3, libX11, libXext, libXinerama, libXrandr, asciidoc
, xdotool, xorgserver, xsetroot, xterm, runtimeShell
, nixosTests }:

# Doc generation is disabled by default when cross compiling because asciidoc
# dependency is broken when cross compiling for now

let
  cross = stdenv.buildPlatform != stdenv.targetPlatform;

in stdenv.mkDerivation rec {
  pname = "herbstluftwm";
  version = "0.9.1";

  src = fetchurl {
    url = "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
    sha256 = "0r4qaklv97qcq8p0pnz4f2zqg69vfai6c2qi1ydi2kz24xqjf5hy";
  };

  outputs = [
    "out"
    "doc" # share/doc exists with examples even without generated html documentation
  ] ++ lib.optionals (!cross) [
    "man"
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONF_PREFIX=${placeholder "out"}/etc"
  ] ++ lib.optional cross "-DWITH_DOCUMENTATION=OFF";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ] ++ lib.optional (!cross) asciidoc;

  buildInputs = [
    libX11
    libXext
    libXinerama
    libXrandr
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

  checkInputs = [
    (python3.withPackages (ps: with ps; [ ewmh pytest xlib ]))
    xdotool
    xorgserver
    xsetroot
    xterm
    python3.pkgs.pytestCheckHook
  ];

  # make the package's module avalaible
  preCheck = ''
    export PYTHONPATH="$PYTHONPATH:../python"
  '';

  pytestFlagsArray = [ "../tests" ];

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
