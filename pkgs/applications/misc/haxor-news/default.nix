{ lib, fetchFromGitHub, python3 }:


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
          sha256 = "09h1153wgr5x2ny7ds0w2m81n3bb9j8hjb8sjfnrg506r01clkyx";
        };
      });
      # Use click 7
      click = super.click.overridePythonAttrs (old: rec {
        version = "7.1.2";
        src = old.src.override {
          inherit version;
          sha256 = "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a";
        };
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
    sha256 = "1g3dfsyk4727d9jh9w6j5r51ag07851cls7v7a7hmdvdixpvbzp6";
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

  nativeCheckInputs = [ unittestCheckHook mock ];

  unittestFlagsArray = [ "-s" "tests" "-v" ];

  meta = with lib; {
    homepage = "https://github.com/donnemartin/haxor-news";
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
