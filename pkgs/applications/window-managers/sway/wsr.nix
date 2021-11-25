{ lib, fetchFromGitHub, rustPlatform, libxcb, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "swaywsr";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pedroscaff";
    repo = pname;
    rev = "6c4671c702f647395d983aaf607286db1c692db6";
    sha256 = "0bmpbhyvgnbi5baj6v0wdxpdh9cnlzvcc44vh3vihmzsp6i5q05a";
  };

  cargoSha256 = "1pmkyw60ggn5filb47nyf97g1arrw7nfa4yjndnx35zw12mkj61d";

  nativeBuildInputs = [ python3 ];
  buildInputs = [ libxcb ];

  # has not tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically change sway workspace names based on their contents";
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
