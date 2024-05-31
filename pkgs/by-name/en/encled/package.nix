{ stdenv, lib, fetchFromGitHub, python3 }:
stdenv.mkDerivation {
  pname = "encled";
  version = "unstable-2022-07-23";

  src = fetchFromGitHub {
    owner = "amarao";
    repo = "sdled";
    rev = "60fd6c728112f2f1feb317355bdb1faf9d2f76da";
    sha256 = "1qygzjzsv305662317435nsc6r15k7r6qidp48lgspvy9x5xli73";
  };

  buildInputs = [ python3 ];

  dontBuild = true;
  installPhase = ''
    install -Dm0755 -t $out/bin/ encled
    install -Dm0644 -t $out/share/man/man8 encled.8
  '';

  meta = {
    description = "Control fault/locate indicators in disk slots in enclosures";
    mainProgram = "encled";
    homepage = "https://github.com/amarao/sdled";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.lheckemann ];
  };
}
