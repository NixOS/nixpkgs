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
    cargoHash = "sha256-ka91IsmBGBYts4U9X4uZDUMeS9adPn3MKl2BY4ZKDCY=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  liberty-parser = rec {
    pname = "liberty-parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/liberty/lib-rust/liberty-parser";
    cargoHash = "sha256-7yUD8M3efisuVoH3/R+Pk2CP4mizSinrqeuy3uqkq2c=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  sdf_parse = rec {
    pname = "sdf_parse";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/sdf/sdf_parse";
    cargoHash = "sha256-6uzufy3S21vHJYgx9sItxQyccG0g/Zz1r2xHsYoQPRM=";

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  spef-parser = rec {
    pname = "spef-parser";
    version = "0.2.4";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/spef/spef-parser";
    cargoHash = "sha256-KTd3HVKV8hRCXf56FPksYGVJNDdlmMMIcSEk1MMGLsw=";

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  vcd_parser = rec {
    pname = "vcd_parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/vcd/vcd_parser";
    cargoHash = "sha256-1y1nPNfx23MyIJUV+E6mMuDOhdob0BDGuQwOl0Le/lE=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
  verilog-parser = rec {
    pname = "verilog-parser";
    version = "0.1.0";
    src = rootSrc;
    sourceRoot = "${src.name}/src/database/manager/parser/verilog/verilog-rust/verilog-parser";
    cargoHash = "sha256-Z/LXQzQ0m1lQdIPaWQ5rs2EAu/mbyi2JvrjGYVmKONs=";

    doCheck = false;

    nativeBuildInputs = [ rustPlatform.bindgenHook ];
  };
})
