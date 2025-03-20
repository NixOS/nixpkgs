{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  makeWrapper,
  boost,
  xz,
  libiconv,
  withGog ? false,
  unar ? null,
}:

stdenv.mkDerivation rec {
  pname = "innoextract";
  version = "1.9";

  src = fetchurl {
    url = "https://constexpr.org/innoextract/files/innoextract-${version}.tar.gz";
    sha256 = "09l1z1nbl6ijqqwszdwch9mqr54qb7df0wp2sd77v17dq6gsci33";
  };

  patches = [
    # Fix boost-1.86 build:
    #   https://github.com/dscharrer/innoextract/pull/169
    (fetchpatch {
      name = "boost-1.86.patch";
      url = "https://github.com/dscharrer/innoextract/commit/264c2fe6b84f90f6290c670e5f676660ec7b2387.patch";
      hash = "sha256-QYwrqLXC7FE4oYi6G1erpX/RUUtS5zNBv7/fO7AdZQg=";
    })
  ];

  buildInputs = [
    xz
    boost
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  # Python is reported as missing during the build, however
  # including Python does not change the output.

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  strictDeps = true;

  # we need unar to for multi-archive extraction
  postFixup = lib.optionalString withGog ''
    wrapProgram $out/bin/innoextract \
      --prefix PATH : ${lib.makeBinPath [ unar ]}
  '';

  meta = with lib; {
    description = "Tool to unpack installers created by Inno Setup";
    homepage = "https://constexpr.org/innoextract/";
    license = licenses.zlib;
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.unix;
    mainProgram = "innoextract";
  };
}
