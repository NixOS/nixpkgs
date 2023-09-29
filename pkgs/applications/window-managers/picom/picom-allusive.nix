{ picom, lib, fetchFromGitHub, installShellFiles }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-allusive";
  version = "0.3.1";

  nativeBuildInputs = [ installShellFiles ] ++ oldAttrs.nativeBuildInputs;

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "picom-allusive";
    rev = version;
    hash = "sha256-lk4Ll0mi9h3BAqwgOzFQw4WYKnSW9XTl3PjoK2E4WKg=";
  };

  postInstall = ''
    chmod +x $out/bin/picom-trans
    installManPage $src/man/picom.1.gz
  '' + oldAttrs.postInstall;

  meta = oldAttrs.meta // {
    description = "A fork of picom featuring improved animations and other features";
    homepage = "https://github.com/allusive-dev/picom-allusive";
    licenses = with lib.licenses; [ mit mpl20 ];
    maintainers = (with lib.maintainers; [ eclairevoyant ]) ++ oldAttrs.meta.maintainers;
  };
})
