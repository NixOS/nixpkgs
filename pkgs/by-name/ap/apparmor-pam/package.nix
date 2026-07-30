{
  stdenv,
  pkg-config,
  which,
  pam,

  # apparmor deps
  libapparmor,
}:
stdenv.mkDerivation {
  pname = "apparmor-pam";
  inherit (libapparmor)
    version
    src
    ;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    libapparmor
    pam
  ];

  sourceRoot = "${libapparmor.src.name}/changehat/pam_apparmor";

  makeFlags = [ "USE_SYSTEM=1" ];
  installFlags = [ "DESTDIR=$(out)" ];

  meta = libapparmor.meta // {
    description = "Mandatory access control system - PAM service";
  };
}
