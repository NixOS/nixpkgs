{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libxcb,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3wsr";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "roosta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Mq4TpQDiIYePUS3EwBfOe2+QmvF6+WEDK12WahbuhSU=";
  };

  cargoSha256 = "sha256-hybvzHwHM0rQwgZfQpww/w9wQDW5h9P2KSjpAScVTBo=";

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
