{
  lib,
  fetchFromGitHub,
  fetchzip,
  buildFHSEnv,
  buildDotnetModule,
  dotnetCorePackages,
  luajitPackages,
  sqlite,
  libarchive,
  curl,
  love,
  xdg-utils,
  writeShellScript,
  # These need overriding if you launch Celeste/Loenn/MiniInstaller from Olympus.
  # Some examples:
  # - null: Use default wrapper.
  # - "": Do not use wrapper.
  # - steam-run: Use steam-run.
  # - "steam-run": Use steam-run command available from PATH.
  # - writeShellScriptBin { ... }: Use a custom script.
  # - ./my-wrapper.sh: Use a custom script.
  # In any case, it can be overridden at runtime by OLYMPUS_{CELESTE,LOENN,MINIINSTALLER}_WRAPPER.
  celesteWrapper ? null,
  loennWrapper ? null,
  miniinstallerWrapper ? null,
  skipHandlerCheck ? false, # whether to skip olympus xdg-mime check, true will override it
}:

let
  lua_cpath =
    with luajitPackages;
    lib.concatMapStringsSep ";" getLuaCPath [
      (buildLuarocksPackage {
        pname = "lsqlite3";
        version = "0.9.6-1";
        src = fetchzip {
          url = "http://lua.sqlite.org/index.cgi/zip/lsqlite3_v096.zip";
          hash = "sha256-Mq409A3X9/OS7IPI/KlULR6ZihqnYKk/mS/W/2yrGBg=";
        };
        buildInputs = [ sqlite.dev ];
      })

      lua-subprocess
      nfd
    ];

  # When installing Everest, Olympus uses MiniInstaller, which is dynamically linked.
  miniinstaller-fhs = buildFHSEnv {
    pname = "olympus-miniinstaller-fhs";
    inherit version;
    targetPkgs =
      pkgs:
      (with pkgs; [
        icu
        openssl
        dotnet-runtime # Without this, MiniInstaller will install dotnet itself.
      ]);
  };

  wrapper-to-env =
    wrapper:
    if lib.isDerivation wrapper then
      lib.getExe wrapper
    else if wrapper != null then
      wrapper
    else
      "";

  miniinstaller-wrapper =
    if miniinstallerWrapper == null then
      (writeShellScript "miniinstaller-wrapper" "exec ${lib.getExe miniinstaller-fhs} -c \"$@\"")
    else
      (wrapper-to-env miniinstallerWrapper);

  pname = "olympus";
  phome = "$out/lib/${pname}";
  # The following variables are to be updated by the update script.
  version = "25.02.07.01";
  buildId = "4624"; # IMPORTANT: This line is matched with regex in update.sh.
  rev = "f4cd9dc973e68dc9b6c043941d5ab57f93b63ac4";

in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    inherit rev;
    owner = "EverestAPI";
    repo = "Olympus";
    fetchSubmodules = true; # Required. See upstream's README.
    hash = "sha256-I0tDqe7XvieL0kj8njzaNx3taY2VpFewi/SnYRCi4tk=";
  };

  nativeBuildInputs = [
    libarchive # To create the .love file (zip format).
  ];

  nugetDeps = ./deps.json;
  projectFile = "sharp/Olympus.Sharp.csproj";
  executables = [ ];
  installPath = "${placeholder "out"}/lib/${pname}/sharp";

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

    mkdir -p $out/bin
    makeWrapper ${phome}/find-love $out/bin/olympus \
      --prefix LUA_CPATH ";" "${lua_cpath}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ curl ]}" \
      --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --set-default OLYMPUS_MINIINSTALLER_WRAPPER "${miniinstaller-wrapper}" \
      --set-default OLYMPUS_CELESTE_WRAPPER "${wrapper-to-env celesteWrapper}" \
      --set-default OLYMPUS_LOENN_WRAPPER "${wrapper-to-env loennWrapper}" \
      --set-default OLYMPUS_SKIP_SCHEME_HANDLER_CHECK ${if skipHandlerCheck then "1" else "0"} \
      --add-flags ${phome}/olympus.love \
      --set DOTNET_ROOT ${dotnetCorePackages.runtime_8_0}/share/dotnet

    bsdtar --format zip --strip-components 1 -cf ${phome}/olympus.love src
  '';

  postInstall = ''
    install -Dm644 lib-linux/olympus.desktop $out/share/applications/olympus.desktop
    install -Dm644 src/data/icon.png $out/share/icons/hicolor/128x128/apps/olympus.png
    install -Dm644 LICENSE $out/share/licenses/${pname}/LICENSE
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
