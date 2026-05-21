{
  lib,
  fetchFromGitHub,
  openttd,
  zstd,
}:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.72.2";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-Ql3W+Xr5zXDW/IBY23X+RMSXieCqn35hYY3jfYGahgs=";
  };
  patches = [ ];

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
    maintainers = with lib.maintainers; [ artifycz ];
  };

})
