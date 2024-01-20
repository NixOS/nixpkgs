{ lib, stdenv, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "pywalfox-native";
  version = "2.7.4";

  src = fetchPypi {
    inherit version;
    pname = "pywalfox";
    hash = "sha256-Wec9fic4lXT7gBY04D2EcfCb/gYoZcrYA/aMRWaA7WY=";
  };

  postInstall = ''
    # Overwrite the original wrapper script with a new one that has the
    # appropriate executable paths.
    cat > $out/lib/${python3.libPrefix}/site-packages/pywalfox/bin/main.sh <<'EOF'
    #!${stdenv.shell}
      ${placeholder "out"}/bin/pywalfox start
    EOF

    # The install.py script forcefully sets executable privileged no matter
    # what during the installation. This is undesired due to read-only nix store
    substituteInPlace $out/lib/${python3.libPrefix}/site-packages/pywalfox/install.py  \
      --replace "set_executable_permissions(BIN_PATH_UNIX)" \
      "#set_executable_permissions(BIN_PATH_UNIX) # Note: read-only /nix/store"
  '';

  pythonImportsCheck = [ "pywalfox" ];

  meta = with lib; {
    homepage = "https://github.com/Frewacom/pywalfox-native";
    description = "Native app used alongside the Pywalfox addon";
    mainProgram = "pywalfox";
    license = licenses.mpl20;
    maintainers = with maintainers; [ tsandrini ];
  };
}
