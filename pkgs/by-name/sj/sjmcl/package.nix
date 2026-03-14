{
  lib,
  symlinkJoin,
  makeWrapper,
  sjmcl-unwrapped,
  desktop-file-utils,
  hicolor-icon-theme,
  jdks ? [ jdk ],
  jdk,
}:
let
  sjmcl' = sjmcl-unwrapped;
in
symlinkJoin {
  pname = "sjmcl";
  inherit (sjmcl') version;

  paths = [
    sjmcl'
    hicolor-icon-theme
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    desktop-file-utils
    hicolor-icon-theme
  ];

  postBuild = ''
    wrapProgram $out/bin/SJMCL \
      --prefix PATH : "${lib.makeBinPath ([ desktop-file-utils ] ++ jdks)}"
  '';

  meta = {
    inherit (sjmcl'.meta)
      description
      longDescription
      homepage
      changelog
      license
      maintainers
      mainProgram
      platforms
      ;
  };
}
