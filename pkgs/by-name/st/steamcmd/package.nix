{
  lib,
  stdenv,
  fetchurl,
  steam-run,
<<<<<<< HEAD
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
=======
  bash,
  coreutils,
  steamRoot ? "~/.local/share/Steam",
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
stdenv.mkDerivation {
  pname = "steamcmd";
  version = "20180104"; # According to steamcmd_linux.tar.gz mtime

<<<<<<< HEAD
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
=======
  src = fetchurl {
    url = "https://web.archive.org/web/20240521141411/https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz";
    hash = "sha256-zr8ARr/QjPRdprwJSuR6o56/QVXl7eQTc7V5uPEHHnw=";
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # The source tarball does not have a single top-level directory.
  preUnpack = ''
    mkdir $name
    cd $name
    sourceRoot=.
  '';

<<<<<<< HEAD
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/steamcmd
    find . -type f -exec install -Dm 755 "{}" "$out/share/steamcmd/{}" \;
=======
  buildInputs = [
    bash
    steam-run
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/steamcmd/linux32
    install -Dm755 steamcmd.sh $out/share/steamcmd/steamcmd.sh
    install -Dm755 linux32/* $out/share/steamcmd/linux32
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    mkdir -p $out/bin
    substitute ${./steamcmd.sh} $out/bin/steamcmd \
      --subst-var out \
      --subst-var-by coreutils ${coreutils} \
<<<<<<< HEAD
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
=======
      --subst-var-by steamRoot "${steamRoot}" \
      --subst-var-by steamRun ${steam-run}
    chmod 0755 $out/bin/steamcmd
  '';

  meta = with lib; {
    homepage = "https://developer.valvesoftware.com/wiki/SteamCMD";
    description = "Steam command-line tools";
    mainProgram = "steamcmd";
    platforms = platforms.linux;
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ tadfisher ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
