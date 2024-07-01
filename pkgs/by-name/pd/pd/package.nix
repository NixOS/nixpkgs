{ romID ? "ntsc-final"

, lib

, fetchFromGitHub
, stdenv_32bit

, pkgsi686Linux # SDL2 and zlib

, pkg-config
, python3
}: let
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
  pname = "pd";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    rev = "b523b1e076158223ff5f07a843522a7898eabb91";
    hash = "sha256-GGmmjwIXsxa1yQgXQEQe0C8RWFd5+Jx6BWrXosqIkOQ=";
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
    "GCC_OPT_LVL=" # "-Og" is explicitly set as default in pd, we remove it to use stdenv's settings instead (defaults to "-O2")
  ];

  makefile = "Makefile.port";

  preBuild = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv build/${romID}-port/${binName}.exe $out/bin/${binName}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/fgsfdsfgs/perfect_dark";
    description = "A PC port of Perfect Dark based on the decompilation of the Nintendo 64 game (${romID})";
    longDescription = ''
      A PC port of Perfect Dark based on the decompilation of the Nintendo 64 game (${romID}).

      You'll need to provide a copy of the ROM at $HOME/.local/share/perfectdark/data/pd.${romID}.z64 to launch to game.

      You can also change the ROM variant of this game with an expression like this:

      `pd.override { romID = "jpn-final" }`

      Supported romIDs are `${lib.generators.toPretty {} roms}`.

      `ntsc-final` the default as it is the only recommended one by upstream.
    '';
    mainProgram = binName;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with lib.maintainers; [ PaulGrandperrin ];
    license = with lib.licenses; [
      # pd, khrplatform.h, port/fast3d
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
