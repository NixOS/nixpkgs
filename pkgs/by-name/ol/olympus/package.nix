{
  fetchFromGitHub,
  fetchzip,
  buildDotnetModule,
  lib,
  mono4,
  love,
  lua51Packages,
  msbuild,
  sqlite,
  curl,
  libarchive,
  buildFHSEnv,
  xdg-utils,
}:
# WONTFIX: On NixOS, cannot launch Steam installations of Everest / Celeste from Olympus.
# The way it launches Celeste is by directly executing steamapps/common/Celeste/Celeste,
# and it does not work on NixOS (even with steam-run).
# This should be considered a bug of Steam on NixOS (and is probably very hard to fix).

# FIXME: olympus checks if xdg-mime x-scheme-handler/everest for a popup. If it's not set it complains about it.
# I'm pretty sure thats by user so end user needs to do it

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

  # NOTE: on installation olympus uses MiniInstallerLinux which is dynamically linked, this makes it run fine
  fhs-env = buildFHSEnv {
    name = "olympus-fhs";
    targetPkgs = pkgs: (with pkgs; [
      icu
      stdenv.cc.cc
      libgcc.lib
      openssl
    ]);
    runScript = "bash";
  };


  lsqlite3 = lua51Packages.buildLuarocksPackage {
    pname = "lsqlite3";
    version = "0.9.6-1";
    src = fetchzip {
      url = "http://lua.sqlite.org/index.cgi/zip/lsqlite3_v096.zip";
      hash = "sha256-Mq409A3X9/OS7IPI/KlULR6ZihqnYKk/mS/W/2yrGBg=";
    };
    buildInputs = [sqlite.dev];
  };

  dotnet-out = "sharp/bin/Release/net452";
  pname = "olympus";
  phome = "$out/lib/${pname}";
  nfd = lua51Packages.nfd;
in
  buildDotnetModule rec {
    inherit pname;

    # FIXME: I made up this version number.
    version = "24.07.06.02";

    src = fetchFromGitHub {
      owner = "EverestAPI";
      repo = "Olympus";
      rev = "5f3e40687eb825c57021f52d83a3bc9a82c04bdb";
      fetchSubmodules = true; # Required. See upstream's README.
      hash = "sha256-rNh6sH51poahiV0Mb61lHfzqOkPF2pW2wr7MOrfVSVs=";
    };

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

    runtimeInputs = [
      xdg-utils
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
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [curl]} \
        --add-flags "${phome}/olympus.love"
      mkdir -p ${phome}
      bsdtar --format zip --strip-components 1 -cf ${phome}/olympus.love src
      install -Dm755 ${dotnet-out}/* -t ${phome}/sharp
      runHook postInstall
    '';

    # we need to force olympus to use the fhs-env
    postInstall = ''
      sed -i 's|^exec|& ${fhs-env}/bin/olympus-fhs|' $out/bin/olympus
      install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
      install -Dm644 src/data/icon.png $out/share/icons/hicolor/128x128/apps/olympus.png
      install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
    '';

    meta = with lib; {
      description = "Cross-platform GUI Everest installer and Celeste mod manager";
      homepage = "https://github.com/EverestAPI/Olympus";
      changelog = "https://github.com/EverestAPI/Olympus/blob/main/changelog.txt";
      license = licenses.mit;
      maintainers = with maintainers; [ulysseszhan petingoso];
      mainProgram = "olympus";
      platforms = platforms.unix;
    };
  }
