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
  p7zip,
  xz,

  # Backend options
  withTTYX ? true,
  libx11,
  withGUI ? true,
  wxwidgets_3_2,
  withSDL ? false,  # SDL GUI (testing), disabled by default
  SDL2,
  harfbuzz,
  fontconfig,
  libxft,
  withUCD ? true,
  libuchardet,

  # Plugins (all enabled by default)
  withColorer ? true,
  spdlog,
  libxml2,
  withMultiArc ? true,
  libarchive,
  withNetRocks ? true,
  openssl,
  libssh,
  samba,
  libnfs,
  neon,
  withAWS ? true,
  aws-sdk-cpp,
  withImageViewer ? true,
  imagemagick,
  ffmpeg,
  withADB ? true,
  android-tools,
  withGitGutter ? true,
  git,
  withArclite ? true,     # Archive support with custom 7z plugin
  _7z-far,                # Custom 7zip plugin (only used if withArclite is true)
  withAlign ? true,       # Align plugin
  withAutowrap ? true,    # Autowrap plugin
  withTruncate ? true,    # Truncate plugin
  withCalc ? true,        # Calculator plugin
  withCompare ? true,     # Compare files plugin
  withDrawline ? true,    # Draw line plugin
  withEditcase ? true,    # Change case plugin
  withEditorcomp ? true,  # Editor completion plugin
  withFarftp ? true,      # FTP client plugin
  withFilecase ? true,    # File case plugin
  withIncsrch ? true,     # Incremental search plugin
  withInside ? true,      # Inside plugin
  withSimpleindent ? true, # Simple indent plugin
  withTmppanel ? true,    # Temporary panel plugin
  withHexitor ? true,     # Hex editor plugin
  withOpenwith ? true,    # Open with plugin
  withEdsort ? true,      # Editor sort plugin
  withMemo ? true,        # Memo plugin

  withPython ? false,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2.8.0-dd06e95";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "dd06e95e1c8ffb6ce26db0c5d5196b3c09b0260f";
    hash = "sha256-O2jH/gsUR+P3WtOTliavec3dBcmuCQG2Ke+9HLEcdQI=";
  };

  patches = [
    # Git Gutter plugin #3248
    (fetchpatch {
      url = "https://github.com/elfmz/far2l/commit/07234cdbe243fb074040e2f57deea742edeb5d96.patch";
      hash = "sha256-ecYQi5xUcs+SAXuW3yb0wHUKgyRZkvdUTU1PYm43tps=";
    })
    (fetchpatch {
      url = "https://github.com/elfmz/far2l/commit/1e0e3d81171925cfb9b3e0a957618350e72f7cdb.patch";
      hash = "sha256-aulSRO48m+VPTfMZ/a5p6Q2J26WV2SHH0hnfyBeHB+o=";
    })
    (fetchpatch {
      url = "https://github.com/elfmz/far2l/commit/f963dee774a4a7a68ab05dfbd5df8c9e54a09124.patch";
      hash = "sha256-pUvVVjlRF/jTHMX1BRKOiElZAuIPY+xO6cKyWqHNd8c=";
    })
    (fetchpatch {
      url = "https://github.com/elfmz/far2l/commit/6020a2103e0b0369de8c0b9085b715dca10d5136.patch";
      hash = "sha256-/tKkz/aWyr2Imv9lKibfPlZs+vh95TQXlsaDgqPp7n4=";
    })
  ];

  postPatch = ''
    chmod +x far2l/bootstrap/*.sh
    patchShebangs far2l/bootstrap/view.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    makeWrapper
  ];

  buildInputs = []
  # SDL GUI dependencies (only if withSDL is enabled)
  ++ lib.optionals withSDL [
    SDL2
    harfbuzz
    fontconfig
    libxft
  ]
  # TTYX backend
  ++ lib.optional withTTYX libx11
  # WX GUI backend
  ++ lib.optional withGUI wxwidgets_3_2
  # UCD plugin
  ++ lib.optional withUCD libuchardet
  # Colorer plugin dependencies
  ++ lib.optionals withColorer [
    spdlog
    libxml2
  ]
  # MultiArc plugin dependencies
  ++ lib.optionals withMultiArc [
    libarchive
  ]
  # NetRocks plugin dependencies
  ++ lib.optionals withNetRocks [
    openssl
    libssh
    libnfs
    neon
  ]
  # AWS S3 support (part of NetRocks)
  ++ lib.optional (withNetRocks && withAWS) aws-sdk-cpp
  # Samba support (NetRocks, not on Darwin)
  ++ lib.optional (withNetRocks && !stdenv.hostPlatform.isDarwin) samba
  # ImageViewer plugin dependencies
  ++ lib.optionals withImageViewer [
    imagemagick
    ffmpeg
  ]
  # ADB plugin dependency
  ++ lib.optional withADB android-tools
  # GitGutter plugin dependency
  ++ lib.optional withGitGutter git
  # Python plugin support
  ++ lib.optionals withPython (
    with python3Packages;
    [
      python
      cffi
      pcpp
    ]
  );

  cmakeFlags = [
    # Basic plugins (always enabled by default, but can be disabled)
    (lib.cmakeBool "ALIGN" withAlign)
    (lib.cmakeBool "AUTOWRAP" withAutowrap)
    (lib.cmakeBool "TRUNCATE" withTruncate)
    (lib.cmakeBool "CALC" withCalc)
    (lib.cmakeBool "COMPARE" withCompare)
    (lib.cmakeBool "DRAWLINE" withDrawline)
    (lib.cmakeBool "EDITCASE" withEditcase)
    (lib.cmakeBool "EDITORCOMP" withEditorcomp)
    (lib.cmakeBool "FARFTP" withFarftp)
    (lib.cmakeBool "FILECASE" withFilecase)
    (lib.cmakeBool "INCSRCH" withIncsrch)
    (lib.cmakeBool "INSIDE" withInside)
    (lib.cmakeBool "SIMPLEINDENT" withSimpleindent)
    (lib.cmakeBool "TMPPANEL" withTmppanel)
    (lib.cmakeBool "HEXITOR" withHexitor)
    (lib.cmakeBool "OPENWITH" withOpenwith)
    (lib.cmakeBool "EDSORT" withEdsort)
    (lib.cmakeBool "MEMO" withMemo)

    # Feature flags
    (lib.cmakeBool "USEUCD" withUCD)
    (lib.cmakeBool "COLORER" withColorer)
    (lib.cmakeBool "MULTIARC" withMultiArc)
    (lib.cmakeBool "NETROCKS" withNetRocks)
    (lib.cmakeBool "AWS_S3" (withNetRocks && withAWS))
    (lib.cmakeBool "IMAGEVIEWER" withImageViewer)
    (lib.cmakeBool "ADB" withADB)
    (lib.cmakeBool "GITGUTTER" withGitGutter)
    (lib.cmakeBool "PYTHON" withPython)
    (lib.cmakeBool "ARCLITE" withArclite)

    # Backend setup
    (lib.cmakeBool "USESDL" withSDL)
    (lib.cmakeBool "TTYX" withTTYX)
    (lib.cmakeBool "USEWX" withGUI)
  ]
  ++ lib.optionals withPython [
    (lib.cmakeFeature "VIRTUAL_PYTHON" "python")
    (lib.cmakeFeature "VIRTUAL_PYTHON_VERSION" "python")
  ];

  runtimeDeps = [
    unzip
    zip
    p7zip
    xz
    gzip
    bzip2
    gnutar
  ]
  # Git is needed for GitGutter plugin
  ++ lib.optional withGitGutter git
  # ADB tools for ADB plugin
  ++ lib.optional withADB android-tools;

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  ''
  # Link 7z plugin only if Arclite is enabled
  + lib.optionalString withArclite ''
    # Link 7z plugin
    echo "Linking 7z libraries..."
    mkdir -p $out/lib/far2l/Plugins/arclite/plug/
    for file in ${_7z-far}/lib/*; do
      ln -sf "$file" "$out/lib/far2l/Plugins/arclite/plug/"
    done
  '';

  meta = {
    description = "Linux port of FAR Manager v2 with enhanced plugin support";
    homepage = "https://github.com/elfmz/far2l";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ hypersw tempergate ];
    platforms = lib.platforms.unix;
  };
}