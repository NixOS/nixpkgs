{stdenv, fetchFromGitHub, python3}:

stdenv.mkDerivation rec {
  version = "1.7";
  pname = "ddgr";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "0kcl8z9w8iwn3pxay1pfahhw6vs2l1dp60yfv3i19in4ac9va7m0";
  };

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    # Version 1.7 was released as 1.6
    # https://github.com/jarun/ddgr/pull/95
    sed -i "s/_VERSION_ = '1.6'/_VERSION_ = '1.7'/" ddgr
  '';

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
