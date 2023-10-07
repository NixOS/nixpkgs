{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, ldc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dlang-dfmt";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "dlang-community";
    repo = "dfmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Qj/H2dlmUKMjXl/ykN0xpPScypoWJz2BIAO45m1GLH0=";
    fetchSubmodules = true;
  };

  patches = [
    # Prevent githash target from being run and add install target.
    # https://github.com/dlang-community/dfmt/pull/597
    (fetchpatch {
      url = "https://github.com/dlang-community/dfmt/commit/23cba7a6f0e8cde8b9e5d1b379abc67a23c787aa.diff";
      hash = "sha256-+uv6Ly7vW4fHxpr8pA2P7MGOn50iyAk3L1Cjv+u22Bc=";
    })
  ];

  nativeBuildInputs = [ ldc ];

  buildFlags = [ "ldc" ];

  preBuild = ''
    mkdir -p bin
    echo "${finalAttrs.version}" >bin/githash.txt
  '';

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  meta = with lib; {
    description = "Formatter for D source code";
    homepage = "https://github.com/dlang-community/dfmt";
    license = licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtbx ];
  };
})
