{ stdenv, fetchgit, qtbase, qtscript, qtxmlpatterns, qtquickcontrols
, makeQtWrapper
}:

let
  version = "17.03.08";
in
stdenv.mkDerivation {
  name = "qownnotes-${version}";

  # needs git submodules, so can't use fetchFromGitHub
  src = fetchgit {
    rev = "refs/tags/linux-b2844-162834";
    url = "https://github.com/pbek/QOwnNotes";
    sha256 = "1s38phw71mxwjpz0bk3apyrmf0jafd1ggh4f821rnshld8kapchr";
  };

  buildInputs = [ qtbase qtscript qtxmlpatterns qtquickcontrols ];
  nativeBuildInputs = [ makeQtWrapper ];

  configurePhase = ''
    runHook preConfigure
    cd src
    qmake -makefile $qmakeFlags PREFIX=$out
    runHook postConfigure
  '';

  # NIX_PROFILES may contain an older libqminimal.so remove system-path from NIX_PROFILES
  postInstall = ''
    wrapQtProgram "$out/bin/QOwnNotes" \
       --set NIX_PROFILES "/nix/var/nix/profiles/default $HOME/.nix-profile"
  '';

  meta = with stdenv.lib;
    { description = "An open source notepad with markdown support and todo list manager";
      homepage = https://www.qownnotes.org/;
      license = licenses.gpl2;
      platforms = qtbase.meta.platforms;
      maintainers = [ maintainers.vandenoever ];
    };
}
