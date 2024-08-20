{
  lib,
  stdenv,
  smartmontools,
  fetchFromGitHub,
  fetchzip,
  cmake,
  qt6,
  theme ? "",
  customBgDark ? "",
  customBgLight ? "",
  customStatusPath ? "",
  customSrc ? "",
  customRightCharacter ? false,
}:

let
  isTheme = theme != null && theme != "";

  rightCharacter =
    (builtins.elem theme [
      "aoi"
      "shizukuTeaBreak"
    ])
    || customRightCharacter;
  themeSources = import ./sources.nix { inherit fetchzip; };
  themes = import ./themes.nix {
    inherit
      customBgDark
      customBgLight
      customSrc
      customStatusPath
      lib
      themeSources
      ;
  };
in
assert !isTheme || lib.attrsets.hasAttrByPath [ theme ] themes;
stdenv.mkDerivation (finalAttrs: {
  pname = "qdiskinfo";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "edisionnano";
    repo = "QDiskInfo";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-0zF3Nc5K8+K68HOSy30ieYvYP9/oSkTe0+cp0hVo9Gs=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    smartmontools
  ];

  cmakeBuildType = "MinSizeRel";

  cmakeFlags =
    [
      "-DQT_VERSION_MAJOR=6"
    ]
    ++ lib.optionals isTheme [ "-DINCLUDE_OPTIONAL_RESOURCES=ON" ]
    ++ (if rightCharacter then [ "-DCHARACTER_IS_RIGHT=ON" ] else [ "-DCHARACTER_IS_RIGHT=OFF" ]);

  postUnpack = ''
    cp -r $sourceRoot $TMPDIR/src
    sourceRoot=$TMPDIR/src
  '';
  patchPhase = lib.optionalString isTheme ''
    export SRCPATH=${themes."${theme}".src}/CdiResource/themes/
    export DESTPATH=$sourceRoot/dist/theme/
    mkdir -p $DESTPATH
    if [ -n "${themes."${theme}".paths.bgDark}" ]; then
      cp $SRCPATH/${themes."${theme}".paths.bgDark} $DESTPATH/bg_dark.png
    fi
    if  [ -n "${themes."${theme}".paths.bgLight}" ]; then
      cp $SRCPATH/${themes."${theme}".paths.bgLight} $DESTPATH/bg_light.png
    fi
    cp $SRCPATH/${themes."${theme}".paths.status}/SDdiskStatusBad-300.png $DESTPATH/bad.png
    cp $SRCPATH/${themes."${theme}".paths.status}/SDdiskStatusCaution-300.png $DESTPATH/caution.png
    cp $SRCPATH/${themes."${theme}".paths.status}/SDdiskStatusGood-300.png $DESTPATH/good.png
    cp $SRCPATH/${themes."${theme}".paths.status}/SDdiskStatusUnknown-300.png $DESTPATH/unknown.png
  '';
  postInstall = ''
    wrapProgram $out/bin/QDiskInfo \
      --suffix PATH : ${smartmontools}/bin
  '';

  meta = {
    description = "CrystalDiskInfo alternative for Linux";
    homepage = "https://github.com/edisionnano/QDiskInfo";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ roydubnium ];
    platforms = lib.platforms.linux;
    mainProgram = "QDiskInfo";
  };
})
