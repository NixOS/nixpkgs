{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  autoPatchelfHook,
  stdenv,
  SDL2,
  libuv,
  lz4,
  #tests
  runCommand,
  igir,
  nodejs,
}:
buildNpmPackage rec {
  pname = "igir";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-DYQn5VF6kBwN6wzImayVqftb28CzmRCUd0jqRExQdoY=";
  };

  npmDepsHash = "sha256-/lbe5YgBb5VIX2Y7ZoCbrYyMchIb+3yZ1Rwp2JDuQfM=";

  # I have no clue why I have to do this
  postPatch = ''
    patchShebangs scripts/update-readme-help.sh
  '';

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    SDL2
    libuv
    lz4
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Fix chdman
    find $out/lib/node_modules/igir/node_modules/@emmercm/ -name chdman -executable -type f \
      -exec install_name_tool -change /opt/homebrew/opt/sdl2/lib/libSDL2-2.0.0.dylib ${SDL2}/lib/libSDL2-2.0.0.dylib {} \;

    # Fix maxcso
    find $out/lib/node_modules/igir/node_modules/@emmercm/ -name maxcso -executable -type f \
      -exec install_name_tool -change /opt/homebrew/opt/libuv/lib/libuv.1.dylib ${libuv}/lib/libuv.1.dylib {} \;
    find $out/lib/node_modules/igir/node_modules/@emmercm/ -name maxcso -executable -type f \
      -exec install_name_tool -change /opt/homebrew/opt/lz4/lib/liblz4.1.dylib ${lz4.lib}/lib/liblz4.1.dylib {} \;
  '';

  passthru.tests =
    let
      igirDir = "${igir}/lib/node_modules/igir";
      npxCmd = "${nodejs}/bin/npx";
    in
    {
      chdman = runCommand "${pname}-chdman" { meta.timeout = 30; } ''
        set +e
        cd ${igirDir}
        ${npxCmd} chdman > $out
        grep -q "chdman - MAME Compressed Hunks of Data (CHD) manager" $out
      '';

      maxcso = runCommand "${pname}-maxcso" { meta.timeout = 30; } ''
        set +e
        cd ${igirDir}
        ${npxCmd} maxcso 2> $out
        grep -q "maxcso v1.13.0" $out
      '';
    };

  meta = {
    description = "Video game ROM collection manager to help filter, sort, patch, archive, and report on collections on any OS";
    mainProgram = "igir";
    homepage = "https://igir.io";
    changelog = "https://github.com/emmercm/igir/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ docbobo ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
