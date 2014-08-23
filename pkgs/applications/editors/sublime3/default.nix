{ fetchurl, stdenv, glib, xlibs, cairo, gtk, pango, makeWrapper}:

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let
  build = "3059";
  libPath = stdenv.lib.makeLibraryPath [glib xlibs.libX11 gtk cairo pango];
in let
  # package with just the binaries
  sublime = stdenv.mkDerivation {
    name = "sublimetext3-${build}-bin";

    src =
      if stdenv.system == "i686-linux" then
        fetchurl {
          name = "sublimetext-3.0.59.tar.bz2";
          url = "http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_${build}_x32.tar.bz2";
          sha256 = "5ee7b42b5db057108e97b86fd408124fc3f7b56662b2851f59d91f8f0c288088";
        }
      else
        fetchurl {
          name = "sublimetext-3.0.59.tar.bz2";
          url = "http://c758482.r82.cf2.rackcdn.com/sublime_text_3_build_${build}_x64.tar.bz2";
          sha256 = "da3039687664d33a734cea0151b2291ece9c7f35e5b73df5b2b5eac28a20b972";
        };

    dontStrip = true;
    dontPatchELF = true;
    buildInputs = [ makeWrapper ];

    buildPhase = ''
      for i in sublime_text plugin_host crash_reporter; do
        patchelf \
          --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
          --set-rpath ${libPath}:${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"} \
          $i
      done
    '';

    installPhase = ''
      mkdir -p $out
      cp -prvd * $out/
      # Without this, plugin_host crashes, even though it has the rpath
      wrapProgram $out/plugin_host --prefix LD_PRELOAD : ${stdenv.gcc.gcc}/lib${stdenv.lib.optionalString stdenv.is64bit "64"}/libgcc_s.so.1
    '';
  };
in stdenv.mkDerivation {
  name = "sublimetext3-${build}";

  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${sublime}/sublime_text $out/bin/sublime
    ln -s ${sublime}/sublime_text $out/bin/sublime3
  '';

  meta = {
    description = "Sophisticated text editor for code, markup and prose";
    maintainers = stdenv.lib.maintainers.wmertens;
    license = stdenv.lib.licenses.unfree;
  };
}
