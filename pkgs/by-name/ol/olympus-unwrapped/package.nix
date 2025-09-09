{
  lib,
  fetchFromGitHub,
  fetchzip,
  buildDotnetModule,
  dotnetCorePackages,
  luajitPackages,
  sqlite,
  libarchive,
  curl,
  love,
  xdg-utils,
}:
let
  lua_cpath =
    with luajitPackages;
    lib.concatMapStringsSep ";" getLuaCPath [
      (buildLuarocksPackage {
        pname = "lsqlite3";
        version = "0.9.6-1";
        src = fetchzip {
          url = "http://lua.sqlite.org/home/zip/lsqlite3_v096.zip";
          hash = "sha256-Mq409A3X9/OS7IPI/KlULR6ZihqnYKk/mS/W/2yrGBg=";
        };
        buildInputs = [ sqlite.dev ];
      })

      lua-subprocess
      nfd
    ];

  phome = "$out/lib/olympus";
  # The following variables are to be updated by the update script.
  version = "25.09.09.02";
  buildId = "5131"; # IMPORTANT: This line is matched with regex in update.sh.
  rev = "fa3f1a9aaca5e57bfa6d2e18a0a8688c7608b747";
in
buildDotnetModule {
  pname = "olympus-unwrapped";
  inherit version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "EverestAPI";
    repo = "Olympus";
    fetchSubmodules = true; # Required. See upstream's README.
    hash = "sha256-MJzrQDMsnbjua76twT+swZ1fMiRqokqlxg0ce1fnvLU=";
  };

  nativeBuildInputs = [
    libarchive # To create the .love file (zip format).
  ];

  nugetDeps = ./deps.json;
  projectFile = "sharp/Olympus.Sharp.csproj";
  executables = [ ];
  installPath = "${placeholder "out"}/lib/olympus/sharp";

  # See the 'Dist: Update src/version.txt' step in azure-pipelines.yml from upstream.
  preConfigure = ''
    echo ${version}-nixos-${buildId}-${builtins.substring 0 5 rev} > src/version.txt
  '';

  # The script find-love is hacked to use love from nixpkgs.
  # It is used to launch Loenn from Olympus.
  # I assume --fused is so saves are properly made (https://love2d.org/wiki/love.filesystem).
  preInstall = ''
    mkdir -p ${phome}
    makeWrapper ${lib.getExe love} ${phome}/find-love \
      --add-flags "--fused"

    install -Dm755 suppress-output.sh ${phome}/suppress-output

    mkdir -p $out/bin
    makeWrapper ${phome}/find-love $out/bin/olympus \
      --prefix LUA_CPATH ";" "${lua_cpath}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ curl ]}" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --add-flags ${phome}/olympus.love \
      --set DOTNET_ROOT ${dotnetCorePackages.runtime_8_0}/share/dotnet

    bsdtar --format zip --strip-components 1 -cf ${phome}/olympus.love src
  '';

  postInstall = ''
    install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
    install -Dm644 src/data/icon.png $out/share/icons/hicolor/128x128/apps/olympus.png
    install -Dm644 LICENSE $out/share/licenses/olympus/LICENSE
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Cross-platform GUI Everest installer and Celeste mod manager";
    homepage = "https://github.com/EverestAPI/Olympus";
    downloadPage = "https://everestapi.github.io/#olympus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ulysseszhan
      petingoso
    ];
    mainProgram = "olympus";
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.aarch; # Celeste doesn't support aarch in the first place
  };
}
