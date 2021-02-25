{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
}:
buildGoModule rec {
  pname = "garble";
  version = "20200107";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "835f4aadf321521acf06aac4d5068473dc4b2ac1";
    sha256 = "sha256-NodsVHRll2YZoxrhmniJvelQOStG82u3kJyc0t8OXD8=";
  };

  vendorSha256 = "sha256-x2fk2QmZDK2yjyfYdK7x+sQjvt7tuggmm8ieVjsNKek=";

  preBuild = ''
    # https://github.com/burrowers/garble/issues/184
    substituteInPlace testdata/scripts/tiny.txt \
      --replace "{6,8}" "{4,8}"
  '' + lib.optionalString (!stdenv.isx86_64) ''
    # The test assumex amd64 assembly
    rm testdata/scripts/asm.txt
  '';

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [ davhau ];
    license = lib.licenses.bsd3;
  };
}
