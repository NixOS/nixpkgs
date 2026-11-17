{
  lib,
  stdenv,
  fetchzip,
  jre,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaitai-struct-compiler";
  version = "0.11";

  src = fetchzip {
    url = "https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/${finalAttrs.version}/kaitai-struct-compiler-${finalAttrs.version}.zip";
    sha256 = "sha256-j9TEilijqgIiD0GbJfGKkU1FLio9aTopIi1v8QT1b+A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D $src/bin/kaitai-struct-compiler $out/bin/kaitai-struct-compiler
    ln -s $out/bin/kaitai-struct-compiler $out/bin/ksc
    cp -R $src/lib $out/lib
    wrapProgram $out/bin/kaitai-struct-compiler --prefix PATH : ${lib.makeBinPath [ jre ]}
  '';

  meta = {
    homepage = "https://github.com/kaitai-io/kaitai_struct_compiler";
    description = "Compiler to generate binary data parsers in C++ / C# / Go / Java / JavaScript / Lua / Perl / PHP / Python / Ruby ";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ qubasa ];
    platforms = lib.platforms.unix;
  };
})
