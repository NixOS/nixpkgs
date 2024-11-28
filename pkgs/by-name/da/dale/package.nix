{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libffi
, llvm_13
, perl
}:

stdenv.mkDerivation {
  pname = "dale";
  version = "20220411";

  src = fetchFromGitHub {
    owner = "tomhrr";
    repo = "dale";
    rev = "7386ef2d8912c60c6fb157a1e5cd772e15eaf658";
    sha256 = "sha256-LNWqrFuEjtL7zuPTBfe4qQWr8IrT/ldQWSeDTK3Wqmo=";
  };

  nativeBuildInputs = [ cmake pkg-config llvm_13.dev ];
  buildInputs = [ libffi llvm_13 ];

  nativeCheckInputs = [ perl ];

  checkTarget = "tests";

  meta = with lib; {
    description = "Lisp-flavoured C";
    longDescription = ''
      Dale is a system (no GC) programming language that uses
      S-expressions for syntax and supports syntactic macros.
    '';
    homepage = "https://github.com/tomhrr/dale";
    license = licenses.bsd3;
    maintainers = with maintainers; [ amiloradovsky ];
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    # failed on Darwin: linker couldn't find the FFI lib
  };
}
