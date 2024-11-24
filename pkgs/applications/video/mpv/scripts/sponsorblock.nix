{
  lib,
  buildLua,
  fetchFromGitHub,
  fetchpatch,
  python3,
  nix-update-script,
}:

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.sponsorblock ]; }`
buildLua {
  pname = "mpv_sponsorblock";
  version = "0-unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "mpv_sponsorblock";
    rev = "7785c1477103f2fafabfd65fdcf28ef26e6d7f0d";
    sha256 = "sha256-iUXaTWWFEdxhxClu2NYbQcThlvYty3A2dEYGooeAVAQ=";
  };

  patches = [
    # Use XDG_DATA_HOME and XDG_CACHE_HOME if defined for UID and DB
    # Necessary to avoid sponsorblock to write in the nix store at runtime.
    # https://github.com/po5/mpv_sponsorblock/pull/17
    (fetchpatch {
      url = "https://github.com/po5/mpv_sponsorblock/pull/17/commits/e65b360a7d03a3430b4829e457a6670b2f617b09.patch";
      sha256 = "00wv0pvbz0dz2ibka66zhl2jk0pil4pyv6ipjfz37i81q6szyhs5";
    })
    (fetchpatch {
      url = "https://github.com/po5/mpv_sponsorblock/pull/17/commits/3832304d959205e99120a14c0560ed3c37104b08.patch";
      sha256 = "149ffvn714n2m3mqs8mgrbs24bcr74kqfkx7wyql36ndhm88xd2z";
    })
  ];

  postPatch = ''
    substituteInPlace sponsorblock.lua \
      --replace-fail "python3" "${lib.getExe python3}" \
      --replace-fail 'mp.find_config_file("scripts")' "\"$out/share/mpv/scripts\""
  '';

  extraScripts = [ "sponsorblock_shared" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    description = "Script for mpv to skip sponsored segments of YouTube videos";
    homepage = "https://github.com/po5/mpv_sponsorblock";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pacien ];
  };
}
