{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "bunnyfetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rosettea";
    repo = "bunnyfetch";
    rev = "v${version}";
    sha256 = "sha256-6MnjCXc9/8twdf8PHKsVJY1yWYwUf5R01vtQFJbyy7M=";
  };

  vendorHash = "sha256-w+O1dU8t7uNvdlFnYhCdJCDixpWWZAnj9GrtsCbu9SM=";

  # No upstream tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Rosettea/bunnyfetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ devins2518 ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Tiny system info fetch utility";
    homepage = "https://github.com/Rosettea/bunnyfetch";
    license = licenses.mit;
    maintainers = with maintainers; [ devins2518 ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bunnyfetch";
  };
}
