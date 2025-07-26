{ rustPlatform, rootSrc }:
let
  mkRustpkgs = _: p: rustPlatform.buildRustPackage p;
in
(builtins.mapAttrs mkRustpkgs {
  iir-rust = rec {
    pname = "iir-rust";
    version = "0.1.3";
    src = rootSrc;
    sourceRoot = "${src.name}/src/operation/iIR/source/iir-rust/iir";

    cargoHash = "sha256-CV1e/f3oCKW5mTbQnFBnp7E2d9nFyDwY3qclP2HwdPM=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  liberty-parser = rec {
    pname = "liberty-parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/liberty/lib-rust/liberty-parser";

    cargoHash = "sha256-nRIOuSz5ImENvKeMAnthmBo+2/Jy5xbM66xkcfVCTMI=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  sdf_parse = rec {
    pname = "sdf_parse";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/sdf/sdf_parse";

    cargoHash = "sha256-PORA/9DDIax4lOn/pzmi7Y8mCCBUphMTzbBsb64sDl0=";

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  spef-parser = rec {
    pname = "spef-parser";
    version = "0.2.4";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/spef/spef-parser";

    cargoHash = "sha256-Qr/oXTqn2gaxyAyLsRjaXNniNzIYVzPGefXTdkULmYk=";

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  vcd_parser = rec {
    pname = "vcd_parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/vcd/vcd_parser";

    cargoHash = "sha256-xcfVzDrnW4w3fU7qo6xzSQeIH8sEbEyzPF92F5tDcAk=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  verilog-parser = rec {
    pname = "verilog-parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/verilog/verilog-rust/verilog-parser";

    cargoHash = "sha256-ooxY8Q8bfD+klBGfpTDD3YyWptEOGGHDoyamhjlSNTM=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
})
