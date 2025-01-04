{
  lib,
  stdenv,
  fetchurl,
  readline,
  termcap,
  gnucap,
  callPackage,
  writeScript,
}:

let
  version = "20240130-dev";
  meta = with lib; {
    description = "Gnu Circuit Analysis Package";
    longDescription = ''
      Gnucap is a modern general purpose circuit simulator with several advantages over Spice derivatives.
      It performs nonlinear dc and transient analyses, fourier analysis, and ac analysis.
    '';
    homepage = "http://www.gnucap.org/";
    changelog = "https://git.savannah.gnu.org/cgit/gnucap.git/plain/NEWS?h=v${version}";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # Relies on LD_LIBRARY_PATH
    maintainers = [ maintainers.raboof ];
    mainProgram = "gnucap";
  };
in
stdenv.mkDerivation rec {
  pname = "gnucap";
  inherit version;

  src = fetchurl {
    url = "https://git.savannah.gnu.org/cgit/gnucap.git/snapshot/gnucap-${version}.tar.gz";
    hash = "sha256-MUCtGw3BxGWgXgUwzklq5T1y9kjBTnFBa0/GK0hhl0E=";
  };

  buildInputs = [
    readline
    termcap
  ];

  doCheck = true;

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
