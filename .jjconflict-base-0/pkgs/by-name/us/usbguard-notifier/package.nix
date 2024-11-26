{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  libqb,
  usbguard,
  librsvg,
  libnotify,
  catch2,
  asciidoc,
}:

stdenv.mkDerivation rec {
  pname = "usbguard-notifier";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Cropi";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-gWvCGSbOuey2ELAPD2WCG4q77IClL0S7rE2RaUJDc1I=";
  };

  patches = [
    # gcc-13 compatibility upstream fix:
    #   https://github.com/Cropi/usbguard-notifier/pull/74
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/Cropi/usbguard-notifier/commit/f4586b732c8a7379aacbc9899173beeacfd54793.patch";
      hash = "sha256-2q/qD6yEQUPxA/UutGIZKFJ3hHJ8ZlGMZI1wJyMRbmo=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    asciidoc
  ];
  buildInputs = [
    libqb
    usbguard
    librsvg
    libnotify
  ];

  configureFlags = [ "CPPFLAGS=-I${catch2}/include/catch2" ];

  prePatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_MSG_FAILURE([Cannot detect the systemd system unit dir])' \
        'systemd_unit_dir="$out/lib/systemd/user"'
  '';

  meta = {
    description = "Notifications for detecting usbguard policy and device presence changes";
    homepage = "https://github.com/Cropi/usbguard-notifier";
    maintainers = with lib.maintainers; [ fpletz ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
