{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  boost,
  xz,
  libiconv,
  withGog ? false,
  unar ? null,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "innoextract";
  version = "1.9-unstable-2025-02-06";

  src = fetchFromGitHub {
    owner = "dscharrer";
    repo = "innoextract";
    rev = "6e9e34ed0876014fdb46e684103ef8c3605e382e";
    hash = "sha256-bgACPDo1phjIiwi336JEB1UAJKyL2NmCVOhyZxBFLJo=";
  };

  buildInputs = [
    xz
    boost
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

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

  # use unstable as latest release does not yet support cmake-4
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Tool to unpack installers created by Inno Setup";
    homepage = "https://constexpr.org/innoextract/";
    license = licenses.zlib;
    maintainers = [ ];
    platforms = platforms.unix;
    mainProgram = "innoextract";
  };
}
