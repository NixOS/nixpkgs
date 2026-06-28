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
  withUCD ? true,
  libuchardet,

  # Plugins (all are enabled by default)
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
  gnutls,
  libtasn1,
  p11-kit,

  withAWS ? true,
  aws-sdk-cpp,
  withImageViewer ? true,
  imagemagick,
  ffmpeg,
  withADB ? true,
  android-tools,
  withMTP ? true,
  libmtp,
  libusb1,
  withArclite ? true, # Archive support with custom 7z plugin
  _7zz, # 7zip plugin (only used if withArclite is true)
  withAlign ? true, # Align plugin
  withAutowrap ? true, # Autowrap plugin
  withTruncate ? true, # Truncate plugin
  withCalc ? true, # Calculator plugin
  withCompare ? true, # Compare files plugin
  withDrawline ? true, # Draw line plugin
  withEditcase ? true, # Change case plugin
  withEditorcomp ? true, # Editor completion plugin
  withFarftp ? true, # FTP client plugin
  withFilecase ? true, # File case plugin
  withIncsrch ? true, # Incremental search plugin
  withInside ? true, # Inside plugin
  withSimpleindent ? true, # Simple indent plugin
  withTmppanel ? true, # Temporary panel plugin
  withHexitor ? true, # Hex editor plugin
  withOpenwith ? true, # Open with plugin
  withEdsort ? true, # Editor sort plugin
  withMemo ? true, # Memo plugin

  withPython ? false,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    tag = "v_${version}";
    hash = "sha256-LP+agJrYxjH6vLAg6cJTU4/9jYGF9iaZzxA7hozDKNY=";
  };

  patches = [
    # Fix sudo helper stealing TTY input in mortal mode, see https://github.com/elfmz/far2l/issues/3425
    (fetchpatch {
      url = "https://github.com/elfmz/far2l/commit/d9f96544adf36d93de813f2f918b78a6f37c61e4.patch";
      sha256 = "sha256-hkFunNxey7A47va8Rm0ZOknM0jPuuT9AL5nfXdssE8s=";
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
    # UCD plugin
    ++ lib.optional withUCD libuchardet
    # Colorer plugin
    ++ lib.optionals withColorer [
      spdlog
      libxml2
    ]
    # MultiArc plugin
    ++ lib.optionals withMultiArc [
      libarchive
    ]
    # NetRocks plugin
    ++ lib.optionals withNetRocks [
      openssl
      libssh
      libnfs
      neon
      gnutls
      libtasn1
      p11-kit
    ]
    ++ lib.optional (withNetRocks && withAWS) aws-sdk-cpp
    # Samba support for NetRocks (broken on darwin)
    ++ lib.optional (withNetRocks && !stdenv.hostPlatform.isDarwin) samba
    # ImageViewer plugin
    ++ lib.optionals withImageViewer [
      imagemagick
      ffmpeg
    ]
    # ADB plugin
    ++ lib.optional withADB android-tools
    #  MTP plugin
    ++ lib.optionals withMTP [
      libmtp
      libusb1
    ]
    # Python plugins support
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

    # Additional plugins
    (lib.cmakeBool "USEUCD" withUCD)
    (lib.cmakeBool "COLORER" withColorer)
    (lib.cmakeBool "MULTIARC" withMultiArc)
    (lib.cmakeBool "NETROCKS" withNetRocks)
    (lib.cmakeBool "AWS_S3" (withNetRocks && withAWS))
    (lib.cmakeBool "IMAGEVIEWER" withImageViewer)
    (lib.cmakeBool "ADB" withADB)
    (lib.cmakeBool "MTP" withMTP)
    (lib.cmakeBool "PYTHON" withPython)
    (lib.cmakeBool "ARCLITE" withArclite)

    # Backend setup
    (lib.cmakeBool "USESDL" withSDL)
    (lib.cmakeBool "TTYX" withTTYX)
    (lib.cmakeBool "USEWX" withGUI)
  ]
  ++ lib.optionals withMTP [
    (lib.cmakeBool "MTP_SYSTEM_LIBUSB" true)
    (lib.cmakeBool "MTP_SYSTEM_LIBMTP" true)
  ]
  ++ lib.optionals withPython [
    (lib.cmakeFeature "VIRTUAL_PYTHON" "python")
    (lib.cmakeFeature "VIRTUAL_PYTHON_VERSION" "python")
  ];

  runtimeDeps = [
    unzip
    zip
    xz
    gzip
    bzip2
    gnutar
  ]
  # Tools for ADB plugin
  ++ lib.optional withADB android-tools;

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  ''
  # Link 7z plugin if Arclite is enabled
  + lib.optionalString withArclite ''
    # Link 7z plugin
    echo "Linking 7z libraries..."
    mkdir -p $out/lib/far2l/Plugins/arclite/plug/
    for file in ${_7zz.lib}/lib/*; do
      ln -sf "$file" "$out/lib/far2l/Plugins/arclite/plug/"
    done
  '';

  meta = {
    description = "Linux port of FAR Manager v2 with enhanced plugin support";
    homepage = "https://github.com/elfmz/far2l";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ smakarov ];
    platforms = lib.platforms.unix;
  };
}
