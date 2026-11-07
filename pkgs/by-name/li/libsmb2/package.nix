{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  krb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsmb2";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libsmb2";
    tag = "libsmb2-${finalAttrs.version}";
    hash = "sha256-2leW52nOtRo+jYdU0LhM2Qt0teimJg3QXxXVEydtKtQ=";
  };

  patches = [ ./fix_version.patch ];

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mv $out/lib/cmake/libsmb2/libsmb2-config-version.cmake $out/lib/cmake/libsmb2/libsmb2-config.cmake
  '';

  meta = {
    description = "Userspace client/server library for accessing or serving SMB2/SMB3 shares on a network";
    homepage = "https://github.com/sahlberg/libsmb2";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ spreetin ];
    platforms = lib.platforms.linux;
  };
})
