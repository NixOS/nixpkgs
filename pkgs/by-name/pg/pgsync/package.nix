{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  gemdir = ./.;
  pname = "pgsync";
  exes = [ "pgsync" ];

  passthru.updateScript = bundlerUpdateScript "pgsync";

<<<<<<< HEAD
  meta = {
    description = "Sync data from one Postgres database to another (like `pg_dump`/`pg_restore`)";
    homepage = "https://github.com/ankane/pgsync";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ fabianhjr ];
=======
  meta = with lib; {
    description = "Sync data from one Postgres database to another (like `pg_dump`/`pg_restore`)";
    homepage = "https://github.com/ankane/pgsync";
    license = with licenses; mit;
    maintainers = with maintainers; [ fabianhjr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
