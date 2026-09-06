{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smcroute";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = finalAttrs.version;
    sha256 = "sha256-UaIiYtPD6nsk5ZnqoWJ6SOsvmM3xIcu/ImqG5ESPOo0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libcap ];

  configureFlags = [
    "--localstatedir=/var"
    "--with-systemd=\$(out)/lib/systemd/system"
  ];

  meta = {
    description = "Static multicast routing daemon";
    homepage = "https://troglobit.com/smcroute.html";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = with lib.platforms; (linux ++ freebsd ++ netbsd ++ openbsd);
  };
})
