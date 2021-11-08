{ lib
, fetchFromGitHub
, buildDotnetPackage
, dotnetPackages
, gtksharp
, gettext
}:

let
  mono-addins = dotnetPackages.MonoAddins;
in
buildDotnetPackage rec {
  baseName = "Pinta";
  version = "1.6";

  outputFiles = [ "bin/*" ];
  buildInputs = [ gtksharp mono-addins gettext ];
  xBuildFiles = [ "Pinta.sln" ];

  src = fetchFromGitHub {
    owner = "PintaProject";
    repo = "Pinta";
    rev = version;
    sha256 = "0vgswy981c7ys4q7js5k85sky7bz8v32wsfq3br4j41vg92pw97d";
  };

  # Remove version information from nodes <Reference Include="... Version=... ">
  postPatch = with lib; let
    csprojFiles = [
      "Pinta/Pinta.csproj"
      "Pinta.Core/Pinta.Core.csproj"
      "Pinta.Effects/Pinta.Effects.csproj"
      "Pinta.Gui.Widgets/Pinta.Gui.Widgets.csproj"
      "Pinta.Resources/Pinta.Resources.csproj"
      "Pinta.Tools/Pinta.Tools.csproj"
    ];
    versionedNames = [
      "Mono\\.Addins"
      "Mono\\.Posix"
      "Mono\\.Addins\\.Gui"
      "Mono\\.Addins\\.Setup"
    ];

    stripVersion = name: file:
      let
        match = ''<Reference Include="${name}([ ,][^"]*)?"'';
        replace = ''<Reference Include="${name}"'';
      in
      "sed -i -re 's/${match}/${replace}/g' ${file}\n";

    # Map all possible pairs of two lists
    map2 = f: listA: listB: concatMap (a: map (f a) listB) listA;
    concatMap2Strings = f: listA: listB: concatStrings (map2 f listA listB);
  in
  concatMap2Strings stripVersion versionedNames csprojFiles
  + ''
    # For some reason there is no Microsoft.Common.tasks file
    # in ''${mono}/lib/mono/3.5 .
    substituteInPlace Pinta.Install.proj \
      --replace 'ToolsVersion="3.5"' 'ToolsVersion="4.0"' \
      --replace "/usr/local" "$out"
  '';

  makeWrapperArgs = [
    "--prefix MONO_GAC_PREFIX : ${gtksharp}"
    "--prefix LD_LIBRARY_PATH : ${gtksharp}/lib"
    "--prefix LD_LIBRARY_PATH : ${gtksharp.gtk.out}/lib"
  ];

  postInstall = ''
    # Do automake's job manually
    substitute xdg/pinta.desktop.in xdg/pinta.desktop \
      --replace _Name Name \
      --replace _Comment Comment \
      --replace _GenericName GenericName \
      --replace _X-GNOME-FullName X-GNOME-FullName

    xbuild /target:CompileTranslations Pinta.Install.proj
    xbuild /target:Install Pinta.Install.proj
  '';

  meta = {
    homepage = "https://www.pinta-project.com/";
    description = "Drawing/editing program modeled after Paint.NET";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
