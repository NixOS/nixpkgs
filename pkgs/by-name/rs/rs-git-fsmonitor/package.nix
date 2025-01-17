{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  watchman,
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-git-fsmonitor";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "jgavris";
    repo = pname;
    rev = "v${version}";
    sha256 = "021vdk5i7yyrnh4apn0gnsh6ycnx15wm3g2jrfsg7fycnq8167wc";
  };

  cargoHash = "sha256-Vi8PUy6Qgp03SghtCneDxwE8vbt7uGClfOCayDq0pUM=";

  nativeBuildInputs = [ makeWrapper ];

  fixupPhase = ''
    wrapProgram $out/bin/rs-git-fsmonitor --prefix PATH ":" "${lib.makeBinPath [ watchman ]}" ;
  '';

  meta = with lib; {
    description = "Fast git core.fsmonitor hook written in Rust";
    homepage = "https://github.com/jgavris/rs-git-fsmonitor";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rs-git-fsmonitor";
  };
}
