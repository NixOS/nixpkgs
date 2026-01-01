{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "grit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "climech";
    repo = "grit";
    rev = "v${version}";
    sha256 = "sha256-c8wBwmXFjpst6UxL5zmTxMR4bhzpHYljQHiJFKiNDms=";
  };

  vendorHash = "sha256-iMMkjJ5dnlr0oSCifBQPWkInQBCp1bh23s+BcKzDNCg=";

<<<<<<< HEAD
  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multitree-based personal task manager";
    homepage = "https://github.com/climech/grit";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Multitree-based personal task manager";
    homepage = "https://github.com/climech/grit";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "grit";
  };
}
