{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  libX11,
  pkg-config,
  gdb,
  freetype,
  freetypeSupport ? true,
  withExtensions ? true,
  extraFlags ? "",
  pluginsFile ? null,
}:

stdenv.mkDerivation {
  pname = "gf";
  version = "0-unstable-2025-02-04";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "9c1686439f97ae6e1ca8f1fb785b545303adfebc";
    hash = "sha256-0uABsjAVn+wAN8hMkM38CepSV4gYtIL0WHDq25TohZ0=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    libX11
    gdb
  ] ++ lib.optional freetypeSupport freetype;

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

  meta = with lib; {
    description = "GDB Frontend";
    homepage = "https://github.com/nakst/gf";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "gf2";
    maintainers = with maintainers; [ _0xd61 ];
  };
}
