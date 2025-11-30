{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ogre,
  freetype,
  boost,
  expat,
  libiconv,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "cegui";
  version = "0-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "paroj";
    repo = "cegui";
    rev = "a630bcc3f1e4b66edcf0fd00edcb9b29ad8446a3";
    hash = "sha256-9lZ7eBwmxZ33XNDJXQ2lbCcH5JyH0KoY1mj/g+2HOJs=";
  };

  patches = [
    ./cmake-minimum-required.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    ogre
    freetype
    boost
    expat
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  cmakeFlags = [
    "-DCEGUI_OPTION_DEFAULT_IMAGECODEC=OgreRenderer-0"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  passthru.updateScript = unstableGitUpdater {
    branch = "v0";
    # The above branch is separate from the branch with the latest tags, so the updater doesn't pick them up
    # This is what would be used to handle upstream's format, if it was able to see the tags
    # tagConverter = writeShellScript "cegui-tag-converter.sh" ''
    #   sed -e 's/^v//g' -e 's/-/./g'
    # '';
    hardcodeZeroVersion = true;
  };

  meta = with lib; {
    homepage = "http://cegui.org.uk/";
    description = "C++ Library for creating GUIs";
    mainProgram = "CEGUISampleFramework-0.9999";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
