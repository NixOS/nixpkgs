{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  fishtape,
  jq,
}:
buildFishPlugin (finalAttrs: {
  pname = "done";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "franciscolourenco";
    repo = "done";
    rev = finalAttrs.version;
    hash = "sha256-GZ1ZpcaEfbcex6XvxOFJDJqoD9C5out0W4bkkn768r0=";
  };

  postPatch = ''
    substituteInPlace conf.d/done.fish \
      --replace-fail " jq " " ${lib.getExe jq} " \
      --replace-fail "and type -q jq" "and type -q ${lib.getExe jq}"
  '';

  checkPlugins = [ fishtape ];
  checkPhase = ''
    fishtape test/done.fish
  '';

  meta = {
    description = "Automatically receive notifications when long processes finish";
    homepage = "https://github.com/franciscolourenco/done";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      malo
      rexies
    ];
  };
})
