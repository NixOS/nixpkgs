{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  ruby,
  inkscape,
  xorg,
  writeText,
  cursorsConf ? null, # If set to a string, overwrites contents of './cursors.conf'
}:
let
  newCursorsConf = writeText "oreo-cursors-plus.conf" cursorsConf;
in
stdenvNoCC.mkDerivation {
  pname = "oreo-cursors-plus";
  version = "unstable-2023-06-05";
  src = fetchFromGitHub {
    owner = "Souravgoswami";
    repo = "oreo-cursors";
    # At the time of writing, there are no version tags. The author will add them starting with the next version release.
    # Using the latest commit instead.
    rev = "9133204d60ca2c54be0df03b836968a1deac6b20";
    hash = "sha256-6oTyOQK7mkr+jWYbPNBlJ4BpT815lNJvsJjzdTmj+68=";
  };

  nativeBuildInputs = lib.optionals (cursorsConf != null) [ ruby inkscape xorg.xcursorgen ];

  # './cursors.conf' contains definitions of cursor variations to generate.
  configurePhase = ''
    runHook preConfigure

    ${lib.optionalString (cursorsConf != null) ''
      cp ${newCursorsConf} cursors.conf
    ''}

    runHook postConfigure
  '';

  # The repo already contains the default cursors pre-generated in './dist'. Just copy these if './cursors.conf' is not overwritten.
  # Otherwise firs remove all default variations and build.
  buildPhase =''
      runHook preBuild

      ${lib.optionalString (cursorsConf != null) ''
        rm -r {dist,src/oreo_*}
        export HOME=$TMP
        ruby generator/convert.rb
        make build
      ''}

      runHook postBuild
    '';

  installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv ./dist $out/share/icons

      runHook postInstall
    '';

  meta = {
    description = "Colored Material cursors with cute animations";
    homepage = "https://github.com/Souravgoswami/oreo-cursors";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [michaelBrunner];
  };
}
