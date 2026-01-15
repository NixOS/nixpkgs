{
  lib,
  rel,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  fetchpatch2,
}:
buildKodiBinaryAddon rec {
  pname = "pvr-hts";
  namespace = "pvr.hts";
  version = "21.2.6";

  src = fetchFromGitHub {
    owner = "kodi-pvr";
    repo = "pvr.hts";
    rev = "${version}-${rel}";
    sha256 = "sha256-opxNgin+Sz/Nb9IGZ+OFrCzbDc4FXl2LaNKUu5LAgFM=";
  };

  patches = [
    # fix gcc-15 compat. See https://github.com/kodi-pvr/pvr.hts/pull/693
    (fetchpatch2 {
      url = "https://github.com/kodi-pvr/pvr.hts/commit/b8fb7f6cbe9e3e9ea2737dc465a70fb4bb0951eb.patch?full_index=1";
      hash = "sha256-GgdEQUwwebQVjsEJAX9V7NRe954HCNMggNUcik8j+lU=";
    })
  ];

  meta = {
    homepage = "https://github.com/kodi-pvr/pvr.hts";
    description = "Kodi's Tvheadend HTSP client addon";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.kodi ];
  };
}
