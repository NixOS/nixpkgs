{ python3Packages, lib, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "2.2.2";

  # This uses a sparse checkout because the repo is >2GB without it
  src = fetchFromGitHub {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "v${version}";
    sparseCheckout = [
      "font-patcher"
      "/src/glyphs"
    ];
    sha256 = "sha256-boZUd1PM8puc9BTgOwCJpkfk6VMdXLsIyp+fQmW/ZqI=";
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  format = "other";

  postPatch = ''
    sed -i font-patcher \
      -e 's,__dir__ + "/src,"'$out'/share/nerd-font-patcher,'
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/nerd-font-patcher
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    cp -ra src/glyphs $out/share/nerd-font-patcher
  '';

  meta = with lib; {
    description = "Font patcher to generate Nerd font";
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ck3d ];
  };
}
