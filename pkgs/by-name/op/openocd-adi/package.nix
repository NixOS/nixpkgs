{
  openocd,
  autoreconfHook,
  lib,
  fetchFromGitHub,
}:

openocd.overrideAttrs (old: {
  pname = "openocd-adi";
  version = "0.12.0-1.3.1-1";
  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "openocd";
    tag = "0.12.0-1.3.1-1";
    hash = "sha256-e25mAxUmbF/hZC+aWRMt9HdwKY0FClNrZXwP3888Z9A=";
    # openocd disables the vendored libraries that use submodules and replaces them with nix versions.
    # this works out as one of the submodule sources seems to be flakey.
    fetchSubmodules = false;
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [
    autoreconfHook
  ];
  meta = openocd.meta // {
    description = "ADI fork of OpenOCD";
    homepage = "https://github.com/analogdevicesinc/openocd";
    maintainers = with lib.maintainers; [
      aiyion
    ];
  };
})
