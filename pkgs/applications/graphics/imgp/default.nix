{ lib, fetchFromGitHub, buildPythonApplication, pillow, imgp }:

buildPythonApplication rec {
  pname = "imgp";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "13r4fn3dd0nyidfhrr7zzpls5ifbyqdwxhyvpkqr8ahchws7wfc6";
  };

  propagatedBuildInputs = [ pillow ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  postInstall = ''
    install -Dm555 auto-completion/bash/imgp-completion.bash $out/share/bash-completion/completions/imgp.bash
    install -Dm555 auto-completion/fish/imgp.fish -t $out/share/fish/vendor_completions.d
    install -Dm555 auto-completion/zsh/_imgp -t $out/share/zsh/site-functions
  '';

  checkPhase = ''
    $out/bin/imgp --help
  '';

  meta = with lib; {
    description = "High-performance CLI batch image resizer & rotator";
    homepage = "https://github.com/jarun/imgp";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
