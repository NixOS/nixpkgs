{
  lib,
  makeBinaryWrapper,
  makeDesktopItem,
  requireFile,
  sdl2-compat,
  stdenv,
  unzip,
  wget,
}:
let
  pname = "pico-8";
  version = "0.2.7";

  src = requireFile rec {
    name = "${pname}_${version}_amd64.zip";
    hash = "sha256-7fLOhUdAWFsPmIhO4J1j+auObIdy4BSKkCkntkCMnqo=";
    message = ''
      PICO-8 cannot be installed automatically since it requires a license.
      The archive has to be loaded into the Nix Store manually.
      In the email from lexaloffle, you should have a link to take you a page to download the application.

      Example: https://www.lexaloffle.com/games.php?page=my&key=abcdefghijklm

      Note you can also find specific versions at:
       - https://www.lexaloffle.com/games.php?page=archive (requires login)

      1. Visit the download page
      2. Download the Linux 64-bit archive
      3. Navigate to the downloaded file and run the following command
         nix-prefetch-url file://$PWD/${name}
      4. Re-run the installation
    '';
  };

in
stdenv.mkDerivation (finalAttrs: rec {
  inherit pname version src;

  desktopItem = makeDesktopItem {
    name = "${pname}";
    desktopName = "PICO-8";
    comment = "Fantasy Console";
    icon = "${pname}";
    exec = meta.mainProgram;
    categories = [ "Development" ];
  };

  unpackPhase = ''
    runHook preUnpack

    unzip $src

    runHook postUnpack
  '';

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    makeBinaryWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    cd pico-8

    patchelf \
      --add-needed ${sdl2-compat}/lib/libSDL2-2.0.so.0 \
      --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
      pico8

    install -D -m 755 pico8 $out/bin/pico8
    makeBinaryWrapper $out/bin/pico8 $out/bin/pico8-wrapped \
      --prefix PATH : ${wget}/bin

    install -D -m 664 pico8.dat $out/bin/pico8.dat
    install -D -m 444 pico-8_manual.txt $out/share/doc/${pname}/manual.txt
    install -D -m 444 license.txt $out/share/doc/${pname}/license/license.txt
    install -D -m 444 lexaloffle-pico8.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    install -D -m 444 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Fantasy console for making, sharing and playing tiny games and other computer programs.";
    homepage = "https://pico-8.com";
    license = lib.licenses.unfree;
    mainProgram = "pico8-wrapped";
    maintainers = [ lib.maintainers.husjon ];
    platforms = [
      "x86_64-linux"
    ];
  };
})
