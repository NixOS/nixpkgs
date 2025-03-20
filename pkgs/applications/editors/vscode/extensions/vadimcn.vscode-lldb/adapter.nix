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
  # debugservers on macOS require the 'com.apple.security.cs.debugger'
  # entitlement which nixpkgs' lldb-server does not yet provide; see
  # <https://github.com/NixOS/nixpkgs/pull/38624> for details
  lldbServer =
    if stdenv.hostPlatform.isDarwin then
      "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/Resources/debugserver"
    else
      "${lldb.out}/bin/lldb-server";
in
rustPlatform.buildRustPackage {
  pname = "${pname}-adapter";
  inherit version src;

  useFetchCargoVendor = true;
  cargoHash = "sha256-7tGX8wt2bb1segoWbBEBwZbznOaAiAyh9i/JC5FKUBU=";

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
      --set-default LLDB_DEBUGSERVER_PATH "${lldbServer}"
  '';

  patches = [ ./patches/adapter-output-shared_object.patch ];

  # Tests are linked to liblldb but it is not available here.
  doCheck = false;

  passthru = { inherit lldbServer; };
}
