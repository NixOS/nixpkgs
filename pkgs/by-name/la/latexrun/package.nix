{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "latexrun";
  version = "0-unstable-2015-11-18";
  src = fetchFromGitHub {
    owner = "aclements";
    repo = "latexrun";
    rev = "38ff6ec2815654513c91f64bdf2a5760c85da26e";
    sha256 = "0xdl94kn0dbp6r7jk82cwxybglm9wp5qwrjqjxmvadrqix11a48w";
  };

  buildInputs = [ python3 ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp latexrun $out/bin/latexrun
    chmod +x $out/bin/latexrun
  '';

  meta = with lib; {
    description = "21st century LaTeX wrapper";
    mainProgram = "latexrun";
    homepage = "https://github.com/aclements/latexrun";
    license = licenses.mit;
    maintainers = [ maintainers.lucus16 ];
    platforms = platforms.all;
  };
}
