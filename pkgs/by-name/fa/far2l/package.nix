{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  makeWrapper,
  cmake,
  ninja,
  pkg-config,
  m4,
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
  nix-update-script,

  # Backend options
  withTTYX ? true,
  libx11,
  withGUI ? true,
  wxwidgets_3_2,
  withUCD ? true,
  libuchardet,

  # Plugins
  withColorer ? true,
  spdlog,
  libxml2,
  withMultiArc ? true,
  libarchive,
  pcre,
  withNetRocks ? true,
  openssl,
  libssh,
  samba,
  libnfs,
  neon,
  withPython ? false,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "far2l";
  version = "2.9.0-unstable-27-08-2026";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "59354e96e366e0bf3a2fcd9d76c45cf5ec6d0c30";
    hash = "sha256-9mSi3gqZ2jpgUawD3Jr2Pmn1shLpySuFCh4iOZe7CO8=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    m4
    perl
    makeWrapper
  ];

  buildInputs =
    lib.optional withTTYX libx11
    ++ lib.optional withGUI wxwidgets_3_2
    ++ lib.optional withUCD libuchardet
    ++ lib.optionals withColorer [
      spdlog
      libxml2
    ]
    ++ lib.optionals withMultiArc [
      libarchive
      pcre
    ]
    ++ lib.optionals withNetRocks [
      openssl
      libssh
      libnfs
      neon
    ]
    ++ lib.optional (withNetRocks && !stdenv.hostPlatform.isDarwin) samba # broken on darwin
    ++ lib.optionals withPython (
      with python3Packages;
      [
        python
        cffi
        debugpy
        pcpp
      ]
    );

  postPatch = ''
    patchShebangs python/src/prebuild.sh
    patchShebangs far2l/bootstrap/view.sh
  '';

  cmakeFlags = [
    (lib.cmakeBool "TTYX" withTTYX)
    (lib.cmakeBool "USEWX" withGUI)
    (lib.cmakeBool "USEUCD" withUCD)
    (lib.cmakeBool "COLORER" withColorer)
    (lib.cmakeBool "MULTIARC" withMultiArc)
    (lib.cmakeBool "NETROCKS" withNetRocks)
    (lib.cmakeBool "PYTHON" withPython)
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
  ];

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  passthru.updateScript = nix-update-script { extraArgs = "--version=branch=master"; };

  meta = {
    description = "Linux port of FAR Manager v2, a program for managing files and archives in Windows operating systems";
    homepage = "https://github.com/elfmz/far2l";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ smakarov ];
    platforms = lib.platforms.unix;
  };
}
