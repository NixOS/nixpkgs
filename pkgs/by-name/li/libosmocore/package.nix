{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  gnutls,
  libmnl,
  liburing,
  libusb1,
  lksctp-tools,
  pcsclite,
  pkg-config,
  python3,
  talloc,
}:

stdenv.mkDerivation rec {
  pname = "libosmocore";
<<<<<<< HEAD
  version = "1.11.3";
=======
  version = "1.11.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "osmocom";
    repo = "libosmocore";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-4fb7vmA3iQuQZ+T2Gp0B7bc5+CYE1cTR3IoFwOde7SE=";
=======
    hash = "sha256-cEMPz5xmvaBnm+U7G1PttfhR6TXsT2PN2hk2FXHbXpg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    echo "${version}" > .tarball-version
  '';

  propagatedBuildInputs = [
    talloc
    libmnl
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    gnutls
    liburing
    libusb1
    lksctp-tools
    pcsclite
  ];

  enableParallelBuilding = true;

<<<<<<< HEAD
  meta = {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Set of Osmocom core libraries";
    homepage = "https://github.com/osmocom/libosmocore";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mog
    ];
  };
}
