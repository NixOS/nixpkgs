{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, rocksdb_6_23
, Security
}:
let
  rocksdb = rocksdb_6_23;
in
rustPlatform.buildRustPackage {
  pname = "electrs-esplora";
  # last tagged versoin is far behind master
  version = "20230218";

  src = fetchFromGitHub {
    owner = "Blockstream";
    repo = "electrs";
    rev = "adedee15f1fe460398a7045b292604df2161adc0";
    hash = "sha256-KnN5C7wFtDF10yxf+1dqIMUb8Q+UuCz4CMQrUFAChuA=";
  };

  cargoHash = "sha256-tM5IFiIYX2SlAp6Q5uccVjW6TgOf5MfoFrLXz3GlZ90=";

  # needed for librocksdb-sys
  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  # link rocksdb dynamically
  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  # rename to avoid a name conflict with other electrs package
  postInstall = ''
    mv $out/bin/electrs $out/bin/electrs-esplora
  '';

  meta = with lib; {
    description = "Blockstream's re-implementation of Electrum Server for Esplora";
    homepage = "https://github.com/Blockstream/electrs";
    license = licenses.mit;
    maintainers = with maintainers; [ dpc ];
  };
}
