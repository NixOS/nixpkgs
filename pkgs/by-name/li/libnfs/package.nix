{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "libnfs";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "sahlberg";
    repo = "libnfs";
    rev = "libnfs-${version}";
    sha256 = "sha256-rdxi5bPXHTICZQIj/CmHgZ/V70svnITJj/OSF4mmC3o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  patches = [
    # Fixes 100% CPU usage in multi-threaded mode
    (fetchpatch {
      url = "https://github.com/sahlberg/libnfs/commit/34d6fe37e986da5b0ced86cd028a88e482537d5a.patch";
      hash = "sha256-i7mi+TVdkLb4MztT5Ic/Q8XBIWk9lo8v5bNjHOr6LaI=";
    })
    # Fixes deprecation warnings on macOS
    (fetchpatch {
      url = "https://github.com/sahlberg/libnfs/commit/f6631c54a7b0385988f11357bf96728a6d7345b9.patch";
      hash = "sha256-xLRZ9J1vr04n//gNv9ljUBt5LHUGBRRVIXJCMlFbHFI=";
    })
  ];

  configureFlags = [
    "--enable-pthread"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "NFS client library";
    homepage = "https://github.com/sahlberg/libnfs";
    license = with licenses; [
      lgpl2
      bsd2
      gpl3
    ];
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
