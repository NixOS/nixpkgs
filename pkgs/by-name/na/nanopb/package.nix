{ stdenvNoCC
, callPackage
, fetchFromGitHub
, buildPackages
, lib
, enable_malloc ? false
, no_packed_structs ? false
, max_required_fields ? null
, field_32bit ? false
, no_errmsg ? false
, buffer_only ? false
, system_header ? null
, without_64bit ? false
, encode_arrays_unpacked ? false
, convert_double_float ? false
, validate_utf8 ? false
, little_endian_8bit ? false
, c99_static_assert ? false
, no_static_assert ? false
}:
stdenvNoCC.mkDerivation (self:
let
  generator-out = buildPackages.callPackage ./generator-out.nix { inherit (self) src version; };
  python-module = buildPackages.callPackage ./python-module.nix {
    inherit (self) version;
    inherit (self.passthru) generator-out;
  };
  python3 = buildPackages.python3.override {
    packageOverrides = _: _: {
      nanopb-proto = self.passthru.python-module;
    };
  };
  generator = buildPackages.callPackage ./generator.nix {
    inherit python3;
    inherit (self) version;
    inherit (self.passthru) generator-out;
  };
  runtime = callPackage ./runtime.nix {
    inherit python3;
    inherit (self) src version;
    inherit
      enable_malloc
      no_packed_structs
      max_required_fields
      field_32bit
      no_errmsg
      buffer_only
      system_header
      without_64bit
      encode_arrays_unpacked
      convert_double_float
      validate_utf8
      little_endian_8bit
      c99_static_assert
      no_static_assert;
  };
in
{
  pname = "nanopb";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "nanopb";
    repo = "nanopb";
    rev = self.version;
    hash = "sha256-LfARVItT+7dczg2u08RlXZLrLR7ScvC44tgmcy/Zv48=";
  };

  dontPatch = true;
  dontUnpack = true;

  propagatedNativeBuildInputs = [ generator ];

  propagatedBuildInputs = [ runtime ];

  postInstall = ''
    mkdir $out
    ln -s ${generator}/bin $out/bin
    ln -s ${runtime}/include $out/include
    ln -s ${runtime}/lib $out/lib
    mkdir -p $out/share/nanopb/generator/proto
    ln -s ${self.src}/generator/proto/nanopb.proto $out/share/nanopb/generator/proto/nanopb.proto
  '';

  passthru = {
    inherit runtime generator-out python-module generator;
    tests = {
      simple-proto2 = callPackage ./test-simple-proto2 { };
      simple-proto3 = callPackage ./test-simple-proto3 { };
      message-with-annotations = callPackage ./test-message-with-annotations { };
      message-with-options = callPackage ./test-message-with-options { };
    };
  };

  meta = with lib; {
    platforms = platforms.all;

    description = "Protocol Buffers with small code size";
    homepage = "https://jpa.kapsi.fi/nanopb/";
    license = licenses.zlib;
    maintainers = with maintainers; [ kalbasit liarokapisv ];

    longDescription = ''
      Nanopb is a small code-size Protocol Buffers implementation in ansi C. It
      is especially suitable for use in microcontrollers, but fits any memory
      restricted system.

      - Homepage: jpa.kapsi.fi/nanopb
      - Documentation: jpa.kapsi.fi/nanopb/docs
      - Downloads: jpa.kapsi.fi/nanopb/download
      - Forum: groups.google.com/forum/#!forum/nanopb

      In order to use the nanopb options in your proto files, you'll need to
      tell protoc where to find the nanopb.proto file.
      You can do so with the --proto_path (-I) option to add the directory
      ''${nanopb}/share/nanopb/generator/proto like so:

      protoc --proto_path=. --proto_path=''${nanopb}/share/nanopb/generator/proto --plugin=protoc-gen-nanopb=''${nanopb}/bin/protoc-gen-nanopb --nanopb_out=out file.proto
    '';
  };
})

