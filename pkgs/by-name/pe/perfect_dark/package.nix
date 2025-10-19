{
  lib,
  stdenv,
  fetchFromGitHub,
  sdl2-compat,
  cmake,
  libGL,
  pkg-config,
  python3,
  zlib,
  unstableGitUpdater,
  romID ? "ntsc-final",
}:
let
  roms = [
    "ntsc-final"
    "pal-final"
    "jpn-final"
  ];
in
assert lib.assertOneOf "romID" romID roms;

stdenv.mkDerivation (finalAttrs: {
  pname = "perfect_dark";
  version = "0-unstable-2025-10-08";

  src = fetchFromGitHub {
    owner = "fgsfdsfgs";
    repo = "perfect_dark";
    rev = "8ea7e7b4108882e066a6c67b9183615718bc27e6";
    hash = "sha256-cAT+exdt+kZZW1+ZNn1h81LdzwDck2QREy/aTUkCFrU=";

    postFetch = ''
      pushd $out
      rm tools/gzip
      rm -r tools/mkrom
      popd
    '';
  };

  enableParallelBuilding = true;

  # Fails to build if not set:
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    (lib.cmakeFeature "ROMID" romID)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    sdl2-compat
    libGL
    zlib
  ];

  postPatch =
    # The project uses Git to retrieve version informations but our
    # fetcher deletes the .git directory, so we replace the commands
    # with the correct data directly.
    ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "git rev-parse --short HEAD" \
                       "echo ${builtins.substring 0 9 finalAttrs.src.rev}" \
        --replace-fail "git rev-parse --abbrev-ref HEAD" \
                       "echo port"
    ''
    # Point toward the compiled binary and not the shell wrapper since
    # the rom auto-detection logic is not needed in this build.
    + ''
      substituteInPlace dist/linux/io.github.fgsfdsfgs.perfect_dark.desktop \
        --replace-fail "Exec=io.github.fgsfdsfgs.perfect_dark.sh" \
                       "Exec=io.github.fgsfdsfgs.perfect_dark"
    '';

  preConfigure = ''
    patchShebangs --build tools/assetmgr
  '';

  installPhase = ''
    runHook preInstall

    pushd ..
    install -Dm755 build/pd.* $out/bin/io.github.fgsfdsfgs.perfect_dark
    install -Dm644 dist/linux/io.github.fgsfdsfgs.perfect_dark.desktop \
            -t $out/share/applications
    install -Dm644 dist/linux/io.github.fgsfdsfgs.perfect_dark.png \
            -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 dist/linux/io.github.fgsfdsfgs.perfect_dark.metainfo.xml \
            -t $out/share/metainfo
    popd

    runHook postInstall
  '';

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    description = "Modern cross-platform port of Perfect Dark";
    longDescription = ''
      This is a port of Ryan Dywer's decompilation of classic N64
      shooter Perfect Dark to modern systems.

      You will need to provide a copy of the ROM at
      `$HOME/.local/share/perfectdark/data/pd.${romID}.z64` to launch
      the game.

      Though `ntsc-final` is the recommended default, you can change
      the ROM variant of this game with an expression like this:

      ```nix
        perfect_dark.override { romID = "jpn-final"; }
      ```

      Supported romIDs are `${lib.generators.toPretty { } roms}`.
    '';
    homepage = "https://github.com/fgsfdsfgs/perfect_dark/";
    license = with lib.licenses; [
      # perfect_dark, khrplatform.h, port/fast3d
      mit
      # Derivative work of "Perfect Dark" © 2000 Rare Ltd.
      unfree
    ];
    maintainers = with lib.maintainers; [
      PaulGrandperrin
      normalcea
      sigmasquadron
    ];
    mainProgram = "io.github.fgsfdsfgs.perfect_dark";
    platforms = lib.platforms.linux;
  };
})
