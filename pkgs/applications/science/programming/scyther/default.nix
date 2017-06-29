{ stdenv, lib, fetchFromGitHub, glibc, flex, bison, python27Packages, graphviz, cmake
, includeGUI ? true
, includeProtocols ? true
}:
let
  version = "1.1.3";
in
stdenv.mkDerivation {
  name = "scyther-${version}";
  src = fetchFromGitHub {
    rev = "v${version}";
    sha256 = "0rb4ha5bnjxnwj4f3hciq7kyj96fhw14hqbwl5kr9cdw8q62mx0h";
    owner = "cascremers";
    repo = "scyther";
  };

  buildInputs = [
    cmake
    glibc.static
    flex
    bison
  ] ++ lib.optional includeGUI [
    python27Packages.wrapPython
  ];

  patchPhase = ''
    # Since we're not in a git dir, the normal command this project uses to create this file wouldn't work
    printf "%s\n" "#define TAGVERSION \"${version}\"" > src/version.h
  '' + lib.optionalString includeGUI ''
    file=gui/Scyther/Scyther.py
    
    # By default the scyther binary is looked for in the directory of the python script ($out/gui), but we want to have it look where our cli package is
    substituteInPlace $file --replace "return getMyDir()" "return \"$out/bin\""

    # Removes the Shebang from the file, as this would be wrapped wrongly
    sed -i -e "1d" $file
  '';

  configurePhase = ''
    (cd src && cmakeConfigurePhase)
  '';

  propagatedBuildInputs = lib.optional includeGUI [
    python27Packages.wxPython
    graphviz
  ];
  
  dontUseCmakeBuildDir = true;
  cmakeFlags = [ "-DCMAKE_C_FLAGS=-std=gnu89" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp src/scyther-linux "$out/bin/scyther-cli"
  '' + lib.optionalString includeGUI ''
    mkdir -p "$out/gui"
    cp -r gui/* "$out/gui"
    ln -s ../gui/scyther-gui.py "$out/bin/scyther-gui"
    ln -s ../bin/scyther-cli "$out/bin/scyther-linux"
  '' + lib.optionalString includeProtocols (if includeGUI then ''
      ln -s ./gui/Protocols "$out/protocols"
    '' else ''
      mkdir -p "$out/protocols"
      cp -r gui/Protocols/* "$out/protocols"
    '');

  postFixup = lib.optionalString includeGUI ''
    wrapPythonProgramsIn "$out/gui" "$out $pythonPath"
  '';

  doInstallCheck = includeGUI;
  installCheckPhase = ''
    "$out/gui/scyther.py" "$src/gui/Protocols/Demo/ns3.spdl"
  '';

  meta = with lib; {
    description = "Scyther is a tool for the automatic verification of security protocols.";
    homepage = https://www.cs.ox.ac.uk/people/cas.cremers/scyther/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };
}
