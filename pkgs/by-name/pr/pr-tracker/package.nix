{
  rustPlatform,
  lib,
  fetchzip,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
<<<<<<< HEAD
  version = "1.10.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-lAraMuhAvTV/PX0R/SSga3bebuK0lizcyEK7Qo3iUmc=";
  };

  cargoHash = "sha256-gD2J3yp2ICNU9bQSXp2ks5GV+vL76t278WwiWCsAT8k=";
=======
  version = "1.9.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-8ZA+FjTO/8GdzYFskz8G0ihxtddsiZ9W44cXbExllZE=";
  };

  cargoHash = "sha256-dFyJX2X+bR3h/opAETTJpvy1vDAmBYQ/gq4ywVRnWaM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = lib.platforms.unix;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      qyliss
      sumnerevans
    ];
    mainProgram = "pr-tracker";
  };
}
