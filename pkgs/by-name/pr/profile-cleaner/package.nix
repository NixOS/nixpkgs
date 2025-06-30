{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  parallel,
  sqlite,
  bc,
  file,
}:

stdenv.mkDerivation rec {
  version = "2.45";
  pname = "profile-cleaner";

  src = fetchFromGitHub {
    owner = "graysky2";
    repo = "profile-cleaner";
    rev = "v${version}";
    sha256 = "sha256-10e1S+li7SXKJX2lETSdx84GavWqQYQqyLoBIVToTBI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    PREFIX=\"\" DESTDIR=$out make install
    wrapProgram $out/bin/profile-cleaner \
      --prefix PATH : "${
        lib.makeBinPath [
          parallel
          sqlite
          bc
          file
        ]
      }"
  '';

  meta = {
    description = "Reduces browser profile sizes by cleaning their sqlite databases";
    longDescription = ''
      Use profile-cleaner to reduce the size of browser profiles by organizing
      their sqlite databases using sqlite3's vacuum and reindex functions. The
      term "browser" is used loosely since profile-cleaner happily works on
      some email clients and newsreaders too.
    '';
    homepage = "https://github.com/graysky2/profile-cleaner";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.devhell ];
    mainProgram = "profile-cleaner";
  };
}
