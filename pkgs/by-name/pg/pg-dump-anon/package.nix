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
  version = "1.3.2";
  src = fetchFromGitLab {
    owner = "dalibo";
    repo = "postgresql_anonymizer";
    rev = version;
    hash = "sha256-MGdGvd4P1fFKdd6wnS2V5Tdly6hJlAmSA4TspnO/6Tk=";
  };

  sourceRoot = "${src.name}/pg_dump_anon";

  vendorHash = "sha256-CwU1zoIayxvfnGL9kPdummPJiV+ECfSz4+q6gZGb8pw=";

  passthru.tests = { inherit (nixosTests.postgresql) anonymizer; };

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
