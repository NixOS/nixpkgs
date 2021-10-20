{ mkDerivation, lib, fetchFromGitLab, fetchpatch, qtsvg, qtbase, cmake, ninja, libcprime, libcsys }:

mkDerivation rec {
  pname = "coreaction";
  version = "4.2.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5qEZNLvbgLoAOXij0wXoVw2iyvytsYZikSJDm6F6ddc=";
  };

  patches = [
    ## Fix Plugin Error: "The shared library was not found." "libbatery.so"
    (fetchpatch {
      url = "https://gitlab.com/cubocore/coreapps/coreaction/-/commit/1d1307363614a117978723eaad2332e6e8c05b28.patch";
      sha256 = "039x19rsm23l9vxd5mnbl6gvc3is0igahf47kv54v6apz2q72l3f";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtsvg
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "A side bar for showing widgets from the C Suite";
    homepage = "https://gitlab.com/cubocore/coreapps/coreaction";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
