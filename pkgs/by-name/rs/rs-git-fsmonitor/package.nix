{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  watchman,
}:

rustPlatform.buildRustPackage rec {
  pname = "rs-git-fsmonitor";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jgavris";
    repo = "rs-git-fsmonitor";
    tag = "v${version}";
    hash = "sha256-+5nR+/09HmFk3mq2B8NTeBT50aBG85yXEdeO6BhStVw=";
  };

  cargoHash = "sha256-WkqJSbtaJxaagJMsdFiVozi1SkrfxXyM9bdZeimwJag=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/rs-git-fsmonitor --prefix PATH ":" "${lib.makeBinPath [ watchman ]}"
  '';

  meta = {
    description = "Fast git core.fsmonitor hook written in Rust";
    homepage = "https://github.com/jgavris/rs-git-fsmonitor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nilscc ];
    mainProgram = "rs-git-fsmonitor";
  };
}
