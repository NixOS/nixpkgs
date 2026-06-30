{
  lib,
  stdenv,
  openssl,
  gnumake,
  fetchgit,
}:

stdenv.mkDerivation {
  pname = "libfetch";
  version = "0.1.0";

  # TODO: fetch original libfetch sources and apply kayoubi13's changes as diffs
  src = fetchgit {
    url = "https://gitea.foss-daily.org/kayoubi13/libfetch";
    hash = "sha256-7EGCuXZ9qCgCoYWtpoQZzaP4SuEZYxShg2imy/0eMHs=";
  };

  nativeBuildInputs = [ gnumake ];
  buildInputs = [ openssl ];

  buildPhase = ''
    make
  '';

  # TODO: make bin and lib build and install separately
  installPhase = ''
    make PREFIX=$out install
  '';

  strictDeps = true;
  __structuredAttrs = true;

  meta = with lib; {
    description = "A Linux port of FreeBSD's libfetch library and fetch utility.";
    homepage = "https://gitea.foss-daily.org/kayoubi13/libfetch";
    license = licenses.bsd3;
    platforms = platforms.linux;
    mainProgram = "fetch";
    maintainers = [ maintainers.ProducerMatt ];
  };
}
