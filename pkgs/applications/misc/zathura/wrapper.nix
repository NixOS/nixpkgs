{ symlinkJoin, lib, makeWrapper, zathura_core, file, plugins ? [] }:
symlinkJoin {
  name = "zathura-with-plugins-${zathura_core.version}";

  paths = with zathura_core; [ man dev out ] ++ plugins;


  buildInputs = [ makeWrapper ];

  postBuild = ''
    makeWrapper ${zathura_core.bin}/bin/zathura $out/bin/zathura \
      --prefix PATH ":" "${lib.makeBinPath [ file ]}" \
      --add-flags --plugins-dir="$out/lib/zathura"
  '';

  meta = with lib; {
    homepage = "https://git.pwmt.org/pwmt/zathura/";
    description = "A highly customizable and functional PDF viewer";
    longDescription = ''
      Zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the GTK toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ smironov globin TethysSvensson ];
  };
}
