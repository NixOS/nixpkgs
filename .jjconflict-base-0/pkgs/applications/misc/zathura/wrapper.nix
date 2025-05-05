{
  symlinkJoin,
  lib,
  makeWrapper,
  zathura_core,
  zathura_djvu,
  zathura_ps,
  zathura_cb,
  zathura_pdf_mupdf,
  zathura_pdf_poppler,
  file,
  useMupdf,
  plugins ? [
    zathura_djvu
    zathura_ps
    zathura_cb
    (if useMupdf then zathura_pdf_mupdf else zathura_pdf_poppler)
  ],
  stdenv,
}:
symlinkJoin {
  inherit (zathura_core) version;
  pname = "zathura-with-plugins";

  paths =
    with zathura_core;
    [
      man
      dev
      out
    ]
    ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild =
    let
      fishCompletion = "share/fish/vendor_completions.d/zathura.fish";
    in
    (lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper ${zathura_core.bin}/bin/zathura-sandbox $out/bin/zathura-sandbox \
        --prefix PATH ":" "${lib.makeBinPath [ file ]}" \
        --prefix ZATHURA_PLUGINS_PATH : "$out/lib/zathura"
    '')
    + ''
      makeWrapper ${zathura_core.bin}/bin/zathura $out/bin/zathura \
        --prefix PATH ":" "${lib.makeBinPath [ file ]}" \
        --prefix ZATHURA_PLUGINS_PATH : "$out/lib/zathura"

      # zathura fish completion references the zathura_core derivation to
      # check for supported plugins which live in the wrapper derivation,
      # so we need to fix the path to reference $out instead.
      rm "$out/${fishCompletion}"
      substitute "${zathura_core.out}/${fishCompletion}" "$out/${fishCompletion}" \
        --replace-fail "${zathura_core.out}" "$out"
    '';

  meta = {
    homepage = "https://pwmt.org/projects/zathura";
    description = "Highly customizable and functional PDF viewer";
    longDescription = ''
      Zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the GTK toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      smironov
      globin
      TethysSvensson
    ];
    mainProgram = "zathura";
  };
}
