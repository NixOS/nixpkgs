{ mkDerivation, lib, fetchFromGitHub, fetchpatch, pkg-config, cmake, qtbase, qttools
, seafile-shared, jansson, libsearpc
, withShibboleth ? true, qtwebengine }:

mkDerivation rec {
  pname = "seafile-client";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafile-client";
    rev = "b4b944921c7efef13a93d693c45c997943899dec";
    sha256 = "2vV+6ZXjVg81JVLfWeD0UK+RdmpBxBU2Ozx790WFSyw=";
  };

  patches = [
    # Fix compilation failure with "error: template with C linkage", fixes #122505
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fix_build_with_glib2.diff?h=seafile-client&id=7be253aaa2bdb6771721f45aa08bc875c8001c5a";
      name = "fix_build_with_glib2.diff";
      sha256 = "0hl7rcqfr8k62c1pr133bp3j63b905izaaggmgvr1af4jibal05v";
    })
  ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [ qtbase qttools seafile-shared jansson libsearpc ]
    ++ lib.optional withShibboleth qtwebengine;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ]
    ++ lib.optional withShibboleth "-DBUILD_SHIBBOLETH_SUPPORT=ON";

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ seafile-shared ]}"
  ];

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafile-client";
    description = "Desktop client for Seafile, the Next-generation Open Source Cloud Storage";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eduardosm ];
  };
}
