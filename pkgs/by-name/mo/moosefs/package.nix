{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  fuse,
  pkg-config,
  libpcap,
  zlib,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "moosefs";
<<<<<<< HEAD
  version = "4.58.3";
=======
  version = "4.58.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "moosefs";
    repo = "moosefs";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lEnCP+ORWdW52SVO7K3WxcjlFMrQFR9VT8fjquI/fZg=";
=======
    sha256 = "sha256-eywJ7MmCrwxqlbTDYEEPs6ego9Ivn+ziXCBNhcDfcmY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
<<<<<<< HEAD
    python3
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    fuse
    libpcap
    zlib
    python3
  ];

  strictDeps = true;

  buildFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "CPPFLAGS=-UHAVE_STRUCT_STAT_ST_BIRTHTIME"
  ];

  # Fix the build on macOS with macFUSE installed
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace configure --replace \
      "/usr/local/lib/pkgconfig" "/nonexistent"
  '';

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace config.h --replace \
      "#define HAVE_STRUCT_STAT_ST_BIRTHTIME 1" \
      "#undef HAVE_STRUCT_STAT_ST_BIRTHTIME"
  '';

<<<<<<< HEAD
=======
  postInstall = ''
    substituteInPlace $out/sbin/mfscgiserv --replace "datapath=\"$out" "datapath=\""
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doCheck = true;

  passthru.tests = {
    inherit (nixosTests) moosefs;
  };

  meta = {
    homepage = "https://moosefs.com";
    description = "Open Source, Petabyte, Fault-Tolerant, Highly Performing, Scalable Network Distributed File System";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      mfossen
      markuskowa
    ];
  };
}
