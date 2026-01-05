{
  lib,
  buildNpmPackage,
  fetchFromGitHub,

  # for patching bundled 7z binary from the 7zip-bin node module
  # at lib/node_modules/igir/node_modules/7zip-bin/linux/x64/7za
  autoPatchelfHook,
  stdenv,

  libusb1,
  libuv,
  libz,
  lz4,
  sdl2-compat,
  systemd,
}:

buildNpmPackage rec {
  pname = "igir";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-t0iGQC3U95707n4iVLbWynh3CadOPFKBEoXPg4rNjVo=";
  };

  npmDepsHash = "sha256-qFgyqh3e2A6D+MaEUoV1jGRp1wJKvB8Dcr5XPrezlSk=";

  # I have no clue why I have to do this
  postPatch = ''
    patchShebangs scripts/update-readme-help.sh
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    libusb1
    libuv
    libz
    lz4
    sdl2-compat
    systemd
  ];

  # from lib/node_modules/igir/node_modules/@node-rs/crc32-linux-x64-musl/crc32.linux-x64-musl.node
  # Irrelevant to our use
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  meta = with lib; {
    description = "Video game ROM collection manager to help filter, sort, patch, archive, and report on collections on any OS";
    mainProgram = "igir";
    homepage = "https://igir.io";
    changelog = "https://github.com/emmercm/igir/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mjm ];
    platforms = platforms.linux;
  };
}
