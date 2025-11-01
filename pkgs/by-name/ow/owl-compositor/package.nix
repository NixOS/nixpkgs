{
  lib,
  clangStdenv,
  fetchFromGitHub,
  gnustep-back,
  wrapGNUstepAppsHook,
  libxkbcommon,
  makeWrapper,
  wayland,
  wayland-scanner,
  darwin,
}:

let
  stdenv = clangStdenv;
in

stdenv.mkDerivation {
  pname = "owl-compositor";
  version = "0-unstable-2021-11-10";

  src = fetchFromGitHub {
    owner = "owl-compositor";
    repo = "owl";
    rev = "91abf02613cd2ddb97be58b5b6703240320233a0";
    hash = "sha256-a+TznasOVEzSNrs66/y91AeMRDEfyd+WO5mO811hLj0=";
  };

  # use pregenerated nib files because generating them requires Xcode
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i "/ibtool/d" configure
    mkdir -p build/Owl.app/Contents/Resources/English.lproj
    cp ${./mac/MainMenu.nib} build/Owl.app/Contents/Resources/English.lproj/MainMenu.nib
    cp ${./mac/OwlPreferences.nib} build/Owl.app/Contents/Resources/English.lproj/OwlPreferences.nib
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    wayland-scanner
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
    darwin.bootstrap_cmds
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    wrapGNUstepAppsHook
  ];

  buildInputs = [
    libxkbcommon
    wayland
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gnustep-back
  ];

  preConfigure = ''
    mkdir -p build
    cd build
  '';

  configureScript = "../configure";

  # error: "Your gnustep-base was configured for the objc-nonfragile-abi but you are not using it now."
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    !stdenv.hostPlatform.isDarwin
  ) "-fobjc-runtime=gnustep-2.0";

  # ld: Seat/OwlPointer.o: undefined reference to symbol 'round@@GLIBC_2.2.5'
  env.NIX_LDFLAGS = "-lm";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    mv Owl.app $out/Applications
    makeWrapper $out/{Applications/Owl.app${lib.optionalString stdenv.hostPlatform.isDarwin "/Contents/MacOS"},bin}/Owl

    runHook postInstall
  '';

  meta = with lib; {
    description = "Portable Wayland compositor in Objective-C";
    homepage = "https://github.com/owl-compositor/owl";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
    mainProgram = "Owl";
  };
}
