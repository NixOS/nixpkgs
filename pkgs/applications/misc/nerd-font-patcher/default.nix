{ python3Packages, lib, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "2.1.0";

  # The size of the nerd fonts repository is bigger than 2GB, because it
  # contains a lot of fonts and the patcher.
  # until https://github.com/ryanoasis/nerd-fonts/issues/484 is not fixed,
  # we download the patcher from an alternative repository
  src = fetchFromGitHub {
    owner = "betaboon";
    repo = "nerd-fonts-patcher";
    rev = "180684d7a190f75fd2fea7ca1b26c6540db8d3c0";
    sha256 = "sha256-FAbdLf0XiUXGltAgmq33Wqv6PFo/5qCv62UxXnj3SgI=";
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
