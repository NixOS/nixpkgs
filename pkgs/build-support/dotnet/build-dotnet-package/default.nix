{
  stdenv,
  lib,
  makeWrapper,
  pkg-config,
  mono,
  dotnetbuildhelpers,
}:

attrsOrig@{
  pname,
  version,
  nativeBuildInputs ? [ ],
  xBuildFiles ? [ ],
  xBuildFlags ? [ "/p:Configuration=Release" ],
  outputFiles ? [ "bin/Release/*" ],
  dllFiles ? [ "*.dll" ],
  exeFiles ? [ "*.exe" ],
  # Additional arguments to pass to the makeWrapper function, which wraps
  # generated binaries.
  makeWrapperArgs ? [ ],
  ...
}:
let
  arrayToShell = (a: toString (map (lib.escape (lib.stringToCharacters "\\ ';$`()|<>\t")) a));

  attrs = {
    inherit pname version;

    nativeBuildInputs = [
      pkg-config
      makeWrapper
      dotnetbuildhelpers
      mono
    ] ++ nativeBuildInputs;

    configurePhase = ''
      runHook preConfigure

      [ -z "''${dontPlacateNuget-}" ] && placate-nuget.sh
      [ -z "''${dontPlacatePaket-}" ] && placate-paket.sh
      [ -z "''${dontPatchFSharpTargets-}" ] && patch-fsharp-targets.sh

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      echo Building dotNET packages...

      # Probably needs to be moved to fsharp
      if pkg-config FSharp.Core
      then
        export FSharpTargetsPath="$(dirname $(pkg-config FSharp.Core --variable=Libraries))/Microsoft.FSharp.Targets"
      fi

      ran=""
      for xBuildFile in ${arrayToShell xBuildFiles} ''${xBuildFilesExtra}
      do
        ran="yes"
        xbuild ${arrayToShell xBuildFlags} ''${xBuildFlagsArray} $xBuildFile
      done

      [ -z "$ran" ] && xbuild ${arrayToShell xBuildFlags} ''${xBuildFlagsArray}

      runHook postBuild
    '';

    dontStrip = true;

    installPhase = ''
      runHook preInstall

      target="$out/lib/dotnet/${pname}"
      mkdir -p "$target"

      cp -rv ${arrayToShell outputFiles} "''${outputFilesArray[@]}" "$target"

      if [ -z "''${dontRemoveDuplicatedDlls-}" ]
      then
        pushd "$out"
        remove-duplicated-dlls.sh
        popd
      fi

      set -f
      for dllPattern in ${arrayToShell dllFiles} ''${dllFilesArray[@]}
      do
        set +f
        for dll in "$target"/$dllPattern
        do
          [ -f "$dll" ] || continue
          if pkg-config $(basename -s .dll "$dll")
          then
            echo "$dll already exported by a buildInputs, not re-exporting"
          else
            create-pkg-config-for-dll.sh "$out/lib/pkgconfig" "$dll"
          fi
        done
      done

      set -f
      for exePattern in ${arrayToShell exeFiles} ''${exeFilesArray[@]}
      do
        set +f
        for exe in "$target"/$exePattern
        do
          [ -f "$exe" ] || continue
          mkdir -p "$out"/bin
          commandName="$(basename -s .exe "$(echo "$exe" | tr "[A-Z]" "[a-z]")")"
          makeWrapper \
            "${mono}/bin/mono" \
            "$out"/bin/"$commandName" \
            --add-flags "\"$exe\"" \
            ''${makeWrapperArgs}
        done
      done

      runHook postInstall
    '';
  };
in
stdenv.mkDerivation (attrs // (builtins.removeAttrs attrsOrig [ "nativeBuildInputs" ]))
