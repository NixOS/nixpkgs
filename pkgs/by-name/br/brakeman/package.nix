{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

let
  gems = import ./gemset.nix;
  version = gems.brakeman.version;
in
bundlerApp {
  pname = "brakeman";
  exes = [ "brakeman" ];
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "brakeman";

  meta = {
    description = "Static analysis security scanner for Ruby on Rails";
    homepage = "https://brakemanscanner.org/";
    changelog = "https://github.com/presidentbeef/brakeman/blob/v${version}/CHANGES.md";
    license = lib.licenses.unfreeRedistributable;
    platforms = ruby.meta.platforms;
    maintainers = [ ];
    mainProgram = "brakeman";
  };
}
