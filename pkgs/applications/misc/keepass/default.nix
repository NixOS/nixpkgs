{ stdenv, lib, fetchurl, buildDotnetPackage, makeWrapper, unzip, makeDesktopItem, icoutils, gtk2, plugins ? [] }:

# KeePass looks for plugins in under directory in which KeePass.exe is
# located. It follows symlinks where looking for that directory, so
# buildEnv is not enough to bring KeePass and plugins together.
#
# This derivation patches KeePass to search for plugins in specified
# plugin derivations in the Nix store and nowhere else.
with builtins; buildDotnetPackage rec {
  baseName = "keepass";
  version = "2.33";

  src = fetchurl {
    url = "mirror://sourceforge/keepass/KeePass-${version}-Source.zip";
    sha256 = "0n4rkx2awyq1gbqiby1lkf2zw82brji96s4fkjsahmci528a882i";
  };

  sourceRoot = ".";

  buildInputs = [ unzip makeWrapper icoutils ];

  pluginLoadPathsPatch =
    let outputLc = toString (add 8 (length plugins));
        patchTemplate = readFile ./keepass-plugins.patch;
        loadTemplate  = readFile ./keepass-plugins-load.patch;
        loads =
          lib.concatStrings
            (map
              (p: replaceStrings ["$PATH$"] [ (unsafeDiscardStringContext (toString p)) ] loadTemplate)
              plugins);
    in replaceStrings ["$OUTPUT_LC$" "$DO_LOADS$"] [outputLc loads] patchTemplate;

  passAsFile = [ "pluginLoadPathsPatch" ];
  postPatch = ''
    sed -i 's/\r*$//' KeePass/Forms/MainForm.cs
    patch -p1 <$pluginLoadPathsPatchPath
  '';

  preConfigure = ''
    rm -rvf Build/*
    find . -name "*.sln" -print -exec sed -i 's/Format Version 10.00/Format Version 11.00/g' {} \;
    find . -name "*.csproj" -print -exec sed -i '
      s#ToolsVersion="3.5"#ToolsVersion="4.0"#g
      s#<TargetFrameworkVersion>.*</TargetFrameworkVersion>##g
      s#<PropertyGroup>#<PropertyGroup><TargetFrameworkVersion>v4.5</TargetFrameworkVersion>#g
      s#<SignAssembly>.*$#<SignAssembly>false</SignAssembly>#g
      s#<PostBuildEvent>.*sgen.exe.*$##
    ' {} \;
  '';

  desktopItem = makeDesktopItem {
    name = "keepass";
    exec = "keepass";
    comment = "Password manager";
    icon = "keepass";
    desktopName = "Keepass";
    genericName = "Password manager";
    categories = "Application;Utility;";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "application/x-keepass2"
      ""
    ];
  };

  outputFiles = [ "Build/KeePass/Release/*" "Build/KeePassLib/Release/*" ];
  dllFiles = [ "KeePassLib.dll" ];
  exeFiles = [ "KeePass.exe" ];

  # plgx plugin like keefox requires mono to compile at runtime
  # after loading. It is brought into plugins bin/ directory using
  # buildEnv in the plugin derivation. Wrapper below makes sure it
  # is found and does not pollute output path.
  binPaths = lib.concatStrings (lib.intersperse ":" (map (x: x + "/bin") plugins));

  dynlibPath = stdenv.lib.makeLibraryPath [ gtk2 ];

  postInstall = 
  let
    extractFDeskIcons = ./extractWinRscIconsToStdFreeDesktopDir.sh;
  in
  ''
    mkdir -p "$out/share/applications"
    cp ${desktopItem}/share/applications/* $out/share/applications
    wrapProgram $out/bin/keepass \
      --prefix PATH : "$binPaths" \
      --prefix LD_LIBRARY_PATH : "$dynlibPath"

    ${extractFDeskIcons} \
      "./Translation/TrlUtil/Resources/KeePass.ico" \
      '[^\.]+_[0-9]+_([0-9]+x[0-9]+)x[0-9]+\.png' \
      '\1' \
      '([^\.]+).+' \
      'keepass' \
      "$out" \
      "./tmp"
  '';

  meta = {
    description = "GUI password manager with strong cryptography";
    homepage = http://www.keepass.info/;
    maintainers = with stdenv.lib.maintainers; [ amorsillo obadz jraygauthier ];
    platforms = with stdenv.lib.platforms; all;
    license = stdenv.lib.licenses.gpl2;
  };
}
