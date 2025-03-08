{
  lib,
  lldb,
  makeWrapper,
  rustPlatform,
  stdenv,

  pname,
  src,
  version,
}:
let
  LLVM_TRIPLE = stdenv.hostPlatform.config;
in
rustPlatform.buildRustPackage {
  pname = "${pname}-adapter";
  inherit version src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-Nh4YesgWa1JR8tLfrIRps9TBdsAfilXu6G2/kB08co8=";

  # Environment variables, based on <https://github.com/vadimcn/codelldb/blob/master/cargo_config.unix.toml>
  # The LLDB_* variables are used in adapter/lldb/build.rs.
  "CC_${LLVM_TRIPLE}" = "${stdenv.cc}/bin/cc";
  "CXX_${LLVM_TRIPLE}" = "${stdenv.cc}/bin/c++";
  LLDB_INCLUDE = "${lib.getDev lldb}/include";
  LLDB_LINK_LIB = "lldb";
  LLDB_LINK_SEARCH = "${lib.getLib lldb}/lib";

  nativeBuildInputs = [ makeWrapper ];

  buildAndTestSubdir = "adapter";

  # There's isn't much point in enabling the `weaklink` feature
  # when we provide lldb via Nix.
  # buildFeatures = [ "weaklink" ];

  cargoBuildFlags = [
    "--bin=codelldb"
  ];

  postFixup = ''
    mkdir -p $out/share/{adapter,lang_support}
    mv $out/bin/* $out/share/adapter
    cp -r adapter/scripts $out/share/adapter
    cp -t $out/share/lang_support lang_support/*.py
    ln -s ${lib.getLib lldb} $out/share/lldb
    makeWrapper $out/share/adapter/codelldb $out/bin/codelldb \
      --set-default LLDB_DEBUGSERVER_PATH "${lib.getBin lldb}/bin/lldb-server"
  '';

  # Tests fail to build (as of version 1.11.4).
  doCheck = false;
}
