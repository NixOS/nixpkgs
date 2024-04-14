{ lib
, buildNpmPackage
, fetchFromGitHub

# for patching bundled 7z binary from the 7zip-bin node module
# at lib/node_modules/igir/node_modules/7zip-bin/linux/x64/7za
, autoPatchelfHook
, stdenv
}:

buildNpmPackage rec {
  pname = "igir";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-bJPUGB9fyeOb5W9EzQldh4rRJQBat58MgjjfS1qh66w=";
  };

  npmDepsHash = "sha256-q8gpx5zwiO/7ZBB/YruhCUgukp71sfJju8nmF6SwTrc=";

  # I have no clue why I have to do this
  postPatch = ''
    patchShebangs scripts/update-readme-help.sh
  '';

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ stdenv.cc.cc.lib ];

  # from lib/node_modules/igir/node_modules/@node-rs/crc32-linux-x64-musl/crc32.linux-x64-musl.node
  # Irrelevant to our use
  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  meta = with lib; {
    description = "A video game ROM collection manager to help filter, sort, patch, archive, and report on collections on any OS";
    mainProgram = "igir";
    homepage = "https://igir.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
