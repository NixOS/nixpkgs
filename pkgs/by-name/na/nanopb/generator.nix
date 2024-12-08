{ python3
, stdenvNoCC
, protobuf
, version
, generator-out
}:
stdenvNoCC.mkDerivation {
  pname = "nanopb-generator";
  inherit version;

  dontUnpack = true;

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  propagatedBuildInputs = [
    protobuf
    python3.pkgs.nanopb-proto
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${generator-out}/bin/protoc-gen-nanopb $out/bin/
    cp ${generator-out}/bin/nanopb_generator $out/bin/
    wrapPythonPrograms
    cp ${generator-out}/bin/nanopb_generator.py $out/bin/
  '';
}
