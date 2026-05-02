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
      lsqlite3
      lua-subprocess
      nfd
    ];

  phome = "$out/lib/olympus";
  # The following variables are to be updated by the update script.
  version = "26.04.22.01";
  buildId = "5580"; # IMPORTANT: This line is matched with regex in update.sh.
  rev = "78728dcc08e5aba23100527da864ec3c93948a44";
in
buildDotnetModule {
  pname = "olympus-unwrapped";
  inherit version;

  strictDeps = false;

  src = fetchFromGitHub {
    inherit rev;
    owner = "EverestAPI";
    repo = "Olympus";
    fetchSubmodules = true; # Required. See upstream's README.
    hash = "sha256-qB41sG3KATUXj/k0WePwM0z0w6UOyfAYEo2Y7YWoKeo=";
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
