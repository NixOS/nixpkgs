{
  lib,
  stdenv,
  runtimeShell,
  fetchurl,
  unzip,
  mono,
  avrdude,
  gtk2,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avrdudess";
  version = "2.19";

  src = fetchurl {
    url = "https://github.com/ZakKemble/AVRDUDESS/releases/download/v${finalAttrs.version}/AVRDUDESS-${finalAttrs.version}-portable.zip";
    hash = "sha256-CXwwbg2hEMzt30j6AO7+v/8WfRsHzNhDgLc9W8/CQzI=";
  };

  nativeBuildInputs = [ unzip ];

  dontUnpack = true;
  dontInstall = true;

  buildPhase = ''
    runHook preBuild

    mkdir -p "$out/avrdudess"
    mkdir -p "$out/bin"

    unzip "$src" -d "$out/avrdudess"

    cat >> "$out/bin/avrdudess" << __EOF__
    #!${runtimeShell}
    export LD_LIBRARY_PATH="${
      lib.makeLibraryPath [
        gtk2
        mono
      ]
    }"
    # We need PATH from user env for xdg-open to find its tools, which
    # typically depend on the currently running desktop environment.
    export PATH="\$PATH:${
      lib.makeBinPath [
        avrdude
        xdg-utils
      ]
    }"

    # avrdudess must have its resource files in its current working directory
    cd $out/avrdudess && exec ${mono}/bin/mono "$out/avrdudess/avrdudess.exe" "\$@"
    __EOF__

    chmod a+x "$out/bin/"*

    runHook postBuild
  '';

  meta = {
    description = "GUI for AVRDUDE (AVR microcontroller programmer)";
    homepage = "https://blog.zakkemble.net/avrdudess-a-gui-for-avrdude/";
    changelog = "https://github.com/ZakKemble/AVRDUDESS/blob/v${finalAttrs.version}/Changelog.txt";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "avrdudess";
  };
})
