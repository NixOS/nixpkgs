{
  lib,
  fetchFromGitLab,
  buildGoModule,
  nixosTests,
  postgresql,
  makeWrapper,
}:

buildGoModule rec {
  pname = "pg-dump-anon";
  version = "1.3.1";
  src = fetchFromGitLab {
    owner = "dalibo";
    repo = "postgresql_anonymizer";
    rev = version;
    hash = "sha256-Z5Oz/cIYDxFUZwQijRk4xAOUdOK0LWR+px8WOcs+Rs0=";
  };

  sourceRoot = "${src.name}/pg_dump_anon";

  vendorHash = "sha256-CwU1zoIayxvfnGL9kPdummPJiV+ECfSz4+q6gZGb8pw=";

  passthru.tests = { inherit (nixosTests) pg_anonymizer; };

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/pg_dump_anon \
      --prefix PATH : ${lib.makeBinPath [ postgresql ]}
  '';

  meta = with lib; {
    description = "Export databases with data being anonymized with the anonymizer extension";
    homepage = "https://postgresql-anonymizer.readthedocs.io/en/stable/";
    maintainers = teams.flyingcircus.members;
    license = licenses.postgresql;
    mainProgram = "pg_dump_anon";
  };
}
