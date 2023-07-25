{ lib, stdenv, fetchFromGitHub, mono, gtk-sharp-2_0, pkg-config, makeWrapper, gnome2, gtk2 }:
stdenv.mkDerivation {
  version = "unstable-2014-08-20";
  pname = "supertux-editor";

  src = fetchFromGitHub {
    owner = "SuperTux";
    repo = "supertux-editor";
    rev = "0c666e8ccc7daf9e9720fe79abd63f8fa979c5e5";
    sha256 = "08y5haclgxvcii3hpdvn1ah8qd0f3n8xgxxs8zryj02b8n7cz3vx";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ mono gtk-sharp-2_0 gnome2.libglade gtk2 ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/supertux-editor
    cp *.{dll,dll.config,exe} $out/lib/supertux-editor
    makeWrapper "${mono}/bin/mono" $out/bin/supertux-editor \
      --add-flags "$out/lib/supertux-editor/supertux-editor.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --suffix LD_LIBRARY_PATH : $(echo $NIX_LDFLAGS | sed 's/ -L/:/g;s/ -rpath /:/g;s/-rpath //')

    makeWrapper "${mono}/bin/mono" $out/bin/supertux-editor-debug \
      --add-flags "--debug $out/lib/supertux-editor/supertux-editor.exe" \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --suffix LD_LIBRARY_PATH : $(echo $NIX_LDFLAGS | sed 's/ -L/:/g;s/ -rpath /:/g;s/-rpath //')
  '';

  # Always needed on Mono, otherwise nothing runs
  dontStrip = true;

  meta = with lib; {
    description = "Level editor for SuperTux";
    homepage = "https://github.com/SuperTux/supertux-editor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    broken = true;
  };
}
