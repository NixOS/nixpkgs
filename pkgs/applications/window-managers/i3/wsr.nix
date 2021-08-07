{ lib, fetchFromGitHub, rustPlatform, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "i3wsr";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "roosta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JzQWfC0kmnMArpIAE5fgb3YLmXktSCH5aUdrQH9pCbo=";
  };

  cargoSha256 = "sha256-ZvSdJLaw1nfaqpTBKIiHiXvNFSZhsmLk0PBrV6ykv/w=";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libxcb ];

  # has not tests
  doCheck = false;

  meta = with lib; {
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
