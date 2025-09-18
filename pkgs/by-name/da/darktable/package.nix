{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  cmake,
  desktop-file-utils,
  intltool,
  llvmPackages,
  ninja,
  perl,
  pkg-config,
  wrapGAppsHook3,
  saxon,

  # buildInputs
  SDL2,
  adwaita-icon-theme,
  alsa-lib,
  cairo,
  curl,
  exiv2,
  glib,
  glib-networking,
  gmic,
  graphicsmagick,
  gtk3,
  icu,
  ilmbase,
  isocodes,
  jasper,
  json-glib,
  lcms2,
  lensfun,
  lerc,
  libaom,
  libavif,
  libdatrie,
  libepoxy,
  libexif,
  libgcrypt,
  libgpg-error,
  libgphoto2,
  libheif,
  libjpeg,
  libjxl,
  libpng,
  librsvg,
  libsecret,
  libsysprof-capture,
  libthai,
  libtiff,
  libwebp,
  libxml2,
  lua,
  util-linux,
  openexr,
  openjpeg,
  osm-gps-map,
  pcre2,
  portmidi,
  pugixml,
  sqlite,
  # Linux only
  colord,
  colord-gtk,
  libselinux,
  libsepol,
  libX11,
  libXdmcp,
  libxkbcommon,
  libXtst,
  ocl-icd,
  # Darwin only
  gtk-mac-integration,

  versionCheckHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "5.2.1";
  pname = "darktable";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    hash = "sha256-AvGqmuk5See8VMNO61/5LCuH+V0lR4Zd9VxgRnVk7hE=";
  };

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    intltool
    llvmPackages.llvm
    ninja
    perl
    pkg-config
    wrapGAppsHook3
    saxon # Use Saxon instead of libxslt to fix XSLT generate-id() consistency issues
  ];

  buildInputs = [
    SDL2
    adwaita-icon-theme
    cairo
    curl
    exiv2
    glib
    glib-networking
    gmic
    graphicsmagick
    gtk3
    icu
    ilmbase
    isocodes
    jasper
    json-glib
    lcms2
    lensfun
    lerc
    libaom
    #libavif # TODO re-enable once cmake files are fixed (#425306)
    libdatrie
    libepoxy
    libexif
    libgcrypt
    libgpg-error
    libgphoto2
    libheif
    libjpeg
    libjxl
    libpng
    librsvg
    libsecret
    libsysprof-capture
    libthai
    libtiff
    libwebp
    libxml2
    lua
    openexr
    openjpeg
    osm-gps-map
    pcre2
    portmidi
    pugixml
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    colord
    colord-gtk
    libselinux
    libsepol
    libX11
    libXdmcp
    libxkbcommon
    libXtst
    ocl-icd
    util-linux
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk-mac-integration
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DUSE_COLORD=OFF"
    "-DUSE_KWALLET=OFF"
  ];

  # darktable changed its rpath handling in commit
  # 83c70b876af6484506901e6b381304ae0d073d3c and as a result the
  # binaries can't find libdarktable.so, so change LD_LIBRARY_PATH in
  # the wrappers:
  preFixup =
    let
      libPathEnvVar = if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH";
      libPathPrefix =
        "$out/lib/darktable" + lib.optionalString stdenv.hostPlatform.isLinux ":${ocl-icd}/lib";
    in
    ''
      for f in $out/share/darktable/kernels/*.cl; do
        sed -r "s|#include \"(.*)\"|#include \"$out/share/darktable/kernels/\1\"|g" -i "$f"
      done

      gappsWrapperArgs+=(
        --prefix ${libPathEnvVar} ":" "${libPathPrefix}"
      )
    '';

  postPatch = ''
    patchShebangs ./tools/generate_styles_string.sh
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "release-";
    odd-unstable = true;
    url = "https://github.com/darktable-org/darktable.git";
  };

  meta = {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = "https://www.darktable.org";
    changelog = "https://github.com/darktable-org/darktable/releases/tag/release-${version}";
    license = lib.licenses.gpl3Plus;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      flosse
      mrVanDalo
      paperdigits
      freyacodes
    ];
  };
}
