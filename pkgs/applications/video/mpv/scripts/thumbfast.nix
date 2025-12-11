{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  mpv-unwrapped,
}:

buildLua {
  pname = "mpv-thumbfast";
  version = "0-unstable-2025-02-04";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "9deb0733c4e36938cf90e42ddfb7a19a8b2f4641";
    hash = "sha256-avG1CRBrs0UM4HcFMUVAQyOtcIFkZ/H+PbjZJKU7o2A=";
  };
  passthru.updateScript = unstableGitUpdater { };

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ mpv-unwrapped ])
  ];

  meta = {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}
