{ lib, fetchFromGitHub, rustPlatform, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "swaywsr";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "pedroscaff";
    repo = pname;
    rev = "0276b43824af5c40085248c1275feaa372c412a5";
    sha256 = "sha256-KCMsn9uevmmjHkP4zwfaWSUI10JgT3M91iqmXI9Cv2Y=";
  };

  cargoSha256 = "sha256-j/9p28ezy8m5NXReOmG1oryWd+GcY/fNW6i7OrEvjSc=";

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
