{ symlinkJoin, lib, makeWrapper, zathura_core, plugins ? [] }:
symlinkJoin {
  name = "zathura-with-plugins-${zathura_core.version}";

  paths = [ zathura_core ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/zathura --add-flags --plugins-dir="''${out}/lib/zathura"
  '';

  meta = with lib; {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A highly customizable and functional PDF viewer";
    longDescription = ''
      Zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the gtk+ toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers;[ garbas smironov ];
  };
}
