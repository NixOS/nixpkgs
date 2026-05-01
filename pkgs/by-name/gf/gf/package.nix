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
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "93066aae8d7328c41f0da9985c680691fafa3fab";
    hash = "sha256-2nA9c8PAIr8o/of//WUI9XHZgVNtXYsnMaaTOdAMTwc=";
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
