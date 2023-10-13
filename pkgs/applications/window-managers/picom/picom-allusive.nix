{ picom, lib, fetchFromGitHub }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-allusive";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "picom-allusive";
    rev = version;
    hash = "sha256-1zWntz2QKp/O9ZuOUZy9NkCNXFsBqRRvcd0SAr+7G/o=";
  };

  postInstall = ''
    chmod +x $out/bin/picom-trans
  '' + (lib.optionalString (oldAttrs ? postInstall) oldAttrs.postInstall);

  meta = {
    description = "A fork of picom featuring improved animations and other features";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with lib.maintainers; [ allusive ];
  };
})
