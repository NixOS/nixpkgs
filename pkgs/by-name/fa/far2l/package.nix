{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  makeWrapper,
  cmake,
  ninja,
  pkg-config,
  perl,
  bash,
  xdg-utils,
  zip,
  unzip,
  gzip,
  bzip2,
  gnutar,
  xz,
  nix-update-script,

  # Backend options
  withTTYX ? true,
  libx11,
  withGUI ? true,
  wxwidgets_3_2,
  withSDL ? false, # SDL GUI (testing), disabled by default
  SDL2,
  harfbuzz,
  fontconfig,
  libxft,

  # Dependencies for plugins (enabled by default)
  # UCD
  libuchardet,

  # Colorer
  spdlog,
  libxml2,

  # MultiArc
  libarchive,

  # NetRocks
  openssl,
  libssh,
  samba,
  libnfs,
  neon,
  gnutls,
  libtasn1,
  p11-kit,

  # AWS
  aws-sdk-cpp,

  # ImageViewer
  imagemagick,
  ffmpeg,

  # ADB
  android-tools,

  # MTP
  libmtp,
  libusb1,

  # GitGutter
  git,

  # Arclite
  _7zz,

  plugins ? [
    "ucd"
    "colorer"
    "multiarc"
    "netrocks"
    "imageviewer"
    "adb"
    "mtp"
    "gitgutter"
    "arclite"
    "align"
    "autowrap"
    "truncate"
    "calc"
    "compare"
    "drawline"
    "editcase"
    "editorcomp"
    "farftp"
    "filecase"
    "incsrch"
    "inside"
    "simpleindent"
    "tmppanel"
    "hexitor"
    "openwith"
    "edsort"
    "memo"
  ],
  python3Packages,
}:

let
  supportedPlugins = [
    "ucd"
    "colorer"
    "multiarc"
    "netrocks"
    "aws"
    "imageviewer"
    "adb"
    "mtp"
    "gitgutter"
    "arclite"
    "align"
    "autowrap"
    "truncate"
    "calc"
    "compare"
    "drawline"
    "editcase"
    "editorcomp"
    "farftp"
    "filecase"
    "incsrch"
    "inside"
    "simpleindent"
    "tmppanel"
    "hexitor"
    "openwith"
    "edsort"
    "memo"
    "python"
  ];
  pluginSpecificBuildInputs =
    plugin:
    [ ]
    ++ lib.optional (plugin == "ucd") libuchardet
    ++ lib.optionals (plugin == "colorer") [
      spdlog
      libxml2
    ]
    ++ lib.optionals (plugin == "multiarc") [
      libarchive
    ]
    ++ lib.optionals (plugin == "netrocks") [
      openssl
      libssh
      libnfs
      neon
      gnutls
      libtasn1
      p11-kit
    ]
    # Samba support is broken on Darwin
    # https://github.com/elfmz/far2l/issues/3068
    ++ lib.optional (plugin == "netrocks" && !stdenv.hostPlatform.isDarwin) samba
    ++ lib.optional (plugin == "aws") aws-sdk-cpp
    ++ lib.optionals (plugin == "imageviewer") [
      imagemagick
      ffmpeg
    ]
    ++ lib.optional (plugin == "adb") android-tools
    ++ lib.optional (plugin == "gitgutter") git
    ++ lib.optionals (plugin == "mtp") [
      libmtp
      libusb1
    ]
    ++ lib.optionals (plugin == "python") (
      with python3Packages;
      [
        python
        cffi
        debugpy
        pcpp
      ]
    );
  pluginSpecificCmakeBool =
    enable: plugin:
    if plugin == "ucd" then
      (lib.cmakeBool "USEUCD" enable)
    else if plugin == "aws" then
      (lib.cmakeBool "NR_AWS" enable)
    else
      (lib.cmakeBool (lib.toUpper plugin) enable);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "far2l";
  version = "2.9.1-unstable-2026-10-10";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "5ec2011794fa0c781e6dde92c84c77b5ae02b25b";
    hash = "sha256-nBcZNIRMKWxMaTPVdXF08KpNPCh/VbgmD2Q4e0rGqCw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    makeWrapper
  ];

  checkPluginsValid =
    let
      diffLists = lib.lists.subtractLists supportedPlugins plugins;
      withNetRocks = builtins.elem "netrocks" plugins;
      withAWS = builtins.elem "aws" plugins;
    in
    if diffLists != [ ] then
      builtins.throw "Unsupported plugin: ${builtins.elemAt diffLists 0}"
    else if withAWS && !withNetRocks then
      builtins.throw "AWS plugin must be built only with NetRocks"
    else
      "";

  buildInputs =
    lib.optionals withSDL [
      SDL2
      harfbuzz
      fontconfig
      libxft
    ]
    # TTYX backend
    ++ lib.optional withTTYX libx11
    # WxWidgets backend
    ++ lib.optional withGUI wxwidgets_3_2
    # Plugins dependencies
    ++ lib.concatMap pluginSpecificBuildInputs plugins;

  postPatch = ''
    chmod +x far2l/bootstrap/*.sh
    patchShebangs far2l/bootstrap/view.sh
  '';

  cmakeFlags = [
    # Backend setup
    (lib.cmakeBool "USESDL" withSDL)
    (lib.cmakeBool "TTYX" withTTYX)
    (lib.cmakeBool "USEWX" withGUI)
  ]
  ++ lib.map (pluginSpecificCmakeBool true) plugins
  ++ lib.map (pluginSpecificCmakeBool false) (lib.subtractLists plugins supportedPlugins)
  ++ lib.optionals (builtins.elem "mtp" plugins) [
    (lib.cmakeBool "MTP_SYSTEM_LIBUSB" true)
    (lib.cmakeBool "MTP_SYSTEM_LIBMTP" true)
  ]
  ++ lib.optionals (builtins.elem "python" plugins) [
    (lib.cmakeFeature "VIRTUAL_PYTHON" "python")
    (lib.cmakeFeature "VIRTUAL_PYTHON_VERSION" "python")
  ];

  runtimeDeps = [
    bash
    unzip
    zip
    xz
    gzip
    bzip2
    gnutar
  ]
  # Git for GitGutter plugin
  ++ lib.optional (builtins.elem "gitgutter" plugins) git
  # Tools for ADB plugin
  ++ lib.optional (builtins.elem "adb" plugins) android-tools;

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  ''
  # Link 7z plugin if Arclite is enabled
  + lib.optionalString (builtins.elem "arclite" plugins) ''
    # Link 7z plugin
    echo "Linking 7z libraries..."
    mkdir -p $out/lib/far2l/Plugins/arclite/plug/
    for file in ${_7zz.lib}/lib/*; do
      ln -sf "$file" "$out/lib/far2l/Plugins/arclite/plug/"
    done
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "Linux port of FAR Manager v2 with enhanced plugin support";
    homepage = "https://github.com/elfmz/far2l";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ smakarov ];
    platforms = lib.platforms.unix;
  };
})
