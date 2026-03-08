{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  libx11,
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
  version = "0-unstable-2025-12-31";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "9a5dbcc90dc9ca9580f6ce2854cd67e2e507b0c1";
    hash = "sha256-+1ERc7mQCwaov+NdL1cdIZeDtHr4wkuLHaSdR8w5u40=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libx11
    gdb
  ]
  ++ lib.optional freetypeSupport freetype;

  patches = [
    ./build-use-optional-freetype-with-pkg-config.patch
  ];

  postPatch =
    lib.optionalString withExtensions ''
      cp ./extensions_v5/extensions.cpp .
    ''
    + lib.optionalString (pluginsFile != null) ''
      cp ${pluginsFile} ./plugins.cpp
    '';

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

  meta = {
    description = "GDB Frontend";
    homepage = "https://github.com/nakst/gf";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "gf2";
    maintainers = with lib.maintainers; [ _0xd61 ];
  };
}
