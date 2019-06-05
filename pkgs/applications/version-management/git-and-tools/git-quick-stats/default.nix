{ stdenv, fetchFromGitHub, makeWrapper, coreutils, git, gnugrep, gnused }:

stdenv.mkDerivation rec {
    pname = "git-quick-stats";
    version = "2.0.8";

    src = fetchFromGitHub {
        owner = "arzzen";
        repo = pname;
        rev = "c11bce17bdb1c7f1272c556605b48770646bf807";
        sha256 = "1px1sk7b6mjnbclsr1jn33m9k4wd8wqyw4d6w1rgj0ii29lhzmqi";
    };

    buildInputs = [ makeWrapper ];

    dontBuild = true;

    makeFlags = [ "PREFIX=${placeholder "out"}" ];

    wrapperPath = with stdenv.lib; makeBinPath [
        coreutils
        git
        gnugrep
        gnused
    ];

    postFixup = ''
        patchShebangs $out/bin

        wrapProgram $out/bin/git-quick-stats --prefix PATH : "${wrapperPath}"
    '';

    meta = with stdenv.lib; {
        description = "Simple and efficient tool to access various statistics in git repository";
        homepage = "https://github.com/arzzen/git-quick-stats";
        maintainers = [ maintainers.alex3rd ];
        license = licenses.mit;
        platforms = platforms.unix;
    };
}
