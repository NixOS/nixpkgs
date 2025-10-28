{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libinotify-kqueue";
  version = "20240724";

  src = fetchFromGitHub {
    owner = "libinotify-kqueue";
    repo = "libinotify-kqueue";
    rev = version;
    sha256 = "sha256-m59GWrx5C+JXDbhVdKx+SNSn8wwIKyW+KlXabNi17A0=";
  };

  patches = [
    # https://github.com/libinotify-kqueue/libinotify-kqueue/pull/23
    (fetchpatch {
      name = "add-configure-caching.patch";
      url = "https://github.com/libinotify-kqueue/libinotify-kqueue/commit/81a8f05c1ce6df819dc898f3754c9c874ee24b10.patch";
      hash = "sha256-imKS2DuQrHSMnJH1gOYrVSeWTe2nhcl8Gm9IX5B9ZqI=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags =
    lib.optionals (with stdenv; buildPlatform != hostPlatform && hostPlatform.isFreeBSD)
      [
        "ik_cv_have_note_extend_in=yes"
        "ik_cv_have_note_extend_out=yes"
        "ik_cv_have_o_path=yes"
        "ik_cv_have_o_empty_path=yes"
        "ik_cv_have_at_empty_path=yes"
      ];

  checkFlags = [ "test" ];

  meta = with lib; {
    description = "Inotify shim for macOS and BSD";
    homepage = "https://github.com/libinotify-kqueue/libinotify-kqueue";
    license = licenses.mit;
    maintainers = [ ];
    platforms = with platforms; darwin ++ freebsd ++ netbsd ++ openbsd;
  };
}
