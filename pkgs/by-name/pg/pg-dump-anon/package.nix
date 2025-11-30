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
  version = "2.4.1";

  src = fetchFromGitLab {
    owner = "dalibo";
    repo = "postgresql_anonymizer";
    tag = version;
    hash = "sha256-vAsKTkFx8HLKDdXIQt6fEF3l7EzzvcilGfqNtBa0AMM=";
  };

  sourceRoot = "${src.name}/pg_dump_anon";

  vendorHash = "sha256-CwU1zoIayxvfnGL9kPdummPJiV+ECfSz4+q6gZGb8pw=";

  passthru.tests = { inherit (nixosTests.postgresql) anonymizer; };

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/pg_dump_anon \
      --prefix PATH : ${lib.makeBinPath [ postgresql ]}
  '';

  meta = {
    description = "Export databases with data being anonymized with the anonymizer extension";
    homepage = "https://postgresql-anonymizer.readthedocs.io/en/stable/";
    teams = [ lib.teams.flyingcircus ];
    license = lib.licenses.postgresql;
    mainProgram = "pg_dump_anon";
  };
}
