{
  lib,
  stdenv,
  fetchFromGitea,
  autoreconfHook,
  atf,
  pkg-config,
  kyua,
}:
stdenv.mkDerivation rec {
  pname = "mlmmj";
  version = "1.4.7";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = pname;
    repo = pname;
    rev = "refs/tags/RELEASE_" + lib.replaceStrings [ "." ] [ "_" ] version;
    hash = "sha256-QetxCxny9elPetKuAsgKF0xTov1bNIRxi7gWhv6dYyU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    atf
    pkg-config
    kyua
  ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # AC_FUNC_MALLOC is broken on cross builds.
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  postInstall = ''
    # grab all documentation files
    docfiles=$(find -maxdepth 1 -name "[[:upper:]][[:upper:]]*")
    install -vDm 644 -t $out/share/doc/mlmmj/ $docfiles
  '';

  meta = with lib; {
    homepage = "http://mlmmj.org";
    description = "Mailing List Management Made Joyful";
    maintainers = [ maintainers.edwtjo ];
    platforms = platforms.linux;
    license = licenses.mit;
  };
}
