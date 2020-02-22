{ lib, mkDerivation, wrapQtAppsHook, callPackage, fetchgit, cmake, jq, python3, qtbase, qtquickcontrols2 }:

let
  # admittedly, we're using (printer firmware) blobs when we could compile them ourselves.
  curaBinaryDataVersion = "3.6.21"; # Marlin v2.0.0.174 for Bio, v2.0.0.144 for others.
  curaBinaryData = fetchgit {
    url = https://code.alephobjects.com/diffusion/CBD/cura-binary-data.git;
    rev = "5c75d0f6c10d8b7a903e2072a48cd1f08059509e";
    sha256 = "1qdsj6rczwzdwzyr7nz7fnypbphckjrnwl8c9dr6izsxyzs465c4";
  };

  libarcusLulzbot = callPackage ./libarcus.nix {
    inherit (python3.pkgs) buildPythonPackage sip pythonOlder;
  };
  libsavitarLulzbot = callPackage ./libsavitar.nix {
    inherit (python3.pkgs) buildPythonPackage sip pythonOlder;
  };

  inherit (python3.pkgs) buildPythonPackage pyqt5 numpy scipy shapely pythonOlder;
  curaengine = callPackage ./curaengine.nix {
    inherit libarcusLulzbot;
  };
  uraniumLulzbot = callPackage ./uranium.nix {
    inherit callPackage libarcusLulzbot;
    inherit (python3.pkgs) buildPythonPackage pyqt5 numpy scipy shapely pythonOlder;
  };
in
mkDerivation rec {
  pname = "cura-lulzbot";
  version = "3.6.21";

  src = fetchgit {
    url = https://code.alephobjects.com/source/cura-lulzbot.git;
    rev = "7faeb18604c83004846a02c60cb240708db0034f";
    sha256 = "10q38s8c8x6xkh1vns4p3iqa5y267vrjh5vq8h55mg1q5001scyq";
  };

  buildInputs = [ qtbase qtquickcontrols2 ];
  # numpy-stl temporarily disabled due to https://code.alephobjects.com/T8415
  propagatedBuildInputs = with python3.pkgs; [ pyserial requests zeroconf ] ++ [ libsavitarLulzbot uraniumLulzbot libarcusLulzbot ]; # numpy-stl
  nativeBuildInputs = [ cmake python3.pkgs.wrapPython ];

  cmakeFlags = [
    "-DURANIUM_DIR=${uraniumLulzbot.src}"
    "-DCURA_VERSION=${version}"
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
    homepage = https://code.alephobjects.com/diffusion/CURA/;
    license = licenses.agpl3;  # a partial relicense to LGPL has happened, but not certain that all AGPL bits are expunged
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
