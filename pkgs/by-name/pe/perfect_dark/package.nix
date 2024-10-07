{
  romID ? "ntsc-final",

  lib,

  fetchFromGitHub,
  stdenv_32bit,

  pkgsi686Linux, # SDL2 and zlib

  pkg-config,
  python3,
}:
let
  roms = {
    "ntsc-final" = {
      binName = "pd";
    };
    "pal-final" = {
      binName = "pd.pal";
    };
    "jpn-final" = {
      binName = "pd.jpn";
    };
  };
  binName = roms.${romID}.binName;
in
assert lib.assertOneOf "romID" romID (builtins.attrNames roms);

stdenv_32bit.mkDerivation rec {
  pname = "perfect_dark";
  version = "0-unstable-2024-09-02";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    rev = "2a5c3a351eeb1772306567969fb8dc5b31eaf34e";
    hash = "sha256-tpAzpIe2NYUtIY3NsvGl9liOuNb4YQCcfs+oLkFpFQA=";
  };

  buildInputs = with pkgsi686Linux; [
    SDL2
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  # the project uses git to retrieve version informations but our fetcher deletes the .git
  # so we replace the commands with the correct data directly
  postPatch = ''
    substituteInPlace Makefile.port \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${builtins.substring 0 9 src.rev}' \
      --replace-fail 'git rev-parse --abbrev-ref HEAD' 'echo port'
  '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ]; # otherwise fails to build
  hardeningEnable = [ "pie" ];

  makeFlags = [
    "TARGET_PLATFORM=i686-linux" # the project is 32-bit only for now
    "ROMID=${romID}"
    "GCC_OPT_LVL=" # "-Og" is explicitly set as default in perfect_dark, we remove it to use stdenv's settings instead (defaults to "-O2")
  ];

  makefile = "Makefile.port";

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 build/${romID}-port/${binName}.exe $out/bin/${binName}

    install -Dm 644 dist/linux/*.desktop -t $out/share/applications/
    install -Dm 644 dist/linux/*.png -t $out/share/pixmaps/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/fgsfdsfgs/perfect_dark/";
    description = "Modern cross-platform port of Perfect Dark";
    longDescription = ''
      This is a port of Ryan Dywer's decompilation of classic N64 shooter Perfect Dark to modern systems.

      You'll need to provide a copy of the ROM at $HOME/.local/share/perfectdark/data/pd.${romID}.z64 to launch to game.

      You can also change the ROM variant of this game with an expression like this:

      `pd.override { romID = "jpn-final" }`

      Supported romIDs are `${lib.generators.toPretty { } roms}`.

      `ntsc-final` the default as it is the only recommended one by upstream.
    '';
    mainProgram = binName;
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ PaulGrandperrin ];
    license = with lib.licenses; [
      # perfect_dark, khrplatform.h, port/fast3d
      mit
      # tools/mkrom/gzip
      gpl3Plus
      # the project's original work is licensed under MIT
      # but a lot of it can be seen as a derivative work of an unfree piece of software
      # we account for that here
      unfree
    ];
  };
}
