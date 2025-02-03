{ lib, fetchFromGitHub, rustPlatform, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "swaywsr";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pedroscaff";
    repo = pname;
    rev = "521fbf92738f44be438d3be6bdd665f02ac9d35c";
    hash = "sha256-6hGEcJz+zGfwz1q+XKQYfyJJK7lr+kCgk2/uiq1xP0M=";
  };

  cargoHash = "sha256-zoV2vy41fVsX8BtddURqQymMX4Zpso+GOBBqoVr3tYo=";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libxcb ];

  # has not tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically change sway workspace names based on their contents";
    mainProgram = "swaywsr";
    longDescription = ''
      Automatically sets the workspace names to match the windows on the workspace.
      The chosen name for a workspace is a composite of the app_id or WM_CLASS X11
      window property for each window in a workspace.
    '';
    homepage = "https://github.com/pedroscaff/swaywsr";
    license = licenses.mit;
    maintainers = [ maintainers.sebbadk ];
  };
}
