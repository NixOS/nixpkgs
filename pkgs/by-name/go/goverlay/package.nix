{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  coreutils,
  fpc,
  git,
  gnugrep,
  iproute2,
  lazarus-qt6,
  libGL,
  libGLU,
  libnotify,
  libX11,
  nix-update-script,
  pciutils,
  polkit,
  procps,
  qt6Packages,
  systemd,
  util-linux,
  vulkan-tools,
  which,
}:

stdenv.mkDerivation rec {
  pname = "goverlay";
  version = "1.3-2";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "goverlay";
    rev = version;
    sha256 = "sha256-Vxmmsf/l3OK1Q6UKdhCWvU4WPJkdQG2Hn+s9tS+D5KM=";
  };

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'prefix = /usr/local' "prefix = $out"

    substituteInPlace overlayunit.pas \
      --replace-fail '/usr/share/icons/hicolor/128x128/apps/goverlay.png' "$out/share/icons/hicolor/128x128/apps/goverlay.png" \
      --replace-fail '/sbin/ip' "${lib.getExe' iproute2 "ip"}" \
      --replace-fail '/bin/bash' "${lib.getExe' bash "bash"}" \
      --replace-fail '/bin/uname' "${lib.getExe' coreutils "uname"}" \
      --replace-fail '/usr/bin/lspci' "${lib.getExe' pciutils "lspci"}" \
      --replace-fail "FONTFOLDER := '/usr/share/fonts/'" "FONTFOLDER := GetEnvironmentVariable('HOME') + '/.local/share/fonts/'" \
      --replace-fail "'/usr/share/fonts/'" 'FONTFOLDER'
  '';

  nativeBuildInputs = [
    fpc
    lazarus-qt6
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    libGL
    libGLU
    qt6Packages.libqtpas
    libX11
    qt6Packages.qtbase
  ];

  NIX_LDFLAGS = "-lGLU -lGL -rpath ${lib.makeLibraryPath buildInputs}";

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild --lazarusdir=${lazarus-qt6}/share/lazarus -B goverlay.lpi
    runHook postBuild
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        bash
        coreutils
        git
        gnugrep
        libnotify
        polkit
        procps
        systemd
        util-linux.bin
        vulkan-tools
        which
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Opensource project that aims to create a Graphical UI to help manage Linux overlays";
    homepage = "https://github.com/benjamimgois/goverlay";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ RoGreat ];
    platforms = platforms.linux;
    mainProgram = "goverlay";
  };
}
