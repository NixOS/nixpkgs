{ lib, fetchFromGitHub, rustPlatform, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "i3wsr";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "roosta";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mwPU700eqyFYihWP1m3y56zXnX16sjSNzB6XNlCttBU=";
  };

  cargoSha256 = "sha256-f0Yby/2g7apkqx0iCcd/QkQgMVYZDUQ1vWw8RCXQ9Z4=";

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
