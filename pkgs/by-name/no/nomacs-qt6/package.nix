{
  cmake,
  exiv2,
  fetchFromGitHub,
  kdePackages,
  lib,
  libraw,
  libtiff,
  opencv4,
  pkg-config,
  qt6,
  stdenv,
  withPlugins ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nomacs";
  rev = "9a3ef35";
  version = "20241125-${finalAttrs.rev}";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = finalAttrs.pname;
    inherit (finalAttrs) rev;
    fetchSubmodules = withPlugins; # NOTE: changed to true to get plugins. Does this have side effects?
    hash = "sha256-kVRbebyVRXqsc+NfyaXl7h8o9Yk8vdxT3ENeWjCEG78=";
  };

  # NOTE: fetch plugins as submodule (according to the docs it should work via .gitmodules)
  # https://github.com/nomacs/nomacs-plugins
  # How to _only_ get the plugins submodule? For now we just fetch all and delete everything else
  postFetch = ''
    rm -rf 3rd-party
  '';

  outputs =
    ["out"]
    # man pages are not installed on Darwin, see cmake/{Mac,Unix}BuildTarget.cmake
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) ["man"];

  sourceRoot = "${finalAttrs.src.name}/ImageLounge";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs =
    [
      exiv2
      libraw
      libtiff
      # Once python stops relying on `propagatedBuildInputs` (https://github.com/NixOS/nixpkgs/issues/272178), deprecate `cxxdev` and switch to `dev`;
      # note `dev` is selected by `mkDerivation` automatically, so one should omit `getOutput "dev"`;
      # see: https://github.com/NixOS/nixpkgs/pull/314186#issuecomment-2129974277
      (lib.getOutput "cxxdev" opencv4)
    ]
    # ++ (lib.optional stdenv.hostPlatform.isLinux qt6.qtwayland) # FIXME: is this now automatically propagated???
    # TODO: should we include qt-heif-image-plugin? It's not in nixpkgs yet, but it seems to be Qt5 only?
    ++ (with kdePackages; [
      kimageformats
      qtbase
      qtimageformats
      qtsvg
      qttools
      quazip
    ]);

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_OPENCV" true)
    (lib.cmakeBool "ENABLE_QUAZIP" true)
    (lib.cmakeBool "ENABLE_RAW" true)
    (lib.cmakeBool "ENABLE_TIFF" true)
    (lib.cmakeBool "ENABLE_TRANSLATIONS" true)
    (lib.cmakeBool "USE_SYSTEM_QUAZIP" true)
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,lib}
    mv $out/nomacs.app $out/Applications/nomacs.app
    mv $out/libnomacsCore.dylib $out/lib/libnomacsCore.dylib
  '';
  # FIXME:
  # why can't we have nomacs look in the "standard" plugin directory???
  # None of the wrap stuff worked...
  # Let's just instead move the plugin dir brute force
  postFixup = ''
    mv $out/lib/nomacs-plugins $out/bin/plugins
  '';

  meta = {
    homepage = "https://nomacs.org";
    description = "Qt-based image viewer";
    longDescription = ''
      nomacs is a free, open source image viewer, which supports multiple
      platforms. You can use it for viewing all common image formats including
      RAW and psd images.

      nomacs features semi-transparent widgets that display additional
      information such as thumbnails, metadata or histogram. It is able to
      browse images in zip or MS Office files which can be extracted to a
      directory. Metadata stored with the image can be displayed and you can add
      notes to images. A thumbnail preview of the current folder is included as
      well as a file explorer panel which allows switching between
      folders. Within a directory you can apply a file filter, so that only
      images are displayed whose filenames have a certain string or match a
      regular expression. Activating the cache allows for instantly switching
      between images.
    '';
    changelog = "https://github.com/nomacs/nomacs/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [gpl3Plus];
    mainProgram = "nomacs";
    maintainers = with lib.maintainers; [mindavi];
    inherit (kdePackages.qtbase.meta) platforms;
  };
})
