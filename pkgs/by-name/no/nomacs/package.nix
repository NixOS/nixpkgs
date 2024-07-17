{
  lib,
  cmake,
  exiv2,
  fetchFromGitHub,
  libraw,
  libsForQt5,
  libtiff,
  opencv4,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nomacs";
  version = "3.19.0";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = finalAttrs.version;
    fetchSubmodules = false; # We'll use our own
    hash = "sha256-lpmM2GfMDlIp1vnbHMaOdicFcKH6LwEoKSETMt7C1NY=";
  };

  outputs =
    [ "out" ]
    # man pages are not installed on Darwin, see cmake/{Mac,Unix}BuildTarget.cmake
    ++ lib.optionals (!stdenv.isDarwin) [ "man" ];

  sourceRoot = "${finalAttrs.src.name}/ImageLounge";

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
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
    ++ (with libsForQt5; [
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

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,lib}
    mv $out/nomacs.app $out/Applications/nomacs.app
    mv $out/libnomacsCore.dylib $out/lib/libnomacsCore.dylib
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
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "nomacs";
    maintainers = with lib.maintainers; [
      AndersonTorres
      mindavi
    ];
    inherit (libsForQt5.qtbase.meta) platforms;
  };
})
