{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "i3-auto-layout";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ps08lga6qkgc8cgf5cx2lgwlqcnd2yazphh9xd2fznnzrllfxxz";
  };

  cargoSha256 = "1i01kqvsykanzs7pi94gab9k2dqg1ki40mmjrwa22n0ypkbnvsmx";

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Automatic, optimal tiling for i3wm";
    homepage = "https://github.com/chmln/i3-auto-layout";
    license = licenses.mit;
    maintainers = with maintainers; [ mephistophiles ];
    platforms = platforms.linux;
  };
}
