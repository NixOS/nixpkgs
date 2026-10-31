{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ruby,
  gz-cmake,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "gz-tools";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-tools";
    tag = "gz-tools${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gz-cmake
    ruby
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = "gz-tools";
    };
    tests.version = testers.testVersion;
  };

  meta = {
    description = "Gazebo Sim tools collection";
    homepage = "https://gazebosim.org/";
    downloadPage = "https://github.com/gazebosim/gz-tools";
    changelog = "https://github.com/gazebosim/gz-tools/blob/${finalAttrs.src.tag}/Changelog.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
    mainProgram = "gz";
  };
})
