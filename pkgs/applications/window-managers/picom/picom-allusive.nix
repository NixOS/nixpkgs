{ picom, lib, fetchFromGitHub, installShellFiles }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-allusive";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "picom-allusive";
    rev = version;
    hash = "sha256-1zWntz2QKp/O9ZuOUZy9NkCNXFsBqRRvcd0SAr+7G/o=";
  };

  nativeBuildInputs = [ installShellFiles ] ++ oldAttrs.nativeBuildInputs;

  postInstall = ''
    chmod +x $out/bin/picom-trans
    installManPage $src/man/picom.1.gz
  '' + (lib.optionalString (oldAttrs ? postInstall) oldAttrs.postInstall);

  meta = (builtins.removeAttrs oldAttrs.meta [ "longDescription" ]) // {
    description = "A fork of picom featuring improved animations and other features";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with lib.maintainers; [ allusive ];
  };
})
