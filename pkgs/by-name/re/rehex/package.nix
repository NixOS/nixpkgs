{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
}:

stdenv.mkDerivation rec {
  pname = "rehex";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "solemnwarning";
    repo = "rehex";
    tag = version;
    hash = "sha256-wFVAytrcRu3Ezy/VcbmXwl+X96QMa5KimjUoP07hmFg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/solemnwarning/rehex/commit/0cfe145e034019952383ad28a431f552a5567f89.patch";
      hash = "sha256-PmqvjAXjqZM1BuqHHyQC5qXubTDYlE3VR1DiCCx3aeU=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    which
    zip
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libicns ];

  buildInputs =
    [
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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "-f Makefile.osx" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-liconv";
  };

  enableParallelBuilding = true;

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
