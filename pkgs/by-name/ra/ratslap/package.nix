{ stdenv
, lib
, fetchFromGitHub
, libusb1
, pkg-config
, installShellFiles
, git
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ratslap";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "krayon";
    repo = "ratslap";
    rev = finalAttrs.version;
    hash = "sha256-PO/79tTiO4TBtojrEtkSf5W6zuG+Ml2iJGAtYHDwHEY=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    git
  ];

  buildInputs = [
    libusb1
  ];

  preBuild = ''
    makeFlagsArray+=(
      "-W gitup"
      "VDIRTY="
      "MAJVER=${finalAttrs.version}"
      "APPBRANCH=main"
      "BINNAME=ratslap"
      "MARKDOWN_GEN="
      "BUILD_DATE=$(git show -s --date=format:'%Y-%m-%d %H:%M:%S%z' --format=%cd)"
      "BUILD_MONTH=$(git show -s --date=format:'%B' --format=%cd)"
      "BUILD_YEAR=$(git show -s --date=format:'%Y' --format=%cd)"
    )
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ratslap $out/bin

    mv manpage.1 ratslap.1
    installManPage ratslap.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Configure G300 and G300s Logitech mice";
    longDescription = ''
      A tool to configure Logitech mice on Linux. Supports remapping
      all buttons and configuring modes, DPI settings and the LED.
    '';
    homepage = "https://github.com/krayon/ratslap";
    changelog = "https://github.com/krayon/ratslap/releases/tag/${finalAttrs.version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ zebreus ];
    platforms = platforms.linux;
  };
})
