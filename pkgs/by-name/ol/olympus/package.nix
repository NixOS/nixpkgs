{ fetchFromGitHub
, fetchzip
, buildDotnetModule
, lib

, mono4
, love
, lua51Packages
, msbuild
, sqlite
, curl
, libarchive
, gtk3
, pkg-config
}:

# WONTFIX: On NixOS, cannot launch Steam installations of Everest / Celeste from Olympus.
# The way it launches Celeste is by directly executing steamapps/common/Celeste/Celeste,
# and it does not work on NixOS (even with steam-run).
# This should be considered a bug of Steam on NixOS (and is probably very hard to fix).
let

  lua-subprocess = lua51Packages.buildLuarocksPackage {
    pname = "subprocess";
    version = "bfa8e9";
    src = fetchFromGitHub {
      owner = "0x0ade"; # a developer of Everest
      repo = "lua-subprocess";
      rev = "bfa8e97da774141f301cfd1106dca53a30a4de54";
      hash = "sha256-4LiYWB3PAQ/s33Yj/gwC+Ef1vGe5FedWexeCBVSDIV0=";
    };
    rockspecFilename = "subprocess-scm-1.rockspec";
  };

  lsqlite3 = lua51Packages.buildLuarocksPackage {
    pname = "lsqlite3";
    version = "0.9.6-1";
    src = fetchzip {
      url = http://lua.sqlite.org/index.cgi/zip/lsqlite3_v096.zip;
      hash = "sha256-9SBXIrHpXzUoyJbtBlIxn/vF9amWm+qP7Nb2MY79QOM=";
    };
    buildInputs = [ sqlite.dev ];
  };

  # FIXME: The package is broken (both here and in nixpkgs). See #295022.
  # Therefore, currently cannot manually select Celeste installation
  # or launching Loenn.
  nfd = lua51Packages.buildLuarocksPackage {
    pname = "nfd";
    version = "bea456";
    src = fetchFromGitHub {
      owner = "Vexatos"; # a developer of the Celeste map editors
      repo = "nativefiledialog";
      rev = "bea4560b9269bdc142fef946ccd8682450748958";
      hash = "sha256-veCLHTmZU4puZW0NHeWFZa80XKc6w6gxVLjyBmTrejg=";
    };

    # Needed because it (incorrectly?) uses LUA_LIBDIR for -L.
    luarocksConfig.LUA_LIBDIR = "${lua51Packages.lua}/lib";

    knownRockspec = "lua/nfd-scm-1.rockspec";

    buildInputs = [ gtk3 ];

    # Using `depsBuildBuild` does not completely make sense,
    # but `nativeBuildInputs` does not work here
    # (leads to command not found in build phase).
    # A bug of `buildLuarocksPackage`?
    depsBuildBuild = [ pkg-config ];

    fixupPhase = ''
      find $out -name nfd_zenity.so -execdir mv {} nfd.so \;
    '';
  };

  dotnet-out = "sharp/bin/Release/net452";
  pname = "olympus";
  phome = "$out/lib/${pname}";

in buildDotnetModule rec {

  inherit pname;

  # FIXME: I made up this version number.
  # Will fix after EverestAPI/Olympus#85 gets merged.
  version = "24.03.11.21";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    # This commit is by package maintainer @UlyssesZh.
    # See EverestAPI/Olympus#85.
    rev = "72b6bbcd054f02c2006589d5a48fa877ce95bb7f";
    fetchSubmodules = true; # Required. See upstream's README.
    hash = "sha256-JVfr4lh2G7S0XCwt/GTFqlgAUHXnwxHBTwLSFLWk6Iw=";
  };

  # FIXME: This does not prevent executables from being installed.
  # See #294661.
  executables = [];

  nativeBuildInputs = [
    msbuild
    libarchive # To create the .love file (zip format)
  ];

  buildInputs = [
    love
    mono4
    nfd
    lua-subprocess
    lsqlite3
  ];
  nugetDeps = ./deps.nix;

  projectFile = "sharp/Olympus.Sharp.sln";

  postConfigure = ''
    echo '${version}-nixos' > src/version.txt
  '';

  # Copied from `olympus` in AUR.
  buildPhase = ''
    runHook preBuild
    FrameworkPathOverride=${mono4.out}/lib/mono/4.5 msbuild ${projectFile} /p:Configuration=Release
    runHook postBuild
  '';

  # Hack Olympus.Sharp.bin.{x86,x86_64} to use system mono.
  # This was proposed by @0x0ade on discord.gg/celeste:
  # https://discord.com/channels/403698615446536203/514006912115802113/827507533962149900
  postBuild = ''
    makeWrapper ${mono4.out}/bin/mono ${dotnet-out}/Olympus.Sharp.bin.x86 \
      --add-flags ${phome}/sharp/Olympus.Sharp.exe
    cp ${dotnet-out}/Olympus.Sharp.bin.x86 ${dotnet-out}/Olympus.Sharp.bin.x86_64
  '';

  # The script find-love is hacked to use love from nixpkgs.
  # It is used to launch Loenn from Olympus.
  installPhase = let
    subprocess-cpath = "${lua-subprocess.out}/lib/lua/5.1/?.so";
    nfd-cpath = "${nfd.out}/lib/lua/5.1/?.so";
    lsqlite3-cpath = "${lsqlite3.out}/lib/lua/5.1/?.so";
  in ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${love.out}/bin/love ${phome}/find-love \
      --add-flags "--fused"
    makeWrapper ${phome}/find-love $out/bin/olympus \
      --prefix LUA_CPATH : "${nfd-cpath};${subprocess-cpath};${lsqlite3-cpath}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curl ]} \
      --add-flags "${phome}/olympus.love"

    mkdir -p ${phome}
    bsdtar --format zip --strip-components 1 -cf ${phome}/olympus.love src
    install -Dm755 ${dotnet-out}/* -t ${phome}/sharp

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
    install -Dm644 src/data/icon.png $out/share/icons/hicolor/128x128/apps/olympus.png
    install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
  '';

  meta = with lib; {
    description = "Cross-platform GUI Everest installer and Celeste mod manager";
    homepage = "https://github.com/EverestAPI/Olympus";
    changelog = "https://github.com/EverestAPI/Olympus/blob/main/changelog.txt";
    license = licenses.mit;
    maintainers = with maintainers; [ ulysseszhan ];
    mainProgram = "olympus";
    platforms = platforms.unix;
  };

}
