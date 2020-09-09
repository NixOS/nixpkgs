{ runCommand, mono, pkgconfig }:
  runCommand
    "dotnetbuildhelpers"
    { preferLocalBuild = true; }
    ''
      target="$out/bin"
      mkdir -p "$target"

      for script in ${./create-pkg-config-for-dll.sh} ${./patch-fsharp-targets.sh} ${./remove-duplicated-dlls.sh} ${./placate-nuget.sh} ${./placate-paket.sh}
      do
        scriptName="$(basename "$script" | cut -f 2- -d -)"
        cp -v "$script" "$target"/"$scriptName"
        chmod 755 "$target"/"$scriptName"
        patchShebangs "$target"/"$scriptName"
        substituteInPlace "$target"/"$scriptName" --replace pkg-config ${pkgconfig}/bin/${pkgconfig.targetPrefix}pkg-config
        substituteInPlace "$target"/"$scriptName" --replace monodis ${mono}/bin/monodis
      done
    ''
