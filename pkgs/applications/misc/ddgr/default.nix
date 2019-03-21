{stdenv, fetchpatch, fetchFromGitHub, python3}:

stdenv.mkDerivation rec {
  version = "1.6";
  name = "ddgr-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "04ybbjsf9hpn2p5cjjm15cwvv0mwrmdi19iifrym6ps3rmll0p3c";
  };

  buildInputs = [ python3 ];

  makeFlags = "PREFIX=$(out)";

  postInstall = ''
    mkdir -p "$out/share/bash-completion/completions/"
    cp "auto-completion/bash/ddgr-completion.bash" "$out/share/bash-completion/completions/"
    mkdir -p "$out/share/fish/vendor_completions.d/"
    cp "auto-completion/fish/ddgr.fish" "$out/share/fish/vendor_completions.d/"
    mkdir -p "$out/share/zsh/site-functions/"
    cp "auto-completion/zsh/_ddgr" "$out/share/zsh/site-functions/"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/jarun/ddgr;
    description = "Search DuckDuckGo from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ceedubs markus1189 ];
    platforms = platforms.unix;
  };
}
