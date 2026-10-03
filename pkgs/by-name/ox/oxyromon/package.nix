{
  lib,
  fetchFromGitHub,
  bchunk,
  cdrkit,
  ctrtool,
  dolphin-emu,
  flips,
  makeWrapper,
  mame,
  maxcso,
  nsz,
  p7zip,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  wiimms-iso-tools,
  xdelta,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxyromon";
  version = "0.22.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "alucryd";
    repo = "oxyromon";
    tag = finalAttrs.version;
    hash = "sha256-m5LxTsqfNdr6sgKxK1kLBOT7QGfFLc8GQUqATsL1a38=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  cargoHash = "sha256-MbaK2HuIep5Yp4pNRs5X7moSzdP/Kj7jZ/zakok9oIU=";

  # Requires internet access
  doCheck = false;

  postFixup =
    let
      runtimeDeps = [
        # disc images
        bchunk
        cdrkit
        p7zip
        # rom patching
        flips
        xdelta
        # console-specific tools
        ctrtool
        dolphin-emu
        mame.tools
        maxcso
        nsz
        wiimms-iso-tools
      ];
    in
    ''
      wrapProgram $out/bin/oxyromon \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Rusty ROM organizer";
    longDescription = ''
      oxyROMon is a cross-platform opinionated CLI ROM organizer written in Rust.
      Like most ROM managers, it checks ROM files against known good databases.
      It is designed with archiving in mind, as such it only supports original and lossless ROM formats.
      It can however export in various popular lossy formats, leaving the lossless ROM files untouched.
      Sorting can be done in regions mode, in so-called 1G1R mode, or both.
      Console, computer and arcade (WIP) systems are supported using Logiqx DAT files.
      The first two require No-Intro or Redump DAT files, while the latter makes use MAME or FBNeo DAT files.
    '';
    homepage = "https://github.com/alucryd/oxyromon";
    changelog = "https://github.com/alucryd/oxyromon/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dansbandit ];
    platforms = lib.platforms.unix;
    mainProgram = "oxyromon";
  };
})
