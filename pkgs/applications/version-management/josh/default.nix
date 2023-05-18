{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libgit2
, openssl
, pkg-config
, makeWrapper
, git
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "josh";
  version = "22.06.22";

  src = fetchFromGitHub {
    owner = "esrlabs";
    repo = "josh";
    rev = "r" + version;
    sha256 = "0511qv9zyjvv4zfz6zyi69ssbkrwa24n0ah5w9mb4gzd547as8pq";
  };

  cargoSha256 = "0zfjjyyz4pxar1mfkkj9aij4dnwqy3asdrmay1iy6ijjn1qd97n4";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Security
  ];

  cargoBuildFlags = [
    "-p" "josh"
    "-p" "josh-proxy"
    # TODO: josh-ui
  ];

  postInstall = ''
    wrapProgram "$out/bin/josh-proxy" --prefix PATH : "${git}/bin"
  '';

  meta = {
    description = "Just One Single History";
    homepage = "https://josh-project.github.io/josh/";
    downloadPage = "https://github.com/josh-project/josh";
    changelog = "https://github.com/josh-project/josh/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sternenseemann
      lib.maintainers.tazjin
    ];
    platforms = lib.platforms.all;
  };
}
