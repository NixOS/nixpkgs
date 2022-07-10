{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, unixtools
, which
}:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "git-extras";
    rev = version;
    sha256 = "sha256-Cn7IXMzgg0QIsNIHz+X14Gkmop0UbsSBlGlGkmg71ek=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/tj/git-extras/commit/66961ad4911cd0f1a908530f2b725bacc7d198e1.patch";
      sha256 = "sha256-iC1lUf/NmuAPADxDWZ2JScHIMgYjIaR0edlGpq0qCOc=";
    })
  ];

  postPatch = ''
    patchShebangs check_dependencies.sh
  '';

  nativeBuildInputs = [
    unixtools.column
    which
  ];

  dontBuild = true;

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "SYSCONFDIR=${placeholder "out"}/share"
  ];

  postInstall = ''
    # bash completion is already handled by make install
    install -D etc/git-extras-completion.zsh $out/share/zsh/site-functions/_git_extras
  '';

  meta = with lib; {
    homepage = "https://github.com/tj/git-extras";
    description = "GIT utilities -- repo summary, repl, changelog population, author commit percentages and more";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ spwhitt cko SuperSandro2000 ];
  };
}
