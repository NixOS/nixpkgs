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
  systemdLibs,
}:

buildNpmPackage rec {
  pname = "igir";
  version = "5.7.2";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-atLfSkOw6nga8PY3rqEmUu4KZxPnmg3R+ocXuKYRs7s=";
  };

  npmDepsHash = "sha256-k6sVocmdDqKae9yEar1S3hOQlYkz6pAEcJzwbsyV/g0=";

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
    systemdLibs
  ];

  # from lib/node_modules/igir/node_modules/@node-rs/crc32-linux-x64-musl/crc32.linux-x64-musl.node
  # Irrelevant to our use
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  meta = {
    description = "Video game ROM collection manager to help filter, sort, patch, archive, and report on collections on any OS";
    mainProgram = "igir";
    homepage = "https://igir.io";
    changelog = "https://github.com/emmercm/igir/releases/tag/${src.rev}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ mjm ];
    platforms = lib.platforms.linux;
  };
}
