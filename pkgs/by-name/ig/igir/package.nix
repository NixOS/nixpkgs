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
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-EKi1m2p4/7E/godxEPnaGaqkRX6PlSbqQYQXw+Eg5hA=";
  };

  npmDepsHash = "sha256-98+DFC7j3lmr9GGnDbrzChzGJG1uU1TTr429JAx7310=";

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
