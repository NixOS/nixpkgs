{ stdenv, lib, buildEnv, callPackage_i686, fetchFromGitHub, python27Packages, graphviz
, includeGUI ? true
, includeProtocols ? true
}:
let
  version = "1.1.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    sha256 = "0rb4ha5bnjxnwj4f3hciq7kyj96fhw14hqbwl5kr9cdw8q62mx0h";
    owner = "cascremers";
    repo = "scyther";
  };

  meta = with lib; {
    description = "Scyther is a tool for the automatic verification of security protocols.";
    homepage = https://www.cs.ox.ac.uk/people/cas.cremers/scyther/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };

  cli = callPackage_i686 ./cli.nix {
    inherit version src meta;
  };

  gui = stdenv.mkDerivation {
    name = "scyther-gui-${version}";
    inherit src meta;
    buildInputs = [
      python27Packages.wrapPython
    ];

    patchPhase = ''
      file=gui/Scyther/Scyther.py

      # By default the scyther binary is looked for in the directory of the python script ($out/gui), but we want to have it look where our cli package is
      substituteInPlace $file --replace "return getMyDir()" "return \"${cli}/bin\""

      # Removes the Shebang from the file, as this would be wrapped wrongly
      sed -i -e "1d" $file
    '';

    dontBuild = true;

    propagatedBuildInputs = [
      python27Packages.wxPython
      graphviz
    ];
 
    installPhase = ''
      mkdir -p "$out"/gui "$out"/bin
      cp -r gui/* "$out"/gui
      ln -s "$out"/gui/scyther-gui.py "$out/bin/scyther-gui"
    '';

    postFixup = ''
      wrapPythonProgramsIn "$out/gui" "$out $pythonPath"
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      "$out/gui/scyther.py" "$src/gui/Protocols/Demo/ns3.spdl"
    '';
  };
in
  buildEnv {
    name = "scyther-${version}";
    inherit meta;
    paths = [ cli ] ++ lib.optional includeGUI gui;
    pathsToLink = [ "/bin" ];

    postBuild = ''
      rm "$out/bin/scyther-linux"
    '' + lib.optionalString includeProtocols ''
      mkdir -p "$out/protocols"
      cp -rv ${src}/protocols/* "$out/protocols"
    '';
  }
