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
  _7zz,
  xz,
  nix-update-script,

  # Backend options
  withTTYX ? true,
  libx11,
  withGUI ? true,
  wxwidgets_3_2,
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
  withPython ? false,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "far2l";
  version = "2.9.0-unstable-06-09-2026";

  src = fetchFromGitHub {
    owner = "elfmz";
    repo = "far2l";
    rev = "1d45c50547f4459c13f3613cb89b09bf8d6139b1";
    hash = "sha256-/AxtL7L6YYKFrtdsUXiBQ1ljuqCBymkdajeMB2xlVrM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    perl
    makeWrapper
  ];

  buildInputs = [
    bash
  ]
  ++ lib.optional withTTYX libx11
  ++ lib.optional withGUI wxwidgets_3_2
  ++ lib.optional withUCD libuchardet
  ++ lib.optionals withColorer [
    spdlog
    libxml2
  ]
  ++ lib.optionals withMultiArc [
    libarchive
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
    chmod +x far2l/bootstrap/*.sh
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
    bash
    unzip
    zip
    xz
    gzip
    bzip2
    gnutar
  ];

  postInstall = ''
    wrapProgram $out/bin/far2l \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
    # Link 7z plugin
    echo "Linking 7z libraries..."
    mkdir -p $out/lib/far2l/Plugins/arclite/plug/
    for file in ${_7zz.lib}/lib/*; do
      ln -sf "$file" "$out/lib/far2l/Plugins/arclite/plug/"
    done
  '';

  passthru.updateScript = nix-update-script { extraArgs = "--version=branch=master"; };

  meta = {
    description = "Linux port of FAR Manager v2 with enhanced plugin support";
    homepage = "https://github.com/elfmz/far2l";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ smakarov ];
    platforms = lib.platforms.unix;
  };
})
