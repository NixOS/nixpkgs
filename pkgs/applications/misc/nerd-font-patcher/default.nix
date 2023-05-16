<<<<<<< HEAD
{ python3Packages, lib, fetchzip }:

python3Packages.buildPythonApplication rec {
  pname = "nerd-font-patcher";
  version = "3.0.2";

  src = fetchzip {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/FontPatcher.zip";
    sha256 = "sha256-ZJpF/Q5lfcW3srb2NbJk+/QEuwaFjdzboa+rl9L7GGE=";
    stripRoot = false;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3Packages; [ fontforge ];

  format = "other";

  postPatch = ''
    sed -i font-patcher \
<<<<<<< HEAD
      -e 's,__dir__ + "/src,"'$out'/share/,'
    sed -i font-patcher \
      -e  's,/bin/scripts/name_parser,/../lib/name_parser,'
  '';
  # Note: we cannot use $out for second substitution
=======
      -e 's,__dir__ + "/src,"'$out'/share/nerd-font-patcher,'
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontBuild = true;

  installPhase = ''
<<<<<<< HEAD
    mkdir -p $out/bin $out/share $out/lib
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    cp -ra src/glyphs $out/share/
    cp -ra bin/scripts/name_parser $out/lib/
=======
    mkdir -p $out/bin $out/share/nerd-font-patcher
    install -Dm755 font-patcher $out/bin/nerd-font-patcher
    cp -ra src/glyphs $out/share/nerd-font-patcher
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Font patcher to generate Nerd font";
    homepage = "https://nerdfonts.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ ck3d ];
  };
}
