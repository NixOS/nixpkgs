{ lib
, python3
, fetchFromGitHub
}:

let
  version = "0.8";
  tag = "v${version}";
in
python3.pkgs.buildPythonApplication rec {
  inherit version;
  pname = "tftui";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "idoavrah";
    repo = "terraform-tui";
    rev = "refs/tags/${tag}";
    hash = "sha256-C4P4pmsavktAUnS4tqAnJHF8hz5AoUk/TDPt27eoagw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "version = \"x.x.x\"" "version = \"${version}\""
  '';

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    posthog
    requests
    textual
  ];

  meta = with lib; {
    description = "TFTUI is a powerful textual GUI that empowers users to effortlessly view and interact with their Terraform state.";
    homepage = "https://github.com/idoavrah/terraform-tui";
    changelog = "https://github.com/idoavrah/terraform-tui/releases/tag/${tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ srounce ];
    mainProgram = "tftui";
  };
}

