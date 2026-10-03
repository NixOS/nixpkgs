{
  lib,
  clangStdenv,
  fetchFromGitHub,
  bash,
  freetype,
  libx11,
  libxext,
  libxfixes,
  libGL,
  makeWrapper,
  libllvm,
  zenity,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  raddebugger,
  gccStdenv,
}:

let
  stdenv = clangStdenv;
  compiler = stdenv.cc.cc.pname;
in
assert compiler == "gcc" || compiler == "clang";

stdenv.mkDerivation (finalAttrs: {
  pname = "raddebugger";
  version = "0.9.29-alpha";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "EpicGames";
    repo = "raddebugger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQNicRWKdIamDeQU1RRceRR2QgoUlomQYoeCgepO10w=";
  };

  nativeBuildInputs = [
    bash
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    freetype
    libx11
    libxext
    libxfixes
    libGL
  ];

  postPatch = ''
    patchShebangs build.sh

    substituteInPlace build.sh \
      --replace-fail '$(git describe --always --dirty)' 'v${finalAttrs.version}' \
      --replace-fail '$(git rev-parse HEAD)' 'v${finalAttrs.version}'
  '';

  buildPhase = ''
    runHook preBuild

    ./build.sh '${compiler}' release raddbg radlink radbin torture

    runHook postBuild
  '';

  doCheck = false; # fails on my machine

  checkPhase = ''
    runHook preCheck

    ./build/torture '*'

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t "$out/bin" build/{raddbg,radlink,radbin}
    install -Dm644 data/logo.png "$out/share/icons/hicolor/256x256/raddbg.png"

    runHook postInstall
  '';

  postFixup = ''
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" \
        --prefix PATH : "${
          lib.makeBinPath [
            zenity
            libllvm
          ]
        }"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "raddbg";
      desktopName = "RAD Debugger";
      genericName = "Debugger";
      comment = "Graphical debugger";
      icon = "raddbg";
      exec = "raddbg %U";
      terminal = false;
      categories = [
        "Development"
        "Debugger"
      ];
      startupNotify = true;
      startupWMClass = "RADDBG";
    })
  ];

  passthru = {
    tests = {
      raddebugger-gcc = raddebugger.override { clangStdenv = gccStdenv; };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/EpicGames/raddebugger";
    description = "A native, user-mode, multi-process, graphical debugger.";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ mithicspirit ];
    mainProgram = "raddbg";
  };
})
