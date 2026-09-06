{
  stdenv,
  lib,
  fetchFromGitHub,
  curl,
  libpng,
  libxcb,
  libGLU,
  libX11,
  copyDesktopItems,
  installShellFiles,
  makeDesktopItem,
  makeWrapper,
  gcc,
  gnumake,
  kdePackages,
  yad,
  zenity,
  dialogPkg ? zenity,
}:

assert lib.elem dialogPkg [
  kdePackages.kdialog
  yad
  zenity
];

stdenv.mkDerivation rec {
  pname = "qb64pe";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "QB64-Phoenix-Edition";
    repo = "QB64pe";
    tag = "v${version}";
    sha256 = "sha256-Iw/hasKW0+9aq7Ld195NlIUpTVqaSZxDQ13vjO+XExE=";
  };

  buildInputs = [
    curl
    libpng
    libxcb
    libGLU
    libX11
  ];

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles
    makeWrapper
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "qb64pe";
      desktopName = "QB64-PE Programming IDE";
      genericName = "Programming IDE";
      icon = "qb64pe";
      exec = "qb64pe";
      terminal = false;
      type = "Application";
      categories = [
        "Development"
        "IDE"
      ];
      startupNotify = false;
    })
  ];

  buildPhase = ''
    runHook preBuild

    patchShebangs --build setup_lnx.sh
    ./setup_lnx.sh

    runHook postBuild
  '';

  # The executable writes into the internal folder and stores settings relative
  # to the executable, so we have to run it from a copy in XDG_DATA_HOME
  installPhase = ''
          runHook preInstall

          find internal -name '*.a' -or -name '*.o' | xargs rm

          install -d $out/share/qb64pe
          cp -r Makefile qb64pe internal $out/share/qb64pe
          installManPage qb64pe.1
          install -D -m 444 -t $out/share/icons source/qb64pe.png

          install -d $out/bin
          cat << EOF > $out/bin/qb64pe
    #! /bin/sh

    XDG_DATA_HOME="\$HOME/.local/share"
    QB64PE_DATA_HOME="\$XDG_DATA_HOME/qb64pe"

    cp -r $out/share/qb64pe "\$XDG_DATA_HOME"
    chmod -R +w "\$QB64PE_DATA_HOME"

    cd "\$QB64PE_DATA_HOME"
    ./qb64pe \$@
    EOF
          chmod +x $out/bin/qb64pe

          # e.g. NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
          nix_cc_wrapper_target_host="$(printenv | grep ^NIX_CC_WRAPPER_TARGET_HOST | sed 's/=.*//')"
          wrapProgram  $out/bin/qb64pe \
            --prefix PATH : ${
              lib.makeBinPath [
                gcc
                gnumake
                dialogPkg
              ]
            } \
            --set NIX_CFLAGS_COMPILE "$NIX_CFLAGS_COMPILE" \
            --set NIX_LDFLAGS "$NIX_LDFLAGS" \
            --set "$nix_cc_wrapper_target_host" "''${!nix_cc_wrapper_target_host}" \

          runHook postInstall
  '';

  meta = rec {
    description = "Modern Cross-Platform BASIC compatible with QBasic and QuickBASIC 4.5";
    homepage = "https://www.qb64phoenix.com/";
    downloadPage = "https://github.com/QB64-Phoenix-Edition/QB64pe";
    changelog = "${downloadPage}/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ sephalon ];
  };
}
