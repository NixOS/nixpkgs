{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxcb,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3wsr";
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "roosta";
    repo = "i3wsr";
    rev = "v${version}";
    hash = "sha256-8cQM2M9XjS4FSSX1/WHqmTP842Ahd1XoaqOWSGSEE0s=";
  };

  cargoHash = "sha256-d+pFDvmfsuJbanUlheHxln9BY1HxU3UQE+pWRthGcc4=";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libxcb ];

  # has not tests
  doCheck = false;

  meta = with lib; {
    mainProgram = "i3wsr";
    description = "Automatically change i3 workspace names based on their contents";
    longDescription = ''
      Automatically sets the workspace names to match the windows on the workspace.
      The chosen name for a workspace is a user-defined composite of the WM_CLASS X11
      window property for each window in a workspace.
    '';
    homepage = "https://github.com/roosta/i3wsr";
    license = licenses.mit;
    maintainers = [ maintainers.sebbadk ];
  };
}
