{
  lib,
  stdenv,
  fetchurl,
  steam-run,
  coreutils,
  steamRoot ? "$HOME/.local/share/Steam",
}:
let
  srcs =
    let
      url =
        platform:
        "https://web.archive.org/web/20240521141411/https://steamcdn-a.akamaihd.net/client/installer/steamcmd_${platform}.tar.gz";
    in
    {
      x86_64-darwin = fetchurl {
        url = url "osx";
        hash = "sha256-jswXyJiOWsrcx45jHEhJD3YVDy36ps+Ne0tnsJe9dTs=";
      };
      x86_64-linux = fetchurl {
        url = url "linux";
        hash = "sha256-zr8ARr/QjPRdprwJSuR6o56/QVXl7eQTc7V5uPEHHnw=";
      };
    };
in
stdenv.mkDerivation {
  pname = "steamcmd";
  version = "20180104"; # According to steamcmd_linux.tar.gz mtime

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # The source tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/steamcmd
    find . -type f -exec install -Dm 755 "{}" "$out/share/steamcmd/{}" \;

    mkdir -p $out/bin
    substitute ${./steamcmd.sh} $out/bin/steamcmd \
      --subst-var out \
      --subst-var-by coreutils ${coreutils} \
      --subst-var-by steamRoot '${steamRoot}' \
      --subst-var-by steamRun ${if stdenv.hostPlatform.isLinux then (lib.getExe steam-run) else "exec"}
    chmod 0755 $out/bin/steamcmd
  '';

  meta = {
    homepage = "https://developer.valvesoftware.com/wiki/SteamCMD";
    description = "Steam command-line tools";
    mainProgram = "steamcmd";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ tadfisher ];
  };
}
