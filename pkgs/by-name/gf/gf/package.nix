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
  version = "0-unstable-2025-09-21";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "5fc7f422c8344277601860646c6ff6e72c8e7041";
    hash = "sha256-YdeF4pBKLn3r3xM7ppX30D196RmO/P8WDj0Zsh7Vdmc=";
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
