{
  lib,
  fetchFromGitHub,
  fetchPypi,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      self = py;

      # not compatible with prompt_toolkit >=2.0
      prompt-toolkit = super.prompt-toolkit.overridePythonAttrs (oldAttrs: rec {
        name = "${oldAttrs.pname}-${version}";
        version = "1.0.18";
        src = oldAttrs.src.override {
          inherit version;
          hash = "sha256-3U/KAsgGlJetkxotCZFMaw0bUBUc6Ha8Fb3kx0cJASY=";
        };
      });
      # Use click 7
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = fetchPypi {
          pname = "click";
          inherit version;
          hash = "sha256-0rUlXHxjSbwb0eWeCM0SrLvWPOZJ8liHVXg6qU37axo=";
        };
        disabledTests = [ "test_bytes_args" ];
      });
    };
  };
in
with py.pkgs;

buildPythonApplication rec {
  pname = "haxor-news";
  version = "unstable-2020-10-20";

  # haven't done a stable release in 3+ years, but actively developed
  src = fetchFromGitHub {
    owner = "donnemartin";
    repo = pname;
    rev = "811a5804c09406465b2b02eab638c08bf5c4fa7f";
    hash = "sha256-5v61b49ttwqPOvtoykJBBzwVSi7S8ARlakccMr12bbw=";
  };

  propagatedBuildInputs = [
    click
    colorama
    requests
    pygments
    prompt-toolkit
    six
  ];

  # will fail without pre-seeded config files
  doCheck = false;

  nativeCheckInputs = [
    unittestCheckHook
    mock
  ];

  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  meta = with lib; {
    homepage = "https://github.com/donnemartin/haxor-news";
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
