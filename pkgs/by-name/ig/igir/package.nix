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
  version = "3.0.1-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    # v3.0.1 has a bug on linux x86 and arm64 that was fixed in a subsequent dependency update
    # Using that commit instead as the other dependencies look safe.
    rev = "ec6c1849fdbe418d9b08270a5c5c577b9de16779";
    hash = "sha256-h95e4UpZCX+/nmk7onSmWbuUSbgqJmyCTqWculckhTs=";
  };

  npmDepsHash = "sha256-getvrta3d9yYulvFje7/zpZL0792Z72N97ngshHuwOA=";

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
