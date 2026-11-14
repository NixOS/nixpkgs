{
  lib,
  stdenv,
  openssl,
  gnumake,
  fetchFromGitea,
}:

let
  pname = "libfetch";
  gitRev = "94465f087e10c933962139f3c72dbcc75a107943";
in
stdenv.mkDerivation {
  inherit pname;
  version = "0.1.0-unstable-2026-06-30";

  # NOTE: binary doesn't depend on library output
  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
    "devman"
  ];

  src = fetchFromGitea {
    domain = "gitea.foss-daily.org";
    owner = "kayoubi13";
    repo = "libfetch";
    rev = gitRev;
    hash = "sha256-7EGCuXZ9qCgCoYWtpoQZzaP4SuEZYxShg2imy/0eMHs=";
  };

  nativeBuildInputs = [ gnumake ];
  buildInputs = [ openssl ];

  installTargets = [ "install" ];
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    mkdir -p ${placeholder "out"}/share/man/man3/ $bin $dev $lib $devman
    cp $src/fetch.3 ${placeholder "out"}/share/man/man3/
    cp -r ${placeholder "out"}/bin $bin/
    cp -r ${placeholder "out"}/lib $lib/
    cp -r ${placeholder "out"}/share $devman/

    ls -la
  '';

  strictDeps = true;
  __structuredAttrs = true;

  # passthru.tests = {
  #   # NOTE(ProducerMatt): this is useful for checking for fails but it's overkill for
  #   # hydra and very coarse. If FreeBSD has a test suite for fetch then I can't find it.
  #   # TODO: make sure this actually counts as a failure if it doesn't finish
  #   largeFileDownload = runCommand "${pname}-test-largeFileDownload" { } ''
  #     fetch -o /dev/null https://proof.ovh.net/files/1Gb.dat
  #   '';
  # };

  meta = with lib; {
    description = "A Linux port of FreeBSD's libfetch library and fetch utility.";
    homepage = "https://gitea.foss-daily.org/kayoubi13/libfetch";
    changelog = "https://gitea.foss-daily.org/kayoubi13/libfetch/commit/${gitRev}";
    license = licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "fetch";
    maintainers = with maintainers; [
      ProducerMatt
      kayoubi13
    ];
  };
}
