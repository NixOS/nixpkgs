{ stdenv_32bit, lib, pkgs, pkgsi686Linux, pkgsCross, callPackage, substituteAll, moltenvk,
  wineRelease ? "stable",
  supportFlags
}:

let
  src = lib.getAttr wineRelease (callPackage ./sources.nix {});
in with src; {
  wine32 = pkgsi686Linux.callPackage ./base.nix {
    pname = "wine";
    inherit src version supportFlags patches moltenvk wineRelease;
    pkgArches = [ pkgsi686Linux ];
    geckos = [ gecko32 ];
    mingwGccs = with pkgsCross; [ mingw32.buildPackages.gcc ];
    monos =  [ mono ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
  wine64 = callPackage ./base.nix {
    pname = "wine64";
    inherit src version supportFlags patches moltenvk wineRelease;
    pkgArches = [ pkgs ];
    mingwGccs = with pkgsCross; [ mingwW64.buildPackages.gcc ];
    geckos = [ gecko64 ];
    monos =  [ mono ];
    configureFlags = [ "--enable-win64" ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "wine64";
  };
  wineWow = callPackage ./base.nix {
    pname = "wine-wow";
    inherit src version supportFlags patches moltenvk wineRelease;
    stdenv = stdenv_32bit;
    pkgArches = [ pkgs pkgsi686Linux ];
    geckos = [ gecko32 gecko64 ];
    mingwGccs = with pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
    monos =  [ mono ];
    buildScript = substituteAll {
        src = ./builder-wow.sh;
        # pkgconfig has trouble picking the right architecture
        pkgconfig64remove = lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ pkgs.glib pkgs.gst_all_1.gstreamer ];
      };
    platforms = [ "x86_64-linux" ];
    mainProgram = "wine64";
  };
  wineWow64 = callPackage ./base.nix {
    pname = "wine-wow64";
    inherit src version patches moltenvk wineRelease;
    supportFlags = supportFlags // { mingwSupport = true; };  # Required because we request "--enable-archs=x86_64"
    pkgArches = [ pkgs ];
    mingwGccs = with pkgsCross; [ mingw32.buildPackages.gcc mingwW64.buildPackages.gcc ];
    geckos = [ gecko64 ];
    monos =  [ mono ];
    configureFlags = [ "--enable-archs=x86_64,i386" ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "wine";
  };
}
