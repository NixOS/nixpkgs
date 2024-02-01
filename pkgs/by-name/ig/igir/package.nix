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
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "emmercm";
    repo = "igir";
    rev = "v${version}";
    hash = "sha256-MlLnnwlqFkzSZi+6OGS/ZPYRPjV7CY/piFvilwhhR9A=";
  };

  npmDepsHash = "sha256-yVo2ZKu2lEOYG12Gk5GQXamprkP5jEyKlSTZdPjNWQM=";

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
    homepage = "https://igir.io";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms = platforms.linux;
  };
}
