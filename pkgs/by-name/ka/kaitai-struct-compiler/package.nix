{
  lib,
  stdenv,
  fetchzip,
  openjdk8,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "kaitai-struct-compiler";
  version = "0.11";

  src = fetchzip {
    url = "https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/${version}/kaitai-struct-compiler-${version}.zip";
    sha256 = "sha256-j9TEilijqgIiD0GbJfGKkU1FLio9aTopIi1v8QT1b+A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D $src/bin/kaitai-struct-compiler $out/bin/kaitai-struct-compiler
    ln -s $out/bin/kaitai-struct-compiler $out/bin/ksc
    cp -R $src/lib $out/lib
    wrapProgram $out/bin/kaitai-struct-compiler --prefix PATH : ${lib.makeBinPath [ openjdk8 ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/kaitai-io/kaitai_struct_compiler";
    description = "Compiler to generate binary data parsers in C++ / C# / Go / Java / JavaScript / Lua / Perl / PHP / Python / Ruby ";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ qubasa ];
    platforms = platforms.unix;
  };
}
