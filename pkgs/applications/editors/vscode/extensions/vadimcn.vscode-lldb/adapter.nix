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
rustPlatform.buildRustPackage {
  pname = "${pname}-adapter";
  inherit version src;

  cargoHash = "sha256-e/Jki/4pCs0qzaBVR4iiUhdBFmWlTZYREQkuFSoWYFo=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ lldb ];

  nativeBuildInputs = [ makeWrapper ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin { NIX_LDFLAGS = "-llldb -lc++abi"; };

  buildAndTestSubdir = "adapter";

  buildFeatures = [ "weak-linkage" ];

  cargoBuildFlags = [
    "--lib"
    "--bin=codelldb"
  ];

  postFixup = ''
    mkdir -p $out/share/{adapter,formatters}
    # codelldb expects libcodelldb.so to be in the same
    # directory as the executable, and can't find it in $out/lib.
    # To make codelldb executable as a standalone,
    # we put all files in $out/share, and then wrap the binary in $out/bin.
    mv $out/bin/* $out/share/adapter
    cp $out/lib/* $out/share/adapter
    cp -r adapter/scripts $out/share/adapter
    cp -t $out/share/formatters formatters/*.py
    ln -s ${lib.getLib lldb} $out/share/lldb
    makeWrapper $out/share/adapter/codelldb $out/bin/codelldb \
      --set-default LLDB_DEBUGSERVER_PATH "${lldb.out}/bin/lldb-server"
  '';

  patches = [ ./patches/adapter-output-shared_object.patch ];

  # Tests are linked to liblldb but it is not available here.
  doCheck = false;
}
