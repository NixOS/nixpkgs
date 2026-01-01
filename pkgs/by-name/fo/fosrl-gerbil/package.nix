{
  lib,
  iptables,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gerbil";
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "gerbil";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-A3ehUYR5dM2No0AXxOCXZi83Lh/NXo6vMSFtYpvSAJo=";
  };

  vendorHash = "sha256-FZuIDHAQtqEuxE1W4yYRnr4Kj8YedNi0Z1NeuWrgnRc=";
=======
    hash = "sha256-Pnti0agkohRBWQ42cqNOA5TnnSLP9JbOK1eyGf88cao=";
  };

  vendorHash = "sha256-Sz+49ViQUwJCy7wXDrQf7c76rOZbSGBCgB+Du8T6ug0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # patch out the /usr/sbin/iptables
  postPatch = ''
    substituteInPlace main.go \
      --replace-fail '/usr/sbin/iptables' '${lib.getExe iptables}'
  '';

  meta = {
    description = "Simple WireGuard interface management server";
    mainProgram = "gerbil";
    homepage = "https://github.com/fosrl/gerbil";
    changelog = "https://github.com/fosrl/gerbil/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jackr
      sigmasquadron
<<<<<<< HEAD
      water-sucks
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    platforms = lib.platforms.linux;
  };
}
