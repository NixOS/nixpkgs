{ stdenv }:
stdenv.mkDerivation rec {
  name = "really";
  version = "";

  src = fetchGit {
    url = "https://www.chiark.greenend.org.uk/ucgi/~ian/githttp/chiark-utils.git";
    rev = "310750eda00f8825bcde2f4f7cbd786a9f81fe01";
  };

  nativeBuildInputs = [
  ];

  buildPhase = ''
    gcc -o really -DREALLY_CHECK_GID=0 cprogs/{really.c,myopt.c}
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/man/man8}
    cp really $out/bin
    cp cprogs/really.8 $out/share/man/man8
  '';
}
