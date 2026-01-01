{
  lib,
  fetchFromGitHub,
  cmake,
  stdenv,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "espresso";
  version = "2.4";
  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = "espresso";
    rev = "v${version}";
    hash = "sha256-z5By57VbmIt4sgRgvECnLbZklnDDWUA6fyvWVyXUzsI=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  outputs = [
    "out"
    "man"
  ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Multi-valued PLA minimization";
    # from manual
    longDescription = ''
      Espresso takes as input a two-level representation of a
      two-valued (or multiple-valued) Boolean function, and produces a
      minimal equivalent representation.  The algorithms used are new and
      represent an advance in both speed and optimality of solution in
      heuristic Boolean minimization.
    '';
    homepage = "https://github.com/chipsalliance/espresso";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ pineapplehunter ];
=======
    maintainers = with maintainers; [ pineapplehunter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "espresso";
    platforms = lib.platforms.all;

    # The license is not provided in the GitHub repo,
    # so until there's an update on the license, it is marked as unfree.
    # See: https://github.com/chipsalliance/espresso/issues/4
<<<<<<< HEAD
    license = lib.licenses.unfree;
=======
    license = licenses.unfree;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
