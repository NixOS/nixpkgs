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
  version = "2.5.7";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "smcroute";
    rev = finalAttrs.version;
    sha256 = "sha256-b1FsaDw5wAZkOwc6Y7TsMwyfxIRQ2rNUTK+knEzOn7w=";
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
