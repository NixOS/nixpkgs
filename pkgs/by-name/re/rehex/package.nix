{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  zip,
  libicns,
  botan3,
  capstone,
  jansson,
  libunistring,
  wxGTK32,
  lua53Packages,
  perlPackages,
  gtk3,
  nix-update-script,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.63.3";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = "rehex";
    tag = version;
    hash = "sha256-o/ff0V0pMomXRu1DrD/m+M6364NisUI+8+RwryIsSLc=";
  };

  nativeBuildInputs = [
    pkg-config
    which
    wrapGAppsHook3
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libicns ];

  buildInputs = [
    botan3
    capstone
    jansson
    libunistring
    wxGTK32
  ]
  ++ (with lua53Packages; [
    lua
    busted
  ])
  ++ (with perlPackages; [
    perl
    TemplateToolkit
  ])
  ++ lib.optionals stdenv.hostPlatform.isLinux [ gtk3 ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "BOTAN_PKG=botan-3"
    "CXXSTD=-std=c++20"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-f Makefile.osx" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reverse Engineers' Hex Editor";
    longDescription = ''
      A cross-platform (Windows, Linux, Mac) hex editor for reverse
      engineering, and everything else.
    '';
    homepage = "https://github.com/solemnwarning/rehex";
    changelog = "https://github.com/solemnwarning/rehex/raw/${version}/CHANGES.txt";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      markus1189
      wegank
    ];
    platforms = lib.platforms.all;
    mainProgram = "rehex";
  };
}
