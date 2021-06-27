{ lib, fetchFromGitLab, unstableGitUpdater, rustPlatform, scdoc }:

rustPlatform.buildRustPackage rec {
  pname = "kile-wl";
  version = "unstable-2021-06-01";

  src = fetchFromGitLab {
    owner = "snakedye";
    repo = "kile";
    rev = "28235f85ece148e7010c5d6ac088688100a18e04";
    sha256 = "sha256-UTfYYywOwa728zLkLWQaz6wN0TM/4OzbHQGedjdHGSI=";
  };

  passthru.updateScript = unstableGitUpdater {
    url = "https://gitlab.com/snakedye/kile.git";
  };

  cargoSha256 = "sha256-dzOkiZYHQu5AuwkbWEtIJAyZ1TNIGYkfz+S3q6K384w=";

  nativeBuildInputs = [ scdoc ];

  postInstall = ''
    mkdir -p $out/share/man
    scdoc < doc/kile.1.scd > $out/share/man/kile.1
  '';

  meta = with lib; {
    description = "A tiling layout generator for river";
    homepage = "https://gitlab.com/snakedye/kile";
    license = licenses.mit;
    platforms = platforms.linux; # It's meant for river, a wayland compositor
    maintainers = with maintainers; [ fortuneteller2k ];
    mainProgram = "kile";
  };
}
