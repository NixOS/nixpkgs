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
  version = "0-unstable-2024-08-21";

  src = fetchFromGitHub {
    repo = "gf";
    owner = "nakst";
    rev = "40f2ae604f3b94b7f818680ac53d4683c629bcf3";
    hash = "sha256-Z8hW/GQjnnojoLeetrBlMnAJ9sP9ELv1lSQJjYPxtRc=";
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
