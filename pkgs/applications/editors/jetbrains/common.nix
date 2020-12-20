{ stdenv, lib, makeDesktopItem, makeWrapper, patchelf, writeText
, coreutils, gnugrep, which, git, unzip, libsecret, libnotify
, vmopts ? null
}:

{ name, product, version, src, wmClass, jdk, meta }:

with stdenv.lib;

let loName = toLower product;
    hiName = toUpper product;
    execName = concatStringsSep "-" (init (splitString "-" name));
    vmoptsName = loName
               + ( if (with stdenv.hostPlatform; (is32bit || isDarwin))
                   then ""
                   else "64" )
               + ".vmoptions";
in

with stdenv; lib.makeOverridable mkDerivation rec {
  inherit name src meta;
  desktopItem = makeDesktopItem {
    name = execName;
    exec = execName;
    comment = lib.replaceChars ["\n"] [" "] meta.longDescription;
    desktopName = product;
    genericName = meta.description;
    categories = "Development;";
    icon = execName;
    extraEntries = ''
      StartupWMClass=${wmClass}
    '';
  };

  vmoptsFile = optionalString (vmopts != null) (writeText vmoptsName vmopts);

  nativeBuildInputs = [ makeWrapper patchelf unzip ];

  patchPhase = lib.optionalString (!stdenv.isDarwin) ''
      get_file_size() {
        local fname="$1"
        echo $(ls -l $fname | cut -d ' ' -f5)
      }

      munge_size_hack() {
        local fname="$1"
        local size="$2"
        strip $fname
        truncate --size=$size $fname
      }

      interpreter=$(echo ${stdenv.glibc.out}/lib/ld-linux*.so.2)
      if [ "${stdenv.hostPlatform.system}" == "x86_64-linux" ]; then
        target_size=$(get_file_size bin/fsnotifier64)
        patchelf --set-interpreter "$interpreter" bin/fsnotifier64
        munge_size_hack bin/fsnotifier64 $target_size
      else
        target_size=$(get_file_size bin/fsnotifier)
        patchelf --set-interpreter "$interpreter" bin/fsnotifier
        munge_size_hack bin/fsnotifier $target_size
      fi
  '';

  installPhase = ''
    mkdir -p $out/{bin,$name,share/pixmaps,libexec/${name}}
    cp -a . $out/$name
    ln -s $out/$name/bin/${loName}.png $out/share/pixmaps/${execName}.png
    mv bin/fsnotifier* $out/libexec/${name}/.

    jdk=${jdk.home}
    item=${desktopItem}

    makeWrapper "$out/$name/bin/${loName}.sh" "$out/bin/${execName}" \
      --prefix PATH : "$out/libexec/${name}:${lib.optionalString (stdenv.isDarwin) "${jdk}/jdk/Contents/Home/bin:"}${stdenv.lib.makeBinPath [ jdk coreutils gnugrep which git ]}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [
        # Some internals want libstdc++.so.6
        stdenv.cc.cc.lib libsecret
        libnotify
      ]}" \
      --set JDK_HOME "$jdk" \
      --set ${hiName}_JDK "$jdk" \
      --set ANDROID_JAVA_HOME "$jdk" \
      --set JAVA_HOME "$jdk" \
      --set ${hiName}_VM_OPTIONS ${vmoptsFile}

    ln -s "$item/share/applications" $out/share
  '';

} // stdenv.lib.optionalAttrs (!(meta.license.free or true)) {
  preferLocalBuild = true;
}
