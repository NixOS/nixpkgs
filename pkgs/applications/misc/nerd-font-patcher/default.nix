{ python3Packages, lib, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "2.1.0";

  # This uses a sparse checkout because the repo is >2GB without it
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "v${version}";
    sparseCheckout = ''
      font-patcher
      /src/glyphs
    '';
    sha256 = "sha256-ePBlEVjzAJ7g6iAGIqPfgZ8bwtNILmyEVm0zD+xNN6k=";
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  format = "other";

  postPatch = ''
    sed -i font-patcher \
      -e 's,__dir__ + "/src,"'$out'/share/${pname},'
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/${pname}
    install -Dm755 font-patcher $out/bin/${pname}
    cp -ra src/glyphs $out/share/${pname}
  '';

  meta = with lib; {
    description = "Font patcher to generate Nerd font";
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ck3d ];
  };
}
