{
  lib,
  clangStdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  clang,
  git,
  libgeneral,
  libplist,
  curl,
}:
let
  libfwkeyfetch = clangStdenv.mkDerivation (finalAttrs: {
    pname = "libfwkeyfetch";
    version = "5";
    src = fetchFromGitHub {
      owner = "tihmstar";
      repo = "libfwkeyfetch";
      tag = finalAttrs.version;
      hash = "sha256-r/xyMsWfpjQqE+hGFq16QLRnj2DyEQgDw3CAxrb7fWM=";
      # Leave DotGit so that autoconfigure can read version from git tags
      leaveDotGit = true;
    };

    postPatch = ''
      # Checking for libgeneral version still fails
      sed -i 's/libgeneral >= 83/libgeneral >= 1/' configure.ac
      sed -i 's/libfragmentzip >= 70/libfragmentzip/' configure.ac
    '';

    nativeBuildInputs = [
      autoreconfHook
      git
      pkg-config
    ];

    buildInputs = [
      curl
      libgeneral
      libfragmentzip
    ];
    propagatedBuildInputs = [ libfragmentzip ];

    meta = {
      description = "Helper library used by usbmuxd2";
      homepage = "https://github.com/tihmstar/libgeneral";
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.all;
    };
  });
  libfragmentzip = clangStdenv.mkDerivation (finalAttrs: {
    pname = "libfragmentzip";
    version = "76";
    src = fetchFromGitHub {
      owner = "tihmstar";
      repo = "libfragmentzip";
      tag = finalAttrs.version;
      hash = "sha256-b0kAef4o4s82ZNdGuzAT/yFvIRDg/Xcx9pNn7VW1d2k=";
      # Leave DotGit so that autoconfigure can read version from git tags
      leaveDotGit = true;
    };

    postPatch = ''
      # Checking for libgeneral version still fails
      sed -i 's/libgeneral >= 80/libgeneral >= 1/' configure.ac
    '';

    nativeBuildInputs = [
      autoreconfHook
      git
      pkg-config
    ];

    buildInputs = [
      curl
      libgeneral
    ];

    meta = {
      description = "Helper library used by usbmuxd2";
      homepage = "https://github.com/tihmstar/libgeneral";
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.all;
    };
  });
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "img4tool";
  version = "217";

  src = fetchFromGitHub {
    owner = "tihmstar";
    repo = "img4tool";
    tag = finalAttrs.version;
    hash = "sha256-s0XKg69wSJl4dsyJaahRXoWoxHcQQGZf42v7Ni7OTdA=";
    # Leave DotGit so that autoconfigure can read version from git tags
    leaveDotGit = true;
  };

  postPatch = ''
    # Checking for libgeneral version still fails
    sed -i 's/libgeneral >= 75/libgeneral >= 1/' configure.ac
  '';

  nativeBuildInputs = [
    autoreconfHook
    clang
    git
    pkg-config
  ];

  buildInputs = [
    libgeneral
    libplist
    libfwkeyfetch
  ];

  meta = {
    description = "Socket daemon to multiplex connections from and to iOS devices";
    homepage = "https://github.com/tihmstar/img4tool";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "img4tool";
  };
})
