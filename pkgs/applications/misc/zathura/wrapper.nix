{ symlinkJoin, lib, makeWrapper, zathura_core, plugins ? [] }:

let
  pluginsPath = lib.makeLibraryPath plugins;

in symlinkJoin {
  name = "zathura-with-plugins-${zathura_core.version}";

  paths = [ zathura_core ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/zathura \
      --add-flags --plugins-dir=${pluginsPath}
  '';

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A highly customizable and functional PDF viewer";
    longDescription = ''
      Zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the gtk+ toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers;[ garbas smironov ];
  };
}
