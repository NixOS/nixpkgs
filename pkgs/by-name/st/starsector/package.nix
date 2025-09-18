{
  lib,
  fetchzip,
  libGL,
  makeWrapper,
  openal,
  openjdk17,
  stdenv,
  xorg,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}:
let
  openjdk = openjdk17;
in
stdenv.mkDerivation rec {
  pname = "starsector";
  version = "0.98a-RC8";

  src = fetchzip {
    url = "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-${version}.zip";
    sha256 = "sha256-W/6QpgKbUJC+jWOlAOEEGStee5KJuLi020kRtPQXK3U=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    xorg.libXxf86vm
    openal
    libGL
  ];

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "starsector";
      exec = "starsector";
      icon = "starsector";
      comment = meta.description;
      genericName = "starsector";
      desktopName = "Starsector";
      categories = [ "Game" ];
    })
  ];

  # need to cd into $out in order for classpath to pick up correct jar files
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/starsector
    rm -r jre_linux # remove bundled jre7
    rm starfarer.api.zip
    cp -r ./* $out/share/starsector

    mkdir -p $out/share/icons/hicolor/64x64/apps
    ln -s $out/share/starsector/graphics/ui/s_icon64.png \
      $out/share/icons/hicolor/64x64/apps/starsector.png

    wrapProgram $out/share/starsector/starsector.sh \
      --prefix PATH : ${
        lib.makeBinPath [
          openjdk
          xorg.xrandr
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector' \
      --chdir "$out/share/starsector"
    ln -s $out/share/starsector/starsector.sh $out/bin/starsector

    runHook postInstall
  '';

  # it tries to run everything with relative paths, which makes it CWD dependent
  # also point mod, screenshot, and save directory to $XDG_DATA_HOME
  # additionally, add some GC options to improve performance of the game,
  # remove flags "PermSize" and "MaxPermSize" that were removed with Java 8 and
  # pass-through CLI args ($@) to the JVM.
  postPatch = ''
    substituteInPlace starsector.sh \
      --replace-fail "./jre_linux/bin/java" "${lib.getExe openjdk}" \
      --replace-fail "./native/linux" "$out/share/starsector/native/linux" \
      --replace-fail "./compiler_directives.txt" "$out/share/starsector/compiler_directives.txt" \
      --replace-fail "=." "=\''${XDG_DATA_HOME:-\$HOME/.local/share}/starsector" \
      --replace-fail "com.fs.starfarer.StarfarerLauncher" "\"\$@\" com.fs.starfarer.StarfarerLauncher"
  '';

  passthru.updateScript = writeScript "starsector-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnugrep common-updater-scripts
    set -eou pipefail;
    version=$(curl -s https://fractalsoftworks.com/preorder/ | grep -oP "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-\K.*?(?=\.zip)" | head -1)
    update-source-version ${pname} "$version" --file=./pkgs/by-name/st/starsector/package.nix
  '';

  meta = with lib; {
    description = "Open-world single-player space-combat, roleplaying, exploration, and economic game";
    homepage = "https://fractalsoftworks.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      bbigras
      rafaelrc
    ];
  };
}
