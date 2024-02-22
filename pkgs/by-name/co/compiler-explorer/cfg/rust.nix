{ utils
, writeText
, defaultGcc
, rustc
, rustfilt
}:
let
  rust =
    {
      supportsBinary = "true";
      objdumper = "${defaultGcc}/bin/objdump";
      stubRe = ''\bmain\b'';
      stubText = ''pub fn main() {/*stub provided by Compiler Explorer*/}'';
      binaryHideFuncRe = ''^(_.*|call_gmon_start|(de)?register_tm_clones|frame_dummy|.*@plt.*)$'';
      versionFlag = "-vV";
      libs = "";

      compilers = "&rust";
      linker = "${defaultGcc}/bin/gcc";
      defaultCompiler = "rust";
      demangler = "${rustfilt}/bin/rustfilt";
      group.rust.compilers = "rust";
      group.rust.compilerType = "rust";
      group.rust.isSemVer = "true";
      group.rust.unwiseOptions = "-Ctarget-cpu=native|target-cpu=native";
      group.rust.baseName = "rustc";
      group.rust.licenseLink = "https://github.com/rust-lang/rust/blob/master/COPYRIGHT";
      group.rust.licenseName = "Dual-licensed under Apache 2.0 and MIT terms";
      group.rust.licensePreamble = "Rust is licensed under the Apache License, Version 2.0 or the MIT license";
      group.rust.supportsBinary = "true";
      group.rust.supportsBinaryObject = "true";
      compiler.rust.exe = "${rustc}/bin/rustc";
      compiler.rust.semver = "${rustc.version}";

    };
in
writeText "rust.defaults.properties" ''
  ${utils.attrToDot rust }
''
