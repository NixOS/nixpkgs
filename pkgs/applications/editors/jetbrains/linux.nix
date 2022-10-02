{ stdenv, lib, makeDesktopItem, makeWrapper, patchelf, writeText
, coreutils, gnugrep, which, git, unzip, libsecret, libnotify, e2fsprogs
, vmopts ? null
}:

{ pname, product, productShort ? product, version, src, wmClass, jdk, meta, extraLdPath ? [], extraWrapperArgs ? [] }@args:

with lib;

let loName = toLower productShort;
    hiName = toUpper productShort;
    vmoptsName = loName
               + lib.optionalString stdenv.hostPlatform.is64bit "64"
               + ".vmoptions";
in

with stdenv; lib.makeOverridable mkDerivation (rec {
  inherit pname version src;
  meta = args.meta // { mainProgram = pname; };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    comment = lib.replaceChars ["\n"] [" "] meta.longDescription;
    desktopName = product;
    genericName = meta.description;
    categories = [ "Development" ];
    icon = pname;
    startupWMClass = wmClass;
  };

  vmoptsFile = optionalString (vmopts != null) (writeText vmoptsName vmopts);

  nativeBuildInputs = [ makeWrapper patchelf unzip ];

  postPatch = ''
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

      interpreter=$(echo ${stdenv.cc.libc}/lib/ld-linux*.so.2)
      if [[ "${stdenv.hostPlatform.system}" == "x86_64-linux" && -e bin/fsnotifier64 ]]; then
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
    runHook preInstall

    mkdir -p $out/{bin,$pname,share/pixmaps,libexec/${pname}}
    cp -a . $out/$pname
    ln -s $out/$pname/bin/${loName}.png $out/share/pixmaps/${pname}.png
    mv bin/fsnotifier* $out/libexec/${pname}/.

    jdk=${jdk.home}
    item=${desktopItem}

    makeWrapper "$out/$pname/bin/${loName}.sh" "$out/bin/${pname}" \
      --prefix PATH : "$out/libexec/${pname}:${lib.makeBinPath [ jdk coreutils gnugrep which git ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath ([
        # Some internals want libstdc++.so.6
        stdenv.cc.cc.lib libsecret e2fsprogs
        libnotify
      ] ++ extraLdPath)}" \
      ${lib.concatStringsSep " " extraWrapperArgs} \
      --set-default JDK_HOME "$jdk" \
      --set-default ANDROID_JAVA_HOME "$jdk" \
      --set-default JAVA_HOME "$jdk" \
      --set ${hiName}_JDK "$jdk" \
      --set ${hiName}_VM_OPTIONS ${vmoptsFile}

    ln -s "$item/share/applications" $out/share

    runHook postInstall
  '';

} // lib.optionalAttrs (!(meta.license.free or true)) {
  preferLocalBuild = true;
})
