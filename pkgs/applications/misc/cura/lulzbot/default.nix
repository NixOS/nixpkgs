{ lib, callPackage, fetchgit, cmake, jq, python3Packages, qtbase, qtquickcontrols2 }:

let
  # admittedly, we're using (printer firmware) blobs when we could compile them ourselves.
  curaBinaryDataVersion = "3.6.18"; # Marlin v2.0.0.144. Keep this accurate wrt. the below.
  curaBinaryData = fetchgit {
    url = https://code.alephobjects.com/diffusion/CBD/cura-binary-data.git;
    rev = "cdc046494bbfe1f65bfb34659a257eef9a0100a0";
    sha256 = "0v0s036gxdjiglas2yzw95alv60sw3pq5k1zrrhmw9mxr4irrblb";
  };

  libarcusLulzbot = callPackage ./libarcus.nix {
    inherit (python3Packages) buildPythonPackage sip pythonOlder;
  };
  libsavitarLulzbot = callPackage ./libsavitar.nix {
    inherit (python3Packages) buildPythonPackage sip pythonOlder;
  };

  inherit (python3Packages) buildPythonPackage pyqt5 numpy scipy shapely pythonOlder;
  curaengine = callPackage ./curaengine.nix {
    inherit libarcusLulzbot;
  };
  uraniumLulzbot = callPackage ./uranium.nix {
    inherit callPackage libarcusLulzbot;
    inherit (python3Packages) buildPythonPackage pyqt5 numpy scipy shapely pythonOlder;
  };
in
python3Packages.buildPythonApplication rec {
  name = "cura-lulzbot-${version}";
  version = "3.6.18";

  src = fetchgit {
    url = https://code.alephobjects.com/source/cura-lulzbot.git;
    rev = "71f1ac5a2b9f535175a3858a565930348358a9ca";
    sha256 = "0by06fpxvdgy858lwhsccbmvkdq67j2s1cz8v6jnrnjrsxk7vzka";
  };

  format = "other"; # using cmake to build
  buildInputs = [ qtbase qtquickcontrols2 ];
  # numpy-stl temporarily disabled due to https://code.alephobjects.com/T8415
  propagatedBuildInputs = with python3Packages; [ pyserial requests zeroconf ] ++ [ libsavitarLulzbot uraniumLulzbot libarcusLulzbot ]; # numpy-stl
  nativeBuildInputs = [ cmake python3Packages.wrapPython ];

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

  meta = with lib; {
    description = "3D printer / slicing GUI built on top of the Uranium framework";
    homepage = https://code.alephobjects.com/diffusion/CURA/;
    license = licenses.agpl3;  # a partial relicense to LGPL has happened, but not certain that all AGPL bits are expunged
    platforms = platforms.linux;
    maintainers = with maintainers; [ chaduffy ];
  };
}
