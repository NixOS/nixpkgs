{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dfrs";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = pname;
    rev = version;
    sha256 = "01h00328kbw83q11yrsvcly69p0hql3kw49b4jx6gwkrdm8c2amk";
  };

  cargoHash = "sha256-KaSBdpgIjMZoX8ejD5hNYtgZLb952t8th4f5Mh6x9bU=";

  meta = with lib; {
    description = "Display file system space usage using graphs and colors";
    homepage = "https://github.com/anthraxx/dfrs";
    license = licenses.mit;
    maintainers = with maintainers; [ wamserma ];
    mainProgram = "dfrs";
  };
}
