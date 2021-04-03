{ lib, mkDerivation, wrapQtAppsHook, callPackage, fetchFromGitLab, cmake, jq, python36, qtbase, qtquickcontrols2 }:

let
  # admittedly, we're using (printer firmware) blobs when we could compile them ourselves.
  curaBinaryDataVersion = "3.6.23";
  curaBinaryData = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "cura-binary-data";
    rev = "${curaBinaryDataVersion}";
    sha256 = "188976fmzsvpvqfhriyws0g986zym9r7m2ismswiw2q6acj8r2nf";
  };

  libarcusLulzbot = callPackage ./libarcus.nix {
    inherit (python36.pkgs) buildPythonPackage sip pythonOlder;
  };
  libsavitarLulzbot = callPackage ./libsavitar.nix {
    inherit (python36.pkgs) buildPythonPackage sip pythonOlder;
  };

  inherit (python36.pkgs) buildPythonPackage pyqt5 numpy scipy_1_4 shapely pythonOlder;
  curaengine = callPackage ./curaengine.nix {
    inherit libarcusLulzbot;
  };
  uraniumLulzbot = callPackage ./uranium.nix {
    inherit callPackage libarcusLulzbot;
    inherit (python36.pkgs) buildPythonPackage pyqt5 numpy scipy_1_4 shapely pythonOlder;
  };
in
mkDerivation rec {
  pname = "cura-lulzbot";
  version = "3.6.23";

  src = fetchFromGitLab {
    group = "lulzbot3d";
    owner = "cura-le";
    repo = "cura-lulzbot";
    rev = version;
    sha256 = "1nq2jjjky5l5r16vcb1l49zsvqhkaq23dh4ghwdss88cpay8c9fk";
  };

  buildInputs = [ qtbase qtquickcontrols2 ];
  # numpy-stl temporarily disabled due to https://code.alephobjects.com/T8415
  propagatedBuildInputs = with python36.pkgs; [ pyserial requests zeroconf ] ++ [ libsavitarLulzbot uraniumLulzbot libarcusLulzbot ]; # numpy-stl
  nativeBuildInputs = [ cmake python36.pkgs.wrapPython ];

  cmakeFlags = [
    "-DURANIUM_DIR=${uraniumLulzbot.src}"
    "-DCURA_VERSION=${version}"
  ];

  makeWrapperArgs = [
    # hacky workaround for https://github.com/NixOS/nixpkgs/issues/59901
    "--set OMP_NUM_THREADS 1"
  ];

  postPatch = ''
    sed -i 's,/python''${PYTHON_VERSION_MAJOR}/dist-packages,/python''${PYTHON_VERSION_MAJOR}.''${PYTHON_VERSION_MINOR}/site-packages,g' CMakeLists.txt
    sed -i 's, executable_name = .*, executable_name = "${curaengine}/bin/CuraEngine",' plugins/CuraEngineBackend/CuraEngineBackend.py
  '';

  preFixup = ''
    substituteInPlace "$out/bin/cura-lulzbot" --replace 'import cura.CuraApplication' 'import Savitar; import cura.CuraApplication'
    ln -sT "${curaBinaryData}/cura/resources/firmware" "$out/share/cura/resources/firmware"
    ln -sT "${uraniumLulzbot}/share/uranium" "$out/share/uranium"
    ${jq}/bin/jq --arg out "$out" '.build=$out' >"$out/version.json" <<'EOF'
    ${builtins.toJSON {
      cura = version;
      cura_version = version;
      binarydata = curaBinaryDataVersion;
      engine = curaengine.version;
      libarcus = libarcusLulzbot.version;
      libsavitar = libsavitarLulzbot.version;
      uranium = uraniumLulzbot.version;
    }}
    EOF
  '';

  postFixup = ''
    wrapPythonPrograms
    wrapQtApp "$out/bin/cura-lulzbot"
  '';

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = "https://gitlab.com/lulzbot3d/cura-le/cura-lulzbot";
    license = licenses.agpl3;  # a partial relicense to LGPL has happened, but not certain that all AGPL bits are expunged
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
