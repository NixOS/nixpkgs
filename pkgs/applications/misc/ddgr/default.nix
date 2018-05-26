{stdenv, fetchpatch, fetchFromGitHub, python3Packages}:

stdenv.mkDerivation rec {
  version = "1.1";
  name = "ddgr-${version}";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "1q66kwip5y0kfkfldm1x54plz85mjyvv1xpxjqrs30r2lr0najgf";
  };

  buildInputs = [
    (python3Packages.python.withPackages (ps: with ps; [
      requests
    ]))
  ];

  patches = [
    (fetchpatch {
     sha256 = "1rxr3biq0mk4m0m7dsxr70dhz4fg5siil5x5fy9nymcmhvcm1cdc";
     name = "Fix-zsh-completion.patch";
     url = "https://github.com/jarun/ddgr/commit/10c1a911a3d5cbf3e96357c932b0211d3165c4b8.patch";
    })
  ];

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
    maintainers = with maintainers; [ markus1189 ];
    platforms = platforms.unix;
  };
}
