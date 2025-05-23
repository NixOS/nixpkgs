{
  callPackage,
  fetchFromSavannah,
  gnucap,
  gnucap-full,
  installShellFiles,
  lib,
  readline,
  runCommand,
  stdenv,
  termcap,
  writeScript,
}:

let
  version = "20240220";
  meta = with lib; {
    description = "Gnu Circuit Analysis Package";
    longDescription = ''
      Gnucap is a modern general purpose circuit simulator with several advantages over Spice derivatives.
      It performs nonlinear dc and transient analyses, fourier analysis, and ac analysis.
    '';
    homepage = "http://www.gnucap.org/";
    changelog = "https://git.savannah.gnu.org/gitweb/?p=gnucap.git;a=blob;f=NEWS";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Relies on LD_LIBRARY_PATH
    maintainers = [ maintainers.raboof ];
    mainProgram = "gnucap";
  };
in
stdenv.mkDerivation {
  pname = "gnucap";
  inherit version;

  src = fetchFromSavannah {
    repo = "gnucap";
    rev = version;
    hash = "sha256-aZMiNKwI6eQZAxlF/+GoJhKczohgGwZ0/Wgpv3+AhYY=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];
  buildInputs = [
    readline
    termcap
  ];

  doCheck = true;

  postInstall = ''
    installManPage man/*
  '';

  passthru.tests = {
    verilog = runCommand "gnucap-verilog-test" { } ''
      echo "attach mgsim" | ${gnucap-full}/bin/gnucap -a msgsim > $out
      cat $out | grep "verilog: already installed"
    '';
  };

  inherit meta;
}
// {
  plugins = callPackage ./plugins.nix { };
  withPlugins =
    p:
    let
      selectedPlugins = p gnucap.plugins;
      wrapper = writeScript "gnucap" ''
        export GNUCAP_PLUGPATH=${gnucap}/lib/gnucap
        for plugin in ${builtins.concatStringsSep " " selectedPlugins}; do
          export GNUCAP_PLUGPATH=$plugin/lib/gnucap:$GNUCAP_PLUGPATH
        done
        ${lib.getExe gnucap}
      '';
    in
    stdenv.mkDerivation {
      pname = "gnucap-with-plugins";
      inherit version;

      propagatedBuildInputs = selectedPlugins;

      dontUnpack = true;

      installPhase = ''
        mkdir -p $out/bin
        cp ${wrapper} $out/bin/gnucap
      '';

      inherit meta;
    };
}
