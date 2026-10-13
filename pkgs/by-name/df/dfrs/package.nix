{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dfrs";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = "dfrs";
    rev = finalAttrs.version;
    sha256 = "01h00328kbw83q11yrsvcly69p0hql3kw49b4jx6gwkrdm8c2amk";
  };

  cargoHash = "sha256-U6z0YMHRmjGobLYdyBaMWJam9mDrHUQEOv5MjOpNfHU=";

  meta = {
    description = "Display file system space usage using graphs and colors";
    homepage = "https://github.com/anthraxx/dfrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wamserma ];
    mainProgram = "dfrs";
  };
})
