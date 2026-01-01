{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  libkrb5,
  libnl,
  libtool,
  pkg-config,
  withKerberos ? false,
}:

stdenv.mkDerivation rec {
  pname = "ksmbd-tools";
<<<<<<< HEAD
  version = "3.5.6";
=======
  version = "3.5.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cifsd-team";
    repo = "ksmbd-tools";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-JwfxYFBwrMtP2D7GcDpW44WYbLJyxZy3Jhgi+7HsIng=";
=======
    sha256 = "sha256-ZA2HE/IhdF0UqVv92h1iEc9vPbycA/7Qxka1fXJ4AhE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [
    glib
    libnl
  ]
  ++ lib.optional withKerberos libkrb5;

  nativeBuildInputs = [
    meson
    ninja
    libtool
    pkg-config
  ];
  patches = [ ./0001-skip-installing-example-configuration.patch ];
  mesonFlags = [
    "-Drundir=/run"
    "-Dsystemdsystemunitdir=lib/systemd/system"
    "--sysconfdir /etc"
  ];

<<<<<<< HEAD
  meta = {
    description = "Userspace utilities for the ksmbd kernel SMB server";
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/cifs/ksmbd.html";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Userspace utilities for the ksmbd kernel SMB server";
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/cifs/ksmbd.html";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
