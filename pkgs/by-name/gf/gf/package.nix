{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  libX11,
  pkg-config,
  gdb,
  freetype,
  nix-update-script,
  freetypeSupport ? true,
  withExtensions ? true,
  extraFlags ? "",
  pluginsFile ? null,
}:

stdenv.mkDerivation {
  pname = "gf";
  version = "0-unstable-2025-11-09";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "64e7ece68a61d90db0dcc11a6d6eecab04af8561";
    hash = "sha256-BvPgBJ/2pEoe4hIgqYi5JXI0ihOJkc/pXAJK/Kf9lVg=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libX11
    gdb
  ]
  ++ lib.optional freetypeSupport freetype;

  patches = [
    ./build-use-optional-freetype-with-pkg-config.patch
  ];

  postPatch = [
    (lib.optionalString withExtensions ''
      cp ./extensions_v5/extensions.cpp .
    '')
    (lib.optionalString (pluginsFile != null) ''
      cp ${pluginsFile} ./plugins.cpp
    '')
  ];

  preConfigure = ''
    patchShebangs build.sh
  '';

  buildPhase = ''
    runHook preBuild
    extra_flags="${extraFlags} -DUI_FREETYPE_SUBPIXEL" ./build.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp gf2 "$out/bin/"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/gf2 --prefix PATH : ${lib.makeBinPath [ gdb ]}
  '';

  passthru.updateScript = nix-update-script { extraArgs = lib.singleton "--version=branch"; };

  meta = with lib; {
    description = "GDB Frontend";
    homepage = "https://github.com/nakst/gf";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "gf2";
    maintainers = with maintainers; [ _0xd61 ];
  };
}
