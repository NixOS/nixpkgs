{ stdenv, fetchFromGitHub, mono, gtk-sharp, pkgconfig, makeWrapper, gnome, gtk }:
stdenv.mkDerivation rec {
  version = "git-2014-08-20";
  name = "supertux-editor-${version}";

  src = fetchFromGitHub {
    owner = "SuperTux";
    repo = "supertux-editor";
    rev = "0c666e8ccc7daf9e9720fe79abd63f8fa979c5e5";
    sha256 = "08y5haclgxvcii3hpdvn1ah8qd0f3n8xgxxs8zryj02b8n7cz3vx";
  };

  buildInputs = [mono gtk-sharp pkgconfig makeWrapper gnome.libglade gtk ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/supertux-editor
    cp *.{dll,dll.config,exe} $out/lib/supertux-editor
    makeWrapper "${mono}/bin/mono" $out/bin/supertux-editor \
      --add-flags "$out/lib/supertux-editor/supertux-editor.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp} \
      --suffix LD_LIBRARY_PATH : $(echo $NIX_LDFLAGS | sed 's/ -L/:/g;s/ -rpath /:/g;s/-rpath //')

    makeWrapper "${mono}/bin/mono" $out/bin/supertux-editor-debug \
      --add-flags "--debug $out/lib/supertux-editor/supertux-editor.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp} \
      --suffix LD_LIBRARY_PATH : $(echo $NIX_LDFLAGS | sed 's/ -L/:/g;s/ -rpath /:/g;s/-rpath //')
  '';

  # Always needed on Mono, otherwise nothing runs
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Level editor for SuperTux";
    homepage = https://github.com/SuperTux/supertux-editor;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = platforms.linux;
  };
}
